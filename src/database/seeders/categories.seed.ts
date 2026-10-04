import prisma from "..";

export const defaultCategories = [
    { name: "Sains Alam" },
    { name: "Keterampilan Hidup" },
    { name: "Kewirausahaan" },
    { name: "Budaya" },
    { name: "Pertanian & Lingkungan" },
    { name: "Teknologi" },
    { name: "Kepemimpinan & Karakter" },
];

export const categoriesSeed = async () => {
    console.log("\n🌱 Seeding categories...");

    for (const category of defaultCategories) {
        await prisma.category.upsert({
            where: { name: category.name },
            update: {},
            create: { name: category.name },
        });
    }

    console.log("✅ Categories seeded.");
};
