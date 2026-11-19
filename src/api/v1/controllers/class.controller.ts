import { Request, Response } from "express";
import { class_approval_status } from "@prisma/client";
import classService from "../services/class.service";
import { BaseResponse } from "../types/responseType";
import { sendResponse } from "../helpers/baseResponse";
import prisma from "../../../database";
import { imageType, optimizeImage } from "../helpers/imageCompress";
import { saveFile } from "../helpers/file";
import { EnrollmentRepository } from "../repositories/enrollment.repository";

interface ClassDto {
    id: number;
    name: string;
    description: string;
    image_path: string;
    registrationType?: string;
    approvalStatus?: string;
    rejectionReason?: string | null;
    approvedById?: string | null;
    approvedAt?: Date | string | null;
    createdAt: string;
    updatedAt: string;
}




export const getClasses = async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string) || 1;
        const limit = 12;
        const search = (req.query.search as string) || undefined;
        const rawCat = (req.query.category ?? req.query.categoryId) as string | undefined;
        const categoryId = rawCat && rawCat.trim() !== "" && rawCat.trim() !== "Semua"
            ? (!Number.isNaN(Number(rawCat.trim())) ? Number(rawCat.trim()) : rawCat.trim())
            : undefined;
        const userId = req.user!.id!;
        const userRole = req.role!;

        const rawApproval = (req.query.approvalStatus as string | undefined)?.toUpperCase();
        const approvalStatus =
            rawApproval === class_approval_status.PENDING ||
            rawApproval === class_approval_status.APPROVED ||
            rawApproval === class_approval_status.REJECTED
                ? (rawApproval as class_approval_status)
                : undefined;

        const { classes, totalItems } = await classService.getClasses(
            userId,
            userRole,
            page,
            limit,
            search,
            categoryId,
            approvalStatus
        );
        const meta = {
            totalItems: totalItems,
            currentPage: page,
            totalPages: Math.ceil(totalItems / limit),
            itemsPerPage: limit
        }

        const data = classes.map(cls => ({
            id: cls.id,
            name: cls.name,
            description: cls.description,
            image_path: cls.image_path,
            image_path_relative: cls.image_path_relative,
            categoryId: (cls as any).categoryId ?? null,
            category: (cls as any).category ?? null,
            registrationType: (cls as any).registrationType ?? "AUTO",
            approvalStatus: (cls as any).approvalStatus ?? "APPROVED",
            rejectionReason: (cls as any).rejectionReason ?? null,
            approvedById: (cls as any).approvedById ?? null,
            approvedAt: (cls as any).approvedAt ?? null,
            createdAt: (cls as any).createdAt ?? null,
            updatedAt: (cls as any).updatedAt ?? null,
            teachers: (cls as any).teachers ?? [],
        }))

        sendResponse({ res, statusCode: 200, success: true, message: "Get Classes", data: data, meta: meta })
    } catch (error) {
        console.error("Error fetching classes:", error);
        res.status(500).json({
            success: false,
            message: "Failed to retrieve classes",
            errors: {
                server: (error as Error).message,
            },
        });
    }
};

