import { class_role } from "@prisma/client";
import prisma from "..";

export const user_classesSeed = async () => {
    console.log("\n🌱 Seeding user_classes (enrollment guru & siswa)...");

    const students = await prisma.user.findMany({
        where: { role: { name: "Student" } },
    });
    const teachers = await prisma.user.findMany({
        where: { role: { name: "Teacher" } },
    });
    const classes = await prisma.class.findMany();

    if (students.length === 0 || classes.length === 0 || teachers.length === 0) {
        throw new Error("Users (Students, Teachers) and Classes must be seeded before seeding user_classes.");
    }

    for (let i = 0; i < classes.length; i++) {
        const cls = classes[i];
        // Pilih guru penanggung jawab secara bergantian
        const assignedTeacher = teachers[i % teachers.length];

        // Daftarkan Guru ke Kelas
        await prisma.user_Class.upsert({
            where: {
                userId_classId: {
                    userId: assignedTeacher.id,
                    classId: cls.id,
                },
            },
            update: { role: class_role.Teacher },
            create: {
                userId: assignedTeacher.id,
                classId: cls.id,
                role: class_role.Teacher,
            },
        });

        // Daftarkan semua siswa ke kelas demo agar saat login siswa dapat melihat kelas aktif
        for (const stu of students) {
            await prisma.user_Class.upsert({
                where: {
                    userId_classId: {
                        userId: stu.id,
                        classId: cls.id,
                    },
                },
                update: { role: class_role.Student },
                create: {
                    userId: stu.id,
                    classId: cls.id,
                    role: class_role.Student,
                },
            });
        }
    }

    console.log(`✅ user_classes seeded: ${teachers.length} Guru dan ${students.length} Siswa terdaftar di ${classes.length} Kelas.`);
};
