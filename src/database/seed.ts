import "dotenv/config"; // ⬅️ ini akan load .env
import { rolesSeed } from "./seeders/roles.seed";
import { usersSeed } from "./seeders/users.seed";
import { classesSeed } from "./seeders/classes.seed";
import { user_classesSeed } from "./seeders/user_classes.seed";
import { categoriesSeed } from "./seeders/categories.seed";
import { sectionsSeeder } from "./seeders/sections.seed";
import { materialsSeed } from "./seeders/materials.seed";
import { workshopsSeed } from "./seeders/workshops.seed";
import { quizzesSeed } from "./seeders/quizzes.seed";
import { quiz_questionsSeed } from "./seeders/quiz_questions.seed";
import { quiz_answersSeed } from "./seeders/quiz_answers.seed";
import prisma from "../database";

async function main() {
    console.log("🌱 Seeding database...");

    await rolesSeed();
    await usersSeed();
    await categoriesSeed();
    await classesSeed();
    await user_classesSeed();
    await sectionsSeeder();
    await materialsSeed();
    await quizzesSeed();
    await quiz_questionsSeed();
    await quiz_answersSeed();
    await workshopsSeed();

    console.log("✅ Seeding finished.");
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
