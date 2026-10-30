import prisma from "..";

const MATERIAL_MAP: Record<
    string,
    {
        title: string;
        content: string;
        xp: number;
        difficulty: string;
        mediaType: string;
        duration_minutes: number;
        video_link?: string;
    }[]
> = {
    "Pengenalan Ekosistem Hutan Tropis & Rantai Makanan": [
        {
            title: "Struktur Kanopi dan Stratifikasi Hutan Tropis",
            content:
                "Hutan hujan tropis memiliki 4 tingkatan utama: lapisan emergent, kanopi atas, understory, dan lantai hutan. Masing-masing lapisan dihuni oleh organisme dengan adaptasi cahaya dan kelembaban yang unik.",
            xp: 25,
            difficulty: "Easy",
            mediaType: "Text",
            duration_minutes: 10,
        },
        {
            title: "Video Dokumentasi: Rantai Makanan di Hutan Lindung",
            content:
                "Simak video observasi interaksi produsen (pohon beringin), konsumen tingkat 1 (burung rangkong & serangga), hingga dekomposer jamur lantai hutan dalam menjaga siklus hara.",
            xp: 30,
            difficulty: "Medium",
            mediaType: "Video",
            duration_minutes: 15,
            video_link: "https://www.youtube.com/watch?v=kYkyXbH6Bco",
        },
    ],
    "Pengamatan Lapangan & Identifikasi Spesies Endemik": [
        {
            title: "Panduan Pembuatan Herbarium dan Peta Spesies Daun",
            content:
                "Langkah-langkah mengumpulkan spesimen daun gugur, teknik pengeringan koran, dan pencatatan morfologi daun (tulang daun menyirip, menjari, sejajar) di buku jurnal alam.",
            xp: 35,
            difficulty: "Medium",
            mediaType: "Pdf",
            duration_minutes: 18,
        },
    ],
    "Aksi Konservasi: Pembibitan & Reboisasi Mandiri": [
        {
            title: "SOP Perbanyakan Bibit Pohon Asli Hutan (Native Trees)",
            content:
                "Teknik stratifikasi biji pohon kayu keras, pembuatan media tanam tanah gembur bercampur arang sekam, serta frekuensi penyiraman di polybag.",
            xp: 40,
            difficulty: "Hard",
            mediaType: "Text",
            duration_minutes: 25,
        },
    ],
    "Dasar Kesuburan Tanah & Pembuatan Kompos Organik": [
        {
            title: "Mengenal 'Cokelat' dan 'Hijau' dalam Kompos",
            content:
                "Kunci keberhasilan kompos ada pada perbandingan bahan kaya karbon (daun kering, serbuk gergaji = C) dan bahan kaya nitrogen (sisa sayur, kotoran hewan = N) dengan rasio 30:1.",
            xp: 25,
            difficulty: "Easy",
            mediaType: "Text",
            duration_minutes: 10,
        },
        {
            title: "Video Tutorial: Membuat Kompos Ember Tumpuk Rumah Tangga",
            content:
                "Panduan visual 10 menit membuat instalasi ember tumpuk sederhana untuk memproduksi pupuk organik cair (POC) dan kompos padat tanpa bau menyengat.",
            xp: 30,
            difficulty: "Easy",
            mediaType: "Video",
            duration_minutes: 12,
            video_link: "https://www.youtube.com/watch?v=Q74Vp8d3WzI",
        },
    ],
    "Teknik Menanam Sayuran Organik Hemat Air": [
        {
            title: "Teknik Mulsa Organik untuk Mempertahankan Kelembaban Tanah",
            content:
                "Penutupan bedengan dengan jerami padi atau serasah daun dapat menekan penguapan air hingga 70% dan menghambat pertumbuhan gulma perusak.",
            xp: 30,
            difficulty: "Medium",
            mediaType: "Text",
            duration_minutes: 14,
        },
    ],
    "Pengendalian Hama Ramah Lingkungan (Pestisida Nabati)": [
        {
            title: "Formulasi Pestisida Nabati Bawang Putih dan Serai",
            content:
                "Resep alami anti-kutu daun: tumbuk 5 siung bawang putih, 3 batang serai, campur dengan 1 liter air dan sedikit sabun lerak sebagai perekat alami.",
            xp: 35,
            difficulty: "Medium",
            mediaType: "Pdf",
            duration_minutes: 18,
        },
    ],
    "Identifikasi Potensi Hasil Alam & Prinsip Zero Waste": [
        {
            title: "Pemetaan Sumber Daya Alam Lokal Bernilai Tambah",
            content:
                "Menganalisis potensi bambu, getah damar, serat kelapa, dan buah musiman menjadi komoditas kerajinan dan pangan sehat bermutu tinggi.",
            xp: 25,
            difficulty: "Easy",
            mediaType: "Text",
            duration_minutes: 12,
        },
    ],
    "Pengolahan & Pengemasan Ramah Lingkungan (Eco-Packaging)": [
        {
            title: "Teknik Anyaman Besek Bambu & Daun Pisang Tahan Bocor",
            content:
                "Memanfaatkan kearifan kemasan tradisional nusantara yang higienis, estetik, dan terurai 100% secara alami di alam bebas.",
            xp: 35,
            difficulty: "Hard",
            mediaType: "Text",
            duration_minutes: 20,
        },
    ],
    "Filosofi Harmoni Manusia dan Alam Nusantara": [
        {
            title: "Prinsip Tri Hita Karana & Hutan Larangan Adat",
            content:
                "Meneladani sistem zonasi hutan larangan masyarakat adat di mana pohon tidak boleh ditebang sembarangan guna menjaga kelangsungan mata air desa.",
            xp: 20,
            difficulty: "Easy",
            mediaType: "Text",
            duration_minutes: 10,
        },
    ],
    "Budidaya & Khasiat Tanaman Obat Keluarga (TOGA)": [
        {
            title: "Katalog 10 Tanaman Obat Wajib di Pekarangan Sekolah",
            content:
                "Identifikasi rimpang jahe merah, kunyit, temulawak, kencur, daun sirih, sambiloto, pegagan, kumis kucing, mahkota dewa, dan binahong beserta manfaat kesehatannya.",
            xp: 30,
            difficulty: "Medium",
            mediaType: "Text",
            duration_minutes: 15,
        },
    ],
    "Pemanfaatan Energi Surya Skala Mini untuk Saung Alam": [
        {
            title: "Dasar Rangkaian Solar Home System (SHS) Sederhana",
            content:
                "Menghubungkan panel surya fotovoltaik, Solar Charge Controller (SCC), aki motor, dan lampu LED 12V untuk penerangan saung belajar mandiri.",
            xp: 40,
            difficulty: "Hard",
            mediaType: "Text",
            duration_minutes: 22,
        },
    ],
    "Sistem Sensor Kelembaban Tanah untuk Kebun Cerdas": [
        {
            title: "Prinsip Kerja Sensor Soil Moisture Resisting Sensor",
            content:
                "Bagaimana arus listrik mengukur hambatan air tanah dan menyalakan indikator LED jika tanah memerlukan penyiraman berkala.",
            xp: 45,
            difficulty: "Hard",
            mediaType: "Text",
            duration_minutes: 25,
        },
    ],
};

