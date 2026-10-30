import { xp_source } from "@prisma/client";
import prisma from "..";

export const xpsSeed = async (): Promise<void> => {
    console.log("\n🌱 Seeding additional XP for quizzes and assignments...");

    // 1. Berikan XP untuk siswa yang menyelesaikan kuis dengan nilai lulus
    const attempts = await prisma.quiz_Attempt.findMany({
        where: { score: { gte: 70 } },
        include: { quiz: true },
    });

    for (const att of attempts) {
        const existing = await prisma.xp.findFirst({
            where: {
                userId: att.userId,
                source: xp_source.Quiz,
                sourceId: att.quizId.toString(),
            },
        });

        if (!existing) {
            await prisma.xp.create({
                data: {
                    userId: att.userId,
                    source: xp_source.Quiz,
                    sourceId: att.quizId.toString(),
                    points: att.quiz.xp,
                },
            });
        }
    }

    // 2. Berikan XP untuk siswa yang tugasnya sudah dinilai
    const userAssignments = await prisma.user_Assignment.findMany({
        where: { is_graded: true },
        include: { Assignment: true },
    });

    for (const ua of userAssignments) {
        const existing = await prisma.xp.findFirst({
            where: {
                userId: ua.userId,
                source: xp_source.Assignment,
                sourceId: ua.assignmentId.toString(),
            },
        });

        if (!existing) {
            await prisma.xp.create({
                data: {
                    userId: ua.userId,
                    source: xp_source.Assignment,
                    sourceId: ua.assignmentId.toString(),
                    points: ua.Assignment.xp,
                },
            });
        }
    }

    console.log("✅ Xps seeded: XP kuis dan tugas berhasil disinkronisasikan ke profil siswa.");
};