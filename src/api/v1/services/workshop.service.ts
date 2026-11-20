import { WorkshopApprovalStatus, WorkshopParticipantStatus } from "@prisma/client";
import prisma from "../../../database";
import workshopRepository, {
    WorkshopFilter,
    WorkshopRequester,
} from "../repositories/workshop.repository";

const formatMediaUrl = (path?: string | null): string | null => {
    if (!path) return null;
    if (/^https?:\/\//i.test(path)) return path;
    const appUrl = (process.env.APP_URL || "http://localhost:3001").replace(/\/$/, "");
    return `${appUrl}/${path.replace(/^\//, "")}`;
};

export const formatParticipantDto = (p: any) => ({
    id: String(p.id),
    userId: p.userId,
    userName: p.user.name,
    userEmail: p.user.email,
    userAvatar: formatMediaUrl(p.user.profileImage),
    registrationDate: p.registrationDate.toISOString(),
    status: p.status,
    notes: p.notes ?? undefined,
    rejectionReason: p.rejectionReason ?? undefined,
    approvedById: p.approvedById ?? undefined,
    approvedAt: p.approvedAt ? p.approvedAt.toISOString() : undefined,
    approvedBy: p.approvedBy
        ? {
              id: p.approvedBy.id,
              name: p.approvedBy.name,
              email: p.approvedBy.email,
          }
        : undefined,
});

export const formatWorkshopDto = (workshop: any) => {
    const activeCount = (workshop.participants || []).filter(
        (p: any) => p.status === WorkshopParticipantStatus.APPROVED
    ).length;

    return {
        id: String(workshop.id),
        title: workshop.title,
        description: workshop.description,
        thumbnail: formatMediaUrl(workshop.thumbnail) ?? workshop.thumbnail,
        categoryId: workshop.categoryId,
        category: workshop.category?.name ?? "Sains Alam",
        date: workshop.date,
        startTime: workshop.startTime,
        endTime: workshop.endTime,
        type: workshop.type,
        location: workshop.location ?? undefined,
        meetingLink: workshop.meetingLink ?? undefined,
        quota: workshop.quota,
        registeredCount: activeCount,
        instructorId: workshop.instructorId,
        instructorName: workshop.instructor.name,
        instructorAvatar: formatMediaUrl(workshop.instructor.profileImage),
        instructorBio: "Guru / Instruktur Sekolah Alam",
        status: workshop.status,
        approvalStatus: workshop.approvalStatus,
        rejectionReason: workshop.rejectionReason ?? undefined,
        approvedById: workshop.approvedById ?? undefined,
        approvedAt: workshop.approvedAt ? workshop.approvedAt.toISOString() : undefined,
        approvedBy: workshop.approvedBy
            ? {
                  id: workshop.approvedBy.id,
                  name: workshop.approvedBy.name,
                  email: workshop.approvedBy.email,
              }
            : undefined,
        participants: (workshop.participants || []).map(formatParticipantDto),
        createdAt: workshop.createdAt.toISOString(),
        updatedAt: workshop.updatedAt.toISOString(),
    };
};

class WorkshopService {
    private async resolveCategoryId(
        categoryId?: number | null,
        categoryName?: string
    ): Promise<number | null | undefined> {
        if (categoryId !== undefined && categoryId !== null) {
            const cat = await prisma.category.findUnique({ where: { id: Number(categoryId) } });
            if (!cat) throw new Error("Category not found");
            return cat.id;
        }
        if (categoryName && categoryName.trim() !== "") {
            const name = categoryName.trim();
            const cat = await prisma.category.upsert({ where: { name }, update: {}, create: { name } });
            return cat.id;
        }
        return categoryId === null ? null : undefined;
    }

    async getAllWorkshops(filters: WorkshopFilter, requester?: WorkshopRequester) {
        const workshops = await workshopRepository.findAll(filters, requester);
        return workshops.map(formatWorkshopDto);
    }

    async getWorkshopById(id: number) {
        const workshop = await workshopRepository.findById(id);
        return workshop ? formatWorkshopDto(workshop) : null;
    }

    async getWorkshopByIdWithVisibility(id: number, requester?: WorkshopRequester) {
        const workshop = await workshopRepository.findById(id);
        if (!workshop) {
            return { error: "Workshop tidak ditemukan", statusCode: 404 as const };
        }

        if (workshop.approvalStatus !== WorkshopApprovalStatus.APPROVED) {
            const isAdmin = requester?.role === "Admin";
            const isOwner = requester?.userId && workshop.instructorId === requester.userId;
            if (!isAdmin && !isOwner) {
                return {
                    error: "Workshop belum disetujui oleh Admin",
                    statusCode: requester?.userId ? (403 as const) : (404 as const),
                };
            }
        }

        return { data: formatWorkshopDto(workshop), statusCode: 200 as const };
    }

    async createWorkshop(instructorId: string, data: any, creatorRole?: string) {
        const categoryId = await this.resolveCategoryId(data.categoryId, data.category);
        const isAdmin = creatorRole === "Admin";
        const workshop = await workshopRepository.create({
            title: data.title,
            description: data.description,
            thumbnail: data.thumbnail || "files/public/placeholder.png",
            date: data.date,
            startTime: data.startTime,
            endTime: data.endTime,
            type: data.type,
            location: data.location,
            meetingLink: data.meetingLink,
            quota: Number(data.quota),
            status: data.status || "Upcoming",
            approvalStatus: isAdmin
                ? WorkshopApprovalStatus.APPROVED
                : WorkshopApprovalStatus.PENDING_APPROVAL,
            approvedById: isAdmin ? instructorId : null,
            approvedAt: isAdmin ? new Date() : null,
            categoryId: categoryId ?? null,
            instructorId,
        });
        return formatWorkshopDto(workshop);
    }

    async updateWorkshop(id: number, data: any) {
        const existing = await workshopRepository.findById(id);
        if (!existing) return null;

        const categoryId = await this.resolveCategoryId(data.categoryId, data.category);
        const payload: Record<string, any> = {};

        for (const f of [
            "title",
            "description",
            "thumbnail",
            "date",
            "startTime",
            "endTime",
            "type",
            "location",
            "meetingLink",
            "status",
        ]) {
            if (data[f] !== undefined) payload[f] = data[f];
        }
        if (data.quota !== undefined) payload.quota = Number(data.quota);
        if (categoryId !== undefined) payload.categoryId = categoryId;

        const updated = await workshopRepository.update(id, payload);
        return formatWorkshopDto(updated);
    }

    async deleteWorkshop(id: number) {
        const existing = await workshopRepository.findById(id);
        if (!existing) return false;
        await workshopRepository.delete(id);
        return true;
    }

    async approveWorkshop(id: number, adminId: string) {
        const existing = await workshopRepository.findById(id);
        if (!existing) return null;
        const updated = await workshopRepository.updateWorkshopApprovalStatus(
            id,
            WorkshopApprovalStatus.APPROVED,
            adminId,
            null
        );
        return formatWorkshopDto(updated);
    }

    async rejectWorkshop(id: number, adminId: string, rejectionReason?: string | null) {
        const existing = await workshopRepository.findById(id);
        if (!existing) return null;
        const updated = await workshopRepository.updateWorkshopApprovalStatus(
            id,
            WorkshopApprovalStatus.REJECTED,
            adminId,
            rejectionReason ?? null
        );
        return formatWorkshopDto(updated);
    }

    async registerParticipant(workshopId: number, userId: string, notes?: string) {
        const workshop = await workshopRepository.findById(workshopId);
        if (!workshop) return { error: "Workshop tidak ditemukan", statusCode: 404 };

        if (workshop.instructorId === userId) {
            return {
                error: "Pembuat/penyelenggara workshop tidak dapat mendaftar pada workshop sendiri",
                statusCode: 400,
            };
        }

        if (workshop.approvalStatus !== WorkshopApprovalStatus.APPROVED) {
            return {
                error: "Workshop belum disetujui oleh Admin",
                statusCode: 400,
            };
        }

        const existing = await workshopRepository.findParticipant(workshopId, userId);
        if (existing) {
            if (existing.status === WorkshopParticipantStatus.APPROVED) {
                return { error: "Anda sudah terdaftar di workshop ini", statusCode: 400 };
            }
            if (existing.status === WorkshopParticipantStatus.PENDING_APPROVAL) {
                return {
                    error: "Pendaftaran Anda sedang menunggu persetujuan",
                    statusCode: 400,
                };
            }
            // REJECTED or CANCELLED -> allowed to re-register (resets to PENDING_APPROVAL)
        }

        const count = await workshopRepository.countActiveParticipants(workshopId);
        if (count >= workshop.quota) {
            return { error: "Pendaftaran gagal: Kuota workshop sudah penuh", statusCode: 400 };
        }

        await workshopRepository.upsertParticipant(workshopId, userId, notes);
        const updated = await workshopRepository.findById(workshopId);
        return { data: formatWorkshopDto(updated!), statusCode: 200 };
    }

    async cancelRegistration(workshopId: number, userId: string) {
        const existing = await workshopRepository.findParticipant(workshopId, userId);
        if (
            !existing ||
            (existing.status !== WorkshopParticipantStatus.APPROVED &&
                existing.status !== WorkshopParticipantStatus.PENDING_APPROVAL)
        ) {
            return { error: "Pendaftaran tidak ditemukan atau sudah dibatalkan", statusCode: 404 };
        }

        await workshopRepository.cancelParticipant(workshopId, userId);
        const updated = await workshopRepository.findById(workshopId);
        return { data: formatWorkshopDto(updated!), statusCode: 200 };
    }

    async approveParticipant(workshopId: number, participantId: number, approverId: string) {
        const result = await workshopRepository.approveParticipantAtomic(
            workshopId,
            participantId,
            approverId
        );
        if ("error" in result && result.error) {
            return { error: result.error, statusCode: result.statusCode };
        }
        return { data: formatParticipantDto(result.participant), statusCode: 200 as const };
    }

    async rejectParticipant(
        workshopId: number,
        participantId: number,
        approverId: string,
        rejectionReason?: string | null
    ) {
        const result = await workshopRepository.rejectParticipant(
            workshopId,
            participantId,
            approverId,
            rejectionReason ?? null
        );
        if ("error" in result && result.error) {
            return { error: result.error, statusCode: result.statusCode };
        }
        return { data: formatParticipantDto(result.participant), statusCode: 200 as const };
    }

    async getParticipants(workshopId: number) {
        const workshop = await workshopRepository.findById(workshopId);
        return workshop ? formatWorkshopDto(workshop).participants : null;
    }
}

export default new WorkshopService();
