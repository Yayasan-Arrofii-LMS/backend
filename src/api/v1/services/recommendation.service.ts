import prisma from '../../../database';
import { AbilityLevel, getAbilityLevelFromScore } from '../helpers/adaptiveEngine';

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

export interface SectionQuizDiagnostic {
    sectionId: number;
    quizId: number;
    percentageScore: number;
    passingGrade: number;
    isPassed: boolean;
    abilityEstimate: number;
    abilityLevel: AbilityLevel;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Normalizes an attempt's score into a percentage (0–100) for comparison with `passing_grade`.
 * - New adaptive attempts (`ability_estimate !== null && ability_estimate !== undefined`):
 *   `score` is already stored as a percentage (0–100).
 * - Legacy attempts (`ability_estimate == null`):
 *   `score` was stored as raw points, so convert to percentage using total quiz question points.
 */
export function computeAttemptPercentageScore(attempt: {
    score: number | null;
    ability_estimate?: number | null;
    quiz: {
        quiz_question?: { points: number; type?: string }[];
    };
}): number | null {
    if (attempt.score === null || attempt.score === undefined) {
        return null;
    }

    if (attempt.ability_estimate !== null && attempt.ability_estimate !== undefined) {
        return attempt.score;
    }

    const questions = attempt.quiz.quiz_question ?? [];
    const totalPossiblePoints = questions.reduce((sum, q) => sum + q.points, 0);

    if (totalPossiblePoints > 0) {
        return Math.round((attempt.score / totalPossiblePoints) * 100);
    }

    return attempt.score;
}

/**
 * Menentukan kecocokan kesulitan materi dengan estimasi kemampuan siswa (theta / level)
 * sebagai tie-breaker pengurutan rekomendasi remedial & lanjutan.
 */
export function getMaterialDifficultySuitability(
    materialDifficulty: string | null,
    diagnostic?: SectionQuizDiagnostic
): number {
    if (!materialDifficulty) return 0;
    const diff = materialDifficulty.toLowerCase();

    if (!diagnostic || !diagnostic.isPassed || diagnostic.abilityLevel === 'Dasar') {
        // Saat remedial / level Dasar: utamakan materi Easy lalu Medium agar mudah dipahami
        if (diff === 'easy') return 3;
        if (diff === 'medium') return 2;
        if (diff === 'hard') return 1;
        return 0;
    }

    if (diagnostic.abilityLevel === 'Cakap') {
        if (diff === 'medium') return 3;
        if (diff === 'easy') return 2;
        if (diff === 'hard') return 1;
        return 0;
    }

    // Level Mahir: utamakan materi Hard / Medium untuk pengayaan
    if (diff === 'hard') return 3;
    if (diff === 'medium') return 2;
    if (diff === 'easy') return 1;
    return 0;
}

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

export async function getSectionQuizDiagnostics(
    userId: string
): Promise<Map<number, SectionQuizDiagnostic>> {
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
            ability_estimate: true,
            quiz: {
                select: {
                    passing_grade: true,
                    sectionId: true,
                    quiz_question: {
                        select: {
                            points: true,
                            type: true,
                        },
                    },
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

    const diagnosticsBySection = new Map<number, SectionQuizDiagnostic>();
    for (const a of latestByQuiz.values()) {
        const percentageScore = computeAttemptPercentageScore(a);
        if (percentageScore === null) continue;

        const isPassed = percentageScore >= a.quiz.passing_grade;
        const abilityEstimate = a.ability_estimate ?? 0;
        const abilityLevel = getAbilityLevelFromScore(percentageScore);

        const existing = diagnosticsBySection.get(a.quiz.sectionId);
        // Jika satu section punya lebih dari satu kuis, prioritaskan kuis yang belum lulus (remedial)
        if (!existing || (!isPassed && existing.isPassed)) {
            diagnosticsBySection.set(a.quiz.sectionId, {
                sectionId: a.quiz.sectionId,
                quizId: a.quizId,
                percentageScore,
                passingGrade: a.quiz.passing_grade,
                isPassed,
                abilityEstimate,
                abilityLevel,
            });
        }
    }

    return diagnosticsBySection;
}

// ─────────────────────────────────────────────────────────────────────────────
// Main engine
// ─────────────────────────────────────────────────────────────────────────────

export class RecommendationService {
    async getRecommendations(userId: string, limit: number = 10): Promise<RecommendationItem[]> {
        const enrolledSectionIds = await getEnrolledSectionIds(userId);
        if (enrolledSectionIds.size === 0) return [];

        const [interestCategoryIds, completedMaterialIds, sectionDiagnostics] = await Promise.all([
            getUserInterestCategoryIds(userId),
            getCompletedMaterialIds(userId),
            getSectionQuizDiagnostics(userId),
        ]);

        const failingSectionIds = new Set<number>();
        for (const [sectionId, diag] of sectionDiagnostics.entries()) {
            if (!diag.isPassed) {
                failingSectionIds.add(sectionId);
            }
        }

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

        const scored: (RecommendationItem & {
            _completedAt?: Date;
            _suitability?: number;
        })[] = [];

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

            const diag = sectionDiagnostics.get(material.sectionId);
            const suitability = getMaterialDifficultySuitability(material.difficulty, diag);

            const item: RecommendationItem & {
                _completedAt?: Date;
                _suitability?: number;
            } = {
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
                _suitability: suitability,
            };

            if (isRemedialRepeat) {
                item.repeat = true;
                item._completedAt = oldestCompletionByMaterial.get(material.id);
            }

            scored.push(item);
        }

        // Sort: score desc → remedial first → adaptive suitability desc → oldest completion first for repeats
        scored.sort((a, b) => {
            if (b.score !== a.score) return b.score - a.score;
            const aIsRemedial = a.reasons.includes('remedial');
            const bIsRemedial = b.reasons.includes('remedial');
            if (aIsRemedial !== bIsRemedial) return aIsRemedial ? -1 : 1;
            const aSuit = a._suitability ?? 0;
            const bSuit = b._suitability ?? 0;
            if (bSuit !== aSuit) return bSuit - aSuit;
            if (a.repeat && b.repeat) {
                const aDate = a._completedAt?.getTime() ?? 0;
                const bDate = b._completedAt?.getTime() ?? 0;
                return aDate - bDate;
            }
            return 0;
        });

        return scored
            .slice(0, limit)
            .map(({ _completedAt, _suitability, ...rest }) => rest);
    }
}

export default new RecommendationService();
