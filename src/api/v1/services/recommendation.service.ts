import prisma from '../../../database';

// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────

export type RecommendationReason = 'remedial' | 'minat' | 'lanjutan';

export interface RecommendationItem {
    material: {
        id: number;
        title: string;
        difficulty: string | null;
        mediaType: string | null;
        categoryId: number | null;
        sectionId: number;
        category: { id: number; name: string } | null;
        Section: { id: number; title: string; classId: number };
    };
    reasons: RecommendationReason[];
    score: number;
    repeat?: boolean;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

async function getEnrolledSectionIds(userId: string): Promise<Set<number>> {
    const enrollments = await prisma.user_Class.findMany({
        where: { userId },
        select: {
            class: {
                select: {
                    Section: { select: { id: true } },
                },
            },
        },
    });
    const sectionIds = new Set<number>();
    for (const e of enrollments) {
        for (const s of e.class.Section) {
            sectionIds.add(s.id);
        }
    }
    return sectionIds;
}

async function getUserInterestCategoryIds(userId: string): Promise<Set<number>> {
    const interests = await prisma.userInterest.findMany({
        where: { userId },
        select: { categoryId: true },
    });
    return new Set(interests.map((i) => i.categoryId));
}

async function getCompletedMaterialIds(userId: string): Promise<Set<number>> {
    const activities = await prisma.materialActivity.findMany({
        where: { userId, action: 'completed' },
        select: { materialId: true },
    });
    return new Set(activities.map((a) => a.materialId));
}

async function getSectionsWithAnyCompletion(
    userId: string,
    completedIds: Set<number>
): Promise<Set<number>> {
    if (completedIds.size === 0) return new Set();
    const materials = await prisma.material.findMany({
        where: { id: { in: [...completedIds] } },
        select: { sectionId: true },
    });
    return new Set(materials.map((m) => m.sectionId));
}

async function getFailingQuizSectionIds(userId: string): Promise<Set<number>> {
    const attempts = await prisma.quiz_Attempt.findMany({
        where: {
            userId,
            is_graded: true,
            submitted_at: { not: null },
        },
        orderBy: { submitted_at: 'desc' },
        select: {
            quizId: true,
            score: true,
            quiz: {
                select: {
                    passing_grade: true,
                    sectionId: true,
                },
            },
        },
    });

    const latestByQuiz = new Map<number, (typeof attempts)[0]>();
    for (const a of attempts) {
        if (!latestByQuiz.has(a.quizId)) {
            latestByQuiz.set(a.quizId, a);
        }
    }

    const failingSectionIds = new Set<number>();
    for (const a of latestByQuiz.values()) {
        if (a.score !== null && a.score < a.quiz.passing_grade) {
            failingSectionIds.add(a.quiz.sectionId);
        }
    }
    return failingSectionIds;
}

// ─────────────────────────────────────────────────────────────────────────────
// Main engine
// ─────────────────────────────────────────────────────────────────────────────

export class RecommendationService {
    async getRecommendations(userId: string, limit: number = 10): Promise<RecommendationItem[]> {
        const enrolledSectionIds = await getEnrolledSectionIds(userId);
        if (enrolledSectionIds.size === 0) return [];

        const [interestCategoryIds, completedMaterialIds, failingSectionIds] = await Promise.all([
            getUserInterestCategoryIds(userId),
            getCompletedMaterialIds(userId),
            getFailingQuizSectionIds(userId),
        ]);

        const sectionsWithAnyCompletion = await getSectionsWithAnyCompletion(userId, completedMaterialIds);

        const materials = await prisma.material.findMany({
            where: { sectionId: { in: [...enrolledSectionIds] } },
            select: {
                id: true,
                title: true,
                difficulty: true,
                mediaType: true,
                categoryId: true,
                sectionId: true,
                createdAt: true,
                category: { select: { id: true, name: true } },
                Section: { select: { id: true, title: true, classId: true } },
            },
            orderBy: { createdAt: 'desc' },
        });

        let oldestCompletionByMaterial = new Map<number, Date>();
        if (completedMaterialIds.size > 0) {
            const completedActivities = await prisma.materialActivity.findMany({
                where: {
                    userId,
                    action: 'completed',
                    materialId: { in: [...completedMaterialIds] },
                },
                select: { materialId: true, createdAt: true },
                orderBy: { createdAt: 'asc' },
            });
            for (const a of completedActivities) {
                if (!oldestCompletionByMaterial.has(a.materialId)) {
                    oldestCompletionByMaterial.set(a.materialId, a.createdAt);
                }
            }
        }

        const scored: (RecommendationItem & { _completedAt?: Date })[] = [];

        for (const material of materials) {
            const isCompleted = completedMaterialIds.has(material.id);
            const isRemedialSection = failingSectionIds.has(material.sectionId);
            const hasInterest =
                material.categoryId !== null && interestCategoryIds.has(material.categoryId);
            const sectionNeverCompleted = !sectionsWithAnyCompletion.has(material.sectionId);
            const isRemedialRepeat = isRemedialSection && isCompleted;

            // Deprioritise completed materials unless remedial
            if (isCompleted && !isRemedialSection) {
                continue;
            }

            const reasons: RecommendationReason[] = [];
            let score = 0;

            if (isRemedialSection) {
                score += 3;
                reasons.push('remedial');
            }
            if (hasInterest) {
                score += 2;
                reasons.push('minat');
            }
            if (sectionNeverCompleted) {
                score += 1;
                reasons.push('lanjutan');
            }

            const item: RecommendationItem & { _completedAt?: Date } = {
                material: {
                    id: material.id,
                    title: material.title,
                    difficulty: material.difficulty,
                    mediaType: material.mediaType,
                    categoryId: material.categoryId,
                    sectionId: material.sectionId,
                    category: material.category,
                    Section: material.Section,
                },
                reasons,
                score,
            };

            if (isRemedialRepeat) {
                item.repeat = true;
                item._completedAt = oldestCompletionByMaterial.get(material.id);
            }

            scored.push(item);
        }

        // Sort: score desc → remedial first → oldest completion first for repeats
        scored.sort((a, b) => {
            if (b.score !== a.score) return b.score - a.score;
            const aIsRemedial = a.reasons.includes('remedial');
            const bIsRemedial = b.reasons.includes('remedial');
            if (aIsRemedial !== bIsRemedial) return aIsRemedial ? -1 : 1;
            if (a.repeat && b.repeat) {
                const aDate = a._completedAt?.getTime() ?? 0;
                const bDate = b._completedAt?.getTime() ?? 0;
                return aDate - bDate;
            }
            return 0;
        });

        return scored.slice(0, limit).map(({ _completedAt, ...rest }) => rest);
    }
}

export default new RecommendationService();
