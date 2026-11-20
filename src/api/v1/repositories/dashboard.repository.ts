import {
    class_approval_status,
    WorkshopApprovalStatus,
    WorkshopParticipantStatus,
} from "@prisma/client";
import prisma from "../../../database";

const LEARNER_ROLES = ["Student", "Teacher"];

export interface DateRangeWindow {
    startDate: Date;
    endDate: Date;
    previousStartDate: Date;
    previousEndDate: Date;
}

class DashboardRepository {
    private async getPeriodMetrics(startDate: Date, endDate: Date) {
        const createdAtRange = { gte: startDate, lte: endDate };

        const [
            students,
            teachers,
            classes,
            materials,
            workshops,
            quizAttempts,
            assignmentsSubmitted,
            workshopRegistrations,
            quizScoreAgg,
        ] = await Promise.all([
            prisma.user.count({
                where: {
                    role: { name: { in: LEARNER_ROLES } },
                    createdAt: createdAtRange,
                },
            }),
            prisma.user.count({
                where: {
                    role: { name: "Teacher" },
                    createdAt: createdAtRange,
                },
            }),
            prisma.class.count({
                where: { createdAt: createdAtRange },
            }),
            prisma.material.count({
                where: { createdAt: createdAtRange },
            }),
            prisma.workshop.count({
                where: { createdAt: createdAtRange },
            }),
            prisma.quiz_Attempt.count({
                where: { createdAt: createdAtRange },
            }),
            prisma.user_Assignment.count({
                where: { submitted_at: createdAtRange },
            }),
            prisma.workshopParticipant.count({
                where: { registrationDate: createdAtRange },
            }),
            prisma.quiz_Attempt.aggregate({
                where: {
                    createdAt: createdAtRange,
                    score: { not: null },
                },
                _avg: { score: true },
            }),
        ]);

        const rawAvg = quizScoreAgg._avg.score;
        const averageQuizScore =
            rawAvg !== null && rawAvg !== undefined
                ? Math.round(rawAvg * 10) / 10
                : 0;

        return {
            students,
            teachers,
            classes,
            materials,
            workshops,
            quizAttempts,
            assignmentsSubmitted,
            workshopRegistrations,
            averageQuizScore,
        };
    }

    private async getCumulativeTotals() {
        const [
            studentsTotal,
            teachersTotal,
            adminsTotal,
            allUsersTotal,
            classesTotal,
            materialsTotal,
            workshopsTotal,
            quizAttemptsTotal,
            assignmentsTotal,
            workshopRegistrationsTotal,
        ] = await Promise.all([
            prisma.user.count({
                where: { role: { name: { in: LEARNER_ROLES } } },
            }),
            prisma.user.count({
                where: { role: { name: "Teacher" } },
            }),
            prisma.user.count({
                where: { role: { name: "Admin" } },
            }),
            prisma.user.count(),
            prisma.class.count(),
            prisma.material.count(),
            prisma.workshop.count(),
            prisma.quiz_Attempt.count(),
            prisma.user_Assignment.count(),
            prisma.workshopParticipant.count(),
        ]);

        return {
            studentsTotal,
            teachersTotal,
            adminsTotal,
            allUsersTotal,
            classesTotal,
            materialsTotal,
            workshopsTotal,
            quizAttemptsTotal,
            assignmentsTotal,
            workshopRegistrationsTotal,
        };
    }

    private async getActionItems() {
        const [
            pendingClasses,
            pendingWorkshops,
            pendingWorkshopParticipants,
            pendingQuizGrading,
            pendingAssignmentGrading,
        ] = await Promise.all([
            prisma.class.count({
                where: { approvalStatus: class_approval_status.PENDING },
            }),
            prisma.workshop.count({
                where: {
                    approvalStatus: WorkshopApprovalStatus.PENDING_APPROVAL,
                },
            }),
            prisma.workshopParticipant.count({
                where: {
                    status: WorkshopParticipantStatus.PENDING_APPROVAL,
                },
            }),
            prisma.quiz_Attempt.count({
                where: {
                    is_graded: false,
                    submitted_at: { not: null },
                },
            }),
            prisma.user_Assignment.count({
                where: { is_graded: false },
            }),
        ]);

        return {
            pendingClasses,
            pendingWorkshops,
            pendingWorkshopParticipants,
            pendingQuizGrading,
            pendingAssignmentGrading,
            totalPending:
                pendingClasses +
                pendingWorkshops +
                pendingWorkshopParticipants +
                pendingQuizGrading +
                pendingAssignmentGrading,
        };
    }

