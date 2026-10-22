import { QuizRepository } from '../repositories/quiz.repository';
import prisma from '../../../database';
import {
    AdaptiveAnswerInput,
    CreateQuestionInput,
    CreateQuizInput,
    StartQuizAttemptInput,
    SaveAnswerInput,
    SubmitQuizInput,
    GetAttemptResultInput,
    UpdateQuestionInput,
    UpdateQuizInput,
    getDifficultyRating,
} from '../types/quiz.type';
import { BulkCreateQuestionsInput } from '../schemas/quiz.schema';

export function buildQuestionBankWarnings(
    questions: { type: string; difficulty?: string | null }[]
): string[] {
    const warnings: string[] = [];
    const activeQuestions = questions.filter(
        (q) => q.type === 'MultipleChoice' || q.type === 'TrueFalse'
    );

    if (activeQuestions.length < 3) {
        warnings.push(
            'Bank soal memiliki kurang dari 3 soal (MultipleChoice/TrueFalse). Disarankan minimal 3 soal agar kuis adaptif berjalan optimal.'
        );
    }

    if (activeQuestions.length >= 1) {
        const distinctDifficulties = new Set(
            activeQuestions.map((q) => q.difficulty ?? 'Medium')
        );
        if (distinctDifficulties.size === 1) {
            warnings.push(
                'Semua soal memiliki tingkat kesulitan yang sama. Variasikan tingkat kesulitan (Easy, Medium, Hard) agar urutan adaptif berpengaruh.'
            );
        }
    }

    return warnings;
}

export class QuizService {
    // === Quiz ===
    static async getQuizzesBySection(sectionId: number) {
        return QuizRepository.getQuizzesBySection(sectionId);
    }

    static async getQuizzesBySectionForStudent(sectionId: number, userId: string) {
        const section = await prisma.section.findUnique({
            where: { id: sectionId },
        });

        if (!section) {
            throw new Error(`Section with ID ${sectionId} not found`);
        }

        return QuizRepository.getQuizzesBySectionForStudent(sectionId, userId);
    }

    static async createQuiz(data: CreateQuizInput) {
        const section = await prisma.section.findUnique({
            where: { id: data.sectionId },
        });

        if (!section) {
            throw new Error(`Section with ID ${data.sectionId} not found`);
        }

        return QuizRepository.createQuiz(data);
    }

    static async getQuizById(id: number) {
        const quiz = await QuizRepository.getQuizById(id);
        if (!quiz) throw new Error('Quiz not found');
        const warnings = buildQuestionBankWarnings(quiz.quiz_question ?? []);
        return {
            ...quiz,
            warnings,
        };
    }

    static async getQuizByIdForStudent(quizId: number, userId: string) {
        const quiz = await QuizRepository.getQuizByIdForStudent(quizId, userId);
        if (!quiz) throw new Error('Quiz not found');
        return quiz;
    }

    static async updateQuiz(id: number, data: UpdateQuizInput) {
        return QuizRepository.updateQuiz(id, data);
    }

    static async deleteQuiz(id: number) {
        return QuizRepository.deleteQuiz(id);
    }

    // === Question ===
    static async createQuestion(quizId: number, data: CreateQuestionInput) {
        if ((data.type as string) === 'Essay') {
            throw new Error('Tipe soal Essay tidak didukung pada kuis adaptif. Gunakan MultipleChoice atau TrueFalse');
        }
        await this.getQuizById(quizId);
        const created = await QuizRepository.createQuestion(quizId, data);
        const quiz = await QuizRepository.getQuizById(quizId);
        const warnings = buildQuestionBankWarnings(quiz?.quiz_question ?? []);
        return {
            ...created,
            warnings,
        };
    }

    static async updateQuestion(questionId: number, data: UpdateQuestionInput) {
        if ((data.type as string) === 'Essay') {
            throw new Error('Tipe soal Essay tidak didukung pada kuis adaptif. Gunakan MultipleChoice atau TrueFalse');
        }
        const updated = await QuizRepository.updateQuestion(questionId, data);
        if (!updated) throw new Error('Question not found');
        const quiz = await QuizRepository.getQuizById(updated.quizId);
        const warnings = buildQuestionBankWarnings(quiz?.quiz_question ?? []);
        return {
            ...updated,
            warnings,
        };
    }

    static async deleteQuestion(questionId: number) {
        return QuizRepository.deleteQuestion(questionId);
    }

    static async getAllQuestions(quizId: number, isStudent: boolean = false) {
        if (isStudent) {
            throw new Error('Akses ditolak: siswa tidak diizinkan mengambil seluruh daftar soal kuis secara langsung');
        }
        await this.getQuizById(quizId);
        return QuizRepository.getAllQuestions(quizId, isStudent);
    }

    static async getQuestionById(questionId: number, isStudent: boolean = false) {
        if (isStudent) {
            throw new Error('Akses ditolak: siswa hanya dapat mengakses soal melalui sesi pengerjaan kuis');
        }
        const question = await QuizRepository.getQuestionById(questionId, isStudent);
        if (!question) throw new Error('Question not found');
        return question;
    }

