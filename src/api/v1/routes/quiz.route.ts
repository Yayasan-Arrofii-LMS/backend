import { Router } from 'express';
import { QuizController } from '../controllers/quiz.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { verifyRole } from '../middlewares/verifyrole.middleware';
import { validateBody } from '../middlewares/schema.middleware';
import {
    createQuizSchema,
    updateQuizSchema,
    createQuestionSchema,
    updateQuestionSchema,
    saveAnswerSchema,
    submitQuizSchema,
    bulkCreateQuestionsSchema,
} from '../schemas/quiz.schema';

const router = Router({ mergeParams: true });

// === STUDENT ROUTES (Must be before /:id routes) ===
// Get quiz detail by ID (student view)
router.get(
    '/detail/:quizId',
    authMiddleware,
    verifyRole(['Student']),
    QuizController.getQuizByIdForStudent
);

// Start quiz attempt
router.post(
    '/:quizId/start',
    authMiddleware,
    verifyRole(['Student']),
    QuizController.startQuizAttempt
);

// Save answer (auto-save)
router.post(
    '/save-answer',
    authMiddleware,
    validateBody(saveAnswerSchema),
    QuizController.saveAnswer
);

// Submit quiz (final)
router.post(
    '/submit',
    authMiddleware,
    validateBody(submitQuizSchema),
    QuizController.submitQuiz
);

// Get attempt result
router.get(
    '/attempts/:attemptId/result',
    authMiddleware,
    QuizController.getAttemptResult
);

// Get all my attempts for a quiz
router.get(
    '/my-attempts/:quizId',
    authMiddleware,
    QuizController.getMyAttempts
);

// Get all questions for an attempt (resume failed attempt)
router.get(
    '/attempts/:attemptId/questions',
    authMiddleware,
    QuizController.getAttemptQuestions
);

// Get quiz review with explanations (after submission)
router.get(
    '/attempts/:attemptId/review',
    authMiddleware,
    QuizController.getQuizReview
);

// === TEACHER/ADMIN ROUTES ===
// Get all quizzes by section
router.get(
    '/',
    authMiddleware,
    verifyRole(['Teacher', 'Admin']),
    QuizController.getQuizzesBySection
);

// Create quiz
router.post(
    '/',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    validateBody(createQuizSchema),
    QuizController.createQuiz
);

// Get all questions by quiz (Teacher sees answers, Student doesn't)
router.get(
    '/:quizId/questions',
    authMiddleware,
    QuizController.getAllQuestions
);

// Create question
router.post(
    '/:quizId/questions',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    validateBody(createQuestionSchema),
    QuizController.createQuestion
);

// Get question by ID (Teacher sees answers, Student doesn't)
router.get(
    '/questions/:questionId',
    authMiddleware,
    QuizController.getQuestionById
);

// Update question
router.put(
    '/questions/:questionId',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    validateBody(updateQuestionSchema),
    QuizController.updateQuestion
);

// Delete question
router.delete(
    '/questions/:questionId',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    QuizController.deleteQuestion
);

// Get quiz by ID (must be after specific routes like /detail/:quizId)
router.get(
    '/:id',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    QuizController.getQuiz
);

// Update quiz
router.put(
    '/:id',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    validateBody(updateQuizSchema),
    QuizController.updateQuiz
);

// Delete quiz
router.delete(
    '/:id',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    QuizController.deleteQuiz
);


router.post(
    '/bulk-create',
    authMiddleware,
    verifyRole(['Teacher', "Admin"]),
    validateBody(bulkCreateQuestionsSchema),
    QuizController.bulkCreate
);
export default router;