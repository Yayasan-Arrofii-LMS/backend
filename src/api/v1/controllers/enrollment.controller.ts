import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import { EnrollmentService } from '../services/enrollment.service';

export class EnrollmentController {
    // Enroll to a class
    static async enrollClass(req: Request, res: Response) {
        try {
            const userId = req.user!.id!;
            const enrollment = await EnrollmentService.enrollClass(userId, req.body);

            return sendResponse({
                res,
                statusCode: 201,
                success: true,
                message: 'Successfully enrolled in the class',
                data: enrollment,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: (error as Error).message,
                data: null,
            });
        }
    }

    // Unenroll from a class
    static async unenrollClass(req: Request, res: Response) {
        try {
            const userId = req.user!.id!;
            await EnrollmentService.unenrollClass(userId, req.body);

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Successfully unenrolled from the class',
                data: null,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: (error as Error).message,
                data: null,
            });
        }
    }

    // Get my enrolled classes
    static async getMyEnrolledClasses(req: Request, res: Response) {
        try {
            const userId = req.user!.id!;
            const classes = await EnrollmentService.getMyEnrolledClasses(userId);

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Enrolled classes retrieved',
                data: classes,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: (error as Error).message,
                data: null,
            });
        }
    }

    // Check enrollment status
    static async checkEnrollment(req: Request, res: Response) {
        try {
            const userId = req.user!.id!;
            const classId = parseInt(req.params.classId);

            if (isNaN(classId)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: 'Invalid class ID',
                    data: null,
                });
            }

            const result = await EnrollmentService.checkEnrollment(userId, classId);

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Enrollment status retrieved',
                data: result,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: (error as Error).message,
                data: null,
            });
        }
    }
}
