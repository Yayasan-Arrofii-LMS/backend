import prisma from "..";

export const officialCategories = [
    { name: "Sains Alam" },
    { name: "Keterampilan Hidup" },
    { name: "Kewirausahaan" },
    { name: "Budaya" },
    { name: "Teknologi & Lingkungan" },
];

export const defaultCategories = officialCategories;

export const categoriesSeed = async () => {
    console.log("\n🌱 Seeding categories...");

    for (const category of defaultCategories) {
        await prisma.category.upsert({
            where: { name: category.name },
            update: {},
            create: { name: category.name },
        });
    }

    // Pembersihan idempoten: hapus kategori non-resmi dari DB
    // (relasi kelas & materi di-set null otomatis via onDelete: SetNull)
    const nonOfficialCategories = await prisma.category.findMany({
        where: {
            name: {
                notIn: defaultCategories.map((c) => c.name),
            },
        },
        select: { id: true },
    });

    for (const category of nonOfficialCategories) {
        await prisma.category.delete({
            where: { id: category.id },
        });
    }

    console.log("✅ Categories seeded.");
};
