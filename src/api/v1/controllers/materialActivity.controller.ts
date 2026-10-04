import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import materialActivityService from '../services/materialActivity.service';

export class MaterialActivityController {
    async getUserActivities(req: Request, res: Response) {
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

            const page = parseInt(req.query.page as string) || 1;
            const limit = parseInt(req.query.limit as string) || 20;

            const result = await materialActivityService.getUserActivities(userId, page, limit);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'User activities retrieved successfully',
                data: result.activities,
                meta: result.meta,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve user activities',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }
}

export default new MaterialActivityController();
