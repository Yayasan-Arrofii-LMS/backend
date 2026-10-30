import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import { NotFoundError } from '../errors/notfound.error';
import recommendationService, {
    ForbiddenEnrollmentError,
    RecommendationReason,
} from '../services/recommendation.service';
import { recommendationReasonEnum } from '../schemas/recommendation.schema';

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

            let parsedType: RecommendationReason | undefined;
            if (req.query.type !== undefined && req.query.type !== '') {
                const typeCheck = recommendationReasonEnum.safeParse(req.query.type);
                if (!typeCheck.success) {
                    return sendResponse({
                        res,
                        statusCode: 400,
                        success: false,
                        message:
                            'Invalid recommendation type. Allowed values: minat, progres, remedial, lanjutan',
                        data: null,
                        errors: { type: ['Invalid recommendation type'] },
                    });
                }
                parsedType = typeCheck.data;
            }

            const rawLimit = parseInt(req.query.limit as string);
            const limit = isNaN(rawLimit) ? 10 : Math.min(Math.max(rawLimit, 1), 50);
            const search =
                typeof req.query.search === 'string' && req.query.search.trim().length > 0
                    ? req.query.search.trim()
                    : undefined;

            const recommendations = await recommendationService.getRecommendations(userId, {
                type: parsedType,
                search,
                limit,
            });

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

    async getOverview(req: Request, res: Response) {
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

            const overview = await recommendationService.getRecommendationOverview(userId);

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Recommendation overview retrieved successfully',
                data: overview,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve recommendation overview',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }

    async getHistory(req: Request, res: Response) {
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

            let parsedType: RecommendationReason | undefined;
            if (req.query.type !== undefined && req.query.type !== '') {
                const typeCheck = recommendationReasonEnum.safeParse(req.query.type);
                if (!typeCheck.success) {
                    return sendResponse({
                        res,
                        statusCode: 400,
                        success: false,
                        message:
                            'Invalid recommendation type. Allowed values: minat, progres, remedial, lanjutan',
                        data: null,
                        errors: { type: ['Invalid recommendation type'] },
                    });
                }
                parsedType = typeCheck.data;
            }

            const rawPage = parseInt(req.query.page as string);
            const page = isNaN(rawPage) ? 1 : Math.max(rawPage, 1);

            const rawLimit = parseInt(req.query.limit as string);
            const limit = isNaN(rawLimit) ? 10 : Math.min(Math.max(rawLimit, 1), 50);

            const search =
                typeof req.query.search === 'string' && req.query.search.trim().length > 0
                    ? req.query.search.trim()
                    : undefined;

            const result = await recommendationService.getRecommendationHistory(userId, {
                type: parsedType,
                search,
                page,
                limit,
            });

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Recommendation history retrieved successfully',
                data: result.items,
                meta: result.meta,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve recommendation history',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }

    async submitFeedback(req: Request, res: Response) {
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

            const materialId = parseInt(req.params.materialId);
            if (isNaN(materialId)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: 'Invalid material ID',
                    data: null,
                });
            }

            const result = await recommendationService.submitFeedback(
                userId,
                materialId,
                req.body.feedback,
                req.role
            );

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Recommendation feedback saved successfully',
                data: result,
            });
        } catch (error) {
            if (error instanceof NotFoundError) {
                return sendResponse({
                    res,
                    statusCode: 404,
                    success: false,
                    message: error.message,
                    data: null,
                });
            }
            if (error instanceof ForbiddenEnrollmentError) {
                return sendResponse({
                    res,
                    statusCode: 403,
                    success: false,
                    message: error.message,
                    data: null,
                });
            }
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to save recommendation feedback',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }
}

export default new RecommendationController();
