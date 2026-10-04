import { randWord } from "@ngneat/falso";
import prisma from "..";

const difficulties = ["Easy", "Medium", "Hard"];
const mediaTypes = ["Text", "Video", "Pdf", "Mixed"];

export const materialsSeed = async () => {
    console.log("\n🌱 Seeding materials...");
    const sections = await prisma.section.findMany();

    if (sections.length === 0) {
        throw new Error("Sections must be seeded before seeding materials.");
    }

    const categories = await prisma.category.findMany();

    for (const section of sections) {
        const randCount = Math.floor(Math.random() * 6) + 1;
        for (let i = 1; i <= randCount; i++) {
            const randomCategory = categories.length > 0
                ? categories[Math.floor(Math.random() * categories.length)]
                : null;
            const randomDifficulty = difficulties[Math.floor(Math.random() * difficulties.length)];
            const randomMediaType = mediaTypes[Math.floor(Math.random() * mediaTypes.length)];

            await prisma.material.create({
                data: {
                    title: randWord({ length: 5 }).join(' '),
                    content: randWord({ length: 15 }).join(' '),
                    xp: Math.floor(Math.random() * 100) + 1,
                    sectionId: section.id,
                    order: i,
                    categoryId: randomCategory ? randomCategory.id : null,
                    difficulty: randomDifficulty,
                    mediaType: randomMediaType,
                }
            });
        }
    }

    console.log("✅ Materials seeded with categories and metadata.");
};