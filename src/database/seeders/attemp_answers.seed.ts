import { quiz_question_type } from "@prisma/client";
import prisma from "..";

export const attemp_answersSeed = async () => {
    console.log("\n🌱 Seeding attempt answers (jawaban detail kuis siswa)...");

    const attempts = await prisma.quiz_Attempt.findMany();
    if (attempts.length === 0) {
        throw new Error("Quiz attempts must be seeded before seeding attempt answers.");
    }

    for (const attempt of attempts) {
        // Ambil HANYA pertanyaan yang sesuai dengan kuis yang dikerjakan
        const questions = await prisma.quiz_Question.findMany({
            where: { quizId: attempt.quizId },
            include: { quiz_answer: true },
        });

        for (let order = 0; order < questions.length; order++) {
            const question = questions[order];
            const isPassing = (attempt.score ?? 0) >= 70;
            // Jika nilai lulus, mayoritas benar; jika nilai remedial, beberapa dibuat salah
            const shouldBeCorrect = isPassing ? (order !== 0) : (order % 2 === 0);

            let answerText: string | null = null;
            let isCorrect = shouldBeCorrect;

            if (question.type === quiz_question_type.MultipleChoice) {
                const targetChoice = question.quiz_answer.find((a) => a.is_correct === shouldBeCorrect)
                    ?? question.quiz_answer[0];
                answerText = targetChoice ? targetChoice.answer : "Jawaban pilihan";
                isCorrect = targetChoice ? targetChoice.is_correct : false;
            } else if (question.type === quiz_question_type.TrueFalse) {
                answerText = shouldBeCorrect ? "Benar" : "Salah";
                isCorrect = shouldBeCorrect;
            } else {
                answerText = "Penjelasan singkat pemahaman materi.";
                isCorrect = true;
            }

            await prisma.attemp_Answer.upsert({
                where: {
                    attemptId_questionId: {
                        attemptId: attempt.id,
                        questionId: question.id,
                    },
                },
                update: {
                    answer: answerText,
                    order: order + 1,
                    is_correct: isCorrect,
                    answered_at: attempt.submitted_at ?? new Date(),
                },
                create: {
                    attemptId: attempt.id,
                    questionId: question.id,
                    answer: answerText,
                    order: order + 1,
                    is_correct: isCorrect,
                    answered_at: attempt.submitted_at ?? new Date(),
                },
            });
        }
    }

    console.log("✅ Attempt answers seeded: Jawaban tersinkronisasi tepat dengan soal kuis masing-masing.");
};