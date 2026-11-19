import { EnrollmentStatus, recommendation_feedback } from '@prisma/client';
import prisma from '../../../database';
import { AbilityLevel, getAbilityLevelFromScore } from '../helpers/adaptiveEngine';
import {
    estimateMaterialDuration,
    extractMaterialExcerpt,
    resolveMaterialThumbnail,
} from '../helpers/materialContent.helper';
import recommendationHistoryRepository from '../repositories/recommendationHistory.repository';
import { EnrollmentRepository } from '../repositories/enrollment.repository';
import { NotFoundError } from '../errors/notfound.error';

// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────

export type RecommendationReason = 'remedial' | 'minat' | 'progres' | 'lanjutan';
export type LearningStatus = 'not_opened' | 'opened' | 'in_progress' | 'completed';
export type RecommendationFeedbackValue = 'relevant' | 'neutral' | 'not_relevant';

export interface EvaluationContext {
    quizId: number;
    quizTitle: string;
    targetCompetency: string;
    currentScore: number;
    passingGrade: number;
    isPassed: boolean;
    abilityLevel: AbilityLevel;
}

export interface RecommendationItem {
    material: {
        id: number;
        title: string;
        difficulty: string | null;
        mediaType: string | null;
        durationMinutes: number;
        categoryId: number | null;
        sectionId: number;
        category: { id: number; name: string } | null;
        Section: { id: number; title: string; classId: number; className?: string };
    };
    reasons: RecommendationReason[];
    primaryReason: RecommendationReason;
    reasonText: string;
    whyDetail: string;
    score: number;
    excerpt: string;
    estimatedMinutes: number;
    thumbnailUrl: string | null;
    learningStatus: LearningStatus;
    progressPercent: number;
    feedback: RecommendationFeedbackValue | null;
    evaluationContext: EvaluationContext | null;
    repeat?: boolean;
}

export interface SectionQuizDiagnostic {
    sectionId: number;
    quizId: number;
    quizTitle: string;
    percentageScore: number;
    passingGrade: number;
    isPassed: boolean;
    abilityEstimate: number;
    abilityLevel: AbilityLevel;
}

export interface GetRecommendationsOptions {
    type?: RecommendationReason;
    search?: string;
    limit?: number;
}

export interface RecommendationOverviewResponse {
    stats: {
        totalRecommended: number;
        totalOpened: number;
        totalCompleted: number;
        completionRate: number;
        totalFeedback: number;
        isAdaptiveActive: boolean;
    };
    remedialSpotlight: {
        targetCompetency: string;
        quizId: number;
        quizTitle: string;
        category: { id: number; name: string } | null;
        currentScore: number;
        passingGrade: number;
        abilityLevel: AbilityLevel;
        reasonText: string;
        material: {
            id: number;
            title: string;
            excerpt: string;
            estimatedMinutes: number;
            mediaType: string | null;
            difficulty: string | null;
            thumbnailUrl: string | null;
            sectionId: number;
            classId: number;
        };
    } | null;
    progressionSpotlight: {
        prerequisite: {
            materialId: number | null;
            materialTitle: string;
            sectionId: number;
            sectionTitle: string;
            competencyTitle: string;
            score: number | null;
            passingGrade: number | null;
            isQuizPassed: boolean;
        };
        nextMaterial: {
            id: number;
            title: string;
            excerpt: string;
            estimatedMinutes: number;
            mediaType: string | null;
            difficulty: string | null;
            thumbnailUrl: string | null;
            category: { id: number; name: string } | null;
            sectionId: number;
            sectionTitle: string;
            classId: number;
        };
        narrativeText: string;
    } | null;
}

