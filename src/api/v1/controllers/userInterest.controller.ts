import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import { NotFoundError } from '../errors/notfound.error';
import userInterestService from '../services/userInterest.service';

export class UserInterestController {
    async getUserInterests(req: Request, res: Response) {
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

            const interests = await userInterestService.getUserInterests(userId);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'User interests retrieved successfully',
                data: interests,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve user interests',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }

    async updateUserInterests(req: Request, res: Response) {
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

            const interests = await userInterestService.updateUserInterests(userId, req.body);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'User interests updated successfully',
                data: interests,
            });
        } catch (error) {
            const statusCode = error instanceof NotFoundError ? 404 : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: error instanceof NotFoundError ? error.message : 'Failed to update user interests',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }
}

export default new UserInterestController();