export const getClassById = async (req: Request, res: Response) => {
    try {
        const classId = parseInt(req.params.id);
        const userId = req.user!.id!;
        const userRole = req.role;
        const classData = await classService.getClassById(classId);

        if (!classData) {
            return res.status(404).json({
                success: false,
                message: "Class not found",
            });
        }

        // Admin can bypass, otherwise check if user is teacher of this class
        if (userRole !== 'Admin') {
            const isTeacher = await EnrollmentRepository.isUserTeacher(userId, classId);
            if (!isTeacher) {
                return res.status(403).json({
                    success: false,
                    message: "Access denied. Only teachers of this class can view details.",
                });
            }
        }

        const studentsInClass = await classService.getAllStudentsInClass(classId);


        const data = {
            id: classData.id,
            name: classData.name,
            description: classData.description,
            image_path: classData.image_path,
            image_path_relative: classData.image_path_relative,
            categoryId: (classData as any).categoryId ?? null,
            category: (classData as any).category ?? null,
            registrationType: classData.registrationType ?? "AUTO",
            approvalStatus: classData.approvalStatus ?? "APPROVED",
            rejectionReason: classData.rejectionReason ?? null,
            approvedById: classData.approvedById ?? null,
            approvedAt: classData.approvedAt ?? null,
            createdAt: classData.createdAt ?? null,
            updatedAt: classData.updatedAt ?? null,
            approver: classData.approver ?? null,
            teachers: classData.teachers,
            students: studentsInClass
        }

        sendResponse({ res, statusCode: 200, message: "Class found", success: true, data })
    } catch (error) {
        console.error("Error fetching class:", error);
        res.status(500).json({
            success: false,
            message: "Internal server error",
            errors: { server: (error as Error).message },
        });
    }
};

export const createClass = async (req: Request, res: Response) => {
    try {
        const { name, description, categoryId, registrationType } = req.body;
        if (!name || !description) {
            return res.status(400).json({
                success: false,
                message: "Invalid input",
                errors: { validation: "Name and description are required" },
            });
        }
        const userId = req.user!.id

        const file = req.file;

        let uploadPath = "files/public/placeholder.png";

        if (file) {
            const type = imageType.THUMBNAIL;

            const optimizedBuffer = await optimizeImage(file.buffer, file.mimetype, type);
            file.buffer = optimizedBuffer;

            uploadPath = await saveFile(file);
        }

        const createdClass = await classService.createClass(
            userId!,
            { name, description, image_path: uploadPath, categoryId: categoryId ?? null, registrationType },
            req.role
        );

        const response: BaseResponse<Partial<ClassDto> & { image_path_relative?: string }> = {
            success: true,
            message: "Class created successfully",
            data: {
                id: createdClass.id,
                name: createdClass.name,
                description: createdClass.description,
                image_path: createdClass.image_path,
                image_path_relative: createdClass.image_path_relative,
                registrationType: createdClass.registrationType,
                approvalStatus: createdClass.approvalStatus,
                rejectionReason: createdClass.rejectionReason,
                approvedById: createdClass.approvedById,
                approvedAt: createdClass.approvedAt,
            },
        };

        res.status(201).json(response);
    } catch (error) {
        console.error("Error creating class:", error);
        res.status(500).json({
            success: false,
            message: "Internal server error",
            errors: { server: (error as Error).message },
        });
    }
};

export const updateClass = async (req: Request, res: Response) => {
    try {
        const classId = parseInt(req.params.id);
        const userId = req.user!.id!;
        const userRole = req.role;
        const { name, description, categoryId, registrationType } = req.body;

        // Check if class exists
        const classData = await classService.getClassById(classId);
        if (!classData) {
            return res.status(404).json({
                success: false,
                message: "Class not found",
            });
        }

        // Admin can bypass, otherwise check if user is teacher of this class
        if (userRole !== 'Admin') {
            const isTeacher = await EnrollmentRepository.isUserTeacher(userId, classId);
            if (!isTeacher) {
                return res.status(403).json({
                    success: false,
                    message: "Access denied. Only teachers of this class can update it.",
                });
            }
        }

        const file = req.file;

        let uploadPath: string | undefined = undefined;
        if (file) {
            const type = imageType.THUMBNAIL;

            const optimizedBuffer = await optimizeImage(file.buffer, file.mimetype, type);
            file.buffer = optimizedBuffer;

            uploadPath = await saveFile(file);
        }

        const updatedClass = await classService.updateClass(classId, { name, description, image_path: uploadPath, categoryId, registrationType });

        if (!updatedClass) {
            return res.status(404).json({
                success: false,
                message: "Class not found",
            });
        }

        const response: BaseResponse<Partial<ClassDto>> = {
            success: true,
            message: "Class updated successfully",
            data: {
                id: updatedClass.id,
                name: updatedClass.name,
                description: updatedClass.description,
                image_path: updatedClass.image_path,
                registrationType: updatedClass.registrationType,
                approvalStatus: updatedClass.approvalStatus,
                rejectionReason: updatedClass.rejectionReason,
                approvedById: updatedClass.approvedById,
                approvedAt: updatedClass.approvedAt,
            },
        };

        res.status(200).json(response);
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Internal server error",
            errors: { server: (error as Error).message },
        });
    }
};

