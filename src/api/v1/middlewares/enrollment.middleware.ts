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
        const userRole = req.role;

        if (!userId) {
            return sendResponse({
                res,
                statusCode: 401,
                success: false,
                message: 'Unauthorized',
                data: null,
            });
        }

        // Admin can bypass enrollment check
        if (userRole === 'Admin') {
            return next();
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
        const userRole = req.role;

        if (!userId) {
            return sendResponse({
                res,
                statusCode: 401,
                success: false,
                message: 'Unauthorized',
                data: null,
            });
        }

        // Admin can bypass enrollment check
        if (userRole === 'Admin') {
            return next();
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

/**
 * Middleware to verify that user is enrolled in a class via materialId
 * Usage: For routes that use materialId instead of sectionId
 * 
 * Expects materialId to be in req.params.materialId
 */
export const verifyEnrollmentByMaterial = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const userId = req.user?.id;
        const userRole = req.role;

        if (!userId) {
            return sendResponse({
                res,
                statusCode: 401,
                success: false,
                message: 'Unauthorized',
                data: null,
            });
        }

        // Admin can bypass enrollment check
        if (userRole === 'Admin') {
            return next();
        }

        const materialIdStr = req.params.materialId;

        if (!materialIdStr) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Material ID is required',
                data: null,
            });
        }

        const materialId = parseInt(materialIdStr);

        if (isNaN(materialId)) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Invalid material ID',
                data: null,
            });
        }

        // Get material to find sectionId, then classId
        const material = await prisma.material.findUnique({
            where: { id: materialId },
            select: {
                Section: {
                    select: { classId: true }
                }
            },
        });

        if (!material) {
            return sendResponse({
                res,
                statusCode: 404,
                success: false,
                message: 'Material not found',
                data: null,
            });
        }

        // Check if user is enrolled in the class
        const isEnrolled = await EnrollmentRepository.isUserEnrolled(userId, material.Section.classId);

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
 * Middleware to verify that user is enrolled in a class via material file
 * Usage: For routes that use fileID (Material_File)
 * 
 * Expects fileID to be in req.params.fileID or materialId in req.params.materialId
 */
export const verifyEnrollmentByMaterialFile = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const userId = req.user?.id;
        const userRole = req.role;

        if (!userId) {
            return sendResponse({
                res,
                statusCode: 401,
                success: false,
                message: 'Unauthorized',
                data: null,
            });
        }

        // Admin can bypass enrollment check
        if (userRole === 'Admin') {
            return next();
        }

        // Check if we have fileID (for material file routes) or materialId (parent param)
        const fileIdStr = req.params.fileID;
        const materialIdStr = req.params.materialId;

        let classId: number;

        if (fileIdStr) {
            // Route is /materials/:materialId/files/:fileID
            const fileId = parseInt(fileIdStr);

            if (isNaN(fileId)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: 'Invalid file ID',
                    data: null,
                });
            }

            // Get material file to find materialId, then sectionId, then classId
            const materialFile = await prisma.material_File.findUnique({
                where: { id: fileId },
                select: {
                    Material: {
                        select: {
                            Section: {
                                select: { classId: true }
                            }
                        }
                    }
                },
            });

            if (!materialFile) {
                return sendResponse({
                    res,
                    statusCode: 404,
                    success: false,
                    message: 'Material file not found',
                    data: null,
                });
            }

            classId = materialFile.Material.Section.classId;
        } else if (materialIdStr) {
            // Route is /materials/:materialId/files (getting all files for a material)
            const materialId = parseInt(materialIdStr);

            if (isNaN(materialId)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: 'Invalid material ID',
                    data: null,
                });
            }

            // Get material to find sectionId, then classId
            const material = await prisma.material.findUnique({
                where: { id: materialId },
                select: {
                    Section: {
                        select: { classId: true }
                    }
                },
            });

            if (!material) {
                return sendResponse({
                    res,
                    statusCode: 404,
                    success: false,
                    message: 'Material not found',
                    data: null,
                });
            }

            classId = material.Section.classId;
        } else {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: 'Material ID or File ID is required',
                data: null,
            });
        }

        // Check if user is enrolled in the class
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
