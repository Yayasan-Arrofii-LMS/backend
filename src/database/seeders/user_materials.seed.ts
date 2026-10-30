import { xp_source } from "@prisma/client";
import prisma from "..";

/**
 * Judul materi yang sengaja diset SELESAI untuk `siswa_demo` agar dalam 1 akun demo klien:
 * - Bab 1 Ekosistem Hutan selesai 100% (2/2 materi) -> memicu banner "Lanjutkan Perjalanan Belajarmu" ke Bab 2!
 * - Bab 1 Kompos Organik selesai 50% (1/2 materi) -> memicu kartu "Berdasarkan Progres" dengan bar Progres Belajar 50%!
 * - Bab 1 Filosofi Budaya selesai 100% (1/1 materi) -> memperkaya Riwayat Rekomendasi berstatus "Selesai"!
 * - Sisanya belum selesai -> mengisi tab Minat, Progres, Remedial, dan Materi Lanjutan secara lengkap!
 */
const DEMO_COMPLETED_TITLES = new Set([
    "Struktur Kanopi dan Stratifikasi Hutan Tropis",
    "Video Dokumentasi: Rantai Makanan di Hutan Lindung",
    "Mengenal 'Cokelat' dan 'Hijau' dalam Kompos",
    "Prinsip Tri Hita Karana & Hutan Larangan Adat",
]);

export const user_materialsSeed = async () => {
    console.log("\n🌱 Seeding user materials & student progress...");
    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });
    const materials = await prisma.material.findMany({
        orderBy: [{ sectionId: "asc" }, { order: "asc" }],
    });

    if (students.length === 0 || materials.length === 0) {
        throw new Error("Students and Materials must be seeded before seeding user materials.");
    }

    const siswaDemo = students.find((s) => s.username === "siswa_demo") ?? students[0];
    const annisa = students.find((s) => s.username === "annisa") ?? students[1];
    const fajar = students.find((s) => s.username === "fajar") ?? students[2];

    for (let i = 0; i < materials.length; i++) {
        const material = materials[i];

        // 1. Siswa Demo: skenario kurasi khusus demo klien agar seluruh widget & 4 tab rekomendasi terisi hidup
        const isDemoCompleted = DEMO_COMPLETED_TITLES.has(material.title);
        await prisma.user_Material.upsert({
            where: {
                userId_materialId: {
                    userId: siswaDemo.id,
                    materialId: material.id,
                },
            },
            update: { is_completed: isDemoCompleted },
            create: {
                userId: siswaDemo.id,
                materialId: material.id,
                is_completed: isDemoCompleted,
            },
        });

        if (isDemoCompleted) {
            const existingXp = await prisma.xp.findFirst({
                where: {
                    userId: siswaDemo.id,
                    source: xp_source.Material,
                    sourceId: material.id.toString(),
                },
            });
            if (!existingXp) {
                await prisma.xp.create({
                    data: {
                        userId: siswaDemo.id,
                        source: xp_source.Material,
                        sourceId: material.id.toString(),
                        points: material.xp,
                    },
                });
            }
        }

        // 2. Annisa: 40% materi diselesaikan
        if (annisa) {
            const isAnnisaCompleted = i % 3 === 0;
            await prisma.user_Material.upsert({
                where: {
                    userId_materialId: {
                        userId: annisa.id,
                        materialId: material.id,
                    },
                },
                update: { is_completed: isAnnisaCompleted },
                create: {
                    userId: annisa.id,
                    materialId: material.id,
                    is_completed: isAnnisaCompleted,
                },
            });

            if (isAnnisaCompleted) {
                const existingXp = await prisma.xp.findFirst({
                    where: {
                        userId: annisa.id,
                        source: xp_source.Material,
                        sourceId: material.id.toString(),
                    },
                });
                if (!existingXp) {
                    await prisma.xp.create({
                        data: {
                            userId: annisa.id,
                            source: xp_source.Material,
                            sourceId: material.id.toString(),
                            points: material.xp,
                        },
                    });
                }
            }
        }

        // 3. Fajar: 20% materi diselesaikan
        if (fajar) {
            const isFajarCompleted = i === 0 || i === 1;
            await prisma.user_Material.upsert({
                where: {
                    userId_materialId: {
                        userId: fajar.id,
                        materialId: material.id,
                    },
                },
                update: { is_completed: isFajarCompleted },
                create: {
                    userId: fajar.id,
                    materialId: material.id,
                    is_completed: isFajarCompleted,
                },
            });

            if (isFajarCompleted) {
                const existingXp = await prisma.xp.findFirst({
                    where: {
                        userId: fajar.id,
                        source: xp_source.Material,
                        sourceId: material.id.toString(),
                    },
                });
                if (!existingXp) {
                    await prisma.xp.create({
                        data: {
                            userId: fajar.id,
                            source: xp_source.Material,
                            sourceId: material.id.toString(),
                            points: material.xp,
                        },
                    });
                }
            }
        }
    }

    console.log(
        "✅ User materials seeded: Progres belajar siswa terisi dengan persentase nyata dan perolehan XP."
    );
};
