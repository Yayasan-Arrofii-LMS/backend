import { computeAttemptPercentageScore } from '../../src/api/v1/services/recommendation.service';
import {
    createQuizSchema,
    updateQuizSchema,
    createQuestionSchema,
    updateQuestionSchema,
    bulkCreateQuestionsSchema,
} from '../../src/api/v1/schemas/quiz.schema';
import { getDifficultyRating } from '../../src/api/v1/types/quiz.type';
import { buildQuestionBankWarnings } from '../../src/api/v1/services/quiz.service';

describe('Fase 0 & Fase 1: Adaptive Quiz Foundation Tests', () => {
    describe('Fase 0: computeAttemptPercentageScore (Recommendation Bug Fix)', () => {
        it('converts legacy raw points score to percentage before comparing with passing_grade', () => {
            // Legacy attempt: 40 points out of 50 total points = 80% (passing_grade = 75%)
            const pct = computeAttemptPercentageScore({
                score: 40,
                ability_estimate: null,
                quiz: {
                    quiz_question: [
                        { points: 10 },
                        { points: 10 },
                        { points: 10 },
                        { points: 10 },
                        { points: 10 },
                    ],
                },
            });
            expect(pct).toBe(80);
        });

        it('uses percentage score directly for adaptive attempts (ability_estimate !== null)', () => {
            // Adaptive attempt: score is already stored as 80% even though 5 questions have points = 1
            const pct = computeAttemptPercentageScore({
                score: 80,
                ability_estimate: 0.65,
                quiz: {
                    quiz_question: [
                        { points: 1 },
                        { points: 1 },
                        { points: 1 },
                        { points: 1 },
                        { points: 1 },
                    ],
                },
            });
            expect(pct).toBe(80);
        });

        it('returns null when score is null', () => {
            const pct = computeAttemptPercentageScore({
                score: null,
                ability_estimate: null,
                quiz: { quiz_question: [{ points: 10 }] },
            });
            expect(pct).toBeNull();
        });
    });

    describe('Fase 1: Quiz & Question Zod Schemas + Business Rules (§4)', () => {
        it('defaults show_review to true in createQuizSchema and accepts false', () => {
            const defaultQuiz = createQuizSchema.parse({
                title: 'Kuis Alam',
                description: 'Deskripsi',
                max_attempts: 2,
                time_limit: 30,
                open_at: new Date().toISOString(),
                close_at: new Date(Date.now() + 3600000).toISOString(),
                passing_grade: 75,
                xp: 50,
            });
            expect(defaultQuiz.show_review).toBe(true);

            const noReviewQuiz = createQuizSchema.parse({
                title: 'Kuis Ujian',
                description: 'Deskripsi',
                max_attempts: 1,
                time_limit: 30,
                open_at: new Date().toISOString(),
                close_at: new Date(Date.now() + 3600000).toISOString(),
                passing_grade: 75,
                xp: 50,
                show_review: false,
            });
            expect(noReviewQuiz.show_review).toBe(false);
        });

        it('does not overwrite show_review when omitted in updateQuizSchema', () => {
            const parsed = updateQuizSchema.parse({ title: 'Judul Baru' });
            expect(parsed.show_review).toBeUndefined();
        });

        it('defaults points to 1 and difficulty to Medium in createQuestionSchema', () => {
            const parsed = createQuestionSchema.parse({
                question: 'Apa warna klorofil?',
                type: 'MultipleChoice',
                answers: [
                    { answer: 'Hijau', is_correct: true },
                    { answer: 'Merah', is_correct: false },
                ],
            });
            expect(parsed.points).toBe(1);
            expect(parsed.difficulty).toBe('Medium');
        });

        it('maps difficulty to difficulty_rating (-1, 0, +1)', () => {
            expect(getDifficultyRating('Easy')).toBe(-1);
            expect(getDifficultyRating('Medium')).toBe(0);
            expect(getDifficultyRating('Hard')).toBe(1);
        });

        it('rejects Essay questions in createQuestionSchema, updateQuestionSchema, and bulkCreateQuestionsSchema', () => {
            expect(() =>
                createQuestionSchema.parse({
                    question: 'Jelaskan proses fotosintesis!',
                    type: 'Essay',
                    points: 10,
                })
            ).toThrow();

            expect(() =>
                updateQuestionSchema.parse({
                    type: 'Essay',
                })
            ).toThrow();

            expect(() =>
                bulkCreateQuestionsSchema.parse({
                    title: 'Kuis Campuran',
                    description: 'Deskripsi',
                    max_attempts: 1,
                    time_limit: 30,
                    open_at: new Date().toISOString(),
                    close_at: new Date(Date.now() + 3600000).toISOString(),
                    passing_grade: 70,
                    xp: 50,
                    questions: [
                        {
                            question: 'Soal Essay',
                            type: 'Essay',
                        },
                    ],
                })
            ).toThrow();
        });

        it('generates teacher warnings for < 3 questions or single difficulty level', () => {
            const twoQuestionsDiffLevel = buildQuestionBankWarnings([
                { type: 'MultipleChoice', difficulty: 'Easy' },
                { type: 'TrueFalse', difficulty: 'Hard' },
            ]);
            expect(twoQuestionsDiffLevel.length).toBe(1);
            expect(twoQuestionsDiffLevel[0]).toContain('kurang dari 3 soal');

            const threeQuestionsSameLevel = buildQuestionBankWarnings([
                { type: 'MultipleChoice', difficulty: 'Medium' },
                { type: 'TrueFalse', difficulty: 'Medium' },
                { type: 'MultipleChoice', difficulty: 'Medium' },
            ]);
            expect(threeQuestionsSameLevel.length).toBe(1);
            expect(threeQuestionsSameLevel[0]).toContain('tingkat kesulitan yang sama');

            const balancedBank = buildQuestionBankWarnings([
                { type: 'MultipleChoice', difficulty: 'Easy' },
                { type: 'TrueFalse', difficulty: 'Medium' },
                { type: 'MultipleChoice', difficulty: 'Hard' },
            ]);
            expect(balancedBank).toEqual([]);
        });
    });
});