    // === Student Adaptive Quiz ===
    static async startQuizAttempt(userId: string, data: StartQuizAttemptInput) {
        const quiz = await this.getQuizById(data.quizId);

        const now = new Date();
        if (now < new Date(quiz.open_at)) {
            throw new Error('Quiz belum dibuka');
        }

        if (now > new Date(quiz.close_at)) {
            // Auto-submit any ongoing attempt then block new attempts
            const lateAttempts = await QuizRepository.getStudentAttempts(userId, data.quizId);
            const ongoingLate = lateAttempts.find((a) => a.submitted_at === null);
            if (ongoingLate) {
                await QuizRepository.submitQuiz(ongoingLate.id);
            }
            throw new Error('Quiz sudah ditutup');
        }

        const attempts = await QuizRepository.getStudentAttempts(userId, data.quizId);
        const ongoingAttempt = attempts.find((a) => a.submitted_at === null);

        if (ongoingAttempt) {
            const timeElapsed = now.getTime() - ongoingAttempt.started_at.getTime();
            const timeLimitMs = quiz.time_limit * 60 * 1000;

            if (timeElapsed < timeLimitMs) {
                // Resume attempt yang sedang berjalan (hanya kirim 1 soal aktif)
                return QuizRepository.getCurrentAttemptQuestion(ongoingAttempt.id);
            } else {
                // Auto-submit attempt yang sudah habis waktu
                await QuizRepository.submitQuiz(ongoingAttempt.id);
            }
        }

        // Hitung ulang jumlah attempt yang sudah selesai setelah auto-submit
        const updatedAttempts = await QuizRepository.getStudentAttempts(userId, data.quizId);
        const submittedAttempts = updatedAttempts.filter((a) => a.submitted_at !== null);

        if (submittedAttempts.length >= quiz.max_attempts) {
            throw new Error('Maksimal percobaan telah tercapai');
        }

        // Buat attempt adaptif baru dan kembalikan soal pertama
        return QuizRepository.startQuizAttempt(userId, data.quizId);
    }

    static async getCurrentAttemptQuestion(userId: string, attemptId: number) {
        const attempt = await QuizRepository.getAttemptById(attemptId);
        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        if (attempt.userId !== userId) {
            throw new Error('Anda tidak memiliki akses ke attempt ini');
        }

        if (attempt.submitted_at) {
            throw new Error('Quiz sudah di-submit');
        }

        const now = new Date();
        const timeElapsed = now.getTime() - attempt.started_at.getTime();
        const timeLimitMs = attempt.quiz.time_limit * 60 * 1000;

        if (timeElapsed >= timeLimitMs || now > new Date(attempt.quiz.close_at)) {
            await QuizRepository.submitQuiz(attemptId);
            throw new Error('Waktu quiz telah habis');
        }

        return QuizRepository.getCurrentAttemptQuestion(attemptId);
    }

    static async submitAdaptiveAnswer(userId: string, data: AdaptiveAnswerInput) {
        const attempt = await QuizRepository.getAttemptById(data.attemptId);
        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        if (attempt.userId !== userId) {
            throw new Error('Anda tidak memiliki akses ke attempt ini');
        }

        if (attempt.submitted_at) {
            throw new Error('Quiz sudah di-submit');
        }

        const now = new Date();
        const timeElapsed = now.getTime() - attempt.started_at.getTime();
        const timeLimitMs = attempt.quiz.time_limit * 60 * 1000;

        if (timeElapsed > timeLimitMs || now > new Date(attempt.quiz.close_at)) {
            // Auto-submit attempt di luar transaksi pelempar error agar status submit tersimpan
            await QuizRepository.submitQuiz(data.attemptId);
            throw new Error('Waktu quiz telah habis');
        }

        return QuizRepository.submitAdaptiveAnswer(data);
    }

    static async saveAnswer(userId: string, data: SaveAnswerInput) {
        const attempt = await QuizRepository.getAttemptById(data.attemptId);
        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        if (attempt.userId !== userId) {
            throw new Error('Anda tidak memiliki akses ke attempt ini');
        }

        if (attempt.submitted_at) {
            throw new Error('Quiz sudah di-submit');
        }

        const now = new Date();
        const timeElapsed = now.getTime() - attempt.started_at.getTime();
        const timeLimitMs = attempt.quiz.time_limit * 60 * 1000;

        if (timeElapsed > timeLimitMs || now > new Date(attempt.quiz.close_at)) {
            await QuizRepository.submitQuiz(data.attemptId);
            throw new Error('Waktu quiz telah habis');
        }

        return QuizRepository.saveAnswer(data);
    }

    static async submitQuiz(userId: string, data: SubmitQuizInput) {
        const attempt = await QuizRepository.getAttemptById(data.attemptId);
        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        if (attempt.userId !== userId) {
            throw new Error('Anda tidak memiliki akses ke attempt ini');
        }

        return QuizRepository.submitQuiz(data.attemptId);
    }

