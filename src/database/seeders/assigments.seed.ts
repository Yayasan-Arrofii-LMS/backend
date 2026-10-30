import prisma from "..";

export const assigmentsSeed = async () => {
    console.log("\n🌱 Seeding realistic assignments...");
    const sections = await prisma.section.findMany();

    if (sections.length === 0) {
        throw new Error("Sections must be seeded before seeding assignments.");
    }

    const now = new Date();
    const openAt = new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000); // 3 hari lalu
    const closeAt = new Date(now.getTime() + 10 * 24 * 60 * 60 * 1000); // 10 hari ke depan

    let count = 0;
    for (const section of sections) {
        const title = `Proyek Praktik: ${section.title}`.slice(0, 100);
        const description = `Lakukan observasi lapangan topik "${section.title}" dan kumpulkan laporan foto format PDF.`.slice(0, 180);

        const existing = await prisma.assignment.findFirst({
            where: {
                sectionId: section.id,
                title,
            },
        });

        if (existing) {
            await prisma.assignment.update({
                where: { id: existing.id },
                data: {
                    description,
                    open_at: openAt,
                    close_at: closeAt,
                    xp: 50,
                },
            });
        } else {
            await prisma.assignment.create({
                data: {
                    title,
                    description,
                    open_at: openAt,
                    close_at: closeAt,
                    xp: 50,
                    sectionId: section.id,
                },
            });
            count++;
        }
    }

    console.log(`✅ Assignments seeded: Proyek tugas praktikum tersedia di setiap bab/section.`);
};