import prisma from "..";
import { randomInt } from "crypto";

export const quiz_answersSeed = async () => {
    console.log("\n🌱 Seeding quiz answers...");
    const questions = await prisma.quiz_Question.findMany({
        include: { quiz_answer: true },
    });

    if (questions.length === 0) {
        throw new Error("Quiz questions must be seeded before seeding quiz answers.");
    }

    for (const question of questions) {
        if (question.quiz_answer.length > 0) {
            continue; // Sudah memiliki pilihan jawaban
        }

        if (question.type === "MultipleChoice") {
            const choices = [
                { answer: "Sangat benar dan selaras dengan prinsip keseimbangan alam", is_correct: true },
                { answer: "Kurang tepat karena mengabaikan siklus rantai makanan", is_correct: false },
                { answer: "Hanya berlaku untuk ekosistem buatan manusia", is_correct: false },
                { answer: "Berdampak negatif terhadap keanekaragaman hayati", is_correct: false },
            ];

            for (const choice of choices) {
                await prisma.quiz_Answer.create({
                    data: {
                        answer: choice.answer,
                        is_correct: choice.is_correct,
                        questionId: question.id,
                    },
                });
            }
        } else if (question.type === "TrueFalse") {
            await prisma.quiz_Answer.create({
                data: {
                    answer: "Benar",
                    is_correct: true,
                    questionId: question.id,
                },
            });
            await prisma.quiz_Answer.create({
                data: {
                    answer: "Salah",
                    is_correct: false,
                    questionId: question.id,
                },
            });
        }
    }

    console.log("✅ Quiz answers seeded dengan opsi jawaban natural dan idempoten.");
};