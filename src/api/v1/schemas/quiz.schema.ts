import { z } from "zod";

export const questionDifficultySchema = z.enum(["Easy", "Medium", "Hard"]);
export const adaptiveQuestionTypeSchema = z.enum(["MultipleChoice", "TrueFalse"], {
    message: "Tipe soal Essay tidak didukung. Gunakan MultipleChoice atau TrueFalse",
});

// === Quiz ===
export const createQuizSchema = z.object({
    title: z.string().min(1, "Title is required"),
    description: z.string().min(1, "Description is required"),
    max_attempts: z.number().int().min(1, "Max attempts must be >= 1"),
    time_limit: z.number().int().min(1, "Time limit must be >= 1 minute"),
    open_at: z.string().datetime().or(z.date()),
    close_at: z.string().datetime().or(z.date()),
    passing_grade: z.number().int().min(0).max(100),
    xp: z.number().int().min(0).default(0),
    show_review: z.boolean().optional().default(true),
    sectionId: z.number().int().optional(),
});

export const updateQuizSchema = z.object({
    title: z.string().min(1, "Title is required").optional(),
    description: z.string().min(1, "Description is required").optional(),
    max_attempts: z.number().int().min(1, "Max attempts must be >= 1").optional(),
    time_limit: z.number().int().min(1, "Time limit must be >= 1 minute").optional(),
    open_at: z.string().datetime().or(z.date()).optional(),
    close_at: z.string().datetime().or(z.date()).optional(),
    passing_grade: z.number().int().min(0).max(100).optional(),
    xp: z.number().int().min(0).optional(),
    show_review: z.boolean().optional(),
    sectionId: z.number().int().optional(),
});

// === Question ===
const answerSchema = z.object({
    answer: z.string().min(1, "Answer text is required"),
    is_correct: z.boolean(),
});

export const createQuestionSchema = z.object({
    question: z.string().min(1, "Question is required"),
    type: adaptiveQuestionTypeSchema,
    difficulty: questionDifficultySchema.optional().default("Medium"),
    points: z.number().int().min(1, "Points must be >= 1").optional().default(1),
    explanation: z.string().optional(),
    answers: z
        .array(answerSchema)
        .min(1, "At least one answer option is required"),
}).superRefine((data, ctx) => {
    const answers = data.answers;
    if (!answers || !answers.some((a) => a.is_correct)) {
        ctx.addIssue({
            code: "custom",
            message: "At least one correct answer required",
            path: ["answers"],
        });
    }
});

export const updateQuestionSchema = z.object({
    question: z.string().min(1, "Question is required").optional(),
    type: adaptiveQuestionTypeSchema.optional(),
    difficulty: questionDifficultySchema.optional(),
    points: z.number().int().min(1, "Points must be >= 1").optional(),
    explanation: z.string().optional(),
    answers: z
        .array(answerSchema)
        .min(1, "At least one answer option is required")
        .optional(),
}).superRefine((data, ctx) => {
    if (data.answers !== undefined && !data.answers.some((a) => a.is_correct)) {
        ctx.addIssue({
            code: "custom",
            message: "At least one correct answer required",
            path: ["answers"],
        });
    }
});

// === Student: Start Quiz Attempt ===
export const startQuizAttemptSchema = z.object({
    quizId: z.number().int(),
});

// === Student: Save Answer (Auto-save) ===
export const saveAnswerSchema = z.object({
    attemptId: z.number().int(),
    questionId: z.number().int(),
    answer: z.string().optional(),
    filePath: z.string().optional(),
    selectedAnswerIds: z.array(z.number().int()).optional(),
});

// === Student: Adaptive Answer ===
export const adaptiveAnswerSchema = z.object({
    attemptId: z.number().int(),
    questionId: z.number().int(),
    selectedAnswerIds: z.array(z.number().int()).optional(),
    answer: z.string().optional(),
});

// === Student: Submit Quiz (Final) ===
export const submitQuizSchema = z.object({
    attemptId: z.number().int(),
});

// === Student: Get Attempt Result ===
export const getAttemptResultSchema = z.object({
    attemptId: z.number().int(),
});

export const bulkCreateQuestionsSchema = z.object({
    title: z.string().min(1, "Title is required"),
    description: z.string().min(1, "Description is required"),
    max_attempts: z.number().int().min(1, "Max attempts must be >= 1"),
    time_limit: z.number().int().min(1, "Time limit must be >= 1 minute"),
    open_at: z.string().datetime().or(z.date()),
    close_at: z.string().datetime().or(z.date()),
    passing_grade: z.number().int().min(0).max(100),
    xp: z.number().int().min(0).default(0),
    show_review: z.boolean().optional().default(true),
    sectionId: z.number().int().optional(),
    questions: z.array(createQuestionSchema).min(1, "At least one question is required"),
});

export type BulkCreateQuestionsInput = z.infer<typeof bulkCreateQuestionsSchema>;
export type AdaptiveAnswerInput = z.infer<typeof adaptiveAnswerSchema>;
