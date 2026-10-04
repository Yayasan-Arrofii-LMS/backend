import { MaterialActivity } from '@prisma/client';
import prisma from '../../../database';

type MaterialActivityWithDetails = MaterialActivity & {
    material: {
        id: number;
        title: string;
        sectionId: number;
        Section: { id: number; title: string; classId: number };
    };
};

export class MaterialActivityRepository {
    async findByUserId(
        userId: string,
        options?: { limit?: number; offset?: number }
    ): Promise<MaterialActivityWithDetails[]> {
        return await prisma.materialActivity.findMany({
            where: { userId },
            include: {
                material: {
                    select: {
                        id: true,
                        title: true,
                        sectionId: true,
                        Section: {
                            select: { id: true, title: true, classId: true },
                        },
                    },
                },
            },
            orderBy: { createdAt: 'desc' },
            take: options?.limit ?? 50,
            skip: options?.offset ?? 0,
        });
    }

    async countByUserId(userId: string): Promise<number> {
        return await prisma.materialActivity.count({
            where: { userId },
        });
    }

    async findLastActivity(
        userId: string,
        materialId: number,
        action: string
    ): Promise<MaterialActivity | null> {
        return await prisma.materialActivity.findFirst({
            where: { userId, materialId, action },
            orderBy: { createdAt: 'desc' },
        });
    }

    async create(data: {
        userId: string;
        materialId: number;
        action: string;
    }): Promise<MaterialActivity> {
        return await prisma.materialActivity.create({
            data,
        });
    }
}

export default new MaterialActivityRepository();
