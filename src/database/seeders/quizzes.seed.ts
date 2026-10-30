import prisma from "..";

export const quizzesSeed = async () => {
    console.log("\n🌱 Seeding quizzes...");
    const sections = await prisma.section.findMany();
    if (sections.length === 0) {
        throw new Error("Sections must be seeded before seeding quizzes.");
    }

    let createdCount = 0;
    const now = new Date();
    const openAt = new Date(now.getTime() - 24 * 60 * 60 * 1000); // dibuka kemarin
    const closeAt = new Date(now.getTime() + 14 * 24 * 60 * 60 * 1000); // ditutup 14 hari lagi

    for (let idx = 0; idx < sections.length; idx++) {
        const section = sections[idx];
        const title = `Kuis Evaluasi: ${section.title}`;

        const existing = await prisma.quiz.findFirst({
            where: {
                sectionId: section.id,
                title,
            },
        });

        if (existing) {
            await prisma.quiz.update({
                where: { id: existing.id },
                data: {
                    description: `Kuis adaptif bertingkat untuk menguji penguasaan materi pada bab "${section.title}".`,
                    xp: 50,
                    max_attempts: 3,
                    time_limit: 30,
                    open_at: openAt,
                    close_at: closeAt,
                    passing_grade: 70,
                    show_review: true,
                },
            });
        } else {
            await prisma.quiz.create({
                data: {
                    title,
                    description: `Kuis adaptif bertingkat untuk menguji penguasaan materi pada bab "${section.title}".`,
                    xp: 50,
                    max_attempts: 3,
                    time_limit: 30,
                    open_at: openAt,
                    close_at: closeAt,
                    sectionId: section.id,
                    passing_grade: 70,
                    show_review: true,
                },
            });
            createdCount++;
        }
    }
    console.log(`✅ Quizzes seeded: Kuis adaptif tersedia di setiap bab materi.`);
};
