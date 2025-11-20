import { NextFunction, Request, Response } from 'express';
import { EnrollmentRepository } from '../repositories/enrollment.repository';
import { sendResponse } from '../helpers/baseResponse';
import prisma from '../../../database';

/**
 * Middleware to verify that user is enrolled in a class
 * Usage: Place after authMiddleware and before controller
 * 
 * Expects classId to be in one of:
 * - req.params.classId
 * - req.body.classId
 * - req.query.classId
 */
export const verifyEnrollment = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const userId = req.user?.id;

        if (!userId) {
            return sendResponse({
                res,
                statusCode: 401,
                success: false,
                message: 'Unauthorized',
                data: null,
            });
        }

        // Get classId from params, body, or query
        const classIdStr =
            req.params.classId ||
            req.body.classId?.toString() ||
            req.query.classId?.toString();

        if (!classIdStr) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Class ID is required',
                data: null,
            });
        }

        const classId = parseInt(classIdStr);

        if (isNaN(classId)) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Invalid class ID',
                data: null,
            });
        }

        // Check if user is enrolled
        const isEnrolled = await EnrollmentRepository.isUserEnrolled(userId, classId);

        if (!isEnrolled) {
            return sendResponse({
                res,
                statusCode: 403,
                success: false,
                message: 'You are not enrolled in this class',
                data: null,
            });
        }

        // User is enrolled, proceed to next middleware
        next();
    } catch (error) {
        return sendResponse({
            res,
            statusCode: 500,
            success: false,
            message: (error as Error).message,
            data: null,
        });
    }
};

/**
 * Middleware to verify that user is enrolled in a class via sectionId
 * Usage: For routes that use sectionId instead of classId
 * 
 * Expects sectionId to be in req.params.sectionId
 */
export const verifyEnrollmentBySection = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const userId = req.user?.id;

        if (!userId) {
            return sendResponse({
                res,
                statusCode: 401,
                success: false,
                message: 'Unauthorized',
                data: null,
            });
        }

        const sectionIdStr = req.params.sectionId;

        if (!sectionIdStr) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Section ID is required',
                data: null,
            });
        }

        const sectionId = parseInt(sectionIdStr);

        if (isNaN(sectionId)) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Invalid section ID',
                data: null,
            });
        }

        // Get section to find classId
        const section = await prisma.section.findUnique({
            where: { id: sectionId },
            select: { classId: true },
        });

        if (!section) {
            return sendResponse({
                res,
                statusCode: 404,
                success: false,
                message: 'Section not found',
                data: null,
            });
        }

        // Check if user is enrolled in the class
        const isEnrolled = await EnrollmentRepository.isUserEnrolled(userId, section.classId);

        if (!isEnrolled) {
            return sendResponse({
                res,
                statusCode: 403,
                success: false,
                message: 'You are not enrolled in this class',
                data: null,
            });
        }

        // User is enrolled, proceed to next middleware
        next();
    } catch (error) {
        return sendResponse({
            res,
            statusCode: 500,
            success: false,
            message: (error as Error).message,
            data: null,
        });
    }
};
