import { recommendation_feedback } from "@prisma/client";
import prisma from "..";
import recommendationService from "../../api/v1/services/recommendation.service";

export const recommendation_historiesSeed = async () => {
    console.log("\n🌱 Seeding recommendation histories & student feedback...");

    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });

    if (students.length === 0) {
        console.log("⚠️ Students not found, skipping recommendation histories.");
        return;
    }

    const siswaDemo = students.find((s) => s.username === "siswa_demo") ?? students[0];

    // Bersihkan histori lama siswa_demo agar tanggal & alasan selalu segar dan konsisten
    await prisma.recommendation_History.deleteMany({
        where: { userId: siswaDemo.id },
    });

    // 1. Tambahkan riwayat rekomendasi lampau pada materi yang sudah SELESAI (tampak status 'Selesai' & badge 'Relevan')
    const completedUserMaterials = await prisma.user_Material.findMany({
        where: { userId: siswaDemo.id, is_completed: true },
        include: {
            Material: {
                include: {
                    category: true,
                    Section: true,
                },
            },
        },
    });

    const pastReasons = ["minat", "progres", "minat", "lanjutan"] as const;

    for (let i = 0; i < completedUserMaterials.length; i++) {
        const mat = completedUserMaterials[i].Material;
        const reason = pastReasons[i % pastReasons.length];
        const pastDate = new Date(Date.now() - (6 - i) * 24 * 60 * 60 * 1000);
        const reasonText =
            reason === "minat"
                ? `Sesuai dengan minatmu pada ${mat.category?.name ?? mat.Section.title}.`
                : reason === "progres"
                  ? `Direkomendasikan berdasarkan progres belajarmu di topik ${mat.Section.title}.`
                  : `Materi lanjutan yang siap dipelajari pada topik ${mat.Section.title}.`;

        await prisma.recommendation_History.create({
            data: {
                userId: siswaDemo.id,
                materialId: mat.id,
                primary_reason: reason,
                reasons: [reason],
                reason_text: reasonText,
                score: 3,
                feedback: i < 2 ? recommendation_feedback.relevant : null,
                feedback_at: i < 2 ? pastDate : null,
                first_recommended_at: pastDate,
                last_recommended_at: pastDate,
            },
        });
    }

    // 2. Jalankan engine rekomendasi untuk meng-generate impresi aktif nyata (remedial, minat, progres, lanjutan)
    const activeRecs = await recommendationService.getRecommendations(siswaDemo.id, {
        limit: 8,
    });

    // Beri feedback 'relevant' pada 2 kartu rekomendasi aktif agar tombol 👍 tampak menyala sebagian & sebagian lagi siap diklik saat live demo!
    for (let i = 0; i < Math.min(2, activeRecs.length); i++) {
        await recommendationService.submitFeedback(
            siswaDemo.id,
            activeRecs[i].material.id,
            "relevant",
            "Student"
        );
    }

    console.log(
        "✅ Recommendation histories seeded: Histori rekomendasi & feedback siswa siap ditampilkan."
    );
};
