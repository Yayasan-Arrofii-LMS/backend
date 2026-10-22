export type QuestionDifficulty = "Easy" | "Medium" | "Hard";

export const DIFFICULTY_RATING_MAP: Record<QuestionDifficulty, number> = {
    Easy: -1,
    Medium: 0,
    Hard: 1,
};

export function getDifficultyRating(difficulty?: QuestionDifficulty): number {
    return DIFFICULTY_RATING_MAP[difficulty ?? "Medium"] ?? 0;
}

export type CreateQuizInput = {
    title: string;
    description: string;
    max_attempts: number;
    time_limit: number;
    open_at: string | Date;
    close_at: string | Date;
    passing_grade: number;
    xp: number;
    show_review?: boolean;
    sectionId: number;
};

export type UpdateQuizInput = Partial<CreateQuizInput>;

export type CreateQuestionInput = {
    question: string;
    type: "MultipleChoice" | "TrueFalse";
    difficulty?: QuestionDifficulty;
    points?: number;
    explanation?: string;
    answers?: { answer: string; is_correct: boolean }[];
};

export type UpdateQuestionInput = Partial<CreateQuestionInput>;

export type StartQuizAttemptInput = {
    quizId: number;
};

export type SaveAnswerInput = {
    attemptId: number;
    questionId: number;
    answer?: string;
    filePath?: string;
    selectedAnswerIds?: number[];
};

export type AdaptiveAnswerInput = {
    attemptId: number;
    questionId: number;
    selectedAnswerIds?: number[];
    answer?: string;
};

export type SubmitQuizInput = {
    attemptId: number;
};

export type GetAttemptResultInput = {
    attemptId: number;
};
