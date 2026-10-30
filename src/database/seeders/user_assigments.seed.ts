import prisma from "..";

export const user_assigmentsSeed = async () => {
    console.log("\n🌱 Seeding user assignments (pengumpulan tugas siswa)...");
    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });
    const assignments = await prisma.assignment.findMany();

    if (students.length === 0 || assignments.length === 0) {
        throw new Error("Students and Assignments must be seeded before seeding user assignments.");
    }

    const siswaDemo = students.find((s) => s.username === "siswa_demo") ?? students[0];
    const annisa = students.find((s) => s.username === "annisa") ?? students[1];
    const fajar = students.find((s) => s.username === "fajar") ?? students[2];

    for (let i = 0; i < assignments.length; i++) {
        const assignment = assignments[i];

        // 1. Siswa Demo (Rajin mengumpulkan, sudah dinilai dengan skor bagus)
        await prisma.user_Assignment.upsert({
            where: {
                userId_assignmentId: {
                    userId: siswaDemo.id,
                    assignmentId: assignment.id,
                },
            },
            update: {
                is_graded: true,
                grade: 90 + (i % 8),
                submitted_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
                path: "files/public/placeholder.png",
            },
            create: {
                userId: siswaDemo.id,
                assignmentId: assignment.id,
                is_graded: true,
                grade: 90 + (i % 8),
                submitted_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
                path: "files/public/placeholder.png",
            },
        });

        // 2. Annisa (Mengumpulkan sebagian tugas, sudah dinilai)
        if (i % 2 === 0 && annisa) {
            await prisma.user_Assignment.upsert({
                where: {
                    userId_assignmentId: {
                        userId: annisa.id,
                        assignmentId: assignment.id,
                    },
                },
                update: {
                    is_graded: true,
                    grade: 82 + (i % 10),
                    submitted_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
                    path: "files/public/placeholder.png",
                },
                create: {
                    userId: annisa.id,
                    assignmentId: assignment.id,
                    is_graded: true,
                    grade: 82 + (i % 10),
                    submitted_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
                    path: "files/public/placeholder.png",
                },
            });
        }

        // 3. Fajar (Mengumpulkan tugas tapi BELUM DINILAI -> siap untuk demo penilaian oleh Guru)
        if (i < 3 && fajar) {
            await prisma.user_Assignment.upsert({
                where: {
                    userId_assignmentId: {
                        userId: fajar.id,
                        assignmentId: assignment.id,
                    },
                },
                update: {
                    is_graded: false,
                    grade: null,
                    submitted_at: new Date(),
                    path: "files/public/placeholder.png",
                },
                create: {
                    userId: fajar.id,
                    assignmentId: assignment.id,
                    is_graded: false,
                    grade: null,
                    submitted_at: new Date(),
                    path: "files/public/placeholder.png",
                },
            });
        }
    }

    console.log("✅ User assignments seeded: Ada tugas sudah dinilai dan tugas baru menunggu penilaian guru.");
};