import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import recommendationService from '../services/recommendation.service';

export class RecommendationController {
    async getRecommendations(req: Request, res: Response) {
        try {
            const userId = req.user?.id;
            if (!userId) {
                return sendResponse({
                    res,
                    statusCode: 401,
                    success: false,
                    message: 'User not authenticated',
                    data: null,
                });
            }

            const rawLimit = parseInt(req.query.limit as string);
            const limit = isNaN(rawLimit) ? 10 : Math.min(Math.max(rawLimit, 1), 50);

            const recommendations = await recommendationService.getRecommendations(userId, limit);

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Recommendations retrieved successfully',
                data: recommendations,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve recommendations',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }
}

export default new RecommendationController();