export interface RecommendationHistoryItem {
    id: number;
    materialId: number;
    recommendedAt: Date;
    firstRecommendedAt: Date;
    primaryReason: RecommendationReason;
    reasons: RecommendationReason[];
    reasonText: string;
    learningStatus: LearningStatus;
    progressPercent: number;
    feedback: RecommendationFeedbackValue | null;
    feedbackAt: Date | null;
    material: {
        id: number;
        title: string;
        excerpt: string;
        estimatedMinutes: number;
        difficulty: string | null;
        mediaType: string | null;
        thumbnailUrl: string | null;
        category: { id: number; name: string } | null;
        Section: { id: number; title: string; classId: number; className: string };
    };
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

export class ForbiddenEnrollmentError extends Error {
    constructor(message: string = 'You are not enrolled in this class') {
        super(message);
        this.name = 'ForbiddenEnrollmentError';
    }
}

const REASON_PRIORITY: RecommendationReason[] = ['remedial', 'minat', 'progres', 'lanjutan'];

function formatDifficultyLabel(difficulty: string | null): string {
    if (!difficulty) return 'Pemula';
    const d = difficulty.toLowerCase();
    if (d === 'easy') return 'Pemula';
    if (d === 'medium') return 'Menengah';
    if (d === 'hard') return 'Mahir';
    return difficulty;
}

function buildReasonNarrative(params: {
    reason: RecommendationReason;
    sectionTitle: string;
    className: string;
    categoryName: string | null;
    difficulty: string | null;
    sectionProgressPercent: number;
    diagnostic?: SectionQuizDiagnostic;
}): { reasonText: string; whyDetail: string } {
    const {
        reason,
        sectionTitle,
        className,
        categoryName,
        difficulty,
        sectionProgressPercent,
        diagnostic,
    } = params;

    if (reason === 'remedial') {
        const currentScore = diagnostic?.percentageScore ?? 0;
        const targetScore = diagnostic?.passingGrade ?? 75;
        const level = diagnostic?.abilityLevel ?? 'Dasar';
        return {
            reasonText: `Membantu memperkuat kompetensi evaluasi ${sectionTitle} (skor ${currentScore}/${targetScore}).`,
            whyDetail: `Hasil evaluasi terakhirmu pada topik "${sectionTitle}" adalah ${currentScore}/100 (target kelulusan ${targetScore}). Materi tingkat ${formatDifficultyLabel(
                difficulty
            )} ini dipilih sesuai profil kemampuanmu (${level}) untuk memperkuat pemahaman konsep dasar.`,
        };
    }

    if (reason === 'minat') {
        const topic = categoryName ?? sectionTitle;
        return {
            reasonText: `Sesuai dengan minatmu pada ${topic}.`,
            whyDetail: `Materi ini direkomendasikan karena relevan dengan topik minat "${topic}" yang kamu pilih pada preferensi belajarmu.`,
        };
    }

    if (reason === 'progres') {
        return {
            reasonText: `Direkomendasikan berdasarkan progres belajarmu di topik ${sectionTitle}.`,
            whyDetail: `Kamu sedang mempelajari bab "${sectionTitle}" dengan progres ketuntasan ${sectionProgressPercent}%. Lanjutkan materi ini untuk menuntaskan bab.`,
        };
    }

    return {
        reasonText: `Materi lanjutan yang siap dipelajari pada topik ${sectionTitle}.`,
        whyDetail: `Materi ini merupakan tahap pembelajaran berikutnya pada kelas "${className}" untuk memperluas penguasaan kompetensimu.`,
    };
}

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

    if (diff === 'hard') return 3;
    if (diff === 'medium') return 2;
    if (diff === 'easy') return 1;
    return 0;
}

