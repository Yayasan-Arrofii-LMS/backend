import "dotenv/config";
import request from "supertest";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import app from "../../src/index";
import prisma from "../../src/database";

describe("Change Password Endpoints", () => {
    let userId: string;
    let token: string;
    const initialPassword = "OldPassword123!";

    beforeAll(async () => {
        const studentRole = await prisma.role.upsert({
            where: { name: "Student" },
            update: {},
            create: { name: "Student" },
        });

        const hashedPassword = await bcrypt.hash(initialPassword, 10);
        const user = await prisma.user.upsert({
            where: { email: "change_pw_test@sekolahalam.id" },
            update: { password: hashedPassword, verified_at: new Date() },
            create: {
                email: "change_pw_test@sekolahalam.id",
                username: "change_pw_test",
                name: "User Change PW",
                password: hashedPassword,
                profileImage: "https://ui-avatars.com/api/?name=User+PW",
                roleId: studentRole.id,
                verified_at: new Date(),
            },
        });

        userId = user.id;
        token = jwt.sign({ user_id: user.id }, process.env.JWT_SECRET ?? "", { expiresIn: "1h" });
    });

    afterAll(async () => {
        if (userId) {
            await prisma.user.deleteMany({ where: { id: userId } });
        }
        await prisma.$disconnect();
    });

    it("rejects unauthenticated requests", async () => {
        const res = await request(app)
            .post("/api/v1/change-password")
            .send({
                currentPassword: initialPassword,
                newPassword: "NewPassword123!",
                confirmPassword: "NewPassword123!",
            });
        expect(res.status).toBe(401);
    });

    it("validates minimum length (8 chars) and confirmPassword match", async () => {
        const shortRes = await request(app)
            .post("/api/v1/change-password")
            .set("Authorization", `Bearer ${token}`)
            .send({
                newPassword: "short",
                confirmPassword: "short",
            });
        expect(shortRes.status).toBe(400);

        const mismatchRes = await request(app)
            .post("/api/v1/change-password")
            .set("Authorization", `Bearer ${token}`)
            .send({
                newPassword: "NewPassword123!",
                confirmPassword: "DifferentPassword123!",
            });
        expect(mismatchRes.status).toBe(400);
    });

    it("returns error when currentPassword does not match", async () => {
        const res = await request(app)
            .post("/api/v1/change-password")
            .set("Authorization", `Bearer ${token}`)
            .send({
                currentPassword: "WrongPassword123!",
                newPassword: "NewPassword123!",
                confirmPassword: "NewPassword123!",
            });
        expect(res.status).toBe(400);
        expect(res.body.message).toBe("Kata sandi saat ini tidak cocok");
    });

    it("updates password via POST /change-password, POST /profile/change-password, and PATCH /profile/change-password", async () => {
        // 1. POST /api/v1/change-password with valid currentPassword
        const res1 = await request(app)
            .post("/api/v1/change-password")
            .set("Authorization", `Bearer ${token}`)
            .send({
                currentPassword: initialPassword,
                newPassword: "NewPassword111!",
                confirmPassword: "NewPassword111!",
            });
        expect(res1.status).toBe(200);
        expect(res1.body.success).toBe(true);
        expect(res1.body.message).toBe("Kata sandi berhasil diperbarui");

        let updatedUser = await prisma.user.findUnique({ where: { id: userId } });
        expect(await bcrypt.compare("NewPassword111!", updatedUser!.password)).toBe(true);

        // 2. POST /api/v1/profile/change-password without currentPassword (optional)
        const res2 = await request(app)
            .post("/api/v1/profile/change-password")
            .set("Authorization", `Bearer ${token}`)
            .send({
                newPassword: "NewPassword222!",
                confirmPassword: "NewPassword222!",
            });
        expect(res2.status).toBe(200);
        expect(res2.body.message).toBe("Kata sandi berhasil diperbarui");

        updatedUser = await prisma.user.findUnique({ where: { id: userId } });
        expect(await bcrypt.compare("NewPassword222!", updatedUser!.password)).toBe(true);

        // 3. PATCH /api/v1/profile/change-password with valid currentPassword
        const res3 = await request(app)
            .patch("/api/v1/profile/change-password")
            .set("Authorization", `Bearer ${token}`)
            .send({
                currentPassword: "NewPassword222!",
                newPassword: "NewPassword333!",
                confirmPassword: "NewPassword333!",
            });
        expect(res3.status).toBe(200);
        expect(res3.body.message).toBe("Kata sandi berhasil diperbarui");

        updatedUser = await prisma.user.findUnique({ where: { id: userId } });
        expect(await bcrypt.compare("NewPassword333!", updatedUser!.password)).toBe(true);
    });
});
