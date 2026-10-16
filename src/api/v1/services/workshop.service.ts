import prisma from "../../../database";
import workshopRepository, { WorkshopFilter } from "../repositories/workshop.repository";

const formatMediaUrl = (path?: string | null): string | null => {
    if (!path) return null;
    if (/^https?:\/\//i.test(path)) return path;
    const appUrl = (process.env.APP_URL || "http://localhost:3001").replace(/\/$/, "");
    return `${appUrl}/${path.replace(/^\//, "")}`;
};

export const formatWorkshopDto = (workshop: any) => {
    const activeCount = (workshop.participants || []).filter((p: any) => p.status === "Terdaftar").length;

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
        participants: (workshop.participants || []).map((p: any) => ({
            id: String(p.id),
            userId: p.userId,
            userName: p.user.name,
            userEmail: p.user.email,
            userAvatar: formatMediaUrl(p.user.profileImage),
            registrationDate: p.registrationDate.toISOString(),
            status: p.status,
            notes: p.notes ?? undefined,
        })),
        createdAt: workshop.createdAt.toISOString(),
        updatedAt: workshop.updatedAt.toISOString(),
    };
};

class WorkshopService {
    private async resolveCategoryId(categoryId?: number | null, categoryName?: string): Promise<number | null | undefined> {
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

    async getAllWorkshops(filters: WorkshopFilter) {
        const workshops = await workshopRepository.findAll(filters);
        return workshops.map(formatWorkshopDto);
    }

    async getWorkshopById(id: number) {
        const workshop = await workshopRepository.findById(id);
        return workshop ? formatWorkshopDto(workshop) : null;
    }

    async createWorkshop(instructorId: string, data: any) {
        const categoryId = await this.resolveCategoryId(data.categoryId, data.category);
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

        for (const f of ["title", "description", "thumbnail", "date", "startTime", "endTime", "type", "location", "meetingLink", "status"]) {
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

    async registerParticipant(workshopId: number, userId: string, notes?: string) {
        const workshop = await workshopRepository.findById(workshopId);
        if (!workshop) return { error: "Workshop tidak ditemukan", statusCode: 404 };

        const existing = await workshopRepository.findParticipant(workshopId, userId);
        if (existing && existing.status === "Terdaftar") {
            return { error: "Anda sudah terdaftar di workshop ini", statusCode: 400 };
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
        if (!existing || existing.status !== "Terdaftar") {
            return { error: "Pendaftaran tidak ditemukan atau sudah dibatalkan", statusCode: 404 };
        }

        await workshopRepository.cancelParticipant(workshopId, userId);
        const updated = await workshopRepository.findById(workshopId);
        return { data: formatWorkshopDto(updated!), statusCode: 200 };
    }

    async getParticipants(workshopId: number) {
        const workshop = await workshopRepository.findById(workshopId);
        return workshop ? formatWorkshopDto(workshop).participants : null;
    }
}

export default new WorkshopService();
