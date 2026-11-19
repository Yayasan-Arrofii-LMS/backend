import "dotenv/config";
import request from "supertest";
import jwt from "jsonwebtoken";
import app from "../../src/index";
import prisma from "../../src/database";

describe("Admin Class Approval, Class Registration Type, Teacher Approval & Access Control", () => {
    let adminToken: string;
    let adminId: string;
    let teacher1Token: string;
    let teacher2Token: string;
    let studentToken: string;
    let studentId: string;
    let adminClassId: number;
    let openClassId: number;
    let approvalClassId: number;
    let approvalSectionId: number;

    beforeAll(async () => {
        for (const name of ["Admin", "Teacher", "Student"]) {
            await prisma.role.upsert({ where: { name }, update: {}, create: { name } });
        }

        const adminRole = await prisma.role.findUnique({ where: { name: "Admin" } });
        const teacherRole = await prisma.role.findUnique({ where: { name: "Teacher" } });
        const studentRole = await prisma.role.findUnique({ where: { name: "Student" } });

        const adminUser = await prisma.user.upsert({
            where: { email: "enroll_admin_test@sekolahalam.id" },
            update: { roleId: adminRole!.id },
            create: {
                email: "enroll_admin_test@sekolahalam.id",
                username: "enroll_admin_test",
                name: "Admin Enroll",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Admin",
                roleId: adminRole!.id,
                verified_at: new Date(),
            },
        });

        const teacher1 = await prisma.user.upsert({
            where: { email: "enroll_teacher1_test@sekolahalam.id" },
            update: { roleId: teacherRole!.id },
            create: {
                email: "enroll_teacher1_test@sekolahalam.id",
                username: "enroll_teacher1_test",
                name: "Guru Satu",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Guru1",
                roleId: teacherRole!.id,
                verified_at: new Date(),
            },
        });

        const teacher2 = await prisma.user.upsert({
            where: { email: "enroll_teacher2_test@sekolahalam.id" },
            update: { roleId: teacherRole!.id },
            create: {
                email: "enroll_teacher2_test@sekolahalam.id",
                username: "enroll_teacher2_test",
                name: "Guru Dua",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Guru2",
                roleId: teacherRole!.id,
                verified_at: new Date(),
            },
        });

        const student = await prisma.user.upsert({
            where: { email: "enroll_student_test@sekolahalam.id" },
            update: { roleId: studentRole!.id },
            create: {
                email: "enroll_student_test@sekolahalam.id",
                username: "enroll_student_test",
                name: "Siswa Enroll",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Siswa",
                roleId: studentRole!.id,
                verified_at: new Date(),
            },
        });

        adminId = adminUser.id;
        studentId = student.id;
        const secret = process.env.JWT_SECRET ?? "";
        adminToken = jwt.sign({ user_id: adminUser.id }, secret, { expiresIn: "1h" });
        teacher1Token = jwt.sign({ user_id: teacher1.id }, secret, { expiresIn: "1h" });
        teacher2Token = jwt.sign({ user_id: teacher2.id }, secret, { expiresIn: "1h" });
        studentToken = jwt.sign({ user_id: student.id }, secret, { expiresIn: "1h" });
    });

    afterAll(async () => {
        const classIds = [adminClassId, openClassId, approvalClassId].filter(Boolean);
        if (classIds.length > 0) {
            await prisma.class.deleteMany({ where: { id: { in: classIds } } });
        }
        await prisma.$disconnect();
    });

    it("enforces Admin class approval workflow and blocks unapproved classes from catalog, student view, and enrollment", async () => {
        // 1. Admin creates a class -> automatically APPROVED
        const adminCreateRes = await request(app)
            .post("/api/v1/classes")
            .set("Authorization", `Bearer ${adminToken}`)
            .send({
                name: "Kelas Buatan Admin",
                description: "Langsung approved karena dibuat Admin",
            });
        expect(adminCreateRes.status).toBe(201);
        expect(adminCreateRes.body.data.approvalStatus).toBe("APPROVED");
        expect(adminCreateRes.body.data.approvedById).toBe(adminId);
        adminClassId = adminCreateRes.body.data.id;

        // 2. Teacher creates OPEN class (attempting to inject approvalStatus: APPROVED is ignored -> PENDING)
        const createOpenRes = await request(app)
            .post("/api/v1/classes")
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({
                name: "Kelas Terbuka Uji",
                description: "Kelas pendaftaran terbuka",
                approvalStatus: "APPROVED",
            });
        expect(createOpenRes.status).toBe(201);
        expect(createOpenRes.body.data.registrationType).toBe("AUTO");
        expect(createOpenRes.body.data.approvalStatus).toBe("PENDING");
        expect(createOpenRes.body.data.approvedById).toBeNull();
        openClassId = createOpenRes.body.data.id;

        // 3. Teacher cannot call admin-only endpoints (/pending, /approve, /reject)
        const pendingByTeacher = await request(app)
            .get("/api/v1/classes/pending")
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(pendingByTeacher.status).toBe(404);

        const approveByTeacher = await request(app)
            .patch(`/api/v1/classes/${openClassId}/approve`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(approveByTeacher.status).toBe(404);

        const rejectByTeacher = await request(app)
            .patch(`/api/v1/classes/${openClassId}/reject`)
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({ rejectionReason: "Coba tolak" });
        expect(rejectByTeacher.status).toBe(404);

        // 4. While PENDING: hidden from public catalog, 404 on public detail, 403 on student detail, 400 on enroll
        const publicListPending = await request(app).get("/api/v1/public/classes?search=Kelas+Terbuka+Uji");
        expect(publicListPending.status).toBe(200);
        const foundInPublic = publicListPending.body.data.classes.find((c: any) => c.id === openClassId);
        expect(foundInPublic).toBeUndefined();

        const publicDetailPending = await request(app).get(`/api/v1/public/classes/${openClassId}`);
        expect(publicDetailPending.status).toBe(404);

        const studentDetailPending = await request(app)
            .get(`/api/v1/students/classes/${openClassId}`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(studentDetailPending.status).toBe(403);

        // Owner teacher & Admin can still view PENDING class via student route
        const ownerDetailPending = await request(app)
            .get(`/api/v1/students/classes/${openClassId}`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(ownerDetailPending.status).toBe(200);

        const enrollPendingClass = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ classId: openClassId });
        expect(enrollPendingClass.status).toBe(400);
        expect(enrollPendingClass.body.message).toBe("Kelas ini belum disetujui oleh Admin");

        // Teacher 1 cannot enroll in their own class
        const teacherSelfEnroll = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({ classId: openClassId });
        expect(teacherSelfEnroll.status).toBe(400);
        expect(teacherSelfEnroll.body.message).toBe(
            "Guru tidak dapat mendaftar pada kelas yang dibuatnya sendiri"
        );

        // 5. Admin sees the class in GET /api/v1/classes/pending
        const pendingByAdmin = await request(app)
            .get("/api/v1/classes/pending")
            .set("Authorization", `Bearer ${adminToken}`);
        expect(pendingByAdmin.status).toBe(200);
        expect(pendingByAdmin.body.data.some((c: any) => c.id === openClassId)).toBe(true);

        // 6. Admin rejects class with reason -> REJECTED
        const rejectRes = await request(app)
            .patch(`/api/v1/classes/${openClassId}/reject`)
            .set("Authorization", `Bearer ${adminToken}`)
            .send({ rejectionReason: "Silabus perlu dilengkapi" });
        expect(rejectRes.status).toBe(200);
        expect(rejectRes.body.data.approvalStatus).toBe("REJECTED");
        expect(rejectRes.body.data.rejectionReason).toBe("Silabus perlu dilengkapi");
        expect(rejectRes.body.data.approvedById).toBe(adminId);

        // Student still cannot enroll in REJECTED class
        const enrollRejectedClass = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ classId: openClassId });
        expect(enrollRejectedClass.status).toBe(400);
        expect(enrollRejectedClass.body.message).toBe("Kelas ini belum disetujui oleh Admin");

        // 7. Admin approves class -> APPROVED & rejectionReason cleared
        const approveOpenRes = await request(app)
            .patch(`/api/v1/classes/${openClassId}/approve`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(approveOpenRes.status).toBe(200);
        expect(approveOpenRes.body.data.approvalStatus).toBe("APPROVED");
        expect(approveOpenRes.body.data.rejectionReason).toBeNull();
        expect(approveOpenRes.body.data.approvedById).toBe(adminId);

        // Now visible in public catalog & public detail
        const publicDetailApproved = await request(app).get(`/api/v1/public/classes/${openClassId}`);
        expect(publicDetailApproved.status).toBe(200);

        // 8. Student enrolls in approved OPEN class -> immediately APPROVED
        const enrollOpenRes = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ classId: openClassId });
        expect(enrollOpenRes.status).toBe(201);
        expect(enrollOpenRes.body.data.status).toBe("APPROVED");

        const checkOpen = await request(app)
            .get(`/api/v1/enrollment/check/${openClassId}`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(checkOpen.status).toBe(200);
        expect(checkOpen.body.data.isEnrolled).toBe(true);
        expect(checkOpen.body.data.status).toBe("APPROVED");
    });

    it("handles teacher approval for student applicants on an Admin-approved APPROVAL class", async () => {
        // 1. Teacher creates MANUAL class -> Admin approves it
        const createApprovalRes = await request(app)
            .post("/api/v1/classes")
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({
                name: "Kelas Persetujuan Uji",
                description: "Kelas butuh persetujuan guru",
                registrationType: "MANUAL",
            });
        expect(createApprovalRes.status).toBe(201);
        expect(createApprovalRes.body.data.registrationType).toBe("MANUAL");
        expect(createApprovalRes.body.data.approvalStatus).toBe("PENDING");
        approvalClassId = createApprovalRes.body.data.id;

        const approveClassRes = await request(app)
            .patch(`/api/v1/classes/${approvalClassId}/approve`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(approveClassRes.status).toBe(200);

        const section = await prisma.section.create({
            data: {
                title: "Bab 1 Uji",
                order: 1,
                classId: approvalClassId,
            },
        });
        approvalSectionId = section.id;

        // 2. Student enrolls in APPROVAL class -> PENDING
        const enrollApprovalRes = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ classId: approvalClassId });
        expect(enrollApprovalRes.status).toBe(201);
        expect(enrollApprovalRes.body.data.status).toBe("PENDING");
        const userClassId = enrollApprovalRes.body.data.id;

        // Duplicate enroll while PENDING fails
        const dupPending = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ classId: approvalClassId });
        expect(dupPending.status).toBe(400);

        // Student cannot access section materials while PENDING
        const blockedMaterials = await request(app)
            .get(`/api/v1/students/classes/sections/${approvalSectionId}/materials`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(blockedMaterials.status).toBe(403);

        // 3. Teacher 2 (non-owner) cannot view applicants or update status -> 403
        const applicantsByOther = await request(app)
            .get(`/api/v1/enrollment/class/${approvalClassId}/applicants`)
            .set("Authorization", `Bearer ${teacher2Token}`);
        expect(applicantsByOther.status).toBe(403);

        const updateByOther = await request(app)
            .patch(`/api/v1/enrollment/applicants/${userClassId}/status`)
            .set("Authorization", `Bearer ${teacher2Token}`)
            .send({ status: "APPROVED" });
        expect(updateByOther.status).toBe(403);

        // 4. Teacher 1 (owner) lists applicants -> sees student PENDING
        const applicantsRes = await request(app)
            .get(`/api/v1/enrollment/class/${approvalClassId}/applicants`)
            .set("Authorization", `Bearer ${teacher1Token}`);
        expect(applicantsRes.status).toBe(200);
        expect(applicantsRes.body.data.length).toBe(1);
        expect(applicantsRes.body.data[0].userId).toBe(studentId);
        expect(applicantsRes.body.data[0].status).toBe("PENDING");

        // 5. Teacher 1 rejects student -> REJECTED
        const rejectRes = await request(app)
            .patch(`/api/v1/enrollment/applicants/${userClassId}/status`)
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({ status: "REJECTED" });
        expect(rejectRes.status).toBe(200);
        expect(rejectRes.body.data.status).toBe("REJECTED");

        const blockedAfterReject = await request(app)
            .get(`/api/v1/students/classes/sections/${approvalSectionId}/materials`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(blockedAfterReject.status).toBe(403);

        // 6. Student re-enrolls after REJECTED -> back to PENDING
        const reEnrollRes = await request(app)
            .post("/api/v1/enrollment/enroll")
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ classId: approvalClassId });
        expect(reEnrollRes.status).toBe(201);
        expect(reEnrollRes.body.data.status).toBe("PENDING");

        // 7. Teacher 1 approves student -> APPROVED
        const approveRes = await request(app)
            .patch(`/api/v1/enrollment/applicants/${userClassId}/status`)
            .set("Authorization", `Bearer ${teacher1Token}`)
            .send({ status: "APPROVED" });
        expect(approveRes.status).toBe(200);
        expect(approveRes.body.data.status).toBe("APPROVED");

        // Student can now access materials
        const allowedMaterials = await request(app)
            .get(`/api/v1/students/classes/sections/${approvalSectionId}/materials`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(allowedMaterials.status).toBe(200);

        // Admin can also view applicants
        const applicantsByAdmin = await request(app)
            .get(`/api/v1/enrollment/class/${approvalClassId}/applicants`)
            .set("Authorization", `Bearer ${adminToken}`);
        expect(applicantsByAdmin.status).toBe(200);
    });
});
