
import { defineConfig } from "prisma/config";
import "dotenv/config";
export default defineConfig({
    schema: "src/database/schema.prisma",
    datasource: {
        db: process.env.DATABASE_URL!,
    },
    migrations: {
        path: "src/database/migrations",
        seed: "ts-node src/database/seed.ts"
    },
});
