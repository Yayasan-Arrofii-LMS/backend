import "dotenv/config";
import { rolesSeed } from "./seeders/roles.seed";
import { usersSeed } from "./seeders/users.seed";
import { categoriesSeed } from "./seeders/categories.seed";
import { classesSeed } from "./seeders/classes.seed";
import { user_classesSeed } from "./seeders/user_classes.seed";
import { sectionsSeeder } from "./seeders/sections.seed";
import { materialsSeed } from "./seeders/materials.seed";
import { material_filesSeed } from "./seeders/material_files.seed";
import { assigmentsSeed } from "./seeders/assigments.seed";
import { user_assigmentsSeed } from "./seeders/user_assigments.seed";
import { quizzesSeed } from "./seeders/quizzes.seed";
import { quiz_questionsSeed } from "./seeders/quiz_questions.seed";
import { quiz_answersSeed } from "./seeders/quiz_answers.seed";
import { quiz_attemptSeed } from "./seeders/quiz_attempt.seed";
import { attemp_answersSeed } from "./seeders/attemp_answers.seed";
import { user_materialsSeed } from "./seeders/user_materials.seed";
import { xpsSeed } from "./seeders/xps.seed";
import { workshopsSeed } from "./seeders/workshops.seed";
import { user_interestsSeed } from "./seeders/user_interests.seed";
import { material_activitiesSeed } from "./seeders/material_activities.seed";
import { recommendation_historiesSeed } from "./seeders/recommendation_histories.seed";
import prisma from "../database";

async function main() {
    console.log("🌱 =========================================");
    console.log("🌱 Seeding database untuk Demo Klien LMS...");
    console.log("🌱 =========================================");

    // 1. Fondasi Dasar: Role, Pengguna, & Kategori
    await rolesSeed();
    await usersSeed();
    await categoriesSeed();

    // 2. Kelas & Pendaftaran (Enrollment)
    await classesSeed();
    await user_classesSeed();

    // 3. Bab (Sections) & Materi Belajar
    await sectionsSeeder();
    await materialsSeed();
    await material_filesSeed();

    // 4. Tugas (Assignments) & Pengumpulan Siswa
    await assigmentsSeed();
    await user_assigmentsSeed();

    // 5. Kuis Adaptif, Bank Soal, & Evaluasi Siswa
    await quizzesSeed();
    await quiz_questionsSeed();
    await quiz_answersSeed();
    await quiz_attemptSeed();
    await attemp_answersSeed();

    // 6. Progres Belajar Siswa & Poin XP
    await user_materialsSeed();
    await xpsSeed();

    // 7. Modul Workshop & Kegiatan Non-Rutin
    await workshopsSeed();

    // 8. Personalisasi & Riwayat Rekomendasi
    await user_interestsSeed();
    await material_activitiesSeed();
    await recommendation_historiesSeed();

    console.log("\n=========================================");
    console.log("🎉 Database seeding demo SELESAI & SUKSES!");
    console.log("=========================================\n");
}

main()
    .catch((e) => {
        console.error("❌ Error during seeding:", e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
