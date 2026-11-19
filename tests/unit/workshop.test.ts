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
    let teacher1Token: string;
    let teacher2Token: string;
    let studentToken: string;
    let student2Token: string;
    let studentId: string;
    let createdWorkshopId: number;
    let teacherWorkshopId: number;

    beforeAll(async () => {
        for (const name of ["Admin", "Teacher", "Student"]) {
            await prisma.role.upsert({ where: { name }, update: {}, create: { name } });
        }

        const adminRole = await prisma.role.findUnique({ where: { name: "Admin" } });
        const teacherRole = await prisma.role.findUnique({ where: { name: "Teacher" } });
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

        const teacherUser1 = await prisma.user.upsert({
            where: { email: "workshop_teacher1_test@sekolahalam.id" },
            update: { roleId: teacherRole!.id },
            create: {
                email: "workshop_teacher1_test@sekolahalam.id",
                username: "workshop_teacher1_test",
                name: "Guru Satu Workshop",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Guru+1",
                roleId: teacherRole!.id,
                verified_at: new Date(),
            },
        });

        const teacherUser2 = await prisma.user.upsert({
            where: { email: "workshop_teacher2_test@sekolahalam.id" },
            update: { roleId: teacherRole!.id },
            create: {
                email: "workshop_teacher2_test@sekolahalam.id",
                username: "workshop_teacher2_test",
                name: "Guru Dua Workshop",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Guru+2",
                roleId: teacherRole!.id,
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

        const studentUser2 = await prisma.user.upsert({
            where: { email: "workshop_student2_test@sekolahalam.id" },
            update: { roleId: studentRole!.id },
            create: {
                email: "workshop_student2_test@sekolahalam.id",
                username: "workshop_student2_test",
                name: "Murid Workshop 2",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Murid+2",
                roleId: studentRole!.id,
                verified_at: new Date(),
            },
        });

        studentId = studentUser.id;
        const secret = process.env.JWT_SECRET ?? "";
        adminToken = jwt.sign({ user_id: adminUser.id }, secret, { expiresIn: "1h" });
        teacher1Token = jwt.sign({ user_id: teacherUser1.id }, secret, { expiresIn: "1h" });
        teacher2Token = jwt.sign({ user_id: teacherUser2.id }, secret, { expiresIn: "1h" });
        studentToken = jwt.sign({ user_id: studentUser.id }, secret, { expiresIn: "1h" });
        student2Token = jwt.sign({ user_id: studentUser2.id }, secret, { expiresIn: "1h" });

        await categoriesSeed();
        await workshopsSeed();
    });

    afterAll(async () => {
        const idsToDelete = [createdWorkshopId, teacherWorkshopId].filter(Boolean);
        if (idsToDelete.length > 0) {
            await prisma.workshop.deleteMany({ where: { id: { in: idsToDelete } } });
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

        const regCreator = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(regCreator.status).toBe(400);
        expect(regCreator.body.message).toBe(
            "Pembuat/penyelenggara workshop tidak dapat mendaftar pada workshop sendiri"
        );

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
            .set("Authorization", `Bearer ${student2Token}`);
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

    it("prevents other teachers from updating, deleting, or viewing participants of another teacher's workshop", async () => {
        const createRes = await request(app)
            .post("/api/v1/workshops")
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({
                title: "Workshop Khusus Guru 1",
                description: "Deskripsi workshop guru 1",
                category: "Sains Alam",
                date: "2026-12-15",
                startTime: "09:00",
                endTime: "11:00",
                type: "Online",
                meetingLink: "https://meet.google.com/test-guru-1",
                quota: 10,
            });
        expect(createRes.status).toBe(201);
        teacherWorkshopId = Number(createRes.body.data.id);

        // Teacher 2 cannot update Teacher 1's workshop
        const updateByOther = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher2Token}`)
            .send({ title: "Dibajak Guru 2" });
        expect(updateByOther.status).toBe(403);
        expect(updateByOther.body.message).toBe("Anda tidak memiliki izin untuk mengelola workshop ini");

        // Teacher 2 cannot view participants of Teacher 1's workshop
        const participantsByOther = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}/participants`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(participantsByOther.status).toBe(403);
        expect(participantsByOther.body.message).toBe("Anda tidak memiliki izin untuk mengelola workshop ini");

        // Teacher 2 cannot delete Teacher 1's workshop
        const deleteByOther = await request(app)
            .delete(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(deleteByOther.status).toBe(403);
        expect(deleteByOther.body.message).toBe("Anda tidak memiliki izin untuk mengelola workshop ini");

        // Teacher 1 (owner) can update and view participants
        const updateByOwner = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({ title: "Workshop Khusus Guru 1 Updated" });
        expect(updateByOwner.status).toBe(200);

        const participantsByOwner = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}/participants`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(participantsByOwner.status).toBe(200);

        // Admin can also view participants
        const participantsByAdmin = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}/participants`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(participantsByAdmin.status).toBe(200);
    });
});
