import { Request, Response } from "express";
import { sendResponse } from "../helpers/baseResponse";
import materialImageService from "../services/materialImage.service";
import { CreateMaterialImageDto, UpdateMaterialImageDto } from "../schemas/materialImage.schema";
import { imageType, optimizeImage } from "../helpers/imageCompress";
import { saveFile } from "../helpers/file";

export class MaterialImageController {

    async getAllMaterialImages(req: Request, res: Response) {
        try {
            const materialImages = await materialImageService.getAllMaterialImages();
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Material images retrieved successfully",
                data: materialImages,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to retrieve material images",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async getMaterialImageById(req: Request, res: Response) {
        try {
            const id = parseInt(req.params.imageID);
            const materialImage = await materialImageService.getMaterialImageById(id);
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Material image retrieved successfully",
                data: materialImage,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 404,
                success: false,
                message: "Material image not found",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async createMaterialImage(req: Request, res: Response) {
        try {
            const dto: CreateMaterialImageDto = req.body;

            const file = req.file;
            console.log("Uploaded image:", file);

            if (!file) {
                return res.status(400).json({ error: "No image uploaded" });
            }

            const type = imageType.BANNER;

            const optimizedBuffer = await optimizeImage(file.buffer, file.mimetype, type);
            file.buffer = optimizedBuffer;

            const filePath = await saveFile(file, false);

            const materialImage = await materialImageService.createMaterialImage(dto, filePath);

            sendResponse({
                res,
                statusCode: 201,
                success: true,
                message: "Material image created successfully",
                data: materialImage,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to create material image",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async updateMaterialImage(req: Request, res: Response) {
        try {
            const id = parseInt(req.params.imageID);
            const dto: UpdateMaterialImageDto = req.body;

            const file = req.file;
            let filePath: string | undefined;

            if (file) {
                const type = imageType.BANNER;
                const optimizedBuffer = await optimizeImage(file.buffer, file.mimetype, type);
                file.buffer = optimizedBuffer;
                filePath = await saveFile(file, false);
            }

            const materialImage = await materialImageService.updateMaterialImage(id, dto, filePath);

            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Material image updated successfully",
                data: materialImage,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to update material image",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async deleteMaterialImage(req: Request, res: Response) {
        try {
            const id = parseInt(req.params.imageID);
            await materialImageService.deleteMaterialImage(id);
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Material image deleted successfully",
                data: null,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to delete material image",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async deleteImagesByUrls(req: Request, res: Response) {
        try {
            const { urls } = req.body;

            if (!Array.isArray(urls)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: "urls must be an array",
                    data: null,
                });
            }

            const result = await materialImageService.deleteImagesByUrls(urls);
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Images deleted successfully",
                data: result,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to delete images",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async markImagesAsUsed(req: Request, res: Response) {
        try {
            const { imageUrls } = req.body;

            if (!Array.isArray(imageUrls)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: "imageUrls must be an array",
                    data: null,
                });
            }

            const result = await materialImageService.markImagesAsUsed(imageUrls);
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Images marked as used",
                data: result,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to mark images as used",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async syncImageUsage(req: Request, res: Response) {
        try {
            const { imageUrls } = req.body;

            if (!Array.isArray(imageUrls)) {
                return sendResponse({
                    res,
                    statusCode: 400,
                    success: false,
                    message: "imageUrls must be an array",
                    data: null,
                });
            }

            const result = await materialImageService.syncImageUsage(imageUrls);
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Image usage synced successfully",
                data: result,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to sync image usage",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }

    async cleanupUnusedImages(req: Request, res: Response) {
        try {
            const olderThanDays = parseInt(req.query.days as string) || 7;
            const result = await materialImageService.cleanupUnusedImages(olderThanDays);
            sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: "Unused images cleaned up successfully",
                data: result,
            });
        } catch (error: any) {
            sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: "Failed to cleanup unused images",
                data: null,
                errors: { general: [error.message] },
            });
        }
    }
}

export default new MaterialImageController();