export const deleteClass = async (req: Request, res: Response) => {
    try {
        const classId = parseInt(req.params.id);
        const userId = req.user!.id!;
        const userRole = req.role;

        // Check if class exists
        const classData = await classService.getClassById(classId);
        if (!classData) {
            return res.status(404).json({
                success: false,
                message: "Class not found",
            });
        }

        // Admin can bypass, otherwise check if user is teacher of this class
        if (userRole !== 'Admin') {
            const isTeacher = await EnrollmentRepository.isUserTeacher(userId, classId);
            if (!isTeacher) {
                return res.status(403).json({
                    success: false,
                    message: "Access denied. Only teachers of this class can delete it.",
                });
            }
        }

        const deleted = await classService.deleteClass(classId);

        if (!deleted) {
            return res.status(404).json({
                success: false,
                message: "Class not found",
            });
        }

        res.status(200).json({
            success: true,
            message: "Class deleted successfully",
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Internal server error",
            errors: { server: (error as Error).message },
        });
    }
};

export const getPendingClasses = async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string) || 1;
        const limit = parseInt(req.query.limit as string) || 12;
        const search = (req.query.search as string) || undefined;

        const { classes, totalItems } = await classService.getPendingClasses(page, limit, search);
        const meta = {
            totalItems,
            currentPage: page,
            totalPages: Math.ceil(totalItems / limit),
            itemsPerPage: limit,
        };

        return sendResponse({
            res,
            statusCode: 200,
            success: true,
            message: "Pending classes retrieved successfully",
            data: classes,
            meta,
        });
    } catch (error) {
        return sendResponse({
            res,
            statusCode: 500,
            success: false,
            message: "Failed to retrieve pending classes",
            data: null,
            errors: { server: [(error as Error).message] },
        });
    }
};

export const approveClass = async (req: Request, res: Response) => {
    try {
        const classId = parseInt(req.params.id);
        if (isNaN(classId)) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: "Invalid class ID",
                data: null,
            });
        }

        const adminId = req.user!.id!;
        const approved = await classService.approveClass(adminId, classId);

        if (!approved) {
            return sendResponse({
                res,
                statusCode: 404,
                success: false,
                message: "Class not found",
                data: null,
            });
        }

        return sendResponse({
            res,
            statusCode: 200,
            success: true,
            message: "Kelas berhasil disetujui",
            data: approved,
        });
    } catch (error) {
        return sendResponse({
            res,
            statusCode: 500,
            success: false,
            message: "Failed to approve class",
            data: null,
            errors: { server: [(error as Error).message] },
        });
    }
};

export const rejectClass = async (req: Request, res: Response) => {
    try {
        const classId = parseInt(req.params.id);
        if (isNaN(classId)) {
            return sendResponse({
                res,
                statusCode: 400,
                success: false,
                message: "Invalid class ID",
                data: null,
            });
        }

        const adminId = req.user!.id!;
        const { rejectionReason } = req.body ?? {};
        const rejected = await classService.rejectClass(adminId, classId, rejectionReason);

        if (!rejected) {
            return sendResponse({
                res,
                statusCode: 404,
                success: false,
                message: "Class not found",
                data: null,
            });
        }

        return sendResponse({
            res,
            statusCode: 200,
            success: true,
            message: "Kelas berhasil ditolak",
            data: rejected,
        });
    } catch (error) {
        return sendResponse({
            res,
            statusCode: 500,
            success: false,
            message: "Failed to reject class",
            data: null,
            errors: { server: [(error as Error).message] },
        });
    }
};