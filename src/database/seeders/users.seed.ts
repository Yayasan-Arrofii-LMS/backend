import prisma from "..";
import bcrypt from "bcrypt";

export const usersSeed = async () => {
    console.log("\n🌱 Seeding users for client demo...");
    const hashedPassword = await bcrypt.hash("password123", 10);

    const adminRole = await prisma.role.findUnique({ where: { name: "Admin" } });
    const teacherRole = await prisma.role.findUnique({ where: { name: "Teacher" } });
    const studentRole = await prisma.role.findUnique({ where: { name: "Student" } });

    if (!adminRole || !teacherRole || !studentRole) {
        throw new Error("Roles must be seeded before seeding users.");
    }

    // 1. Akun Admin
    const admins = [
        {
            email: "admin@sekolahalam.id",
            username: "admin",
            name: "Admin Sekolah Alam",
            roleId: adminRole.id,
            profileImage: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "umartaufiq8284@ugm.ac.id",
            username: "admin_umar",
            name: "Umar Taufiq (Admin)",
            roleId: adminRole.id,
            profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
    ];

    for (const a of admins) {
        await prisma.user.upsert({
            where: { email: a.email },
            update: a,
            create: a,
        });
    }

    // 2. Akun Guru / Pengajar (Teacher)
    const teachers = [
        {
            email: "budi@sekolahalam.id",
            username: "guru_budi",
            name: "Budi Santoso, S.Pd.",
            roleId: teacherRole.id,
            profileImage: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "siti@sekolahalam.id",
            username: "guru_siti",
            name: "Siti Rahmawati, M.Si.",
            roleId: teacherRole.id,
            profileImage: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "teachertestacc@example.com",
            username: "teachertestacc",
            name: "Guru Praktik (Test)",
            roleId: teacherRole.id,
            profileImage: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
    ];

    for (const t of teachers) {
        await prisma.user.upsert({
            where: { email: t.email },
            update: t,
            create: t,
        });
    }

    // 3. Akun Siswa (Student)
    const students = [
        {
            email: "siswa@sekolahalam.id",
            username: "siswa_demo",
            name: "Rizky Pratama (Demo Siswa)",
            roleId: studentRole.id,
            profileImage: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "annisa@sekolahalam.id",
            username: "annisa",
            name: "Annisa Larasati",
            roleId: studentRole.id,
            profileImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "fajar@sekolahalam.id",
            username: "fajar",
            name: "Fajar Hidayat",
            roleId: studentRole.id,
            profileImage: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "dewi@sekolahalam.id",
            username: "dewi",
            name: "Dewi Lestari",
            roleId: studentRole.id,
            profileImage: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
        {
            email: "bima@sekolahalam.id",
            username: "bima",
            name: "Bima Arya",
            roleId: studentRole.id,
            profileImage: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&auto=format&fit=crop&q=80",
            verified_at: new Date(),
            password: hashedPassword,
        },
    ];

    for (const s of students) {
        await prisma.user.upsert({
            where: { email: s.email },
            update: s,
            create: s,
        });
    }

    console.log(`✅ Users seeded: ${admins.length} Admin, ${teachers.length} Guru, ${students.length} Siswa (semua password: password123).`);
};