async function getEnrolledSectionIds(userId: string): Promise<Set<number>> {
    const enrollments = await prisma.user_Class.findMany({
        where: { userId, status: EnrollmentStatus.APPROVED },
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

async function getUserLearningActivitySets(userId: string): Promise<{
    openedIds: Set<number>;
    completedIds: Set<number>;
    oldestCompletionByMaterial: Map<number, Date>;
}> {
    const [activities, completedUserMaterials] = await Promise.all([
        prisma.materialActivity.findMany({
            where: { userId, action: { in: ['opened', 'completed'] } },
            select: { materialId: true, action: true, createdAt: true },
            orderBy: { createdAt: 'asc' },
        }),
        prisma.user_Material.findMany({
            where: { userId, is_completed: true },
            select: { materialId: true, updatedAt: true },
        }),
    ]);

    const openedIds = new Set<number>();
    const completedIds = new Set<number>();
    const oldestCompletionByMaterial = new Map<number, Date>();

    for (const act of activities) {
        if (act.action === 'opened') {
            openedIds.add(act.materialId);
        } else if (act.action === 'completed') {
            completedIds.add(act.materialId);
            openedIds.add(act.materialId);
            if (!oldestCompletionByMaterial.has(act.materialId)) {
                oldestCompletionByMaterial.set(act.materialId, act.createdAt);
            }
        }
    }

    for (const um of completedUserMaterials) {
        completedIds.add(um.materialId);
        openedIds.add(um.materialId);
        if (!oldestCompletionByMaterial.has(um.materialId)) {
            oldestCompletionByMaterial.set(um.materialId, um.updatedAt);
        }
    }

    return { openedIds, completedIds, oldestCompletionByMaterial };
}

function resolveLearningStatus(
    materialId: number,
    openedIds: Set<number>,
    completedIds: Set<number>,
    sectionProgressPercent: number
): LearningStatus {
    if (completedIds.has(materialId)) return 'completed';
    if (openedIds.has(materialId)) {
        return sectionProgressPercent > 0 ? 'in_progress' : 'opened';
    }
    return 'not_opened';
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
                    title: true,
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
                quizTitle: a.quiz.title,
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

type InternalScoredCandidate = RecommendationItem & {
    _completedAt?: Date;
    _suitability: number;
    _defaultPrimaryReason: RecommendationReason;
    _defaultReasonText: string;
};

export class RecommendationService {
    private async computeRankedCandidates(userId: string): Promise<{
        candidates: InternalScoredCandidate[];
        enrolledSectionIds: Set<number>;
        interestCategoryIds: Set<number>;
        openedIds: Set<number>;
        completedIds: Set<number>;
        sectionDiagnostics: Map<number, SectionQuizDiagnostic>;
        sectionProgressMap: Map<number, number>;
        allEnrolledMaterials: {
            id: number;
            title: string;
            content: string;
            video_link: string | null;
            duration_minutes: number | null;
            difficulty: string | null;
            mediaType: string | null;
            order: number;
            categoryId: number | null;
            sectionId: number;
            createdAt: Date;
            category: { id: number; name: string } | null;
            Section: {
                id: number;
                title: string;
                order: number;
                classId: number;
                Class: { id: number; name: string; image_path: string };
            };
        }[];
    }> {
        const enrolledSectionIds = await getEnrolledSectionIds(userId);
        if (enrolledSectionIds.size === 0) {
            return {
                candidates: [],
                enrolledSectionIds,
                interestCategoryIds: new Set(),
                openedIds: new Set(),
                completedIds: new Set(),
                sectionDiagnostics: new Map(),
                sectionProgressMap: new Map(),
                allEnrolledMaterials: [],
            };
        }

        const [interestCategoryIds, activitySets, sectionDiagnostics, allEnrolledMaterials] =
            await Promise.all([
                getUserInterestCategoryIds(userId),
                getUserLearningActivitySets(userId),
                getSectionQuizDiagnostics(userId),
                prisma.material.findMany({
                    where: { sectionId: { in: [...enrolledSectionIds] } },
                    select: {
                        id: true,
                        title: true,
                        content: true,
                        video_link: true,
                        duration_minutes: true,
                        difficulty: true,
                        mediaType: true,
                        order: true,
                        categoryId: true,
                        sectionId: true,
                        createdAt: true,
                        category: { select: { id: true, name: true } },
                        Section: {
                            select: {
                                id: true,
                                title: true,
                                order: true,
                                classId: true,
                                Class: { select: { id: true, name: true, image_path: true } },
                            },
                        },
                    },
                    orderBy: [{ createdAt: 'desc' }],
                }),
            ]);

        const { openedIds, completedIds, oldestCompletionByMaterial } = activitySets;

        const failingSectionIds = new Set<number>();
        for (const [sectionId, diag] of sectionDiagnostics.entries()) {
            if (!diag.isPassed) {
                failingSectionIds.add(sectionId);
            }
        }

        // Hitung statistik per-section: total materi, jumlah selesai, dan apakah section sudah dimulai
        const sectionTotalCount = new Map<number, number>();
        const sectionCompletedCount = new Map<number, number>();
        const startedSectionIds = new Set<number>();

        for (const mat of allEnrolledMaterials) {
            sectionTotalCount.set(mat.sectionId, (sectionTotalCount.get(mat.sectionId) ?? 0) + 1);
            if (completedIds.has(mat.id)) {
                sectionCompletedCount.set(
                    mat.sectionId,
                    (sectionCompletedCount.get(mat.sectionId) ?? 0) + 1
                );
                startedSectionIds.add(mat.sectionId);
            } else if (openedIds.has(mat.id)) {
                startedSectionIds.add(mat.sectionId);
            }
        }

        const sectionProgressMap = new Map<number, number>();
        for (const [secId, total] of sectionTotalCount.entries()) {
            const done = sectionCompletedCount.get(secId) ?? 0;
            sectionProgressMap.set(secId, total > 0 ? Math.round((done / total) * 100) : 0);
        }

        const historyMap = await recommendationHistoryRepository.findMapByUserAndMaterialIds(
            userId,
            allEnrolledMaterials.map((m) => m.id)
        );

        const candidates: InternalScoredCandidate[] = [];

        for (const material of allEnrolledMaterials) {
            const isCompleted = completedIds.has(material.id);
            const isRemedialSection = failingSectionIds.has(material.sectionId);
            const hasInterest =
                material.categoryId !== null && interestCategoryIds.has(material.categoryId);
            const isSectionStarted = startedSectionIds.has(material.sectionId);
            const isRemedialRepeat = isRemedialSection && isCompleted;

            // Deprioritise completed materials unless remedial
            if (isCompleted && !isRemedialSection) {
                continue;
            }

            const reasons: RecommendationReason[] = [];
            let score = 0;

            if (isRemedialSection) {
                score += 4;
                reasons.push('remedial');
            }
            if (hasInterest) {
                score += 3;
                reasons.push('minat');
            }
            if (!isCompleted && isSectionStarted) {
                score += 2;
                reasons.push('progres');
            }
            if (!isCompleted && !isSectionStarted) {
                score += 1;
                reasons.push('lanjutan');
            }

            const defaultPrimaryReason =
                REASON_PRIORITY.find((r) => reasons.includes(r)) ?? reasons[0] ?? 'lanjutan';

            const diag = sectionDiagnostics.get(material.sectionId);
            const suitability = getMaterialDifficultySuitability(material.difficulty, diag);
            const sectionProgressPercent = sectionProgressMap.get(material.sectionId) ?? 0;

            const narrative = buildReasonNarrative({
                reason: defaultPrimaryReason,
                sectionTitle: material.Section.title,
                className: material.Section.Class.name,
                categoryName: material.category?.name ?? null,
                difficulty: material.difficulty,
                sectionProgressPercent,
                diagnostic: diag,
            });

            const estimatedMinutes =
                material.duration_minutes ??
                estimateMaterialDuration({
                    content: material.content,
                    mediaType: material.mediaType,
                    videoLink: material.video_link,
                });

            const excerpt = extractMaterialExcerpt(material.content, 150);
            const thumbnailUrl = resolveMaterialThumbnail(
                material.content,
                material.Section.Class.image_path
            );
            const learningStatus = resolveLearningStatus(
                material.id,
                openedIds,
                completedIds,
                sectionProgressPercent
            );
            const existingHistory = historyMap.get(material.id);

            const evaluationContext: EvaluationContext | null = diag
                ? {
                      quizId: diag.quizId,
                      quizTitle: diag.quizTitle,
                      targetCompetency: material.Section.title,
                      currentScore: diag.percentageScore,
                      passingGrade: diag.passingGrade,
                      isPassed: diag.isPassed,
                      abilityLevel: diag.abilityLevel,
                  }
                : null;

            const item: InternalScoredCandidate = {
                material: {
                    id: material.id,
                    title: material.title,
                    difficulty: material.difficulty,
                    mediaType: material.mediaType,
                    durationMinutes: estimatedMinutes,
                    categoryId: material.categoryId,
                    sectionId: material.sectionId,
                    category: material.category,
                    Section: {
                        id: material.Section.id,
                        title: material.Section.title,
                        classId: material.Section.classId,
                        className: material.Section.Class.name,
                    },
                },
                reasons,
                primaryReason: defaultPrimaryReason,
                reasonText: narrative.reasonText,
                whyDetail: narrative.whyDetail,
                score,
                excerpt,
                estimatedMinutes,
                thumbnailUrl,
                learningStatus,
                progressPercent: sectionProgressPercent,
                feedback: (existingHistory?.feedback as RecommendationFeedbackValue | null) ?? null,
                evaluationContext,
                _suitability: suitability,
                _defaultPrimaryReason: defaultPrimaryReason,
                _defaultReasonText: narrative.reasonText,
            };

            if (isRemedialRepeat) {
                item.repeat = true;
                item._completedAt = oldestCompletionByMaterial.get(material.id);
            }

            candidates.push(item);
        }

        // Sort: score desc → remedial first → adaptive suitability desc → oldest completion first for repeats
        candidates.sort((a, b) => {
            if (b.score !== a.score) return b.score - a.score;
            const aIsRemedial = a.reasons.includes('remedial');
            const bIsRemedial = b.reasons.includes('remedial');
            if (aIsRemedial !== bIsRemedial) return aIsRemedial ? -1 : 1;
            if (b._suitability !== a._suitability) return b._suitability - a._suitability;
            if (a.repeat && b.repeat) {
                const aDate = a._completedAt?.getTime() ?? 0;
                const bDate = b._completedAt?.getTime() ?? 0;
                return aDate - bDate;
            }
            return 0;
        });

        return {
            candidates,
            enrolledSectionIds,
            interestCategoryIds,
            openedIds,
            completedIds,
            sectionDiagnostics,
            sectionProgressMap,
            allEnrolledMaterials,
        };
    }

    /**
     * Mengambil daftar kartu rekomendasi aktif untuk siswa.
     * Mendukung pemanggilan legacy `(userId, limitNumber)` maupun `(userId, { type, search, limit })`.
     */
    async getRecommendations(
        userId: string,
        limitOrOptions: number | GetRecommendationsOptions = 10
    ): Promise<RecommendationItem[]> {
        const options: GetRecommendationsOptions =
            typeof limitOrOptions === 'number' ? { limit: limitOrOptions } : limitOrOptions;

        const limit = options.limit ?? 10;
        const { candidates, sectionDiagnostics } = await this.computeRankedCandidates(userId);
        if (candidates.length === 0) return [];

        let filtered = candidates;

        if (options.type) {
            const targetType = options.type;
            filtered = filtered
                .filter((item) => item.reasons.includes(targetType))
                .map((item) => {
                    if (item.primaryReason === targetType) return item;
                    const diag = sectionDiagnostics.get(item.material.sectionId);
                    const adjusted = buildReasonNarrative({
                        reason: targetType,
                        sectionTitle: item.material.Section.title,
                        className: item.material.Section.className ?? '',
                        categoryName: item.material.category?.name ?? null,
                        difficulty: item.material.difficulty,
                        sectionProgressPercent: item.progressPercent,
                        diagnostic: diag,
                    });
                    return {
                        ...item,
                        primaryReason: targetType,
                        reasonText: adjusted.reasonText,
                        whyDetail: adjusted.whyDetail,
                    };
                });
        }

        if (options.search && options.search.trim().length > 0) {
            const q = options.search.trim().toLowerCase();
            filtered = filtered.filter(
                (item) =>
                    item.material.title.toLowerCase().includes(q) ||
                    item.reasonText.toLowerCase().includes(q) ||
                    item.excerpt.toLowerCase().includes(q)
            );
        }

        const sliced = filtered.slice(0, limit);

        // Sinkronkan impresi ke Recommendation_History menggunakan defaultPrimaryReason agar histori stabil
        await recommendationHistoryRepository.syncImpressions(
            userId,
            sliced.map((item) => ({
                materialId: item.material.id,
                primaryReason: item._defaultPrimaryReason,
                reasons: item.reasons,
                reasonText: item._defaultReasonText,
                score: item.score,
            }))
        );

        return sliced.map(
            ({ _completedAt, _suitability, _defaultPrimaryReason, _defaultReasonText, ...rest }) =>
                rest
        );
    }

    /**
     * Mengambil paket data ringkasan halaman rekomendasi:
     * 1. Statistik "Aktivitas Rekomendasimu"
     * 2. Banner "Perkuat Pemahamanmu" (`remedialSpotlight`)
     * 3. Banner "Lanjutkan Perjalanan Belajarmu" (`progressionSpotlight`)
     */
    async getRecommendationOverview(userId: string): Promise<RecommendationOverviewResponse> {
        const {
            candidates,
            enrolledSectionIds,
            interestCategoryIds,
            openedIds,
            completedIds,
            sectionDiagnostics,
            allEnrolledMaterials,
        } = await this.computeRankedCandidates(userId);

        let summaryRows = await recommendationHistoryRepository.findAllSummaryRowsByUser(userId);

        // Jika siswa belum punya catatan histori tetapi punya kandidat rekomendasi aktif, sinkronkan 10 teratas
        if (summaryRows.length === 0 && candidates.length > 0) {
            const initialBatch = candidates.slice(0, 10);
            await recommendationHistoryRepository.syncImpressions(
                userId,
                initialBatch.map((item) => ({
                    materialId: item.material.id,
                    primaryReason: item._defaultPrimaryReason,
                    reasons: item.reasons,
                    reasonText: item._defaultReasonText,
                    score: item.score,
                }))
            );
            summaryRows = await recommendationHistoryRepository.findAllSummaryRowsByUser(userId);
        }

        const totalRecommended = summaryRows.length;
        const totalOpened = summaryRows.filter(
            (r) => openedIds.has(r.materialId) || completedIds.has(r.materialId)
        ).length;
        const totalCompleted = summaryRows.filter((r) => completedIds.has(r.materialId)).length;
        const completionRate =
            totalRecommended > 0 ? Math.round((totalCompleted / totalRecommended) * 100) : 0;
        const totalFeedback = summaryRows.filter((r) => r.feedback !== null).length;
        const isAdaptiveActive =
            enrolledSectionIds.size > 0 ||
            interestCategoryIds.size > 0 ||
            sectionDiagnostics.size > 0;

        // ── 1. Remedial Spotlight ("Perkuat Pemahamanmu") ──
        let remedialSpotlight: RecommendationOverviewResponse['remedialSpotlight'] = null;
        const remedialCandidates = candidates.filter(
            (c) => c.reasons.includes('remedial') && c.evaluationContext && !c.evaluationContext.isPassed
        );

        if (remedialCandidates.length > 0) {
            remedialCandidates.sort((a, b) => {
                const gapA =
                    (a.evaluationContext?.passingGrade ?? 75) -
                    (a.evaluationContext?.currentScore ?? 0);
                const gapB =
                    (b.evaluationContext?.passingGrade ?? 75) -
                    (b.evaluationContext?.currentScore ?? 0);
                if (gapB !== gapA) return gapB - gapA;
                return b._suitability - a._suitability;
            });

            const topRemedial = remedialCandidates[0];
            const evalCtx = topRemedial.evaluationContext!;

            remedialSpotlight = {
                targetCompetency: evalCtx.targetCompetency,
                quizId: evalCtx.quizId,
                quizTitle: evalCtx.quizTitle,
                category: topRemedial.material.category,
                currentScore: evalCtx.currentScore,
                passingGrade: evalCtx.passingGrade,
                abilityLevel: evalCtx.abilityLevel,
                reasonText: `Materi ini dapat membantu memperkuat kompetensi yang belum mencapai target ketuntasan (${evalCtx.currentScore}/100).`,
                material: {
                    id: topRemedial.material.id,
                    title: topRemedial.material.title,
                    excerpt: topRemedial.excerpt,
                    estimatedMinutes: topRemedial.estimatedMinutes,
                    mediaType: topRemedial.material.mediaType,
                    difficulty: topRemedial.material.difficulty,
                    thumbnailUrl: topRemedial.thumbnailUrl,
                    sectionId: topRemedial.material.sectionId,
                    classId: topRemedial.material.Section.classId,
                },
            };
        }

        // ── 2. Progression Spotlight ("Lanjutkan Perjalanan Belajarmu") ──
        let progressionSpotlight: RecommendationOverviewResponse['progressionSpotlight'] = null;

        // Urutkan materi per kelas berdasarkan Section.order asc, lalu Material.order asc
        const materialsByClass = new Map<number, typeof allEnrolledMaterials>();
        for (const mat of allEnrolledMaterials) {
            const classId = mat.Section.classId;
            const list = materialsByClass.get(classId) ?? [];
            list.push(mat);
            materialsByClass.set(classId, list);
        }

        for (const classMats of materialsByClass.values()) {
            classMats.sort((a, b) => {
                if (a.Section.order !== b.Section.order) return a.Section.order - b.Section.order;
                if (a.order !== b.order) return a.order - b.order;
                return a.id - b.id;
            });

            // Kelompokkan per section dalam urutan kelas
            const sectionsOrdered: {
                sectionId: number;
                sectionTitle: string;
                order: number;
                materials: typeof allEnrolledMaterials;
            }[] = [];

            for (const mat of classMats) {
                let secGroup = sectionsOrdered.find((s) => s.sectionId === mat.sectionId);
                if (!secGroup) {
                    secGroup = {
                        sectionId: mat.sectionId,
                        sectionTitle: mat.Section.title,
                        order: mat.Section.order,
                        materials: [],
                    };
                    sectionsOrdered.push(secGroup);
                }
                secGroup.materials.push(mat);
            }

            // Prioritas A: Section yang sudah LULUS kuis (atau semua materinya tuntas dan tidak gagal kuis) -> buka Section berikutnya
            for (let idx = 0; idx < sectionsOrdered.length - 1; idx++) {
                const currentSec = sectionsOrdered[idx];
                const diag = sectionDiagnostics.get(currentSec.sectionId);
                const allMatsDone = currentSec.materials.every((m) => completedIds.has(m.id));
                const isQuizPassed = diag?.isPassed === true;
                const isQuizFailed = diag !== undefined && !diag.isPassed;

                if (!isQuizFailed && (isQuizPassed || allMatsDone)) {
                    // Cari materi pertama yang belum tuntas di section setelahnya
                    const nextSections = sectionsOrdered.slice(idx + 1);
                    let targetNextMat: (typeof allEnrolledMaterials)[0] | undefined;
                    for (const ns of nextSections) {
                        targetNextMat = ns.materials.find((m) => !completedIds.has(m.id));
                        if (targetNextMat) break;
                    }

                    if (targetNextMat) {
                        const prereqMat =
                            [...currentSec.materials]
                                .reverse()
                                .find((m) => completedIds.has(m.id)) ??
                            currentSec.materials[currentSec.materials.length - 1];

                        const nextDuration =
                            targetNextMat.duration_minutes ??
                            estimateMaterialDuration({
                                content: targetNextMat.content,
                                mediaType: targetNextMat.mediaType,
                                videoLink: targetNextMat.video_link,
                            });

                        progressionSpotlight = {
                            prerequisite: {
                                materialId: prereqMat?.id ?? null,
                                materialTitle: prereqMat?.title ?? currentSec.sectionTitle,
                                sectionId: currentSec.sectionId,
                                sectionTitle: currentSec.sectionTitle,
                                competencyTitle: diag?.quizTitle ?? currentSec.sectionTitle,
                                score: diag?.percentageScore ?? null,
                                passingGrade: diag?.passingGrade ?? null,
                                isQuizPassed,
                            },
                            nextMaterial: {
                                id: targetNextMat.id,
                                title: targetNextMat.title,
                                excerpt: extractMaterialExcerpt(targetNextMat.content, 160),
                                estimatedMinutes: nextDuration,
                                mediaType: targetNextMat.mediaType,
                                difficulty: targetNextMat.difficulty,
                                thumbnailUrl: resolveMaterialThumbnail(
                                    targetNextMat.content,
                                    targetNextMat.Section.Class.image_path
                                ),
                                category: targetNextMat.category,
                                sectionId: targetNextMat.sectionId,
                                sectionTitle: targetNextMat.Section.title,
                                classId: targetNextMat.Section.classId,
                            },
                            narrativeText: `Kamu telah menuntaskan "${
                                prereqMat?.title ?? currentSec.sectionTitle
                            }". Sekarang saatnya melangkah ke "${
                                targetNextMat.title
                            }" pada bab ${targetNextMat.Section.title}.`,
                        };
                        break;
                    }
                }
            }

            if (progressionSpotlight) break;

            // Prioritas B (Fallback dalam section yang sama): materi sebelumnya sudah selesai -> materi urutan berikutnya belum selesai
            for (const sec of sectionsOrdered) {
                const diag = sectionDiagnostics.get(sec.sectionId);
                if (diag && !diag.isPassed) continue; // section remedial ditangani oleh remedialSpotlight

                for (let mIdx = 0; mIdx < sec.materials.length - 1; mIdx++) {
                    const currMat = sec.materials[mIdx];
                    const nextMat = sec.materials[mIdx + 1];
                    if (completedIds.has(currMat.id) && !completedIds.has(nextMat.id)) {
                        const nextDuration =
                            nextMat.duration_minutes ??
                            estimateMaterialDuration({
                                content: nextMat.content,
                                mediaType: nextMat.mediaType,
                                videoLink: nextMat.video_link,
                            });

                        progressionSpotlight = {
                            prerequisite: {
                                materialId: currMat.id,
                                materialTitle: currMat.title,
                                sectionId: sec.sectionId,
                                sectionTitle: sec.sectionTitle,
                                competencyTitle: diag?.quizTitle ?? sec.sectionTitle,
                                score: diag?.percentageScore ?? null,
                                passingGrade: diag?.passingGrade ?? null,
                                isQuizPassed: diag?.isPassed ?? false,
                            },
                            nextMaterial: {
                                id: nextMat.id,
                                title: nextMat.title,
                                excerpt: extractMaterialExcerpt(nextMat.content, 160),
                                estimatedMinutes: nextDuration,
                                mediaType: nextMat.mediaType,
                                difficulty: nextMat.difficulty,
                                thumbnailUrl: resolveMaterialThumbnail(
                                    nextMat.content,
                                    nextMat.Section.Class.image_path
                                ),
                                category: nextMat.category,
                                sectionId: nextMat.sectionId,
                                sectionTitle: nextMat.Section.title,
                                classId: nextMat.Section.classId,
                            },
                            narrativeText: `Kamu telah menyelesaikan "${currMat.title}". Lanjutkan perjalanan belajarmu ke materi "${nextMat.title}".`,
                        };
                        break;
                    }
                }
                if (progressionSpotlight) break;
            }

            if (progressionSpotlight) break;
        }

        return {
            stats: {
                totalRecommended,
                totalOpened,
                totalCompleted,
                completionRate,
                totalFeedback,
                isAdaptiveActive,
            },
            remedialSpotlight,
            progressionSpotlight,
        };
    }

    /**
     * Menyimpan feedback relevansi siswa (`relevant` | `neutral` | `not_relevant` | `null`)
     * pada suatu materi rekomendasi.
     */
    async submitFeedback(
        userId: string,
        materialId: number,
        feedback: RecommendationFeedbackValue | null,
        userRole?: string
    ) {
        const material = await prisma.material.findUnique({
            where: { id: materialId },
            select: {
                id: true,
                title: true,
                difficulty: true,
                categoryId: true,
                sectionId: true,
                category: { select: { id: true, name: true } },
                Section: {
                    select: {
                        id: true,
                        title: true,
                        classId: true,
                        Class: { select: { name: true } },
                    },
                },
            },
        });

        if (!material) {
            throw new NotFoundError('Material not found');
        }

        if (userRole !== 'Admin') {
            const isEnrolled = await EnrollmentRepository.isUserEnrolled(
                userId,
                material.Section.classId
            );
            if (!isEnrolled) {
                throw new ForbiddenEnrollmentError('You are not enrolled in this class');
            }
        }

        const narrative = buildReasonNarrative({
            reason: 'minat',
            sectionTitle: material.Section.title,
            className: material.Section.Class.name,
            categoryName: material.category?.name ?? null,
            difficulty: material.difficulty,
            sectionProgressPercent: 0,
        });

        const updated = await recommendationHistoryRepository.upsertFeedback(
            userId,
            materialId,
            feedback as recommendation_feedback | null,
            {
                materialId,
                primaryReason: 'minat',
                reasons: ['minat'],
                reasonText: narrative.reasonText,
                score: 1,
            }
        );

        return {
            materialId: updated.materialId,
            feedback: updated.feedback as RecommendationFeedbackValue | null,
            feedbackAt: updated.feedback_at,
        };
    }

    /**
     * Mengambil daftar Riwayat Rekomendasi siswa dengan filter `type`, pencarian `search`,
     * pagination, serta penggabungan status belajar terkini.
     */
    async getRecommendationHistory(
        userId: string,
        options: {
            type?: RecommendationReason;
            search?: string;
            page?: number;
            limit?: number;
        }
    ): Promise<{
        items: RecommendationHistoryItem[];
        meta: {
            totalItems: number;
            itemsPerPage: number;
            totalPages: number;
            currentPage: number;
        };
    }> {
        const page = options.page ?? 1;
        const limit = options.limit ?? 10;
        const offset = (page - 1) * limit;

        const [rows, totalItems, activitySets] = await Promise.all([
            recommendationHistoryRepository.findHistoryByUser(userId, {
                type: options.type,
                search: options.search,
                limit,
                offset,
            }),
            recommendationHistoryRepository.countHistoryByUser(userId, {
                type: options.type,
                search: options.search,
            }),
            getUserLearningActivitySets(userId),
        ]);

        const { openedIds, completedIds } = activitySets;

        // Hitung persentase ketuntasan section untuk section-section yang muncul di halaman histori ini
        const sectionIds = [...new Set(rows.map((r) => r.material.sectionId))];
        const sectionMaterials =
            sectionIds.length > 0
                ? await prisma.material.findMany({
                      where: { sectionId: { in: sectionIds } },
                      select: { id: true, sectionId: true },
                  })
                : [];

        const sectionTotalMap = new Map<number, number>();
        const sectionDoneMap = new Map<number, number>();
        for (const sm of sectionMaterials) {
            sectionTotalMap.set(sm.sectionId, (sectionTotalMap.get(sm.sectionId) ?? 0) + 1);
            if (completedIds.has(sm.id)) {
                sectionDoneMap.set(sm.sectionId, (sectionDoneMap.get(sm.sectionId) ?? 0) + 1);
            }
        }

        const items: RecommendationHistoryItem[] = rows.map((row) => {
            const totalInSec = sectionTotalMap.get(row.material.sectionId) ?? 0;
            const doneInSec = sectionDoneMap.get(row.material.sectionId) ?? 0;
            const progressPercent =
                totalInSec > 0 ? Math.round((doneInSec / totalInSec) * 100) : 0;

            const learningStatus = resolveLearningStatus(
                row.materialId,
                openedIds,
                completedIds,
                progressPercent
            );

            const estimatedMinutes =
                row.material.duration_minutes ??
                estimateMaterialDuration({
                    content: row.material.content,
                    mediaType: row.material.mediaType,
                    videoLink: row.material.video_link,
                });

            const parsedReasons = Array.isArray(row.reasons)
                ? (row.reasons as RecommendationReason[])
                : ([row.primary_reason] as RecommendationReason[]);

            return {
                id: row.id,
                materialId: row.materialId,
                recommendedAt: row.last_recommended_at,
                firstRecommendedAt: row.first_recommended_at,
                primaryReason: row.primary_reason as RecommendationReason,
                reasons: parsedReasons,
                reasonText: row.reason_text,
                learningStatus,
                progressPercent,
                feedback: (row.feedback as RecommendationFeedbackValue | null) ?? null,
                feedbackAt: row.feedback_at,
                material: {
                    id: row.material.id,
                    title: row.material.title,
                    excerpt: extractMaterialExcerpt(row.material.content, 150),
                    estimatedMinutes,
                    difficulty: row.material.difficulty,
                    mediaType: row.material.mediaType,
                    thumbnailUrl: resolveMaterialThumbnail(
                        row.material.content,
                        row.material.Section.Class.image_path
                    ),
                    category: row.material.category,
                    Section: {
                        id: row.material.Section.id,
                        title: row.material.Section.title,
                        classId: row.material.Section.classId,
                        className: row.material.Section.Class.name,
                    },
                },
            };
        });

        return {
            items,
            meta: {
                totalItems,
                itemsPerPage: limit,
                totalPages: Math.ceil(totalItems / limit),
                currentPage: page,
            },
        };
    }
}

export default new RecommendationService();
