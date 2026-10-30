import prisma from "..";

export const user_interestsSeed = async () => {
    console.log("\n🌱 Seeding user interests (preferensi minat siswa)...");

    const categories = await prisma.category.findMany();
    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });

    if (categories.length === 0 || students.length === 0) {
        console.log("⚠️ Categories/Students not found, skipping user interests.");
        return;
    }

    const getCatId = (name: string) => categories.find((c) => c.name.toLowerCase() === name.toLowerCase())?.id;

    const interestMapping: Record<string, string[]> = {
        siswa_demo: ["Sains Alam", "Teknologi & Lingkungan"],
        annisa: ["Keterampilan Hidup", "Budaya"],
        fajar: ["Kewirausahaan", "Sains Alam"],
        dewi: ["Budaya", "Keterampilan Hidup"],
        bima: ["Teknologi & Lingkungan", "Kewirausahaan"],
    };

    for (const stu of students) {
        const catNames = interestMapping[stu.username] || ["Sains Alam"];
        for (const catName of catNames) {
            const catId = getCatId(catName);
            if (catId) {
                await prisma.userInterest.upsert({
                    where: {
                        userId_categoryId: {
                            userId: stu.id,
                            categoryId: catId,
                        },
                    },
                    update: {},
                    create: {
                        userId: stu.id,
                        categoryId: catId,
                    },
                });
            }
        }
    }

    console.log("✅ User interests seeded: Profil minat siswa siap untuk personalisasi materi.");
};
