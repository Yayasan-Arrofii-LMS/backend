import { question_difficulty, quiz_question_type } from "@prisma/client";
import prisma from "..";
import { getDifficultyRating } from "../../api/v1/types/quiz.type";

const DIFFICULTY_PLAN: {
    difficulty: question_difficulty;
    type: quiz_question_type;
    label: string;
}[] = [
    { difficulty: "Easy", type: "MultipleChoice", label: "Mudah #1" },
    { difficulty: "Easy", type: "TrueFalse", label: "Mudah #2" },
    { difficulty: "Medium", type: "MultipleChoice", label: "Sedang #1" },
    { difficulty: "Medium", type: "TrueFalse", label: "Sedang #2" },
    { difficulty: "Hard", type: "MultipleChoice", label: "Sulit #1" },
    { difficulty: "Hard", type: "MultipleChoice", label: "Sulit #2" },
];

export const quiz_questionsSeed = async () => {
    console.log("\n🌱 Seeding quiz questions (3 difficulty levels: Easy, Medium, Hard)...");
    const quizzes = await prisma.quiz.findMany();

    if (quizzes.length === 0) {
        throw new Error("Quizzes must be seeded before seeding quiz questions.");
    }

    for (const quiz of quizzes) {
        for (const item of DIFFICULTY_PLAN) {
            await prisma.quiz_Question.create({
                data: {
                    quizId: quiz.id,
                    question: `[${item.label}] Pertanyaan tentang ${quiz.title}?`,
                    type: item.type,
                    points: 1,
                    difficulty: item.difficulty,
                    difficulty_rating: getDifficultyRating(item.difficulty),
                    explanation: `Pembahasan untuk soal tingkat ${item.difficulty} pada ${quiz.title}.`,
                },
            });
        }
    }

    console.log("✅ Quiz questions seeded across 3 difficulty levels.");
};
