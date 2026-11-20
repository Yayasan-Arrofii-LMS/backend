import "dotenv/config";
import request from "supertest";
import jwt from "jsonwebtoken";
import {
    class_approval_status,
    WorkshopApprovalStatus,
    WorkshopParticipantStatus,
} from "@prisma/client";
import app from "../../src/index";
import prisma from "../../src/database";
import dashboardService from "../../src/api/v1/services/dashboard.service";

describe("Admin Analytics Dashboard Verification", () => {
    let adminToken: string;
    let studentToken: string;
    let teacherId: string;
    let createdClassId: number | null = null;
    let createdWorkshopId: number | null = null;

    beforeAll(async () => {
        for (const name of ["Admin", "Teacher", "Student"]) {
            await prisma.role.upsert({ where: { name }, update: {}, create: { name } });
        }

        const adminRole = await prisma.role.findUnique({ where: { name: "Admin" } });
        const teacherRole = await prisma.role.findUnique({ where: { name: "Teacher" } });
        const studentRole = await prisma.role.findUnique({ where: { name: "Student" } });

        const adminUser = await prisma.user.upsert({
            where: { email: "dashboard_admin_test@sekolahalam.id" },
            update: { roleId: adminRole!.id },
            create: {
                email: "dashboard_admin_test@sekolahalam.id",
                username: "dashboard_admin_test",
                name: "Admin Dashboard Test",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Admin",
                roleId: adminRole!.id,
                verified_at: new Date(),
            },
        });

        const teacherUser = await prisma.user.upsert({
            where: { email: "dashboard_teacher_test@sekolahalam.id" },
            update: { roleId: teacherRole!.id },
            create: {
                email: "dashboard_teacher_test@sekolahalam.id",
                username: "dashboard_teacher_test",
                name: "Teacher Dashboard Test",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Teacher",
                roleId: teacherRole!.id,
                verified_at: new Date(),
            },
        });
        teacherId = teacherUser.id;

        const studentUser = await prisma.user.upsert({
            where: { email: "dashboard_student_test@sekolahalam.id" },
            update: { roleId: studentRole!.id },
            create: {
                email: "dashboard_student_test@sekolahalam.id",
                username: "dashboard_student_test",
                name: "Student Dashboard Test",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Student",
                roleId: studentRole!.id,
                verified_at: new Date(),
            },
        });

        const secret = process.env.JWT_SECRET ?? "";
        adminToken = jwt.sign({ user_id: adminUser.id }, secret, { expiresIn: "1h" });
        studentToken = jwt.sign({ user_id: studentUser.id }, secret, { expiresIn: "1h" });

        // Create a pending class & pending workshop + pending participant to verify actionItems
        const pendingClass = await prisma.class.create({
            data: {
                name: "Dashboard Test Pending Class",
                description: "Pending class for dashboard test",
                image_path: "files/public/placeholder.png",
                approvalStatus: class_approval_status.PENDING,
            },
        });
        createdClassId = pendingClass.id;

        const pendingWorkshop = await prisma.workshop.create({
            data: {
                title: "Dashboard Test Pending Workshop",
                description: "Pending workshop for dashboard test",
                thumbnail: "files/public/placeholder.png",
                date: "2026-12-01",
                startTime: "09:00",
                endTime: "12:00",
                type: "Online",
                meetingLink: "https://meet.google.com/dash-test",
                quota: 20,
                approvalStatus: WorkshopApprovalStatus.PENDING_APPROVAL,
                instructorId: teacherId,
            },
        });
        createdWorkshopId = pendingWorkshop.id;

        await prisma.workshopParticipant.create({
            data: {
                workshopId: pendingWorkshop.id,
                userId: studentUser.id,
                status: WorkshopParticipantStatus.PENDING_APPROVAL,
            },
        });
    });

    afterAll(async () => {
        if (createdWorkshopId) {
            await prisma.workshop.delete({ where: { id: createdWorkshopId } }).catch(() => {});
        }
        if (createdClassId) {
            await prisma.class.delete({ where: { id: createdClassId } }).catch(() => {});
        }
        await prisma.$disconnect();
    });

    it("resolves all period presets and year/month/custom filters accurately", () => {
        const monthRes = dashboardService.resolveDateRange({ year: "2026", month: "11" });
        expect(monthRes.granularity).toBe("day");
        expect(monthRes.label).toBe("November 2026");
        expect(monthRes.startDate.getDate()).toBe(1);
        expect(monthRes.endDate.getDate()).toBe(30);

        const yearRes = dashboardService.resolveDateRange({ year: "2026" });
        expect(yearRes.granularity).toBe("month");
        expect(yearRes.label).toBe("Tahun 2026");

        const customShort = dashboardService.resolveDateRange({
            period: "custom",
            startDate: "2026-10-01",
            endDate: "2026-10-15",
        });
        expect(customShort.granularity).toBe("day");

        const customLong = dashboardService.resolveDateRange({
            period: "custom",
            startDate: "2026-01-01",
            endDate: "2026-06-30",
        });
        expect(customLong.granularity).toBe("month");

        for (const preset of ["today", "7d", "30d", "this_month", "last_month", "this_year", "last_year"]) {
            const res = dashboardService.resolveDateRange({ period: preset });
            expect(res.startDate.getTime()).toBeLessThanOrEqual(res.endDate.getTime());
            expect(res.previousEndDate.getTime()).toBeLessThan(res.startDate.getTime());
        }
    });

    it("blocks non-Admin roles and returns full analytics + backward-compatible fields for Admin", async () => {
        const forbidden = await request(app)
            .get("/api/v1/dashboard")
            .set("Authorization", `Bearer ${studentToken}`);
        expect(forbidden.status).toBe(404);

        const res = await request(app)
            .get("/api/v1/dashboard?year=2026&month=11")
            .set("Authorization", `Bearer ${adminToken}`);

        expect(res.status).toBe(200);
        expect(res.body.success).toBe(true);

        const data = res.body.data;

        // Verify Student = Student + Teacher cumulative rule
        const expectedLearners = await prisma.user.count({
            where: { role: { name: { in: ["Student", "Teacher"] } } },
        });
        const expectedTeachers = await prisma.user.count({
            where: { role: { name: "Teacher" } },
        });
        const expectedAdmins = await prisma.user.count({
            where: { role: { name: "Admin" } },
        });
        const expectedTotalUsers = await prisma.user.count();

        expect(data.studentCount).toBe(expectedLearners);
        expect(data.teacherCount).toBe(expectedTeachers);
        expect(data.overview.students.totalCumulative).toBe(expectedLearners);
        expect(data.overview.teachers.totalCumulative).toBe(expectedTeachers);
        expect(data.overview.totalUsers).toEqual({
            students: expectedLearners,
            teachers: expectedTeachers,
            admins: expectedAdmins,
            total: expectedTotalUsers,
        });

        // Verify periodInfo & daily timeline for November 2026 (30 days)
        expect(data.periodInfo.label).toBe("November 2026");
        expect(data.periodInfo.granularity).toBe("day");
        expect(data.timeline).toHaveLength(30);
        expect(data.timeline[0].label).toBe("1 Nov");
        expect(data.timeline[29].label).toBe("30 Nov");
        expect(data.timeline[0]).toEqual(
            expect.objectContaining({
                students: expect.any(Number),
                teachers: expect.any(Number),
                classes: expect.any(Number),
                materials: expect.any(Number),
                quizAttempts: expect.any(Number),
                assignments: expect.any(Number),
                workshopRegistrations: expect.any(Number),
            })
        );

        // Verify action items include our pending items
        expect(data.actionItems.pendingClasses).toBeGreaterThanOrEqual(1);
        expect(data.actionItems.pendingWorkshops).toBeGreaterThanOrEqual(1);
        expect(data.actionItems.pendingWorkshopParticipants).toBeGreaterThanOrEqual(1);
        expect(data.actionItems.totalPending).toBe(
            data.actionItems.pendingClasses +
                data.actionItems.pendingWorkshops +
                data.actionItems.pendingWorkshopParticipants +
                data.actionItems.pendingQuizGrading +
                data.actionItems.pendingAssignmentGrading
        );

        // Verify workshopStats structure
        expect(data.workshopStats.total).toBe(
            data.workshopStats.approved +
                data.workshopStats.pending +
                data.workshopStats.rejected
        );
        expect(data.workshopStats.pending).toBeGreaterThanOrEqual(1);
        expect(data.workshopStats.participantsPending).toBeGreaterThanOrEqual(1);

        // Verify backward-compatible Chart structure
        expect(data.Chart).toBeDefined();
        expect(Object.keys(data.Chart.student.oneYear)).toHaveLength(12);
        expect(Object.keys(data.Chart.teacher.oneYear)).toHaveLength(12);
        expect(Object.keys(data.Chart.student.fiveYear)).toHaveLength(5);
        expect(Object.keys(data.Chart.teacher.fiveYear)).toHaveLength(5);
    });

    it("supports monthly granularity when filtering by year or this_year", async () => {
        const res = await request(app)
            .get("/api/v1/dashboard?period=this_year")
            .set("Authorization", `Bearer ${adminToken}`);

        expect(res.status).toBe(200);
        const data = res.body.data;
        expect(data.periodInfo.granularity).toBe("month");
        expect(data.timeline).toHaveLength(12);
        expect(data.timeline[0].label).toBe("Jan");
        expect(data.timeline[11].label).toBe("Des");
    });
});
