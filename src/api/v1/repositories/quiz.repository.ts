import {
    AdaptiveAnswerInput,
    CreateQuestionInput,
    CreateQuizInput,
    UpdateQuestionInput,
    getDifficultyRating,
} from '../types/quiz.type';
import {
    DEFAULT_INITIAL_THETA,
    computeAdaptivePercentageScore,
    evaluateAnswerCorrectness,
    filterAdaptiveEligibleQuestions,
    getAbilityLevelFromScore,
    resolveQuestionDifficultyRating,
    selectNextQuestion,
    updateAbility,
} from '../helpers/adaptiveEngine';
import prisma from '../../../database';
import { question_difficulty, quiz_question_type } from '@prisma/client';

export class QuizRepository {
    /**
     * Format soal untuk dikirim ke siswa saat kuis berlangsung (tanpa bocoran is_correct / explanation / difficulty).
     */
    static formatSafeQuestionForStudent(question: {
        id: number;
        question: string;
        type: string;
        quiz_answer: { id: number; answer: string }[];
    }) {
        return {
            id: question.id,
            question: question.question,
            type: question.type,
            answers:
                question.type === 'Essay'
                    ? []
                    : question.quiz_answer.map((a) => ({
                          id: a.id,
                          answer: a.answer,
                      })),
        };
    }

    /**
     * Evaluasi apakah satu baris Attemp_Answer bernilai benar.
     */
    private static isAttemptAnswerCorrect(answerRow: any, question: any): boolean {
        if (typeof answerRow.is_correct === 'boolean') {
            return answerRow.is_correct;
        }
        const selectedAnswerIds = Array.isArray(answerRow.attemp_multiple_answer)
            ? answerRow.attemp_multiple_answer.map((m: any) => m.answerId)
            : [];
        return evaluateAnswerCorrectness(question, {
            selectedAnswerIds,
            answer: answerRow.answer,
        });
    }

    /**
     * Hitung ringkasan skor adaptif (persentase 0-100, jumlah benar, total soal MC/TF, isPassed, level).
     * Kompatibel dengan attempt adaptif baru maupun attempt lama sebelum migrasi.
     */
    static computeAttemptMetrics(attempt: any) {
        const allQuestions: any[] = attempt.quiz?.quiz_question ?? [];
        const eligibleQuestions = filterAdaptiveEligibleQuestions(allQuestions);
        const totalQuestions = eligibleQuestions.length;

        let correctAnswersCount = 0;
        const answers: any[] = attempt.attemp_answer ?? [];

        for (const ans of answers) {
            const q = eligibleQuestions.find((item) => item.id === ans.questionId);
            if (!q) continue;
            if (this.isAttemptAnswerCorrect(ans, q)) {
                correctAnswersCount++;
            }
        }

        const isAdaptiveAttempt =
            attempt.ability_estimate !== null && attempt.ability_estimate !== undefined;

        let percentage: number;
        if (isAdaptiveAttempt) {
            percentage =
                typeof attempt.score === 'number' && attempt.submitted_at !== null
                    ? attempt.score
                    : computeAdaptivePercentageScore(correctAnswersCount, totalQuestions);
        } else {
            // Kompatibilitas attempt lama (sebelum migrasi)
            const totalLegacyPoints = allQuestions.reduce(
                (sum, q) => sum + (q.points ?? 1),
                0
            );
            if (typeof attempt.score === 'number') {
                percentage =
                    totalLegacyPoints > 0
                        ? Math.round((attempt.score / totalLegacyPoints) * 100)
                        : attempt.score;
            } else {
                percentage = computeAdaptivePercentageScore(
                    correctAnswersCount,
                    totalQuestions
                );
            }
        }

        const passingGrade = attempt.quiz?.passing_grade ?? 0;
        const isPassed = percentage >= passingGrade;
        const abilityEstimate = Number((attempt.ability_estimate ?? 0).toFixed(4));
        const abilityLevel = getAbilityLevelFromScore(percentage);

        return {
            score: percentage,
            percentage,
            totalScore: 100,
            totalQuestions,
            correctAnswersCount,
            passingGrade,
            isPassed,
            abilityEstimate,
            ability_estimate: abilityEstimate,
            abilityLevel,
            ability_level: abilityLevel,
            showReview: attempt.quiz?.show_review ?? true,
            show_review: attempt.quiz?.show_review ?? true,
        };
    }

