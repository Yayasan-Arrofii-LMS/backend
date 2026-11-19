import { Request, Response } from 'express';
import { EnrollmentStatus } from '@prisma/client';
import { sendResponse } from '../helpers/baseResponse';
import { EnrollmentError, EnrollmentService } from '../services/enrollment.service';

export class EnrollmentController {
    // Enroll to a class
    static async enrollClass(req: Request, res: Response) {
        try {
            const userId = req.user!.id!;
            const enrollment = await EnrollmentService.enrollClass(userId, req.body);

            const message =
                enrollment.status === EnrollmentStatus.PENDING
                    ? 'Pendaftaran berhasil dikirim dan menunggu persetujuan guru'
                    : 'Successfully enrolled in the class';

            return sendResponse({
                res,
                statusCode: 201,
                success: true,
                message,
                data: enrollment,
            });
        } catch (error) {
            const statusCode = error instanceof EnrollmentError ? error.statusCode : 400;
            return sendResponse({
                res,
                statusCode,
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
            const statusCode = error instanceof EnrollmentError ? error.statusCode : 400;
            return sendResponse({
                res,
                statusCode,
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
            const rawStatus = (req.query.status as string | undefined)?.toUpperCase();
            let statusFilter: EnrollmentStatus | 'ALL' = EnrollmentStatus.APPROVED;
            if (
                rawStatus === 'ALL' ||
                rawStatus === EnrollmentStatus.PENDING ||
                rawStatus === EnrollmentStatus.APPROVED ||
                rawStatus === EnrollmentStatus.REJECTED
            ) {
                statusFilter = rawStatus as EnrollmentStatus | 'ALL';
            }

            const classes = await EnrollmentService.getMyEnrolledClasses(userId, statusFilter);

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

    // Get class applicants (Teacher/Admin)
    static async getClassApplicants(req: Request, res: Response) {
        try {
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

            const rawStatus = (req.query.status as string | undefined)?.toUpperCase();
            const status =
                rawStatus === EnrollmentStatus.PENDING ||
                rawStatus === EnrollmentStatus.APPROVED ||
                rawStatus === EnrollmentStatus.REJECTED
                    ? (rawStatus as EnrollmentStatus)
                    : undefined;

            const applicants = await EnrollmentService.getClassApplicants(
                classId,
                req.user!.id!,
                req.role,
                status
            );

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Class applicants retrieved successfully',
                data: applicants,
            });
        } catch (error) {
            const statusCode = error instanceof EnrollmentError ? error.statusCode : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: (error as Error).message,
                data: null,
            });
        }
    }

    // Approve or reject applicant status (Teacher/Admin)
    static async updateApplicantStatus(req: Request, res: Response) {
        try {
            const userClassId = parseInt(req.params.userClassId);
            if (isNaN(userClassId)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: 'Invalid userClassId',
                    data: null,
                });
            }

            const updated = await EnrollmentService.updateApplicantStatus(
                userClassId,
                req.body,
                req.user!.id!,
                req.role
            );

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Applicant status updated successfully',
                data: updated,
            });
        } catch (error) {
            const statusCode = error instanceof EnrollmentError ? error.statusCode : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: (error as Error).message,
                data: null,
            });
        }
    }
}
