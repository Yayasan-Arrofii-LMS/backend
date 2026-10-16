import "dotenv/config";
import request from "supertest";
import jwt from "jsonwebtoken";
import app from "../../src/index";
import prisma from "../../src/database";
import { categoriesSeed } from "../../src/database/seeders/categories.seed";
import { workshopsSeed } from "../../src/database/seeders/workshops.seed";
import { createWorkshopSchema } from "../../src/api/v1/schemas/workshop.schema";

describe("Workshop Module Verification", () => {
    let adminToken: string;
    let studentToken: string;
    let studentId: string;
    let createdWorkshopId: number;

    beforeAll(async () => {
        for (const name of ["Admin", "Teacher", "Student"]) {
            await prisma.role.upsert({ where: { name }, update: {}, create: { name } });
        }

        const adminRole = await prisma.role.findUnique({ where: { name: "Admin" } });
        const studentRole = await prisma.role.findUnique({ where: { name: "Student" } });

        const adminUser = await prisma.user.upsert({
            where: { email: "workshop_admin_test@sekolahalam.id" },
            update: { roleId: adminRole!.id },
            create: {
                email: "workshop_admin_test@sekolahalam.id",
                username: "workshop_admin_test",
                name: "Guru Workshop",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Guru",
                roleId: adminRole!.id,
                verified_at: new Date(),
            },
        });

        const studentUser = await prisma.user.upsert({
            where: { email: "workshop_student_test@sekolahalam.id" },
            update: { roleId: studentRole!.id },
            create: {
                email: "workshop_student_test@sekolahalam.id",
                username: "workshop_student_test",
                name: "Murid Workshop",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Murid",
                roleId: studentRole!.id,
                verified_at: new Date(),
            },
        });

        studentId = studentUser.id;
        const secret = process.env.JWT_SECRET ?? "";
        adminToken = jwt.sign({ user_id: adminUser.id }, secret, { expiresIn: "1h" });
        studentToken = jwt.sign({ user_id: studentUser.id }, secret, { expiresIn: "1h" });

        await categoriesSeed();
        await workshopsSeed();
    });

    afterAll(async () => {
        if (createdWorkshopId) {
            await prisma.workshop.deleteMany({ where: { id: createdWorkshopId } });
        }
        await prisma.$disconnect();
    });

    it("validates Offline requires location and Online requires meetingLink", () => {
        expect(() =>
            createWorkshopSchema.parse({
                title: "Offline",
                description: "Desc",
                date: "2026-12-01",
                startTime: "08:00",
                endTime: "10:00",
                type: "Offline",
                quota: 10,
            })
        ).toThrow();

        expect(() =>
            createWorkshopSchema.parse({
                title: "Online",
                description: "Desc",
                date: "2026-12-01",
                startTime: "08:00",
                endTime: "10:00",
                type: "Online",
                quota: 10,
            })
        ).toThrow();
    });

    it("verifies GET /workshops, POST /workshops, category rename sync, register, quota, and cancel", async () => {
        const listRes = await request(app).get("/api/v1/workshops");
        expect(listRes.status).toBe(200);
        expect(listRes.body.data.length).toBeGreaterThanOrEqual(4);

        const createRes = await request(app)
            .post("/api/v1/workshops")
            .set("Authorization", `Bearer ${adminToken}`)
            .send({
                title: "Workshop Uji Kuota 1",
                description: "Deskripsi uji kuota",
                thumbnail: "https://images.unsplash.com/photo-1511497584788-876760111969",
                category: "Sains Alam",
                date: "2026-12-10",
                startTime: "09:00",
                endTime: "11:00",
                type: "Offline",
                location: "Saung Utama",
                quota: 1,
            });

        expect(createRes.status).toBe(201);
        expect(createRes.body.data.category).toBe("Sains Alam");
        createdWorkshopId = Number(createRes.body.data.id);
        const categoryId = createRes.body.data.categoryId;

        const patchCat = await request(app)
            .patch(`/api/v1/categories/${categoryId}`)
            .set("Authorization", `Bearer ${adminToken}`)
            .send({ name: "Sains Alam Updated" });
        expect(patchCat.status).toBe(200);

        const detailAfterCatUpdate = await request(app).get(`/api/v1/workshops/${createdWorkshopId}`);
        expect(detailAfterCatUpdate.body.data.category).toBe("Sains Alam Updated");

        await request(app)
            .patch(`/api/v1/categories/${categoryId}`)
            .set("Authorization", `Bearer ${adminToken}`)
            .send({ name: "Sains Alam" });

        const reg1 = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ notes: "Saya ikut!" });
        expect(reg1.status).toBe(200);
        expect(reg1.body.data.registeredCount).toBe(1);

        const regDup = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(regDup.status).toBe(400);
        expect(regDup.body.message).toBe("Anda sudah terdaftar di workshop ini");

        const regFull = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(regFull.status).toBe(400);
        expect(regFull.body.message).toBe("Pendaftaran gagal: Kuota workshop sudah penuh");

        const cancelRes = await request(app)
            .delete(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(cancelRes.status).toBe(200);
        expect(cancelRes.body.data.registeredCount).toBe(0);
        const participant = cancelRes.body.data.participants.find((p: any) => p.userId === studentId);
        expect(participant.status).toBe("Dibatalkan");
    });
});
