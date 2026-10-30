import prisma from "..";

export const quiz_attemptSeed = async () => {
    console.log("\n🌱 Seeding quiz attempts (riwayat pengerjaan kuis siswa)...");
    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });
    const quizzes = await prisma.quiz.findMany({
        include: { Section: true },
    });

    if (students.length === 0 || quizzes.length === 0) {
        throw new Error("Students and Quizzes must be seeded before seeding quiz attempts.");
    }

    const siswaDemo = students.find((s) => s.username === "siswa_demo") ?? students[0];
    const annisa = students.find((s) => s.username === "annisa") ?? students[1];
    const fajar = students.find((s) => s.username === "fajar") ?? students[2];

    // Bersihkan attempt kuis lama siswa_demo agar skenario demo selalu konsisten (1 lulus tinggi + 1 remedial)
    await prisma.quiz_Attempt.deleteMany({
        where: { userId: siswaDemo.id },
    });

    for (let i = 0; i < quizzes.length; i++) {
        const quiz = quizzes[i];
        const secTitle = quiz.Section.title;

        // 1. Skenario Kurasi `siswa_demo` untuk Presentasi Klien:
        // - Bab 1 Ekosistem Hutan: LULUS TINGGI (Skor 90 / KKM 70) -> menghidupkan banner "Lanjutkan Perjalanan Belajarmu"!
        // - Bab Filosofi Budaya: LULUS (Skor 85 / KKM 70)
        // - Bab Pestisida Nabati: REMEDIAL (Skor 55 / KKM 70) -> menghidupkan banner "Perkuat Pemahamanmu" & tab "Remedial"!
        // - Bab lain sengaja belum dikerjakan kuisnya agar siswa_demo juga bisa live-demo mengerjakan Kuis Adaptif dari awal!
        if (secTitle === "Pengenalan Ekosistem Hutan Tropis & Rantai Makanan") {
            await prisma.quiz_Attempt.create({
                data: {
                    userId: siswaDemo.id,
                    quizId: quiz.id,
                    score: 90,
                    ability_estimate: 1.4,
                    is_graded: true,
                    started_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
                    submitted_at: new Date(
                        Date.now() - 3 * 24 * 60 * 60 * 1000 + 18 * 60 * 1000
                    ),
                },
            });
        } else if (secTitle === "Filosofi Harmoni Manusia dan Alam Nusantara") {
            await prisma.quiz_Attempt.create({
                data: {
                    userId: siswaDemo.id,
                    quizId: quiz.id,
                    score: 85,
                    ability_estimate: 1.0,
                    is_graded: true,
                    started_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
                    submitted_at: new Date(
                        Date.now() - 2 * 24 * 60 * 60 * 1000 + 15 * 60 * 1000
                    ),
                },
            });
        } else if (secTitle === "Pengendalian Hama Ramah Lingkungan (Pestisida Nabati)") {
            await prisma.quiz_Attempt.create({
                data: {
                    userId: siswaDemo.id,
                    quizId: quiz.id,
                    score: 55,
                    ability_estimate: -0.6,
                    is_graded: true,
                    started_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
                    submitted_at: new Date(
                        Date.now() - 1 * 24 * 60 * 60 * 1000 + 20 * 60 * 1000
                    ),
                },
            });
        }

        // 2. Annisa: Mengerjakan sebagian kuis dengan nilai pas KKM (skor 75)
        if (i % 2 === 0 && annisa) {
            const existingAnnisa = await prisma.quiz_Attempt.findFirst({
                where: { userId: annisa.id, quizId: quiz.id },
            });
            if (!existingAnnisa) {
                await prisma.quiz_Attempt.create({
                    data: {
                        userId: annisa.id,
                        quizId: quiz.id,
                        score: 75,
                        ability_estimate: 0.5,
                        is_graded: true,
                        started_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
                        submitted_at: new Date(
                            Date.now() - 1 * 24 * 60 * 60 * 1000 + 20 * 60 * 1000
                        ),
                    },
                });
            }
        }

        // 3. Fajar: Mengerjakan kuis pertama dengan nilai di bawah KKM (skor 50 < 70)
        if (i === 0 && fajar) {
            const existingFajar = await prisma.quiz_Attempt.findFirst({
                where: { userId: fajar.id, quizId: quiz.id },
            });
            if (!existingFajar) {
                await prisma.quiz_Attempt.create({
                    data: {
                        userId: fajar.id,
                        quizId: quiz.id,
                        score: 50,
                        ability_estimate: -0.8,
                        is_graded: true,
                        started_at: new Date(Date.now() - 12 * 60 * 60 * 1000),
                        submitted_at: new Date(Date.now() - 11 * 60 * 60 * 1000),
                    },
                });
            }
        }
    }

    console.log(
        "✅ Quiz attempts seeded: Skenario lulus KKM & remedial siap ditampilkan langsung di akun siswa_demo."
    );
};
