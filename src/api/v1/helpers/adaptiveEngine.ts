import { QuestionDifficulty, getDifficultyRating } from '../types/quiz.type';

export type AbilityLevel = 'Dasar' | 'Cakap' | 'Mahir';

export interface AdaptiveCandidateQuestion {
    id: number;
    type: string;
    difficulty?: QuestionDifficulty | string | null;
    difficulty_rating?: number | null;
    groupKey?: string | null; // Hook untuk kesiapan kompetensi (§6 Opsi A)
}

export interface AnswerOptionForEval {
    id: number;
    answer: string;
    is_correct: boolean;
}

export interface QuestionForEval {
    id: number;
    type: string;
    quiz_answer: AnswerOptionForEval[];
}

export const DEFAULT_INITIAL_THETA = 0;
export const DEFAULT_ELO_K = 0.4;
export const TARGET_DIFFICULTY_OFFSET = 0.4; // target b = theta - 0.4 (~60% peluang benar)
export const MIN_THETA = -3;
export const MAX_THETA = 3;
export const TOP_CANDIDATES_POOL_SIZE = 3;

/**
 * Clamp nilai theta ke rentang [-3, +3].
 */
export function clampTheta(theta: number): number {
    if (theta < MIN_THETA) return MIN_THETA;
    if (theta > MAX_THETA) return MAX_THETA;
    return Number(theta.toFixed(4));
}

/**
 * Hitung peluang menjawab benar menggunakan fungsi logistik 1PL (Rasch / Elo-lite):
 * P = 1 / (1 + e^-(theta - b))
 */
export function expectedProbability(theta: number, difficultyRating: number): number {
    return 1 / (1 + Math.exp(-(theta - difficultyRating)));
}

/**
 * Update estimasi kemampuan siswa (theta) menggunakan rumus Elo-lite:
 * theta_baru = clamp(theta + K * (hasil - P), -3, +3)
 */
export function updateAbility(
    currentTheta: number,
    difficultyRating: number,
    isCorrect: boolean,
    k: number = DEFAULT_ELO_K
): number {
    const p = expectedProbability(currentTheta, difficultyRating);
    const outcome = isCorrect ? 1 : 0;
    const nextTheta = currentTheta + k * (outcome - p);
    return clampTheta(nextTheta);
}

/**
 * Hook kesiapan Kompetensi (§6 Opsi A):
 * Menyimpan & memperbarui kemampuan per kelompok (`groupKey`, default: 'default',
 * nantinya dapat diisi `competencyId` tanpa merombak engine).
 */
export function updateGroupAbility(
    abilitiesByGroup: Record<string, number>,
    groupKey: string = 'default',
    difficultyRating: number,
    isCorrect: boolean,
    k: number = DEFAULT_ELO_K
): Record<string, number> {
    const current = abilitiesByGroup[groupKey] ?? DEFAULT_INITIAL_THETA;
    return {
        ...abilitiesByGroup,
        [groupKey]: updateAbility(current, difficultyRating, isCorrect, k),
    };
}

/**
 * Resolusi angka kesulitan b (-1 / 0 / +1) dari properti soal.
 */
export function resolveQuestionDifficultyRating(question: {
    difficulty?: QuestionDifficulty | string | null;
    difficulty_rating?: number | null;
}): number {
    if (
        typeof question.difficulty_rating === 'number' &&
        !Number.isNaN(question.difficulty_rating)
    ) {
        return question.difficulty_rating;
    }
    if (
        question.difficulty === 'Easy' ||
        question.difficulty === 'Medium' ||
        question.difficulty === 'Hard'
    ) {
        return getDifficultyRating(question.difficulty);
    }
    return 0;
}

/**
 * Filter hanya soal yang didukung oleh mesin adaptif (MultipleChoice & TrueFalse).
 * Soal Essay lama di data diabaikan oleh mesin (§0.5 & §4).
 */
export function filterAdaptiveEligibleQuestions<T extends { type: string }>(
    questions: T[]
): T[] {
    return questions.filter(
        (q) => q.type === 'MultipleChoice' || q.type === 'TrueFalse'
    );
}

/**
 * Pilih soal berikutnya untuk disajikan:
 * 1. Hanya dari kandidat MultipleChoice / TrueFalse yang belum disajikan (`servedQuestionIds`).
 * 2. Jalankan hook `groupBalancer` (no-op default sekarang, siap untuk kompetensi §6).
 * 3. Hitung target kesulitan `b_target = theta - 0.4`.
 * 4. Ambil `poolSize` (default 3) kandidat dengan jarak |b - b_target| terdekat,
 *    lalu pilih satu secara acak untuk mengurangi contek.
 */
