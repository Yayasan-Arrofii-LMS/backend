import { randWord } from "@ngneat/falso";
import prisma from "..";

const difficulties = ["Easy", "Medium", "Hard"];
const mediaTypes = ["Text", "Video", "Pdf", "Mixed"];

export const materialsSeed = async () => {
    console.log("\n🌱 Seeding materials...");
    const sections = await prisma.section.findMany({
        include: {
            Class: true,
        },
    });

    if (sections.length === 0) {
        throw new Error("Sections must be seeded before seeding materials.");
    }

    const categories = await prisma.category.findMany();

    for (const section of sections) {
        const randCount = Math.floor(Math.random() * 6) + 1;
        for (let i = 1; i <= randCount; i++) {
            const classCategoryId = section.Class?.categoryId;
            const randomCategory = categories.length > 0
                ? categories[Math.floor(Math.random() * categories.length)]
                : null;

            // Mayoritas (80%) inherit dari kategori kelas, 20% variasi override
            const shouldOverride = Math.random() < 0.20;
            const categoryId = (!shouldOverride && classCategoryId)
                ? classCategoryId
                : (randomCategory ? randomCategory.id : classCategoryId ?? null);

            const randomDifficulty = difficulties[Math.floor(Math.random() * difficulties.length)];
            const randomMediaType = mediaTypes[Math.floor(Math.random() * mediaTypes.length)];

            await prisma.material.create({
                data: {
                    title: randWord({ length: 5 }).join(' '),
                    content: randWord({ length: 15 }).join(' '),
                    xp: Math.floor(Math.random() * 100) + 1,
                    sectionId: section.id,
                    order: i,
                    categoryId,
                    difficulty: randomDifficulty,
                    mediaType: randomMediaType,
                }
            });
        }
    }

    console.log("✅ Materials seeded with inherited & overridden categories and metadata.");
};