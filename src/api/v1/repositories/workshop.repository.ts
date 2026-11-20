import { WorkshopApprovalStatus, WorkshopParticipantStatus } from "@prisma/client";
import prisma from "../../../database";

const approverSelect = {
    select: { id: true, name: true, email: true },
};

const participantInclude = {
    user: { select: { id: true, name: true, email: true, profileImage: true } },
    approvedBy: approverSelect,
};

const workshopInclude = {
    category: { select: { id: true, name: true } },
    instructor: { select: { id: true, name: true, email: true, profileImage: true } },
    approvedBy: approverSelect,
    participants: {
        include: participantInclude,
        orderBy: { registrationDate: "asc" as const },
    },
};

export interface WorkshopFilter {
    category?: string;
    type?: string;
    status?: string;
    approvalStatus?: string;
    instructorId?: string;
    search?: string;
}

export interface WorkshopRequester {
    userId?: string;
    role?: string;
}

class WorkshopRepository {
    async findAll(filters: WorkshopFilter = {}, requester?: WorkshopRequester) {
        const andConditions: Record<string, any>[] = [];

        if (filters.type) {
            andConditions.push({ type: filters.type });
        }
        if (filters.status) {
            andConditions.push({ status: filters.status });
        }
        if (filters.category) {
            const catNum = Number(filters.category);
            if (!Number.isNaN(catNum) && filters.category.trim() !== "") {
                andConditions.push({ categoryId: catNum });
            } else {
                andConditions.push({ category: { name: filters.category } });
            }
        }
        if (filters.search) {
            andConditions.push({
                OR: [
                    { title: { contains: filters.search } },
                    { description: { contains: filters.search } },
                ],
            });
        }
        if (filters.instructorId) {
            andConditions.push({ instructorId: filters.instructorId });
        }

        // Visibility rules by role
        const role = requester?.role;
        const userId = requester?.userId;

        if (role === "Admin") {
            if (
                filters.approvalStatus &&
                Object.values(WorkshopApprovalStatus).includes(
                    filters.approvalStatus as WorkshopApprovalStatus
                )
            ) {
                andConditions.push({
                    approvalStatus: filters.approvalStatus as WorkshopApprovalStatus,
                });
            }
        } else if (role === "Teacher" && userId) {
            andConditions.push({
                OR: [
                    { approvalStatus: WorkshopApprovalStatus.APPROVED },
                    { instructorId: userId },
                ],
            });
            if (
                filters.approvalStatus &&
                Object.values(WorkshopApprovalStatus).includes(
                    filters.approvalStatus as WorkshopApprovalStatus
                )
            ) {
                andConditions.push({
                    approvalStatus: filters.approvalStatus as WorkshopApprovalStatus,
                });
            }
        } else {
            // Public / Guest / Student -> APPROVED only
            andConditions.push({ approvalStatus: WorkshopApprovalStatus.APPROVED });
        }

        return await prisma.workshop.findMany({
            where: andConditions.length > 0 ? { AND: andConditions } : {},
            include: workshopInclude,
            orderBy: { createdAt: "desc" },
        });
    }

    async findById(id: number) {
        return await prisma.workshop.findUnique({
            where: { id },
            include: workshopInclude,
        });
    }

    async create(data: {
        title: string;
        description: string;
        thumbnail: string;
        date: string;
        startTime: string;
        endTime: string;
        type: string;
        location?: string | null;
        meetingLink?: string | null;
        quota: number;
        status?: string;
        approvalStatus: WorkshopApprovalStatus;
        approvedById?: string | null;
        approvedAt?: Date | null;
        categoryId?: number | null;
        instructorId: string;
    }) {
        return await prisma.workshop.create({
            data: {
                title: data.title,
                description: data.description,
                thumbnail: data.thumbnail,
                date: data.date,
                startTime: data.startTime,
                endTime: data.endTime,
                type: data.type,
                location: data.location ?? null,
                meetingLink: data.meetingLink ?? null,
                quota: data.quota,
                status: data.status ?? "Upcoming",
                approvalStatus: data.approvalStatus,
                approvedById: data.approvedById ?? null,
                approvedAt: data.approvedAt ?? null,
                categoryId: data.categoryId ?? null,
                instructorId: data.instructorId,
            },
            include: workshopInclude,
        });
    }

    async update(id: number, data: Record<string, any>) {
        return await prisma.workshop.update({
            where: { id },
            data,
            include: workshopInclude,
        });
    }

