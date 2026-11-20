import "dotenv/config";
import request from "supertest";
import jwt from "jsonwebtoken";
import app from "../../src/index";
import prisma from "../../src/database";
import { categoriesSeed } from "../../src/database/seeders/categories.seed";
import { workshopsSeed } from "../../src/database/seeders/workshops.seed";
import { createWorkshopSchema } from "../../src/api/v1/schemas/workshop.schema";

describe("Workshop Module & Approval Verification", () => {
    let adminToken: string;
    let adminId: string;
    let teacher1Token: string;
    let teacher2Token: string;
    let studentToken: string;
    let student2Token: string;
    let studentId: string;
    let student2Id: string;
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
                name: "Admin Workshop",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Admin",
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

        adminId = adminUser.id;
        studentId = studentUser.id;
        student2Id = studentUser2.id;
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

    it("verifies Admin workshop auto-approval, participant PENDING_APPROVAL, atomic quota approval, reject, and cancel", async () => {
        const listRes = await request(app).get("/api/v1/workshops");
        expect(listRes.status).toBe(200);
        expect(listRes.body.data.length).toBeGreaterThanOrEqual(4);

        // Admin creates workshop -> automatically APPROVED
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
        expect(createRes.body.data.approvalStatus).toBe("APPROVED");
        expect(createRes.body.data.category).toBe("Sains Alam");
        createdWorkshopId = Number(createRes.body.data.id);

        // Creator cannot register for own workshop (400)
        const regCreator = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(regCreator.status).toBe(400);
        expect(regCreator.body.message).toBe(
            "Pembuat/penyelenggara workshop tidak dapat mendaftar pada workshop sendiri"
        );

        // Student 1 registers -> PENDING_APPROVAL, registeredCount still 0
        const reg1 = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ notes: "Saya ikut!" });
        expect(reg1.status).toBe(200);
        expect(reg1.body.data.registeredCount).toBe(0);
        const p1 = reg1.body.data.participants.find((p: any) => p.userId === studentId);
        expect(p1.status).toBe("PENDING_APPROVAL");

        // Duplicate registration while PENDING_APPROVAL fails
        const regDup = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(regDup.status).toBe(400);
        expect(regDup.body.message).toBe("Pendaftaran Anda sedang menunggu persetujuan");

        // Student 2 also applies while quota isn't consumed yet -> PENDING_APPROVAL
        const reg2 = await request(app)
            .post(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${student2Token}`);
        expect(reg2.status).toBe(200);
        const p2 = reg2.body.data.participants.find((p: any) => p.userId === student2Id);
        expect(p2.status).toBe("PENDING_APPROVAL");

        // Admin approves Student 1 -> APPROVED, registeredCount becomes 1
        const approveP1 = await request(app)
            .patch(`/api/v1/workshops/${createdWorkshopId}/participants/${p1.id}/approve`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(approveP1.status).toBe(200);
        expect(approveP1.body.data.status).toBe("APPROVED");
        expect(approveP1.body.data.approvedBy.id).toBe(adminId);

        // Admin attempts to approve Student 2 when quota (1) is full -> 400
        const approveP2Full = await request(app)
            .patch(`/api/v1/workshops/${createdWorkshopId}/participants/${p2.id}/approve`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(approveP2Full.status).toBe(400);
        expect(approveP2Full.body.message).toContain("Kuota workshop sudah penuh");

        // Admin rejects Student 2 with reason -> REJECTED
        const rejectP2 = await request(app)
            .patch(`/api/v1/workshops/${createdWorkshopId}/participants/${p2.id}/reject`)
            .set("Authorization", `Bearer ${adminToken}`)
            .send({ reason: "Kuota sudah terisi" });
        expect(rejectP2.status).toBe(200);
        expect(rejectP2.body.data.status).toBe("REJECTED");
        expect(rejectP2.body.data.rejectionReason).toBe("Kuota sudah terisi");

        // Student 1 cancels -> CANCELLED, registeredCount returns to 0
        const cancelRes = await request(app)
            .delete(`/api/v1/workshops/${createdWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(cancelRes.status).toBe(200);
        expect(cancelRes.body.data.registeredCount).toBe(0);
        const cancelledP1 = cancelRes.body.data.participants.find((p: any) => p.userId === studentId);
        expect(cancelledP1.status).toBe("CANCELLED");
    });

    it("enforces Teacher workshop PENDING_APPROVAL visibility, Admin publication approve/reject, and ownership checks", async () => {
        // Teacher 1 creates workshop -> PENDING_APPROVAL
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
        expect(createRes.body.data.approvalStatus).toBe("PENDING_APPROVAL");
        teacherWorkshopId = Number(createRes.body.data.id);

        // Public & Student cannot see PENDING_APPROVAL workshop
        const publicList = await request(app).get("/api/v1/workshops");
        expect(publicList.body.data.some((w: any) => Number(w.id) === teacherWorkshopId)).toBe(false);

        const publicDetail = await request(app).get(`/api/v1/workshops/${teacherWorkshopId}`);
        expect(publicDetail.status).toBe(404);

        const studentDetail = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(studentDetail.status).toBe(403);

        // Student cannot register into PENDING_APPROVAL workshop
        const regPending = await request(app)
            .post(`/api/v1/workshops/${teacherWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(regPending.status).toBe(400);

        // Teacher 1 (owner) CAN see their own PENDING_APPROVAL workshop
        const ownerList = await request(app)
            .get("/api/v1/workshops")
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(ownerList.body.data.some((w: any) => Number(w.id) === teacherWorkshopId)).toBe(true);

        const ownerDetail = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(ownerDetail.status).toBe(200);

        // Teacher 2 (non-owner) cannot view/update/delete/participants of Teacher 1's workshop
        const otherTeacherDetail = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(otherTeacherDetail.status).toBe(403);

        const updateByOther = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher2Token}`)
            .send({ title: "Dibajak Guru 2" });
        expect(updateByOther.status).toBe(403);
        expect(updateByOther.body.message).toBe("Anda tidak memiliki izin untuk mengelola workshop ini");

        const participantsByOther = await request(app)
            .get(`/api/v1/workshops/${teacherWorkshopId}/participants`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(participantsByOther.status).toBe(403);

        const deleteByOther = await request(app)
            .delete(`/api/v1/workshops/${teacherWorkshopId}`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(deleteByOther.status).toBe(403);

        // Teacher 1 cannot approve/reject own workshop (Admin only)
        const approveByTeacher = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}/approve`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(approveByTeacher.status).toBe(404);

        // Admin sees it under ?approvalStatus=PENDING_APPROVAL
        const adminPendingList = await request(app)
            .get("/api/v1/workshops?approvalStatus=PENDING_APPROVAL")
            .set("Authorization", `Bearer ${adminToken}`);
        expect(adminPendingList.status).toBe(200);
        expect(adminPendingList.body.data.some((w: any) => Number(w.id) === teacherWorkshopId)).toBe(true);

        // Admin rejects workshop with reason
        const rejectByAdmin = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}/reject`)
            .set("Authorization", `Bearer ${adminToken}`)
            .send({ reason: "Link meeting belum jelas" });
        expect(rejectByAdmin.status).toBe(200);
        expect(rejectByAdmin.body.data.approvalStatus).toBe("REJECTED");
        expect(rejectByAdmin.body.data.rejectionReason).toBe("Link meeting belum jelas");

        // Admin approves workshop -> APPROVED, now visible publicly
        const approveByAdmin = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}/approve`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(approveByAdmin.status).toBe(200);
        expect(approveByAdmin.body.data.approvalStatus).toBe("APPROVED");
        expect(approveByAdmin.body.data.rejectionReason).toBeUndefined();

        const publicDetailAfterApprove = await request(app).get(`/api/v1/workshops/${teacherWorkshopId}`);
        expect(publicDetailAfterApprove.status).toBe(200);

        // Student registers -> Teacher 2 cannot approve (403), Teacher 1 (owner) CAN approve (200)
        const studentReg = await request(app)
            .post(`/api/v1/workshops/${teacherWorkshopId}/register`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(studentReg.status).toBe(200);
        const participantId = studentReg.body.data.participants.find((p: any) => p.userId === studentId).id;

        const approvePByOther = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}/participants/${participantId}/approve`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(approvePByOther.status).toBe(403);

        const approvePByOwner = await request(app)
            .patch(`/api/v1/workshops/${teacherWorkshopId}/participants/${participantId}/approve`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(approvePByOwner.status).toBe(200);
        expect(approvePByOwner.body.data.status).toBe("APPROVED");
    });
});
