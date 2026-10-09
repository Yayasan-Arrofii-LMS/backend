import { Request, Response } from "express";
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
    createdAt: string;
    updatedAt: string;
}




export const getClasses = async (req: Request, res: Response) => {
    try {
        const page = parseInt(req.query.page as string) || 1;
        const limit = 12;
        const search = (req.query.search as string) || undefined;
        const categoryId = req.query.category ? parseInt(req.query.category as string) || undefined : undefined;
        const userId = req.user!.id!;
        const userRole = req.role!;

        const { classes, totalItems } = await classService.getClasses(userId, userRole, page, limit, search, categoryId);
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
        const { name, description, categoryId } = req.body;
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

        const createdClass = await classService.createClass(userId!, { name, description, image_path: uploadPath, categoryId: categoryId ?? null });

        const response: BaseResponse<Partial<ClassDto> & { image_path_relative?: string }> = {
            success: true,
            message: "Class created successfully",
            data: {
                id: createdClass.id,
                name: createdClass.name,
                description: createdClass.description,
                image_path: createdClass.image_path,
                image_path_relative: createdClass.image_path_relative
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
        const { name, description, categoryId } = req.body;

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

        const updatedClass = await classService.updateClass(classId, { name, description, image_path: uploadPath, categoryId });

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
                image_path: updatedClass.image_path
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