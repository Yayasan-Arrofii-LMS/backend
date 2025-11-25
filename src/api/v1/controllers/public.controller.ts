import { Request, Response } from "express";
import classService from "../services/class.service";
import { sendResponse } from "../helpers/baseResponse";
import sectionService from "../services/section.service";



class PublicController {
    async getClasses(req: Request, res: Response) {
        const search = req.query.search as string | undefined;
        const page = Number(req.query.page ?? 1);
        const limit = Number(req.query.limit ?? 12);

        const classes = await classService.getAllClasses({ search: search || "", limit, page });
        sendResponse({ res, statusCode: 200, success: true, data: classes, message: "Classes retrieved successfully" });
    }

    async getClassById(req: Request, res: Response) {
        const classId = req.params.id;
        const classData = await classService.getClassById(Number(classId));
        if (!classData) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Class not found", data: null });
        }
        const sections = await sectionService.getAllSectionsPublic(classId);


        const data = { ...classData, sections };

        sendResponse({ res, statusCode: 200, success: true, data, message: "Class retrieved successfully" });
    }

    async getBanners(req: Request, res: Response) {
        sendResponse({ res, statusCode: 200, success: true, data: "Public Banners Endpoint", message: "Banners retrieved successfully" });
    }


    async getSectionById(req: Request, res: Response) {
        const sectionId = req.params.id;


        const section = await sectionService.getSectionById(sectionId);

        sendResponse({ res, statusCode: 200, success: true, data: section, message: "Section retrieved successfully" });
    }
}

export default new PublicController();