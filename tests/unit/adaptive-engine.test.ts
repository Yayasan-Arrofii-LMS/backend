import {
    clampTheta,
    expectedProbability,
    updateAbility,
    updateGroupAbility,
    selectNextQuestion,
    evaluateAnswerCorrectness,
    computeAdaptivePercentageScore,
    getAbilityLevelFromScore,
    filterAdaptiveEligibleQuestions,
} from '../../src/api/v1/helpers/adaptiveEngine';

describe('Fase 2: Adaptive Engine Pure Functions', () => {
    describe('expectedProbability & updateAbility (Elo-lite)', () => {
        it('returns P = 0.5 when theta equals difficulty rating b', () => {
            expect(expectedProbability(0, 0)).toBeCloseTo(0.5, 5);
            expect(expectedProbability(1, 1)).toBeCloseTo(0.5, 5);
            expect(expectedProbability(-1, -1)).toBeCloseTo(0.5, 5);
        });

        it('increases theta more when answering a Hard question correctly than an Easy question', () => {
            const theta0 = 0;
            const afterEasyCorrect = updateAbility(theta0, -1, true);
            const afterHardCorrect = updateAbility(theta0, 1, true);

            expect(afterEasyCorrect).toBeGreaterThan(theta0);
            expect(afterHardCorrect).toBeGreaterThan(afterEasyCorrect);
        });

        it('decreases theta more when answering an Easy question wrong than a Hard question wrong', () => {
            const theta0 = 0;
            const afterEasyWrong = updateAbility(theta0, -1, false);
            const afterHardWrong = updateAbility(theta0, 1, false);

            expect(afterEasyWrong).toBeLessThan(theta0);
            expect(afterHardWrong).toBeLessThan(theta0);
            expect(afterEasyWrong).toBeLessThan(afterHardWrong); // Turun lebih besar di soal mudah
        });

        it('clamps theta strictly within [-3, +3]', () => {
            expect(clampTheta(4.5)).toBe(3);
            expect(clampTheta(-5.2)).toBe(-3);
            expect(updateAbility(2.98, 1, true)).toBe(3);
            expect(updateAbility(-2.98, -1, false)).toBe(-3);
        });

        it('supports competency group ability tracking (§6 Opsi A)', () => {
            let groupMap: Record<string, number> = {};
            groupMap = updateGroupAbility(groupMap, 'comp-ekosistem', 0, true);
            groupMap = updateGroupAbility(groupMap, 'comp-fotosintesis', 1, false);

            expect(groupMap['comp-ekosistem']).toBeGreaterThan(0);
            expect(groupMap['comp-fotosintesis']).toBeLessThan(0);
        });
    });

    describe('selectNextQuestion', () => {
        const sampleBank = [
            { id: 1, type: 'MultipleChoice', difficulty: 'Easy', difficulty_rating: -1 },
            { id: 2, type: 'TrueFalse', difficulty: 'Easy', difficulty_rating: -1 },
            { id: 3, type: 'MultipleChoice', difficulty: 'Medium', difficulty_rating: 0 },
            { id: 4, type: 'TrueFalse', difficulty: 'Medium', difficulty_rating: 0 },
            { id: 5, type: 'MultipleChoice', difficulty: 'Hard', difficulty_rating: 1 },
            { id: 6, type: 'MultipleChoice', difficulty: 'Hard', difficulty_rating: 1 },
            { id: 7, type: 'Essay', difficulty: 'Medium', difficulty_rating: 0 }, // Legacy essay should be ignored
        ];

        it('ignores Essay questions in the bank', () => {
            const eligible = filterAdaptiveEligibleQuestions(sampleBank);
            expect(eligible.some((q) => q.type === 'Essay')).toBe(false);
            expect(eligible.length).toBe(6);
        });

        it('never selects already served questions and finishes when all MC/TF are served', () => {
            const served: number[] = [];
            let theta = 0;

            for (let step = 0; step < 6; step++) {
                const next = selectNextQuestion(sampleBank, served, theta, {
                    randomFn: () => 0,
                });
                expect(next).not.toBeNull();
                expect(next!.type).not.toBe('Essay');
                expect(served).not.toContain(next!.id);
                served.push(next!.id);
                theta = updateAbility(theta, next!.difficulty_rating!, true);
            }

            expect(served.length).toBe(6);
            const afterAllServed = selectNextQuestion(sampleBank, served, theta);
            expect(afterAllServed).toBeNull();
        });

        it('adapts question selection upward as theta increases and falls back gracefully when a level is empty', () => {
            // High theta (2.0) -> target b = 1.6 -> closest are Hard (+1) questions (id 5 and 6)
            const pickedHigh = selectNextQuestion(sampleBank, [], 2.0, {
                poolSize: 1,
                randomFn: () => 0,
            });
            expect(pickedHigh?.difficulty).toBe('Hard');

            // If all Hard and Medium are already served, falls back to Easy without error
            const fallbackEasy = selectNextQuestion(sampleBank, [3, 4, 5, 6], 2.0, {
                randomFn: () => 0,
            });
            expect(fallbackEasy?.difficulty).toBe('Easy');
        });
    });

    describe('evaluateAnswerCorrectness, computeAdaptivePercentageScore & getAbilityLevelFromScore', () => {
        it('evaluates MultipleChoice and TrueFalse (by ID and by text) accurately', () => {
            const mcQuestion = {
                id: 10,
                type: 'MultipleChoice',
                quiz_answer: [
                    { id: 101, answer: 'A', is_correct: false },
                    { id: 102, answer: 'B', is_correct: true },
                ],
            };
            expect(evaluateAnswerCorrectness(mcQuestion, { selectedAnswerIds: [102] })).toBe(true);
            expect(evaluateAnswerCorrectness(mcQuestion, { selectedAnswerIds: [101] })).toBe(false);
            expect(evaluateAnswerCorrectness(mcQuestion, { selectedAnswerIds: [101, 102] })).toBe(false);

            const tfQuestion = {
                id: 11,
                type: 'TrueFalse',
                quiz_answer: [
                    { id: 201, answer: 'Benar', is_correct: true },
                    { id: 202, answer: 'Salah', is_correct: false },
                ],
            };
            expect(evaluateAnswerCorrectness(tfQuestion, { selectedAnswerIds: [201] })).toBe(true);
            expect(evaluateAnswerCorrectness(tfQuestion, { selectedAnswerIds: [202] })).toBe(false);
            expect(evaluateAnswerCorrectness(tfQuestion, { answer: 'Benar' })).toBe(true);
            expect(evaluateAnswerCorrectness(tfQuestion, { answer: 'Salah' })).toBe(false);
        });

        it('computes unweighted percentage score and maps to Dasar / Cakap / Mahir', () => {
            expect(computeAdaptivePercentageScore(8, 10)).toBe(80);
            expect(computeAdaptivePercentageScore(6, 10)).toBe(60);
            expect(computeAdaptivePercentageScore(7, 10)).toBe(70);

            expect(getAbilityLevelFromScore(60)).toBe('Dasar');
            expect(getAbilityLevelFromScore(64)).toBe('Dasar');
            expect(getAbilityLevelFromScore(65)).toBe('Cakap');
            expect(getAbilityLevelFromScore(79)).toBe('Cakap');
            expect(getAbilityLevelFromScore(80)).toBe('Mahir');
            expect(getAbilityLevelFromScore(100)).toBe('Mahir');
        });
    });
});
