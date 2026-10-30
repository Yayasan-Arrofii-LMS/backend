import prisma from "..";

const SECTION_TEMPLATES: Record<string, { title: string; description: string }[]> = {
    "Konservasi Hutan & Ekosistem Alam": [
        {
            title: "Pengenalan Ekosistem Hutan Tropis & Rantai Makanan",
            description: "Memahami struktur lapisan kanopi, peran pohon pencegah erosi, dan simbiosis organisme hutan.",
        },
        {
            title: "Pengamatan Lapangan & Identifikasi Spesies Endemik",
            description: "Teknik mencatat data fauna, keanekaragaman flora lokal, dan pemetaan vegetasi liar.",
        },
        {
            title: "Aksi Konservasi: Pembibitan & Reboisasi Mandiri",
            description: "Langkah penanaman bibit pohon native, perawatan bibit, dan penjagaan sumber mata air alami.",
        },
    ],
    "Pertanian Organik & Permakultur Mandiri": [
        {
            title: "Dasar Kesuburan Tanah & Pembuatan Kompos Organik",
            description: "Mengenal mikroorganisme tanah, rasio karbon-nitrogen, dan pembuatan pupuk kompos daun.",
        },
        {
            title: "Teknik Menanam Sayuran Organik Hemat Air",
            description: "Desain bedengan permakultur, mulsa alami, dan sistem penampungan air sederhana.",
        },
        {
            title: "Pengendalian Hama Ramah Lingkungan (Pestisida Nabati)",
            description: "Meracik ekstrak daun mimba, serai wangi, dan bawang putih untuk mengatasi serangga pengganggu.",
        },
    ],
    "Kewirausahaan Hijau & Kerajinan Ramah Lingkungan": [
        {
            title: "Identifikasi Potensi Hasil Alam & Prinsip Zero Waste",
            description: "Menganalisis hasil panen berlebih dan serat alam yang dapat diolah menjadi produk bermanfaat.",
        },
        {
            title: "Pengolahan & Pengemasan Ramah Lingkungan (Eco-Packaging)",
            description: "Desain kemasan dari pelepah pisang, besek bambu, dan pewarna alami ramah lingkungan.",
        },
    ],
    "Kearifan Budaya Lokal & Harmoni Alam": [
        {
            title: "Filosofi Harmoni Manusia dan Alam Nusantara",
            description: "Mempelajari kearifan lokal suku-suku nusantara dalam menjaga kelestarian hutan adat.",
        },
        {
            title: "Budidaya & Khasiat Tanaman Obat Keluarga (TOGA)",
            description: "Mengenal jahe merah, temulawak, sambiloto, dan cara pengolahan jamu tradisional.",
        },
    ],
    "Teknologi Bersih & Energi Terbarukan Sederhana": [
        {
            title: "Pemanfaatan Energi Surya Skala Mini untuk Saung Alam",
            description: "Prinsip kerja panel surya 50W, inverter mini, dan pengisian baterai tenaga surya.",
        },
        {
            title: "Sistem Sensor Kelembaban Tanah untuk Kebun Cerdas",
            description: "Merakit sensor kelembaban sederhana untuk mendeteksi waktu terbaik menyiram tanaman.",
        },
    ],
};

export const sectionsSeeder = async () => {
    console.log("\n🌱 Seeding realistic sections for each class...");

    const classes = await prisma.class.findMany();

    if (classes.length === 0) {
        throw new Error("Classes must be seeded before seeding sections.");
    }

    for (const cls of classes) {
        const templates = SECTION_TEMPLATES[cls.name] || [
            {
                title: `Bab 1: Pengantar ${cls.name}`,
                description: `Materi dasar dan konsep pendukung untuk mata pelajaran ${cls.name}.`,
            },
            {
                title: `Bab 2: Praktik Lapangan ${cls.name}`,
                description: `Penerapan langsung konsep teori dalam kegiatan alam terbuka.`,
            },
        ];

        for (let i = 0; i < templates.length; i++) {
            const t = templates[i];
            const existing = await prisma.section.findFirst({
                where: {
                    classId: cls.id,
                    title: t.title,
                },
            });

            if (existing) {
                await prisma.section.update({
                    where: { id: existing.id },
                    data: {
                        description: t.description,
                        order: i + 1,
                    },
                });
            } else {
                await prisma.section.create({
                    data: {
                        title: t.title,
                        description: t.description,
                        classId: cls.id,
                        order: i + 1,
                    },
                });
            }
        }
    }

    console.log("✅ Sections seeded dengan struktur bab yang natural dan terorganisir.");
};