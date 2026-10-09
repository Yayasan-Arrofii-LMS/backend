import "dotenv/config"; // ⬅️ ini akan load .env
import { rolesSeed } from "./seeders/roles.seed";
import { usersSeed } from "./seeders/users.seed";
import { classesSeed } from "./seeders/classes.seed";
import { user_classesSeed } from "./seeders/user_classes.seed";
import { categoriesSeed } from "./seeders/categories.seed";
import { sectionsSeeder } from "./seeders/sections.seed";
import { materialsSeed } from "./seeders/materials.seed";
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
