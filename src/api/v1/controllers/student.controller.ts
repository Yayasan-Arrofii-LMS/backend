import { Request, Response } from "express";
import { sendResponse } from "../helpers/baseResponse";
import materialService from "../services/material.service";
import studentService from "../services/student.service";
import classService from "../services/class.service";
import sectionService from "../services/section.service";
import { EnrollmentRepository } from "../repositories/enrollment.repository";


class StudentController {

    async getClassById(req: Request, res: Response) {
        const classId = req.params.id;
        const userId = req.user?.id;
        const userRole = req.role;

        const classData = await classService.getClassById(Number(classId));

        if (!classData) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Class not found", data: null });
        }

        // Prevent non-Admin / non-owner-teacher from accessing unapproved classes
        if (classData.approvalStatus !== "APPROVED") {
            const isOwnerTeacher = userId
                ? await EnrollmentRepository.isUserTeacher(userId, Number(classId))
                : false;
            if (userRole !== "Admin" && !isOwnerTeacher) {
                return sendResponse({
                    res,
                    statusCode: 403,
                    success: false,
                    message: "Kelas ini belum disetujui oleh Admin",
                    data: null,
                });
            }
        }

        const sections = await sectionService.getAllSectionsPublic(classId);

        // Check if user is enrolled (and status)
        const enrollment = userId
            ? await studentService.getEnrollmentDetail(userId, Number(classId))
            : null;
        const isEnrolled = enrollment?.status === "APPROVED";
        const enrollmentStatus = enrollment?.status ?? null;

        const data = {
            ...classData,
            sections,
            isEnrolled,
            enrollmentStatus,
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