    private async getWorkshopStats() {
        const [workshopGroups, participantGroups] = await Promise.all([
            prisma.workshop.groupBy({
                by: ["approvalStatus"],
                _count: { _all: true },
            }),
            prisma.workshopParticipant.groupBy({
                by: ["status"],
                _count: { _all: true },
            }),
        ]);

        const wsMap: Record<string, number> = {};
        for (const g of workshopGroups) {
            wsMap[g.approvalStatus] = g._count._all;
        }

        const pMap: Record<string, number> = {};
        let participantsTotal = 0;
        for (const g of participantGroups) {
            pMap[g.status] = g._count._all;
            participantsTotal += g._count._all;
        }

        const approved = wsMap[WorkshopApprovalStatus.APPROVED] ?? 0;
        const pending = wsMap[WorkshopApprovalStatus.PENDING_APPROVAL] ?? 0;
        const rejected = wsMap[WorkshopApprovalStatus.REJECTED] ?? 0;

        return {
            approved,
            pending,
            rejected,
            total: approved + pending + rejected,
            participantsApproved:
                pMap[WorkshopParticipantStatus.APPROVED] ?? 0,
            participantsPending:
                pMap[WorkshopParticipantStatus.PENDING_APPROVAL] ?? 0,
            participantsRejected:
                pMap[WorkshopParticipantStatus.REJECTED] ?? 0,
            participantsTotal,
        };
    }

    private async getTimelineRawTimestamps(startDate: Date, endDate: Date) {
        const range = { gte: startDate, lte: endDate };

        const [
            learnerUsers,
            teacherUsers,
            classes,
            materials,
            quizAttempts,
            assignments,
            workshopRegistrations,
        ] = await Promise.all([
            prisma.user.findMany({
                where: {
                    role: { name: { in: LEARNER_ROLES } },
                    createdAt: range,
                },
                select: { createdAt: true },
            }),
            prisma.user.findMany({
                where: {
                    role: { name: "Teacher" },
                    createdAt: range,
                },
                select: { createdAt: true },
            }),
            prisma.class.findMany({
                where: { createdAt: range },
                select: { createdAt: true },
            }),
            prisma.material.findMany({
                where: { createdAt: range },
                select: { createdAt: true },
            }),
            prisma.quiz_Attempt.findMany({
                where: { createdAt: range },
                select: { createdAt: true },
            }),
            prisma.user_Assignment.findMany({
                where: { submitted_at: range },
                select: { submitted_at: true },
            }),
            prisma.workshopParticipant.findMany({
                where: { registrationDate: range },
                select: { registrationDate: true },
            }),
        ]);

        return {
            learnerDates: learnerUsers.map((u) => u.createdAt),
            teacherDates: teacherUsers.map((u) => u.createdAt),
            classDates: classes.map((c) => c.createdAt),
            materialDates: materials.map((m) => m.createdAt),
            quizAttemptDates: quizAttempts.map((q) => q.createdAt),
            assignmentDates: assignments.map((a) => a.submitted_at),
            workshopRegistrationDates: workshopRegistrations.map(
                (w) => w.registrationDate
            ),
        };
    }

    private async getLegacyUserCharts() {
        const currentYear = new Date().getFullYear();
        const startYear = currentYear - 4;
        const startOfWindow = new Date(startYear, 0, 1, 0, 0, 0, 0);

        const [learners, teachers] = await Promise.all([
            prisma.user.findMany({
                where: {
                    role: { name: { in: LEARNER_ROLES } },
                    createdAt: { gte: startOfWindow },
                },
                select: { createdAt: true },
            }),
            prisma.user.findMany({
                where: {
                    role: { name: "Teacher" },
                    createdAt: { gte: startOfWindow },
                },
                select: { createdAt: true },
            }),
        ]);

        const buildChart = (rows: { createdAt: Date }[]) => {
            const oneYear: Record<number, number> = {};
            for (let m = 1; m <= 12; m++) {
                oneYear[m] = 0;
            }
            const fiveYear: Record<number, number> = {};
            for (let y = startYear; y <= currentYear; y++) {
                fiveYear[y] = 0;
            }

            for (const row of rows) {
                const y = row.createdAt.getFullYear();
                const m = row.createdAt.getMonth() + 1;
                if (y === currentYear) {
                    oneYear[m] = (oneYear[m] ?? 0) + 1;
                }
                if (y >= startYear && y <= currentYear) {
                    fiveYear[y] = (fiveYear[y] ?? 0) + 1;
                }
            }

            return { oneYear, fiveYear };
        };

        return {
            student: buildChart(learners),
            teacher: buildChart(teachers),
        };
    }

    async fetchDashboardAggregations(window: DateRangeWindow) {
        const [
            currentMetrics,
            previousMetrics,
            cumulativeTotals,
            actionItems,
            workshopStats,
            timelineTimestamps,
            legacyCharts,
        ] = await Promise.all([
            this.getPeriodMetrics(window.startDate, window.endDate),
            this.getPeriodMetrics(
                window.previousStartDate,
                window.previousEndDate
            ),
            this.getCumulativeTotals(),
            this.getActionItems(),
            this.getWorkshopStats(),
            this.getTimelineRawTimestamps(window.startDate, window.endDate),
            this.getLegacyUserCharts(),
        ]);

        return {
            currentMetrics,
            previousMetrics,
            cumulativeTotals,
            actionItems,
            workshopStats,
            timelineTimestamps,
            legacyCharts,
        };
    }
}

export default new DashboardRepository();
