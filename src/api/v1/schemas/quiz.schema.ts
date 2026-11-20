import { z } from "zod";

export const questionDifficultySchema = z.enum(["Easy", "Medium", "Hard"]);
export const questionTypeSchema = z.enum(["MultipleChoice", "TrueFalse", "Essay"], {
    message: "Tipe soal tidak valid. Gunakan MultipleChoice, TrueFalse, atau Essay",
});
export const adaptiveQuestionTypeSchema = questionTypeSchema;

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
    type: questionTypeSchema,
    difficulty: questionDifficultySchema.optional().default("Medium"),
    points: z.number().int().min(1, "Points must be >= 1").optional().default(1),
    explanation: z.string().nullable().optional(),
    instructions: z.string().nullable().optional(),
    rubric: z.string().nullable().optional(),
    answers: z.array(answerSchema).optional(),
}).superRefine((data, ctx) => {
    if (data.type !== "Essay") {
        const answers = data.answers;
        if (!answers || answers.length === 0) {
            ctx.addIssue({
                code: "custom",
                message: "At least one answer option is required",
                path: ["answers"],
            });
            return;
        }
        if (!answers.some((a) => a.is_correct)) {
            ctx.addIssue({
                code: "custom",
                message: "At least one correct answer required",
                path: ["answers"],
            });
        }
    }
});

export const updateQuestionSchema = z.object({
    question: z.string().min(1, "Question is required").optional(),
    type: questionTypeSchema.optional(),
    difficulty: questionDifficultySchema.optional(),
    points: z.number().int().min(1, "Points must be >= 1").optional(),
    explanation: z.string().nullable().optional(),
    instructions: z.string().nullable().optional(),
    rubric: z.string().nullable().optional(),
    answers: z.array(answerSchema).optional(),
}).superRefine((data, ctx) => {
    if (data.type !== "Essay" && data.answers !== undefined) {
        if (data.answers.length === 0) {
            ctx.addIssue({
                code: "custom",
                message: "At least one answer option is required",
                path: ["answers"],
            });
            return;
        }
        if (!data.answers.some((a) => a.is_correct)) {
            ctx.addIssue({
                code: "custom",
                message: "At least one correct answer required",
                path: ["answers"],
            });
        }
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

// === Teacher: Grade Essay Attempt ===
export const gradeEssayItemSchema = z.object({
    questionId: z.number().int().positive("Question ID must be a positive integer"),
    score: z.number().min(0, "Nilai tidak boleh negatif"),
    feedback: z.string().nullable().optional(),
});

export const gradeEssayAttemptSchema = z.object({
    attemptId: z.number().int().positive().optional(),
    grades: z.array(gradeEssayItemSchema).min(1, "Minimal satu penilaian harus disertakan"),
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
export type GradeEssayAttemptInput = z.infer<typeof gradeEssayAttemptSchema>;
