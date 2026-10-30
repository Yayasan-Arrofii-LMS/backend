import prisma from "..";

export const matkuls = ["Ekologi Hutan", "Pertanian Organik", "Kewirausahaan Hijau", "Kearifan Budaya"];

export const sampleClasses = [
    {
        name: "Konservasi Hutan & Ekosistem Alam",
        categoryName: "Sains Alam",
        description: "Mempelajari keanekaragaman flora dan fauna hutan tropis, rantai makanan, serta praktik konservasi tanah dan air secara berkelanjutan.",
        image_path: "https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&auto=format&fit=crop&q=60",
    },
    {
        name: "Pertanian Organik & Permakultur Mandiri",
        categoryName: "Keterampilan Hidup",
        description: "Panduan praktis budidaya sayuran sehat bebas pestisida kimia, pembuatan pupuk kompos cair, dan pemanfaatan pekarangan rumah.",
        image_path: "https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800&auto=format&fit=crop&q=60",
    },
    {
        name: "Kewirausahaan Hijau & Kerajinan Ramah Lingkungan",
        categoryName: "Kewirausahaan",
        description: "Belajar mengolah hasil kebun dan material alam sekitar menjadi produk bernilai ekonomi tinggi dengan prinsip keberlanjutan dan zero waste.",
        image_path: "https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=60",
    },
    {
        name: "Kearifan Budaya Lokal & Harmoni Alam",
        categoryName: "Budaya",
        description: "Menelusuri warisan arsitektur bambu tradisional, tanaman obat keluarga nusantara (TOGA), dan filosofi hidup selaras dengan alam.",
        image_path: "https://images.unsplash.com/photo-1533900298318-6b8da08a523e?w=800&auto=format&fit=crop&q=60",
    },
    {
        name: "Teknologi Bersih & Energi Terbarukan Sederhana",
        categoryName: "Teknologi & Lingkungan",
        description: "Pengenalan teknologi tepat guna ramah lingkungan seperti panel surya mini, instalasi filtrasi air hujan, dan sensor kelembaban kebun.",
        image_path: "https://images.unsplash.com/photo-1509391365360-2e959784a276?w=800&auto=format&fit=crop&q=60",
    },
];

export const classesSeed = async () => {
    console.log("\n🌱 Seeding classes with realistic Sekolah Alam subjects...");

    const categories = await prisma.category.findMany();

    for (const item of sampleClasses) {
        const cat = categories.find((c) => c.name.toLowerCase() === item.categoryName.toLowerCase());
        const existing = await prisma.class.findFirst({ where: { name: item.name } });

        if (existing) {
            await prisma.class.update({
                where: { id: existing.id },
                data: {
                    description: item.description,
                    image_path: item.image_path,
                    categoryId: cat ? cat.id : existing.categoryId,
                },
            });
        } else {
            await prisma.class.create({
                data: {
                    name: item.name,
                    description: item.description,
                    image_path: item.image_path,
                    categoryId: cat ? cat.id : null,
                },
            });
        }
    }

    console.log(`✅ ${sampleClasses.length} Kelas Sekolah Alam berhasil di-seed dengan gambar dan kategori resmi.`);
};