    async updateWorkshopApprovalStatus(
        id: number,
        approvalStatus: WorkshopApprovalStatus,
        adminId: string,
        rejectionReason?: string | null
    ) {
        return await prisma.workshop.update({
            where: { id },
            data: {
                approvalStatus,
                rejectionReason:
                    approvalStatus === WorkshopApprovalStatus.REJECTED
                        ? (rejectionReason ?? null)
                        : null,
                approvedById: adminId,
                approvedAt: new Date(),
            },
            include: workshopInclude,
        });
    }

    async delete(id: number) {
        return await prisma.workshop.delete({
            where: { id },
        });
    }

    async findParticipant(workshopId: number, userId: string) {
        return await prisma.workshopParticipant.findUnique({
            where: {
                workshopId_userId: { workshopId, userId },
            },
            include: participantInclude,
        });
    }

    async findParticipantById(participantId: number) {
        return await prisma.workshopParticipant.findUnique({
            where: { id: participantId },
            include: participantInclude,
        });
    }

    async countActiveParticipants(workshopId: number) {
        return await prisma.workshopParticipant.count({
            where: {
                workshopId,
                status: WorkshopParticipantStatus.APPROVED,
            },
        });
    }

    async upsertParticipant(workshopId: number, userId: string, notes?: string) {
        return await prisma.workshopParticipant.upsert({
            where: {
                workshopId_userId: { workshopId, userId },
            },
            update: {
                status: WorkshopParticipantStatus.PENDING_APPROVAL,
                notes: notes ?? null,
                rejectionReason: null,
                approvedById: null,
                approvedAt: null,
                registrationDate: new Date(),
            },
            create: {
                workshopId,
                userId,
                status: WorkshopParticipantStatus.PENDING_APPROVAL,
                notes: notes ?? null,
                registrationDate: new Date(),
            },
            include: participantInclude,
        });
    }

    async cancelParticipant(workshopId: number, userId: string) {
        return await prisma.workshopParticipant.update({
            where: {
                workshopId_userId: { workshopId, userId },
            },
            data: { status: WorkshopParticipantStatus.CANCELLED },
            include: participantInclude,
        });
    }

    async approveParticipantAtomic(
        workshopId: number,
        participantId: number,
        approverId: string
    ) {
        return await prisma.$transaction(async (tx) => {
            const workshop = await tx.workshop.findUnique({
                where: { id: workshopId },
            });
            if (!workshop) {
                return { error: "Workshop tidak ditemukan", statusCode: 404 as const };
            }

            const participant = await tx.workshopParticipant.findFirst({
                where: { id: participantId, workshopId },
            });
            if (!participant) {
                return { error: "Data peserta tidak ditemukan", statusCode: 404 as const };
            }
            if (participant.status === WorkshopParticipantStatus.APPROVED) {
                return { error: "Peserta sudah disetujui sebelumnya", statusCode: 400 as const };
            }
            if (participant.status === WorkshopParticipantStatus.CANCELLED) {
                return { error: "Pendaftaran peserta sudah dibatalkan", statusCode: 400 as const };
            }

            const approvedCount = await tx.workshopParticipant.count({
                where: {
                    workshopId,
                    status: WorkshopParticipantStatus.APPROVED,
                },
            });
            if (approvedCount >= workshop.quota) {
                return {
                    error: "Persetujuan gagal: Kuota workshop sudah penuh",
                    statusCode: 400 as const,
                };
            }

            const updated = await tx.workshopParticipant.update({
                where: { id: participantId },
                data: {
                    status: WorkshopParticipantStatus.APPROVED,
                    rejectionReason: null,
                    approvedById: approverId,
                    approvedAt: new Date(),
                },
                include: participantInclude,
            });

            return { participant: updated, statusCode: 200 as const };
        });
    }

    async rejectParticipant(
        workshopId: number,
        participantId: number,
        approverId: string,
        rejectionReason?: string | null
    ) {
        const participant = await prisma.workshopParticipant.findFirst({
            where: { id: participantId, workshopId },
        });
        if (!participant) {
            return { error: "Data peserta tidak ditemukan", statusCode: 404 as const };
        }

        const updated = await prisma.workshopParticipant.update({
            where: { id: participantId },
            data: {
                status: WorkshopParticipantStatus.REJECTED,
                rejectionReason: rejectionReason ?? null,
                approvedById: approverId,
                approvedAt: new Date(),
            },
            include: participantInclude,
        });

        return { participant: updated, statusCode: 200 as const };
    }

    async findParticipantsByWorkshop(workshopId: number) {
        return await prisma.workshopParticipant.findMany({
            where: { workshopId },
            include: participantInclude,
            orderBy: { registrationDate: "asc" },
        });
    }
}

export default new WorkshopRepository();