    static async getQuizzesBySection(sectionId: number) {
        return prisma.quiz.findMany({
            where: { sectionId },
            include: {
                quiz_question: {
                    include: { quiz_answer: true },
                    orderBy: { id: 'asc' },
                },
                _count: {
                    select: {
                        quiz_attempt: true,
                    },
                },
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    static async getQuizzesBySectionForStudent(sectionId: number, userId: string) {
        const quizzes = await prisma.quiz.findMany({
            where: { sectionId },
            select: {
                id: true,
                title: true,
                description: true,
                max_attempts: true,
                time_limit: true,
                passing_grade: true,
                xp: true,
                show_review: true,
                createdAt: true,
                quiz_question: {
                    select: {
                        id: true,
                        type: true,
                        points: true,
                    },
                },
            },
            orderBy: { createdAt: 'desc' },
        });

        const quizzesWithAttempts = await Promise.all(
            quizzes.map(async (quiz) => {
                const eligibleCount = filterAdaptiveEligibleQuestions(
                    quiz.quiz_question
                ).length;

                const attemptsRaw = await prisma.quiz_Attempt.findMany({
                    where: {
                        quizId: quiz.id,
                        userId,
                        submitted_at: { not: null },
                    },
                    select: {
                        id: true,
                        score: true,
                        ability_estimate: true,
                        is_graded: true,
                        submitted_at: true,
                    },
                    orderBy: { submitted_at: 'desc' },
                });

                const normalizedAttempts = attemptsRaw.map((a) => {
                    const metrics = this.computeAttemptMetrics({
                        ...a,
                        quiz: {
                            passing_grade: quiz.passing_grade,
                            show_review: quiz.show_review,
                            quiz_question: quiz.quiz_question,
                        },
                        attemp_answer: [],
                    });
                    return {
                        id: a.id,
                        score: metrics.percentage,
                        percentage: metrics.percentage,
                        isPassed: metrics.isPassed,
                        abilityLevel: metrics.abilityLevel,
                        is_graded: a.is_graded,
                        submitted_at: a.submitted_at,
                    };
                });

                const bestScore =
                    normalizedAttempts.length > 0
                        ? Math.max(...normalizedAttempts.map((a) => a.score))
                        : null;

                const { quiz_question, ...quizInfo } = quiz;

                return {
                    ...quizInfo,
                    totalQuestions: eligibleCount,
                    attemptsUsed: normalizedAttempts.length,
                    attemptsRemaining: Math.max(
                        0,
                        quiz.max_attempts - normalizedAttempts.length
                    ),
                    bestScore,
                    lastAttempt:
                        normalizedAttempts.length > 0 ? normalizedAttempts[0] : null,
                };
            })
        );

        return quizzesWithAttempts;
    }

    static async createQuiz(data: CreateQuizInput) {
        return prisma.quiz.create({
            data: {
                title: data.title,
                description: data.description,
                max_attempts: data.max_attempts,
                time_limit: data.time_limit,
                open_at: new Date(data.open_at),
                close_at: new Date(data.close_at),
                passing_grade: data.passing_grade,
                xp: data.xp,
                show_review: data.show_review ?? true,
                sectionId: data.sectionId,
            },
        });
    }

    static async getQuizById(id: number) {
        return prisma.quiz.findUnique({
            where: { id },
            include: {
                quiz_question: {
                    include: { quiz_answer: true },
                    orderBy: { id: 'asc' },
                },
            },
        });
    }

    static async getQuizByIdForStudent(quizId: number, userId: string) {
        const quiz = await prisma.quiz.findUnique({
            where: { id: quizId },
            select: {
                id: true,
                title: true,
                description: true,
                max_attempts: true,
                time_limit: true,
                passing_grade: true,
                xp: true,
                show_review: true,
                sectionId: true,
                createdAt: true,
                open_at: true,
                close_at: true,
                quiz_question: {
                    select: {
                        id: true,
                        type: true,
                        points: true,
                    },
                },
            },
        });

        if (!quiz) {
            return null;
        }

        const totalQuestions = filterAdaptiveEligibleQuestions(
            quiz.quiz_question
        ).length;

        const attemptsRaw = await prisma.quiz_Attempt.findMany({
            where: {
                quizId,
                userId,
                submitted_at: { not: null },
            },
            select: {
                id: true,
                score: true,
                ability_estimate: true,
                is_graded: true,
                started_at: true,
                submitted_at: true,
            },
            orderBy: { submitted_at: 'desc' },
        });

        const attempts = attemptsRaw.map((attempt) => {
            const metrics = this.computeAttemptMetrics({
                ...attempt,
                quiz: {
                    passing_grade: quiz.passing_grade,
                    show_review: quiz.show_review,
                    quiz_question: quiz.quiz_question,
                },
                attemp_answer: [],
            });

            return {
                ...attempt,
                score: metrics.percentage,
                percentage: metrics.percentage,
                isPassed: metrics.isPassed,
                abilityEstimate: metrics.abilityEstimate,
                abilityLevel: metrics.abilityLevel,
            };
        });

        const ongoingAttempt = await prisma.quiz_Attempt.findFirst({
            where: {
                quizId,
                userId,
                submitted_at: null,
            },
            select: {
                id: true,
                started_at: true,
            },
        });

        const bestScore =
            attempts.length > 0
                ? Math.max(...attempts.map((a) => a.percentage))
                : null;

        return {
            id: quiz.id,
            title: quiz.title,
            description: quiz.description,
            max_attempts: quiz.max_attempts,
            time_limit: quiz.time_limit,
            passing_grade: quiz.passing_grade,
            xp: quiz.xp,
            show_review: quiz.show_review,
            sectionId: quiz.sectionId,
            createdAt: quiz.createdAt,
            open_at: quiz.open_at,
            close_at: quiz.close_at,
            totalQuestions,
            attemptsUsed: attempts.length,
            attemptsRemaining: Math.max(0, quiz.max_attempts - attempts.length),
            bestScore,
            attempts,
            ongoingAttempt,
        };
    }

    static async updateQuiz(id: number, data: Partial<CreateQuizInput>) {
        const updateData: any = { ...data };
        if (data.open_at !== undefined) updateData.open_at = new Date(data.open_at);
        if (data.close_at !== undefined) updateData.close_at = new Date(data.close_at);
        return prisma.quiz.update({ where: { id }, data: updateData });
    }

    static async deleteQuiz(id: number) {
        const quiz = await prisma.quiz.findUnique({ where: { id } });
        if (!quiz) {
            throw new Error(`Quiz with ID ${id} not found`);
        }

        return prisma.quiz.delete({ where: { id } });
    }

    // === Question ===
    static async createQuestion(quizId: number, data: CreateQuestionInput) {
        const difficulty = (data.difficulty ?? 'Medium') as question_difficulty;
        const difficultyRating = getDifficultyRating(data.difficulty ?? 'Medium');

        return prisma.$transaction(async (tx) => {
            const question = await tx.quiz_Question.create({
                data: {
                    question: data.question,
                    type: data.type as quiz_question_type,
                    points: data.points ?? 1,
                    difficulty,
                    difficulty_rating: difficultyRating,
                    explanation: data.explanation,
                    quizId,
                },
            });

            if (data.answers && data.answers.length > 0) {
                await tx.quiz_Answer.createMany({
                    data: data.answers.map((a) => ({
                        answer: a.answer,
                        is_correct: a.is_correct,
                        questionId: question.id,
                    })),
                });
            }

            return tx.quiz_Question.findUnique({
                where: { id: question.id },
                include: { quiz_answer: true },
            });
        });
    }

    static async updateQuestion(questionId: number, data: UpdateQuestionInput) {
        return prisma.$transaction(async (tx) => {
            const updateData: any = {};
            if (data.question !== undefined) updateData.question = data.question;
            if (data.type !== undefined) updateData.type = data.type;
            if (data.points !== undefined) updateData.points = data.points;
            if (data.explanation !== undefined) updateData.explanation = data.explanation;
            if (data.difficulty !== undefined) {
                updateData.difficulty = data.difficulty as question_difficulty;
                updateData.difficulty_rating = getDifficultyRating(data.difficulty);
            }

            await tx.quiz_Question.update({
                where: { id: questionId },
                data: updateData,
            });

            if (data.answers !== undefined) {
                await tx.quiz_Answer.deleteMany({ where: { questionId } });
                if (data.answers.length > 0) {
                    await tx.quiz_Answer.createMany({
                        data: data.answers.map((a) => ({
                            answer: a.answer,
                            is_correct: a.is_correct,
                            questionId,
                        })),
                    });
                }
            }

            return tx.quiz_Question.findUnique({
                where: { id: questionId },
                include: { quiz_answer: true },
            });
        });
    }

    static async deleteQuestion(questionId: number) {
        return prisma.$transaction(async (tx) => {
            await tx.quiz_Answer.deleteMany({ where: { questionId } });
            return tx.quiz_Question.delete({ where: { id: questionId } });
        });
    }

    static async getAllQuestions(quizId: number, isStudent: boolean = false) {
        const questions = await prisma.quiz_Question.findMany({
            where: { quizId },
            include: {
                quiz_answer: {
                    select: {
                        id: true,
                        answer: true,
                        is_correct: !isStudent,
                        questionId: true,
                        createdAt: true,
                        updatedAt: true,
                    },
                },
            },
            orderBy: { id: 'asc' },
        });

        if (isStudent) {
            return questions.map((q) => ({
                ...q,
                explanation: undefined,
            }));
        }

        return questions;
    }

    static async getQuestionById(questionId: number, isStudent: boolean = false) {
        const question = await prisma.quiz_Question.findUnique({
            where: { id: questionId },
            include: {
                quiz_answer: {
                    select: {
                        id: true,
                        answer: true,
                        is_correct: !isStudent,
                        questionId: true,
                        createdAt: true,
                        updatedAt: true,
                    },
                },
            },
        });

        if (question && isStudent) {
            return {
                ...question,
                explanation: undefined,
            };
        }

        return question;
    }

    // === Adaptive Attempt & Question Delivery ===

    /**
     * Buat attempt baru dan sajikan soal pertama secara adaptif (theta awal = 0).
     */
    static async startQuizAttempt(userId: string, quizId: number) {
        return prisma.$transaction(async (tx) => {
            const quiz = await tx.quiz.findUnique({
                where: { id: quizId },
                include: {
                    quiz_question: {
                        include: {
                            quiz_answer: {
                                select: {
                                    id: true,
                                    answer: true,
                                },
                            },
                        },
                        orderBy: { id: 'asc' },
                    },
                },
            });

            if (!quiz) {
                throw new Error('Quiz not found');
            }

            const eligibleQuestions = filterAdaptiveEligibleQuestions(
                quiz.quiz_question
            );
            if (eligibleQuestions.length === 0) {
                throw new Error('Quiz belum memiliki soal pilihan ganda atau benar/salah');
            }

            const now = new Date();
            const firstQuestion = selectNextQuestion(
                eligibleQuestions,
                [],
                DEFAULT_INITIAL_THETA
            );

            if (!firstQuestion) {
                throw new Error('Gagal memilih soal pertama');
            }

            const attempt = await tx.quiz_Attempt.create({
                data: {
                    userId,
                    quizId,
                    started_at: now,
                    ability_estimate: DEFAULT_INITIAL_THETA,
                },
            });

            await tx.attemp_Answer.create({
                data: {
                    attemptId: attempt.id,
                    questionId: firstQuestion.id,
                    order: 1,
                    served_at: now,
                    answered_at: null,
                    ability_before: DEFAULT_INITIAL_THETA,
                },
            });

            return {
                attemptId: attempt.id,
                quizId: quiz.id,
                quizTitle: quiz.title,
                timeLimit: quiz.time_limit,
                timeRemainingSeconds: quiz.time_limit * 60,
                startedAt: attempt.started_at,
                totalQuestions: eligibleQuestions.length,
                currentQuestionNumber: 1,
                question: this.formatSafeQuestionForStudent(firstQuestion),
            };
        });
    }

    /**
     * Ambil soal aktif saat ini untuk resume/refresh halaman.
     */
    static async getCurrentAttemptQuestion(attemptId: number) {
        return prisma.$transaction(async (tx) => {
            const attempt = await tx.quiz_Attempt.findUnique({
                where: { id: attemptId },
                include: {
                    quiz: {
                        include: {
                            quiz_question: {
                                include: {
                                    quiz_answer: {
                                        select: {
                                            id: true,
                                            answer: true,
                                        },
                                    },
                                },
                                orderBy: { id: 'asc' },
                            },
                        },
                    },
                    attemp_answer: {
                        orderBy: { order: 'asc' },
                    },
                },
            });

            if (!attempt) return null;

            const eligibleQuestions = filterAdaptiveEligibleQuestions(
                attempt.quiz.quiz_question
            );
            const totalQuestions = eligibleQuestions.length;
            const now = new Date();
            const elapsedSeconds = Math.floor(
                (now.getTime() - attempt.started_at.getTime()) / 1000
            );
            const timeRemainingSeconds = Math.max(
                0,
                attempt.quiz.time_limit * 60 - elapsedSeconds
            );

            // Cari soal yang sedang aktif (answered_at === null)
            let activeAnswer = attempt.attemp_answer.find(
                (ans) => ans.answered_at === null
            );

            if (!activeAnswer) {
                const servedIds = attempt.attemp_answer.map((a) => a.questionId);
                const currentTheta =
                    attempt.ability_estimate ?? DEFAULT_INITIAL_THETA;
                const nextQ = selectNextQuestion(
                    eligibleQuestions,
                    servedIds,
                    currentTheta
                );

                if (!nextQ) {
                    return {
                        attemptId: attempt.id,
                        quizId: attempt.quizId,
                        quizTitle: attempt.quiz.title,
                        timeLimit: attempt.quiz.time_limit,
                        timeRemainingSeconds,
                        startedAt: attempt.started_at,
                        totalQuestions,
                        done: true,
                        currentQuestionNumber: totalQuestions,
                        question: null,
                    };
                }

                const nextOrder = attempt.attemp_answer.length + 1;
                activeAnswer = await tx.attemp_Answer.create({
                    data: {
                        attemptId: attempt.id,
                        questionId: nextQ.id,
                        order: nextOrder,
                        served_at: now,
                        answered_at: null,
                        ability_before: currentTheta,
                    },
                });
            }

            const activeQuestion = eligibleQuestions.find(
                (q) => q.id === activeAnswer!.questionId
            );

            if (!activeQuestion) {
                throw new Error('Soal aktif tidak ditemukan');
            }

            const currentQuestionNumber =
                activeAnswer.order ?? attempt.attemp_answer.length;

            return {
                attemptId: attempt.id,
                quizId: attempt.quizId,
                quizTitle: attempt.quiz.title,
                timeLimit: attempt.quiz.time_limit,
                timeRemainingSeconds,
                startedAt: attempt.started_at,
                totalQuestions,
                currentQuestionNumber,
                question: this.formatSafeQuestionForStudent(activeQuestion),
            };
        });
    }

    /**
     * Proses jawaban adaptif siswa dalam transaksi atomik:
     * - Cek answered_at === null (anti double-submit / spam click)
     * - Nilai jawaban di server & update statistik soal
     * - Update theta (ability_estimate) dengan Elo-lite
     * - Sajikan soal berikutnya atau selesaikan attempt jika seluruh soal MC/TF telah dijawab
     */
    static async submitAdaptiveAnswer(data: AdaptiveAnswerInput) {
        return prisma.$transaction(async (tx) => {
            const attempt = await tx.quiz_Attempt.findUnique({
                where: { id: data.attemptId },
                include: {
                    quiz: {
                        include: {
                            quiz_question: {
                                include: { quiz_answer: true },
                                orderBy: { id: 'asc' },
                            },
                        },
                    },
                    attemp_answer: {
                        orderBy: { order: 'asc' },
                    },
                },
            });

            if (!attempt) {
                throw new Error('Attempt tidak ditemukan');
            }

            if (attempt.submitted_at !== null) {
                throw new Error('Quiz sudah di-submit');
            }

            const eligibleQuestions = filterAdaptiveEligibleQuestions(
                attempt.quiz.quiz_question
            );
            const totalQuestions = eligibleQuestions.length;

            const currentQuestion = eligibleQuestions.find(
                (q) => q.id === data.questionId
            );
            if (!currentQuestion) {
                throw new Error('Soal tidak ditemukan pada kuis ini');
            }

            const activeAnswer = attempt.attemp_answer.find(
                (a) => a.questionId === data.questionId
            );

            if (!activeAnswer) {
                throw new Error('Soal ini belum disajikan pada sesi pengerjaan Anda');
            }

            if (activeAnswer.answered_at !== null) {
                throw new Error('Soal ini sudah dijawab');
            }

            const now = new Date();

            // Atomic guard untuk mencegah race condition / double click
            const lockResult = await tx.attemp_Answer.updateMany({
                where: {
                    id: activeAnswer.id,
                    answered_at: null,
                },
                data: {
                    answered_at: now,
                },
            });

            if (lockResult.count === 0) {
                throw new Error('Soal ini sudah dijawab');
            }

            const isCorrect = evaluateAnswerCorrectness(currentQuestion, {
                selectedAnswerIds: data.selectedAnswerIds,
                answer: data.answer,
            });

            const thetaBefore =
                attempt.ability_estimate ?? DEFAULT_INITIAL_THETA;
            const b = resolveQuestionDifficultyRating(currentQuestion);
            const thetaAfter = updateAbility(thetaBefore, b, isCorrect);

            // Resolusi teks jawaban (untuk kompatibilitas TrueFalse dan histori)
            let resolvedAnswerText = data.answer ?? null;
            if (
                !resolvedAnswerText &&
                data.selectedAnswerIds &&
                data.selectedAnswerIds.length === 1
            ) {
                const matchedOption = currentQuestion.quiz_answer.find(
                    (opt) => opt.id === data.selectedAnswerIds![0]
                );
                if (matchedOption) {
                    resolvedAnswerText = matchedOption.answer;
                }
            }

            await tx.attemp_Answer.update({
                where: { id: activeAnswer.id },
                data: {
                    answer: resolvedAnswerText,
                    answered_at: now,
                    is_correct: isCorrect,
                    ability_before: thetaBefore,
                    ability_after: thetaAfter,
                },
            });

            await tx.attemp_Multiple_Answer.deleteMany({
                where: { attempt_answerId: activeAnswer.id },
            });

            if (data.selectedAnswerIds && data.selectedAnswerIds.length > 0) {
                const validOptionIds = new Set(
                    currentQuestion.quiz_answer.map((opt) => opt.id)
                );
                const validSelectedIds = [
                    ...new Set(
                        data.selectedAnswerIds.filter((id) =>
                            validOptionIds.has(id)
                        )
                    ),
                ];

                if (validSelectedIds.length > 0) {
                    await tx.attemp_Multiple_Answer.createMany({
                        data: validSelectedIds.map((answerId) => ({
                            attempt_answerId: activeAnswer.id,
                            answerId,
                        })),
                    });
                }
            }

            // Update statistik kalibrasi soal
            await tx.quiz_Question.update({
                where: { id: currentQuestion.id },
                data: {
                    times_answered: { increment: 1 },
                    ...(isCorrect ? { times_correct: { increment: 1 } } : {}),
                },
            });

            // Daftar soal yang sudah disajikan sejauh ini
            const servedIds = new Set<number>(
                attempt.attemp_answer.map((a) => a.questionId)
            );
            servedIds.add(currentQuestion.id);

            const answeredCount =
                attempt.attemp_answer.filter(
                    (a) => a.id !== activeAnswer.id && a.answered_at !== null
                ).length + 1;

            const nextQuestion = selectNextQuestion(
                eligibleQuestions,
                servedIds,
                thetaAfter
            );

            if (nextQuestion) {
                const nextOrder = servedIds.size + 1;
                await tx.quiz_Attempt.update({
                    where: { id: attempt.id },
                    data: {
                        ability_estimate: thetaAfter,
                    },
                });

                await tx.attemp_Answer.create({
                    data: {
                        attemptId: attempt.id,
                        questionId: nextQuestion.id,
                        order: nextOrder,
                        served_at: now,
                        answered_at: null,
                        ability_before: thetaAfter,
                    },
                });

                return {
                    done: false,
                    currentQuestionNumber: nextOrder,
                    totalQuestions,
                    progress: {
                        answered: answeredCount,
                        total: totalQuestions,
                    },
                    nextQuestion: this.formatSafeQuestionForStudent(nextQuestion),
                };
            }

            // Semua soal MC/TF telah selesai dijawab -> hitung skor akhir & tandai selesai
            const previouslyCorrectCount = attempt.attemp_answer.filter(
                (a) => a.id !== activeAnswer.id && a.is_correct === true
            ).length;
            const totalCorrectCount =
                previouslyCorrectCount + (isCorrect ? 1 : 0);
            const finalPercentageScore = computeAdaptivePercentageScore(
                totalCorrectCount,
                totalQuestions
            );

            await tx.quiz_Attempt.update({
                where: { id: attempt.id },
                data: {
                    ability_estimate: thetaAfter,
                    score: finalPercentageScore,
                    is_graded: true,
                    submitted_at: now,
                },
            });

            return {
                done: true,
                attemptId: attempt.id,
                progress: {
                    answered: answeredCount,
                    total: totalQuestions,
                },
                message: 'Seluruh soal telah selesai dijawab',
            };
        });
    }

    static async getAttemptById(attemptId: number) {
        const attempt = await prisma.quiz_Attempt.findUnique({
            where: { id: attemptId },
            include: {
                quiz: {
                    include: {
                        quiz_question: {
                            include: { quiz_answer: true },
                            orderBy: { id: 'asc' },
                        },
                    },
                },
                attemp_answer: {
                    include: {
                        quiz_question: true,
                        attemp_multiple_answer: {
                            include: { quiz_answer: true },
                        },
                    },
                    orderBy: { order: 'asc' },
                },
            },
        });

        if (!attempt) return null;

        const metrics = this.computeAttemptMetrics(attempt);

        return {
            ...attempt,
            ...metrics,
        };
    }

    /**
     * Guard anti-bocor (§5):
     * Hanya mengembalikan soal yang SUDAH disajikan pada attempt ini (tanpa membocorkan seluruh bank soal).
     */
    static async getAttemptQuestions(attemptId: number) {
        const attempt = await prisma.quiz_Attempt.findUnique({
            where: { id: attemptId },
            include: {
                quiz: {
                    include: {
                        quiz_question: {
                            include: {
                                quiz_answer: {
                                    select: {
                                        id: true,
                                        answer: true,
                                    },
                                },
                            },
                            orderBy: { id: 'asc' },
                        },
                    },
                },
                attemp_answer: {
                    include: {
                        quiz_question: true,
                        attemp_multiple_answer: {
                            include: {
                                quiz_answer: {
                                    select: {
                                        id: true,
                                        answer: true,
                                    },
                                },
                            },
                        },
                    },
                    orderBy: { order: 'asc' },
                },
            },
        });

        if (!attempt) return null;

        const eligibleQuestions = filterAdaptiveEligibleQuestions(
            attempt.quiz.quiz_question
        );

        const servedQuestions = attempt.attemp_answer
            .map((ansRow, index) => {
                const question = eligibleQuestions.find(
                    (q) => q.id === ansRow.questionId
                );
                if (!question) return null;

                return {
                    order: ansRow.order ?? index + 1,
                    id: question.id,
                    question: question.question,
                    type: question.type,
                    answers: question.quiz_answer.map((ans) => ({
                        id: ans.id,
                        answer: ans.answer,
                    })),
                    isAnswered: ansRow.answered_at !== null,
                    savedAnswer:
                        ansRow.answered_at !== null ||
                        ansRow.answer !== null ||
                        ansRow.attemp_multiple_answer.length > 0
                            ? {
                                  answer: ansRow.answer,
                                  path: ansRow.path,
                                  selectedAnswerIds:
                                      ansRow.attemp_multiple_answer.map(
                                          (ma) => ma.answerId
                                      ),
                              }
                            : null,
                };
            })
            .filter(Boolean);

        return {
            attemptId: attempt.id,
            quizId: attempt.quizId,
            quizTitle: attempt.quiz.title,
            timeLimit: attempt.quiz.time_limit,
            startedAt: attempt.started_at,
            submittedAt: attempt.submitted_at,
            totalQuestions: eligibleQuestions.length,
            questions: servedQuestions,
        };
    }

    static async saveAnswer(data: {
        attemptId: number;
        questionId: number;
        answer?: string;
        filePath?: string;
        selectedAnswerIds?: number[];
    }) {
        return prisma.$transaction(async (tx) => {
            const attempAnswer = await tx.attemp_Answer.upsert({
                where: {
                    attemptId_questionId: {
                        attemptId: data.attemptId,
                        questionId: data.questionId,
                    },
                },
                update: {
                    answer: data.answer,
                    path: data.filePath,
                },
                create: {
                    attemptId: data.attemptId,
                    questionId: data.questionId,
                    answer: data.answer,
                    path: data.filePath,
                },
            });

            await tx.attemp_Multiple_Answer.deleteMany({
                where: { attempt_answerId: attempAnswer.id },
            });

            if (data.selectedAnswerIds && data.selectedAnswerIds.length > 0) {
                await tx.attemp_Multiple_Answer.createMany({
                    data: data.selectedAnswerIds.map((id) => ({
                        attempt_answerId: attempAnswer.id,
                        answerId: id,
                    })),
                });
            }

            return tx.attemp_Answer.findUnique({
                where: { id: attempAnswer.id },
                include: {
                    quiz_question: true,
                    attemp_multiple_answer: {
                        include: {
                            quiz_answer: {
                                select: {
                                    id: true,
                                    answer: true,
                                    questionId: true,
                                    createdAt: true,
                                    updatedAt: true,
                                },
                            },
                        },
                    },
                },
            });
        });
    }

    static async submitQuiz(attemptId: number) {
        return prisma.$transaction(async (tx) => {
            const attempt = await tx.quiz_Attempt.findUnique({
                where: { id: attemptId },
                include: {
                    quiz: {
                        include: {
                            quiz_question: {
                                include: { quiz_answer: true },
                            },
                        },
                    },
                    attemp_answer: {
                        include: {
                            quiz_question: true,
                            attemp_multiple_answer: {
                                include: { quiz_answer: true },
                            },
                        },
                        orderBy: { order: 'asc' },
                    },
                },
            });

            if (!attempt) throw new Error('Attempt not found');

            // Idempotent jika sudah di-submit sebelumnya (misal otomatis selesai di soal terakhir)
            if (attempt.submitted_at !== null && attempt.is_graded) {
                const metrics = this.computeAttemptMetrics(attempt);
                return {
                    ...attempt,
                    ...metrics,
                };
            }

            const eligibleQuestions = filterAdaptiveEligibleQuestions(
                attempt.quiz.quiz_question
            );
            let correctCount = 0;

            for (const ans of attempt.attemp_answer) {
                const q = eligibleQuestions.find((item) => item.id === ans.questionId);
                if (!q) continue;

                // Soal yang masih menggantung (answered_at === null dan tidak ada pilihan jawaban) dihitung salah
                const hasSelection =
                    (ans.attemp_multiple_answer &&
                        ans.attemp_multiple_answer.length > 0) ||
                    (typeof ans.answer === 'string' && ans.answer.trim().length > 0);

                const isCorrect =
                    typeof ans.is_correct === 'boolean'
                        ? ans.is_correct
                        : hasSelection
                          ? this.isAttemptAnswerCorrect(ans, q)
                          : false;

                if (ans.is_correct === null || ans.is_correct === undefined) {
                    await tx.attemp_Answer.update({
                        where: { id: ans.id },
                        data: {
                            is_correct: isCorrect,
                            answered_at: ans.answered_at ?? new Date(),
                        },
                    });
                }

                if (isCorrect) {
                    correctCount++;
                }
            }

            const percentageScore = computeAdaptivePercentageScore(
                correctCount,
                eligibleQuestions.length
            );
            const finalTheta =
                attempt.ability_estimate ?? DEFAULT_INITIAL_THETA;

            const updatedAttempt = await tx.quiz_Attempt.update({
                where: { id: attemptId },
                data: {
                    submitted_at: attempt.submitted_at ?? new Date(),
                    score: percentageScore,
                    ability_estimate: finalTheta,
                    is_graded: true,
                },
                include: {
                    quiz: {
                        include: {
                            quiz_question: {
                                include: { quiz_answer: true },
                            },
                        },
                    },
                    attemp_answer: {
                        include: {
                            quiz_question: true,
                            attemp_multiple_answer: {
                                include: { quiz_answer: true },
                            },
                        },
                        orderBy: { order: 'asc' },
                    },
                },
            });

            const metrics = this.computeAttemptMetrics(updatedAttempt);

            return {
                ...updatedAttempt,
                ...metrics,
            };
        });
    }

    static async calculateScore(attemptId: number) {
        const submitted = await this.submitQuiz(attemptId);
        return {
            attemptId,
            score: submitted.score ?? 0,
            percentage: submitted.percentage,
            isPassed: submitted.isPassed,
            abilityEstimate: submitted.abilityEstimate,
            abilityLevel: submitted.abilityLevel,
            isGraded: true,
        };
    }

    static async getStudentAttempts(userId: string, quizId: number) {
        const attempts = await prisma.quiz_Attempt.findMany({
            where: { userId, quizId },
            include: {
                quiz: {
                    include: {
                        quiz_question: {
                            include: { quiz_answer: true },
                        },
                    },
                },
                attemp_answer: {
                    include: {
                        quiz_question: true,
                        attemp_multiple_answer: { include: { quiz_answer: true } },
                    },
                    orderBy: { order: 'asc' },
                },
            },
            orderBy: { createdAt: 'desc' },
        });

        return Promise.all(
            attempts.map(async (attempt) => {
                if (attempt.submitted_at !== null && !attempt.is_graded) {
                    const graded = await this.submitQuiz(attempt.id);
                    return graded;
                }

                const metrics = this.computeAttemptMetrics(attempt);
                return {
                    ...attempt,
                    ...metrics,
                };
            })
        );
    }

    static async getQuizReview(
        attemptId: number,
        userId: string,
        requesterRole: string = 'Student'
    ) {
        const whereClause =
            requesterRole === 'Teacher' || requesterRole === 'Admin'
                ? { id: attemptId }
                : { id: attemptId, userId };

        const attempt = await prisma.quiz_Attempt.findFirst({
            where: whereClause,
            include: {
                quiz: {
                    include: {
                        quiz_question: {
                            include: { quiz_answer: true },
                            orderBy: { id: 'asc' },
                        },
                    },
                },
                attemp_answer: {
                    include: {
                        quiz_question: true,
                        attemp_multiple_answer: {
                            include: { quiz_answer: true },
                        },
                    },
                    orderBy: { order: 'asc' },
                },
            },
        });

        if (!attempt) throw new Error('Attempt not found or unauthorized');
        if (!attempt.submitted_at) throw new Error('Quiz not submitted yet');

        const metrics = this.computeAttemptMetrics(attempt);
        const showReviewAllowed =
            attempt.quiz.show_review ||
            requesterRole === 'Teacher' ||
            requesterRole === 'Admin';

        if (!showReviewAllowed) {
            return {
                attemptId: attempt.id,
                quizId: attempt.quizId,
                quizTitle: attempt.quiz.title,
                score: metrics.percentage,
                totalScore: 100,
                passingGrade: attempt.quiz.passing_grade,
                percentage: metrics.percentage,
                isPassed: metrics.isPassed,
                abilityEstimate: metrics.abilityEstimate,
                ability_estimate: metrics.abilityEstimate,
                abilityLevel: metrics.abilityLevel,
                ability_level: metrics.abilityLevel,
                showReview: false,
                show_review: false,
                isGraded: attempt.is_graded,
                submittedAt: attempt.submitted_at,
                message:
                    'Guru menonaktifkan tinjauan pembahasan untuk kuis ini.',
                reviews: [],
                review: [],
            };
        }

        const eligibleQuestions = filterAdaptiveEligibleQuestions(
            attempt.quiz.quiz_question
        );

        // Urutkan soal berdasarkan urutan penyajian ke siswa (order asc), diikuti soal yang belum sempat disajikan jika waktu habis
        const servedOrderMap = new Map<number, number>();
        attempt.attemp_answer.forEach((ans, idx) => {
            servedOrderMap.set(ans.questionId, ans.order ?? idx + 1);
        });

        const orderedQuestions = [...eligibleQuestions].sort((a, b) => {
            const orderA = servedOrderMap.get(a.id) ?? Number.MAX_SAFE_INTEGER;
            const orderB = servedOrderMap.get(b.id) ?? Number.MAX_SAFE_INTEGER;
            if (orderA !== orderB) return orderA - orderB;
            return a.id - b.id;
        });

        const reviews = orderedQuestions.map((question, idx) => {
            const userAnswerRow = attempt.attemp_answer.find(
                (ans) => ans.questionId === question.id
            );

            const isCorrect = userAnswerRow
                ? this.isAttemptAnswerCorrect(userAnswerRow, question)
                : false;

            const correctOptions = question.quiz_answer.filter(
                (a) => a.is_correct
            );
            const correctAnswerIds = correctOptions.map((a) => a.id);
            const correctAnswers = correctOptions.map((a) => ({
                id: a.id,
                answer: a.answer,
            }));

            let userAnswerIds: number[] =
                userAnswerRow?.attemp_multiple_answer.map(
                    (a) => a.quiz_answer.id
                ) ?? [];

            if (
                userAnswerIds.length === 0 &&
                question.type === 'TrueFalse' &&
                userAnswerRow?.answer
            ) {
                const matchedOption = question.quiz_answer.find(
                    (a) =>
                        a.answer.trim().toLowerCase() ===
                        userAnswerRow.answer!.trim().toLowerCase()
                );
                if (matchedOption) {
                    userAnswerIds = [matchedOption.id];
                }
            }

            const userAnswers =
                userAnswerRow?.attemp_multiple_answer.map((a) => ({
                    id: a.quiz_answer.id,
                    answer: a.quiz_answer.answer,
                })) ??
                (userAnswerRow?.answer
                    ? [{ answer: userAnswerRow.answer }]
                    : []);

            return {
                order: userAnswerRow?.order ?? idx + 1,
                questionId: question.id,
                question: question.question,
                type: question.type,
                points: question.points,
                difficulty: question.difficulty,
                isCorrect,
                explanation: question.explanation,
                userAnswer: userAnswerIds,
                correctAnswer: correctAnswerIds,
                userAnswers,
                correctAnswers,
                answers: question.quiz_answer.map((a) => ({
                    id: a.id,
                    answer: a.answer,
                    isCorrect: a.is_correct,
                })),
            };
        });

        return {
            attemptId: attempt.id,
            quizId: attempt.quizId,
            quizTitle: attempt.quiz.title,
            score: metrics.percentage,
            totalScore: 100,
            passingGrade: attempt.quiz.passing_grade,
            percentage: metrics.percentage,
            isPassed: metrics.isPassed,
            correctAnswersCount: metrics.correctAnswersCount,
            totalQuestions: metrics.totalQuestions,
            abilityEstimate: metrics.abilityEstimate,
            ability_estimate: metrics.abilityEstimate,
            abilityLevel: metrics.abilityLevel,
            ability_level: metrics.abilityLevel,
            showReview: attempt.quiz.show_review,
            show_review: attempt.quiz.show_review,
            isGraded: attempt.is_graded,
            submittedAt: attempt.submitted_at,
            reviews,
            review: reviews,
        };
    }
}