export function selectNextQuestion<T extends AdaptiveCandidateQuestion>(
    allQuestions: T[],
    servedQuestionIds: Iterable<number>,
    currentTheta: number = DEFAULT_INITIAL_THETA,
    options?: {
        poolSize?: number;
        randomFn?: () => number;
        groupBalancer?: (candidates: T[]) => T[];
    }
): T | null {
    const servedSet = new Set(servedQuestionIds);
    const eligible = filterAdaptiveEligibleQuestions(allQuestions).filter(
        (q) => !servedSet.has(q.id)
    );

    if (eligible.length === 0) {
        return null;
    }

    const balancedCandidates = options?.groupBalancer
        ? options.groupBalancer(eligible)
        : eligible;

    const candidates =
        balancedCandidates.length > 0 ? balancedCandidates : eligible;

    const targetB = currentTheta - TARGET_DIFFICULTY_OFFSET;
    const poolSize = options?.poolSize ?? TOP_CANDIDATES_POOL_SIZE;
    const randomFn = options?.randomFn ?? Math.random;

    const ranked = [...candidates].sort((a, b) => {
        const distA = Math.abs(resolveQuestionDifficultyRating(a) - targetB);
        const distB = Math.abs(resolveQuestionDifficultyRating(b) - targetB);
        if (Math.abs(distA - distB) > 1e-9) {
            return distA - distB;
        }
        return a.id - b.id;
    });

    const topPool = ranked.slice(0, Math.min(poolSize, ranked.length));
    const randomIndex = Math.min(
        topPool.length - 1,
        Math.floor(randomFn() * topPool.length)
    );

    return topPool[randomIndex];
}

/**
 * Evaluasi kebenaran jawaban siswa di server untuk soal MultipleChoice atau TrueFalse.
 * Mendukung pengiriman via `selectedAnswerIds` (array ID) maupun `answer` (string untuk TrueFalse).
 */
export function evaluateAnswerCorrectness(
    question: QuestionForEval,
    input: {
        selectedAnswerIds?: number[];
        answer?: string | null;
    }
): boolean {
    const correctOptions = question.quiz_answer.filter((a) => a.is_correct);
    if (correctOptions.length === 0) {
        return false;
    }

    const selectedIds = input.selectedAnswerIds
        ? [...new Set(input.selectedAnswerIds)].sort((a, b) => a - b)
        : [];

    if (question.type === 'MultipleChoice') {
        if (selectedIds.length === 0) return false;
        const correctIds = correctOptions.map((a) => a.id).sort((a, b) => a - b);
        return (
            correctIds.length === selectedIds.length &&
            correctIds.every((id, idx) => id === selectedIds[idx])
        );
    }

    if (question.type === 'TrueFalse') {
        if (selectedIds.length > 0) {
            const correctIds = correctOptions.map((a) => a.id).sort((a, b) => a - b);
            return (
                correctIds.length === selectedIds.length &&
                correctIds.every((id, idx) => id === selectedIds[idx])
            );
        }

        if (typeof input.answer === 'string' && input.answer.trim().length > 0) {
            const normalizedUser = input.answer.trim().toLowerCase();
            return correctOptions.some(
                (opt) => opt.answer.trim().toLowerCase() === normalizedUser
            );
        }

        return false;
    }

    return false;
}

/**
 * Hitung skor akhir persentase (0 - 100):
 * skor% = Math.round((jumlah_benar / jumlah_soal_MC_TF_di_bank) * 100)
 * Tanpa bobot kesulitan (§0.8 & §4).
 */
export function computeAdaptivePercentageScore(
    correctCount: number,
    totalBankQuestionsCount: number
): number {
    if (totalBankQuestionsCount <= 0) return 0;
    const boundedCorrect = Math.max(0, Math.min(correctCount, totalBankQuestionsCount));
    return Math.round((boundedCorrect / totalBankQuestionsCount) * 100);
}

/**
 * Tentukan Level Capaian Siswa berdasarkan skor persentase (§4 & Panduan FE §1.5):
 * - Skor < 65%       -> 'Dasar'
 * - 65% <= Skor <= 79% -> 'Cakap'
 * - Skor >= 80%      -> 'Mahir'
 */
export function getAbilityLevelFromScore(percentageScore: number): AbilityLevel {
    if (percentageScore >= 80) return 'Mahir';
    if (percentageScore >= 65) return 'Cakap';
    return 'Dasar';
}
