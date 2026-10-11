import { Router } from 'express';
import recommendationController from '../controllers/recommendation.controller';

const recommendationRouter = Router();

// GET /recommendations?limit=
// Auth: applied at mount point in index.route.ts (authMiddleware)
recommendationRouter.get(
    '/',
    (req, res) => recommendationController.getRecommendations(req, res)
);

export default recommendationRouter;
