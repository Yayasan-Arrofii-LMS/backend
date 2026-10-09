import { randWord } from "@ngneat/falso";
import prisma from "..";

export const matkuls = ["PPK", "Pancasila", "Agama", "Bahasa Indonesia"]

export const classesSeed = async () => {
    console.log("\n🌱 Seeding classes...");

    const categories = await prisma.category.findMany();

    for (let i = 0; i < 10; i++) {
        const assignedCategory = categories.length > 0
            ? categories[i % categories.length]
            : null;

        await prisma.class.create({
            data: {
                name: randWord(),
                description: randWord({ length: 30 }).join(" "),
                image_path: "files/public/placeholder.png",
                categoryId: assignedCategory ? assignedCategory.id : null,
            }
        });
    }

    console.log("✅ Classes seeded with categories.");
};

