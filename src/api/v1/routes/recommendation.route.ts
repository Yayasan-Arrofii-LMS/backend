import { Router } from 'express';
import recommendationController from '../controllers/recommendation.controller';
import { validateBody } from '../middlewares/schema.middleware';
import { submitRecommendationFeedbackSchema } from '../schemas/recommendation.schema';

const recommendationRouter = Router();

// GET /recommendations?type=&search=&limit=
// Auth: applied at mount point in index.route.ts (authMiddleware)
recommendationRouter.get('/', (req, res) =>
    recommendationController.getRecommendations(req, res)
);

// GET /recommendations/overview — stats + remedialSpotlight + progressionSpotlight
recommendationRouter.get('/overview', (req, res) =>
    recommendationController.getOverview(req, res)
);

// GET /recommendations/history?type=&search=&page=&limit=
recommendationRouter.get('/history', (req, res) =>
    recommendationController.getHistory(req, res)
);

// POST /recommendations/:materialId/feedback
recommendationRouter.post(
    '/:materialId/feedback',
    validateBody(submitRecommendationFeedbackSchema),
    (req, res) => recommendationController.submitFeedback(req, res)
);

export default recommendationRouter;
