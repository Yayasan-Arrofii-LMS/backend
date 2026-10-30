import { Recommendation_History, recommendation_feedback } from '@prisma/client';
import prisma from '../../../database';

export interface ImpressionSnapshot {
    materialId: number;
    primaryReason: string;
    reasons: string[];
    reasonText: string;
    score: number;
}

export type RecommendationHistoryWithMaterial = Recommendation_History & {
    material: {
        id: number;
        title: string;
        content: string;
        video_link: string | null;
        duration_minutes: number | null;
        difficulty: string | null;
        mediaType: string | null;
        categoryId: number | null;
        sectionId: number;
        category: { id: number; name: string } | null;
        Section: {
            id: number;
            title: string;
            classId: number;
            Class: { id: number; name: string; image_path: string };
        };
    };
};

export class RecommendationHistoryRepository {
    async findMapByUserAndMaterialIds(
        userId: string,
        materialIds: number[]
    ): Promise<Map<number, Recommendation_History>> {
        if (materialIds.length === 0) return new Map();

        const rows = await prisma.recommendation_History.findMany({
            where: {
                userId,
                materialId: { in: materialIds },
            },
        });

        return new Map(rows.map((r) => [r.materialId, r]));
    }

    async syncImpressions(userId: string, items: ImpressionSnapshot[]): Promise<void> {
        if (items.length === 0) return;

        const now = new Date();
        await prisma.$transaction(
            items.map((item) =>
                prisma.recommendation_History.upsert({
                    where: {
                        userId_materialId: {
                            userId,
                            materialId: item.materialId,
                        },
                    },
                    update: {
                        primary_reason: item.primaryReason,
                        reasons: item.reasons,
                        reason_text: item.reasonText,
                        score: item.score,
                        last_recommended_at: now,
                    },
                    create: {
                        userId,
                        materialId: item.materialId,
                        primary_reason: item.primaryReason,
                        reasons: item.reasons,
                        reason_text: item.reasonText,
                        score: item.score,
                        first_recommended_at: now,
                        last_recommended_at: now,
                    },
                })
            )
        );
    }

    async upsertFeedback(
        userId: string,
        materialId: number,
        feedback: recommendation_feedback | null,
        fallbackSnapshot: ImpressionSnapshot
    ): Promise<Recommendation_History> {
        const now = new Date();
        return await prisma.recommendation_History.upsert({
            where: {
                userId_materialId: {
                    userId,
                    materialId,
                },
            },
            update: {
                feedback,
                feedback_at: feedback ? now : null,
            },
            create: {
                userId,
                materialId,
                primary_reason: fallbackSnapshot.primaryReason,
                reasons: fallbackSnapshot.reasons,
                reason_text: fallbackSnapshot.reasonText,
                score: fallbackSnapshot.score,
                feedback,
                feedback_at: feedback ? now : null,
                first_recommended_at: now,
                last_recommended_at: now,
            },
        });
    }

    async findAllSummaryRowsByUser(
        userId: string
    ): Promise<{ materialId: number; feedback: recommendation_feedback | null }[]> {
        return await prisma.recommendation_History.findMany({
            where: { userId },
            select: {
                materialId: true,
                feedback: true,
            },
        });
    }

    private buildHistoryWhere(userId: string, filters?: { type?: string; search?: string }) {
        const where: Record<string, any> = { userId };

        if (filters?.type) {
            where.primary_reason = filters.type;
        }

        if (filters?.search && filters.search.trim().length > 0) {
            const keyword = filters.search.trim();
            where.OR = [
                { material: { title: { contains: keyword } } },
                { reason_text: { contains: keyword } },
            ];
        }

        return where;
    }

    async findHistoryByUser(
        userId: string,
        options: { type?: string; search?: string; limit: number; offset: number }
    ): Promise<RecommendationHistoryWithMaterial[]> {
        const where = this.buildHistoryWhere(userId, options);

        return await prisma.recommendation_History.findMany({
            where,
            include: {
                material: {
                    select: {
                        id: true,
                        title: true,
                        content: true,
                        video_link: true,
                        duration_minutes: true,
                        difficulty: true,
                        mediaType: true,
                        categoryId: true,
                        sectionId: true,
                        category: { select: { id: true, name: true } },
                        Section: {
                            select: {
                                id: true,
                                title: true,
                                classId: true,
                                Class: {
                                    select: { id: true, name: true, image_path: true },
                                },
                            },
                        },
                    },
                },
            },
            orderBy: [{ last_recommended_at: 'desc' }, { id: 'desc' }],
            take: options.limit,
            skip: options.offset,
        });
    }

    async countHistoryByUser(
        userId: string,
        filters?: { type?: string; search?: string }
    ): Promise<number> {
        const where = this.buildHistoryWhere(userId, filters);
        return await prisma.recommendation_History.count({ where });
    }
}

export default new RecommendationHistoryRepository();