export const materialsSeed = async () => {
    console.log("\n🌱 Seeding realistic materials for each section...");

    const sections = await prisma.section.findMany({
        include: { Class: true },
    });

    if (sections.length === 0) {
        throw new Error("Sections must be seeded before seeding materials.");
    }

    for (const section of sections) {
        const classCategoryId = section.Class?.categoryId ?? null;
        const items = MATERIAL_MAP[section.title] || [
            {
                title: `Panduan Praktik ${section.title}`,
                content: `Penjelasan mendalam dan studi kasus mengenai topik ${section.title}. Siswa diajak melakukan observasi aktif di lingkungan alam sekitar.`,
                xp: 25,
                difficulty: "Medium",
                mediaType: "Text",
                duration_minutes: 15,
            },
        ];

        for (let i = 0; i < items.length; i++) {
            const item = items[i];
            const existing = await prisma.material.findFirst({
                where: {
                    sectionId: section.id,
                    title: item.title,
                },
            });

            if (existing) {
                await prisma.material.update({
                    where: { id: existing.id },
                    data: {
                        content: item.content,
                        xp: item.xp,
                        order: i + 1,
                        categoryId: classCategoryId,
                        difficulty: item.difficulty,
                        mediaType: item.mediaType,
                        duration_minutes: item.duration_minutes,
                        video_link: item.video_link ?? null,
                    },
                });
            } else {
                await prisma.material.create({
                    data: {
                        title: item.title,
                        content: item.content,
                        xp: item.xp,
                        sectionId: section.id,
                        order: i + 1,
                        categoryId: classCategoryId,
                        difficulty: item.difficulty,
                        mediaType: item.mediaType,
                        duration_minutes: item.duration_minutes,
                        video_link: item.video_link ?? null,
                    },
                });
            }
        }
    }

    console.log("✅ Materials seeded dengan konten Sekolah Alam yang edukatif dan realistis.");
};