    static async getAttemptResult(
        userId: string,
        data: GetAttemptResultInput,
        requesterRole: string = 'Student'
    ) {
        let attempt = await QuizRepository.getAttemptById(data.attemptId);
        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        const isTeacherOrAdmin =
            requesterRole === 'Teacher' || requesterRole === 'Admin';

        if (!isTeacherOrAdmin && attempt.userId !== userId) {
            throw new Error('Anda tidak memiliki akses ke attempt ini');
        }

        // Jika belum di-submit tapi waktu sudah habis, lakukan auto-submit
        if (!attempt.submitted_at) {
            const now = new Date();
            const timeElapsed = now.getTime() - attempt.started_at.getTime();
            const timeLimitMs = attempt.quiz.time_limit * 60 * 1000;
            if (timeElapsed >= timeLimitMs || now > new Date(attempt.quiz.close_at)) {
                await QuizRepository.submitQuiz(data.attemptId);
                attempt = await QuizRepository.getAttemptById(data.attemptId);
            } else {
                throw new Error('Quiz belum di-submit');
            }
        } else if (!attempt.is_graded) {
            await QuizRepository.submitQuiz(data.attemptId);
            attempt = await QuizRepository.getAttemptById(data.attemptId);
        }

        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        return {
            attemptId: attempt.id,
            quizId: attempt.quizId,
            quizTitle: attempt.quiz.title,
            score: attempt.percentage,
            percentage: attempt.percentage,
            totalScore: 100,
            passingGrade: attempt.quiz.passing_grade,
            isPassed: attempt.isPassed,
            totalQuestions: attempt.totalQuestions,
            correctAnswersCount: attempt.correctAnswersCount,
            abilityEstimate: attempt.abilityEstimate,
            ability_estimate: attempt.abilityEstimate,
            abilityLevel: attempt.abilityLevel,
            ability_level: attempt.abilityLevel,
            showReview: attempt.quiz.show_review,
            show_review: attempt.quiz.show_review,
            isGraded: attempt.is_graded,
            startedAt: attempt.started_at,
            submittedAt: attempt.submitted_at,
        };
    }

    static async getMyAttempts(userId: string, quizId: number) {
        return QuizRepository.getStudentAttempts(userId, quizId);
    }

    static async getAttemptQuestions(userId: string, attemptId: number) {
        const attempt = await QuizRepository.getAttemptById(attemptId);
        if (!attempt) {
            throw new Error('Attempt tidak ditemukan');
        }

        if (attempt.userId !== userId) {
            throw new Error('Anda tidak memiliki akses ke attempt ini');
        }

        if (attempt.submitted_at) {
            throw new Error('Quiz sudah disubmit, tidak bisa diubah lagi');
        }

        return QuizRepository.getAttemptQuestions(attemptId);
    }

    static async getQuizReview(
        userId: string,
        attemptId: number,
        requesterRole: string = 'Student'
    ) {
        return QuizRepository.getQuizReview(attemptId, userId, requesterRole);
    }

    static async bulkCreate(sectionId: number, bulkCreate: BulkCreateQuestionsInput) {
        const section = await prisma.section.findUnique({
            where: { id: sectionId },
        });

        if (!section) {
            throw new Error(`Section with ID ${sectionId} not found`);
        }

        const quizData = {
            title: bulkCreate.title,
            description: bulkCreate.description,
            max_attempts: bulkCreate.max_attempts,
            time_limit: bulkCreate.time_limit,
            open_at: new Date(bulkCreate.open_at),
            close_at: new Date(bulkCreate.close_at),
            passing_grade: bulkCreate.passing_grade,
            xp: bulkCreate.xp,
            show_review: bulkCreate.show_review ?? true,
            sectionId: sectionId,
        };

        const questionsData = bulkCreate.questions;

        for (const q of questionsData) {
            if ((q.type as string) === 'Essay') {
                throw new Error('Tipe soal Essay tidak didukung pada kuis adaptif. Gunakan MultipleChoice atau TrueFalse');
            }
        }

        const createdQuiz = await prisma.$transaction(async (tx) => {
            const quiz = await tx.quiz.create({
                data: quizData,
            });

            for (const questionData of questionsData) {
                const difficulty = questionData.difficulty ?? 'Medium';
                const question = await tx.quiz_Question.create({
                    data: {
                        question: questionData.question,
                        type: questionData.type as any,
                        points: questionData.points ?? 1,
                        difficulty,
                        difficulty_rating: getDifficultyRating(difficulty),
                        explanation: questionData.explanation,
                        quizId: quiz.id,
                    },
                });

                if (questionData.answers && questionData.answers.length > 0) {
                    await tx.quiz_Answer.createMany({
                        data: questionData.answers.map((a) => ({
                            answer: a.answer,
                            is_correct: a.is_correct,
                            questionId: question.id,
                        })),
                    });
                }
            }

            return tx.quiz.findUnique({
                where: { id: quiz.id },
                include: {
                    quiz_question: {
                        include: { quiz_answer: true },
                        orderBy: { id: 'asc' },
                    },
                },
            });
        });

        const warnings = buildQuestionBankWarnings(createdQuiz?.quiz_question ?? []);
        return {
            ...createdQuiz,
            warnings,
        };
    }
}
