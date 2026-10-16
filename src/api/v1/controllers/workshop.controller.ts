import { Request, Response } from "express";
import workshopService from "../services/workshop.service";
import { sendResponse } from "../helpers/baseResponse";
import { imageType, optimizeImage } from "../helpers/imageCompress";
import { saveFile } from "../helpers/file";

const resolveUploadedThumbnail = async (req: Request): Promise<string | undefined> => {
    const filesObj = req.files as Record<string, Express.Multer.File[]> | undefined;
    const file = req.file || filesObj?.file?.[0] || filesObj?.thumbnail?.[0];
    if (!file) return undefined;

    file.buffer = await optimizeImage(file.buffer, file.mimetype, imageType.THUMBNAIL);
    return await saveFile(file);
};

const handleError = (res: Response, error: unknown, defaultMessage: string) => {
    const message = (error as Error).message;
    const statusCode = message === "Category not found" ? 404 : 500;
    return sendResponse({
        res,
        statusCode,
        success: false,
        message: statusCode === 404 ? message : defaultMessage,
        data: null,
        errors: { server: [message] },
    });
};

export const getWorkshops = async (req: Request, res: Response) => {
    try {
        const data = await workshopService.getAllWorkshops({
            category: req.query.category as string | undefined,
            type: req.query.type as string | undefined,
            status: req.query.status as string | undefined,
            search: req.query.search as string | undefined,
        });
        return sendResponse({ res, statusCode: 200, success: true, message: "Workshops retrieved successfully", data });
    } catch (error) {
        return handleError(res, error, "Failed to retrieve workshops");
    }
};

export const getWorkshopById = async (req: Request, res: Response) => {
    try {
        const workshop = await workshopService.getWorkshopById(parseInt(req.params.id));
        if (!workshop) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Workshop tidak ditemukan", data: null });
        }
        return sendResponse({ res, statusCode: 200, success: true, message: "Workshop retrieved successfully", data: workshop });
    } catch (error) {
        return handleError(res, error, "Failed to retrieve workshop");
    }
};

export const createWorkshop = async (req: Request, res: Response) => {
    try {
        const uploadedPath = await resolveUploadedThumbnail(req);
        const thumbnail = uploadedPath || req.body.thumbnail || "files/public/placeholder.png";
        const workshop = await workshopService.createWorkshop(req.user!.id!, { ...req.body, thumbnail });
        return sendResponse({ res, statusCode: 201, success: true, message: "Workshop created successfully", data: workshop });
    } catch (error) {
        return handleError(res, error, "Failed to create workshop");
    }
};

export const updateWorkshop = async (req: Request, res: Response) => {
    try {
        const uploadedPath = await resolveUploadedThumbnail(req);
        const updated = await workshopService.updateWorkshop(parseInt(req.params.id), {
            ...req.body,
            ...(uploadedPath ? { thumbnail: uploadedPath } : {}),
        });
        if (!updated) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Workshop tidak ditemukan", data: null });
        }
        return sendResponse({ res, statusCode: 200, success: true, message: "Workshop updated successfully", data: updated });
    } catch (error) {
        return handleError(res, error, "Failed to update workshop");
    }
};

export const deleteWorkshop = async (req: Request, res: Response) => {
    try {
        const deleted = await workshopService.deleteWorkshop(parseInt(req.params.id));
        if (!deleted) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Workshop tidak ditemukan", data: null });
        }
        return sendResponse({ res, statusCode: 200, success: true, message: "Workshop deleted successfully", data: null });
    } catch (error) {
        return handleError(res, error, "Failed to delete workshop");
    }
};

export const registerWorkshop = async (req: Request, res: Response) => {
    try {
        const result = await workshopService.registerParticipant(parseInt(req.params.id), req.user!.id!, req.body?.notes);
        if ("error" in result) {
            return sendResponse({ res, statusCode: result.statusCode, success: false, message: result.error!, data: null });
        }
        return sendResponse({ res, statusCode: 200, success: true, message: "Berhasil mendaftar workshop", data: result.data });
    } catch (error) {
        return handleError(res, error, "Gagal mendaftar workshop");
    }
};

export const cancelWorkshopRegistration = async (req: Request, res: Response) => {
    try {
        const result = await workshopService.cancelRegistration(parseInt(req.params.id), req.user!.id!);
        if ("error" in result) {
            return sendResponse({ res, statusCode: result.statusCode, success: false, message: result.error!, data: null });
        }
        return sendResponse({ res, statusCode: 200, success: true, message: "Pendaftaran workshop berhasil dibatalkan", data: result.data });
    } catch (error) {
        return handleError(res, error, "Gagal membatalkan pendaftaran workshop");
    }
};

export const getWorkshopParticipants = async (req: Request, res: Response) => {
    try {
        const participants = await workshopService.getParticipants(parseInt(req.params.id));
        if (!participants) {
            return sendResponse({ res, statusCode: 404, success: false, message: "Workshop tidak ditemukan", data: null });
        }
        return sendResponse({ res, statusCode: 200, success: true, message: "Workshop participants retrieved successfully", data: participants });
    } catch (error) {
        return handleError(res, error, "Failed to retrieve workshop participants");
    }
};
