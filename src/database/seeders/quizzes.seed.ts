import prisma from "..";

export const quizzesSeed = async () => {
    console.log("\n🌱 Seeding quizzes...");
    const sections = await prisma.section.findMany();
    if (sections.length === 0) {
        throw new Error("Sections must be seeded before seeding quizzes.");
    }

    let createdCount = 0;

    for (let idx = 0; idx < sections.length; idx++) {
        const section = sections[idx];
        // Ensure first section always gets a quiz, and 40% chance for others
        const flag = idx === 0 || Math.random() < 0.4;
        if (!flag) {
            continue;
        }
        const now = new Date();
        const openAt = new Date(now.getTime() - 24 * 60 * 60 * 1000); // opened yesterday
        const closeAt = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000); // closes in 7 days

        await prisma.quiz.create({
            data: {
                title: `Quiz Adaptif: ${section.title}`,
                description: `Kuis adaptif untuk menguji penguasaan materi pada bagian ${section.title}.`,
                xp: Math.floor(Math.random() * 51) + 50, // XP between 50 and 100
                max_attempts: Math.floor(Math.random() * 3) + 1, // 1-3 attempts
                time_limit: (Math.floor(Math.random() * 4) + 1) * 15, // 15, 30, 45, 60 minutes
                open_at: openAt,
                close_at: closeAt,
                sectionId: section.id,
                passing_grade: 70,
                show_review: true,
            },
        });
        createdCount++;
    }
    console.log(`✅ Quizzes seeded (${createdCount} quizzes).`);
};
