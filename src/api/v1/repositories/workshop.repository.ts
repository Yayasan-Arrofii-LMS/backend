import prisma from "../../../database";

const workshopInclude = {
    category: { select: { id: true, name: true } },
    instructor: { select: { id: true, name: true, email: true, profileImage: true } },
    participants: {
        include: {
            user: { select: { id: true, name: true, email: true, profileImage: true } },
        },
        orderBy: { registrationDate: "asc" as const },
    },
};

export interface WorkshopFilter {
    category?: string;
    type?: string;
    status?: string;
    search?: string;
}

class WorkshopRepository {
    async findAll(filters: WorkshopFilter = {}) {
        const where: Record<string, any> = {};

        if (filters.type) {
            where.type = filters.type;
        }
        if (filters.status) {
            where.status = filters.status;
        }
        if (filters.category) {
            const catNum = Number(filters.category);
            if (!Number.isNaN(catNum) && filters.category.trim() !== "") {
                where.categoryId = catNum;
            } else {
                where.category = { name: filters.category };
            }
        }
        if (filters.search) {
            where.OR = [
                { title: { contains: filters.search } },
                { description: { contains: filters.search } },
            ];
        }

        return await prisma.workshop.findMany({
            where,
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
        });
    }

    async countActiveParticipants(workshopId: number) {
        return await prisma.workshopParticipant.count({
            where: { workshopId, status: "Terdaftar" },
        });
    }

    async upsertParticipant(workshopId: number, userId: string, notes?: string) {
        return await prisma.workshopParticipant.upsert({
            where: {
                workshopId_userId: { workshopId, userId },
            },
            update: {
                status: "Terdaftar",
                notes: notes ?? null,
                registrationDate: new Date(),
            },
            create: {
                workshopId,
                userId,
                status: "Terdaftar",
                notes: notes ?? null,
                registrationDate: new Date(),
            },
            include: {
                user: { select: { id: true, name: true, email: true, profileImage: true } },
            },
        });
    }

    async cancelParticipant(workshopId: number, userId: string) {
        return await prisma.workshopParticipant.update({
            where: {
                workshopId_userId: { workshopId, userId },
            },
            data: { status: "Dibatalkan" },
        });
    }

    async findParticipantsByWorkshop(workshopId: number) {
        return await prisma.workshopParticipant.findMany({
            where: { workshopId },
            include: {
                user: { select: { id: true, name: true, email: true, profileImage: true } },
            },
            orderBy: { registrationDate: "asc" },
        });
    }
}

export default new WorkshopRepository();
