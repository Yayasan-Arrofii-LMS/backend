import prisma from "..";

export const workshopsSeed = async () => {
    console.log("\n🌱 Seeding workshops...");

    const instructor = await prisma.user.findFirst({
        where: { role: { name: { in: ["Teacher", "Admin"] } } },
    });

    if (!instructor) {
        console.log("⚠️ No Teacher/Admin user found, skipping workshops seed.");
        return;
    }

    const categories = await prisma.category.findMany();
    const getCategoryId = (name: string) =>
        categories.find((c) => c.name.toLowerCase() === name.toLowerCase())?.id ?? categories[0]?.id ?? null;

    const sampleWorkshops = [
        {
            title: "Eksplorasi Ekosistem Hutan & Biota Sungai",
            description: "Kegiatan observasi langsung ekosistem sungai dan hutan sekitar sekolah alam untuk mengenal keanekaragaman hayati.",
            thumbnail: "https://images.unsplash.com/photo-1511497584788-876760111969?w=800&auto=format&fit=crop&q=60",
            date: "2026-11-10",
            startTime: "08:30",
            endTime: "11:30",
            type: "Offline",
            location: "Area Hutan Edukasi Sekolah Alam",
            meetingLink: null,
            quota: 25,
            status: "Upcoming",
            categoryId: getCategoryId("Sains Alam"),
            instructorId: instructor.id,
        },
        {
            title: "Workshop Permakultur & Kompos Organik Mandiri",
            description: "Belajar membuat sistem kompos rumah tangga dan kebun permakultur hemat lahan bersama praktisi lingkungan.",
            thumbnail: "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800&auto=format&fit=crop&q=60",
            date: "2026-11-15",
            startTime: "09:00",
            endTime: "12:00",
            type: "Offline",
            location: "Kebun Praktik Sekolah Alam",
            meetingLink: null,
            quota: 20,
            status: "Upcoming",
            categoryId: getCategoryId("Keterampilan Hidup"),
            instructorId: instructor.id,
        },
        {
            title: "Inovasi IoT Sensor Kelembaban Tanah untuk Kebun Cerdas",
            description: "Sesi interaktif daring merakit dan memprogram sensor kelembaban tanah berbasis mikrokontroler.",
            thumbnail: "https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&auto=format&fit=crop&q=60",
            date: "2026-11-20",
            startTime: "13:00",
            endTime: "15:30",
            type: "Online",
            location: null,
            meetingLink: "https://meet.google.com/abc-defg-hij",
            quota: 30,
            status: "Upcoming",
            categoryId: getCategoryId("Teknologi & Lingkungan"),
            instructorId: instructor.id,
        },
        {
            title: "Kewirausahaan Hijau: Mengolah Hasil Panen Menjadi Produk Bernilai",
            description: "Pelatihan pengemasan, branding ramah lingkungan, dan pemasaran produk hasil kebun sekolah.",
            thumbnail: "https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&auto=format&fit=crop&q=60",
            date: "2026-11-25",
            startTime: "09:30",
            endTime: "12:00",
            type: "Offline",
            location: "Aula Utama Sekolah Alam",
            meetingLink: null,
            quota: 1,
            status: "Upcoming",
            categoryId: getCategoryId("Kewirausahaan"),
            instructorId: instructor.id,
        },
    ];

    for (const item of sampleWorkshops) {
        const existing = await prisma.workshop.findFirst({ where: { title: item.title } });
        const workshop = existing
            ? await prisma.workshop.update({ where: { id: existing.id }, data: item })
            : await prisma.workshop.create({ data: item });

        // Isi 1 peserta di workshop kuota=1 agar mencontohkan kondisi kuota penuh
        if (item.quota === 1) {
            await prisma.workshopParticipant.upsert({
                where: {
                    workshopId_userId: {
                        workshopId: workshop.id,
                        userId: instructor.id,
                    },
                },
                update: { status: "Terdaftar" },
                create: {
                    workshopId: workshop.id,
                    userId: instructor.id,
                    status: "Terdaftar",
                    notes: "Peserta perdana (kuota penuh)",
                },
            });
        }
    }

    console.log("✅ Workshops seeded.");
};
