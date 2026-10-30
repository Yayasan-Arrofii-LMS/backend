import prisma from "..";

export const material_activitiesSeed = async () => {
    console.log("\n🌱 Seeding material activities (log interaksi materi siswa)...");

    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });
    const materials = await prisma.material.findMany();

    if (students.length === 0 || materials.length === 0) {
        console.log("⚠️ Students/Materials not found, skipping material activities.");
        return;
    }

    const siswaDemo = students.find((s) => s.username === "siswa_demo") ?? students[0];

    // Bersihkan log lama siswa_demo agar idempoten saat re-seed demo klien
    await prisma.materialActivity.deleteMany({
        where: { userId: siswaDemo.id },
    });

    const findMat = (title: string) => materials.find((m) => m.title === title);

    // 1. Materi yang sudah SELESAI (opened + completed)
    const completedTitles = [
        "Struktur Kanopi dan Stratifikasi Hutan Tropis",
        "Video Dokumentasi: Rantai Makanan di Hutan Lindung",
        "Mengenal 'Cokelat' dan 'Hijau' dalam Kompos",
        "Prinsip Tri Hita Karana & Hutan Larangan Adat",
    ];

    for (let i = 0; i < completedTitles.length; i++) {
        const mat = findMat(completedTitles[i]);
        if (!mat) continue;
        const baseDate = new Date(Date.now() - (6 - i) * 24 * 60 * 60 * 1000);

        await prisma.materialActivity.createMany({
            data: [
                {
                    userId: siswaDemo.id,
                    materialId: mat.id,
                    action: "opened",
                    createdAt: baseDate,
                },
                {
                    userId: siswaDemo.id,
                    materialId: mat.id,
                    action: "completed",
                    createdAt: new Date(baseDate.getTime() + 20 * 60 * 1000),
                },
            ],
        });
    }

    // 2. Materi yang SEDANG DIPELAJARI / SUDAH DIBUKA tetapi belum tuntas (memicu tab Berdasarkan Progres & status 'Dipelajari'/'Dibuka')
    const openedOnlyTitles = [
        "Video Tutorial: Membuat Kompos Ember Tumpuk Rumah Tangga", // Section Kompos sudah 50% -> status 'in_progress' (Dipelajari)
        "Teknik Mulsa Organik untuk Mempertahankan Kelembaban Tanah", // Section baru dibuka 0% -> status 'opened' (Dibuka)
    ];

    for (let i = 0; i < openedOnlyTitles.length; i++) {
        const mat = findMat(openedOnlyTitles[i]);
        if (!mat) continue;
        await prisma.materialActivity.create({
            data: {
                userId: siswaDemo.id,
                materialId: mat.id,
                action: "opened",
                createdAt: new Date(Date.now() - (2 - i) * 24 * 60 * 60 * 1000),
            },
        });
    }

    console.log("✅ Material activities seeded: Log aktivitas riwayat belajar siswa tersimpan.");
};
