import { Request, Response } from "express";
import { sendResponse } from "../helpers/baseResponse";
import materialService from "../services/material.service";
import studentService from "../services/student.service";
import classService from "../services/class.service";
import sectionService from "../services/section.service";


class StudentController {

    async getClassById(req: Request, res: Response) {
        const classId = req.params.id;
        const userId = req.user?.id;

        const classData = await classService.getClassById(Number(classId));

        if (!classData) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Class not found", data: null });
        }

        const sections = await sectionService.getAllSectionsPublic(classId);

        // Check if user is enrolled
        const isEnrolled = userId
            ? await studentService.checkEnrollment(userId, Number(classId))
            : false;

        const data = {
            ...classData,
            sections,
            isEnrolled
        };

        sendResponse({ res, statusCode: 200, success: true, data, message: "Class retrieved successfully" });
    }

    async getMaterialsBySection(req: Request, res: Response) {
        try {
            const sectionId = parseInt(req.params.sectionId);
            if (isNaN(sectionId)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: "Invalid section ID",
                    data: null,
                });
            }

            const materials = await materialService.getAllMaterials(sectionId);

            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Materials retrieved successfully",
                data: materials,
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

export default new StudentController();