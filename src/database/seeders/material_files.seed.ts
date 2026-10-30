import prisma from "..";

export const material_filesSeed = async () => {
    console.log("\n🌱 Seeding material files (lampiran modul & PDF)...");

    const materials = await prisma.material.findMany();

    if (materials.length === 0) {
        throw new Error("Materials must be seeded before seeding material files.");
    }

    const sampleFiles = [
        {
            title: "Lembar Kerja Pengamatan Lapangan (LKS).pdf",
            path: "files/public/placeholder.png",
        },
        {
            title: "Modul Ringkasan & Petunjuk Praktikum.pdf",
            path: "files/public/placeholder.png",
        },
    ];

    for (const material of materials) {
        // Setiap materi diberi 1 atau 2 lampiran modul
        const filesToAdd = material.id % 2 === 0 ? sampleFiles : [sampleFiles[0]];

        for (const file of filesToAdd) {
            const existing = await prisma.material_File.findFirst({
                where: {
                    materialId: material.id,
                    title: file.title,
                },
            });

            if (!existing) {
                await prisma.material_File.create({
                    data: {
                        title: file.title,
                        path: file.path,
                        materialId: material.id,
                    },
                });
            }
        }
    }

    console.log("✅ Material files seeded.");
};