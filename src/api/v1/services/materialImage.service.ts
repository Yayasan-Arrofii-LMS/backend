import { Material_Image } from "@prisma/client";
import fs from "fs/promises";
import path from "path";
import materialImageRepository from "../repositories/materialImage.repository";
import { CreateMaterialImageDto, UpdateMaterialImageDto } from "../schemas/materialImage.schema";
import { deleteFile } from "../helpers/file";

export class MaterialImageService {
    async getAllMaterialImages(): Promise<Omit<Material_Image, 'path'>[]> {
        const images = await materialImageRepository.findAll();
        return images.map(({ path, ...rest }) => rest);
    }

    async getMaterialImageById(id: number): Promise<Material_Image | null> {
        const materialImage = await materialImageRepository.findById(id);
        if (!materialImage) {
            throw new Error(`Material image with ID ${id} not found`);
        }
        return materialImage;
    }

    async createMaterialImage(dto: CreateMaterialImageDto, filePath: string): Promise<Material_Image | null> {
        return await materialImageRepository.create({
            title: dto.title,
            path: filePath,
        });
    }

    async updateMaterialImage(id: number, dto: UpdateMaterialImageDto, filePath?: string): Promise<Material_Image | null> {
        const materialImage = await materialImageRepository.findById(id);
        if (!materialImage) {
            throw new Error(`Material image with ID ${id} not found`);
        }

        if (filePath && materialImage.path) {
            try {
                deleteFile(materialImage.path);
            } catch (error) {
                console.warn(`Failed to delete old image: ${materialImage.path}`, error);
            }
        }

        return await materialImageRepository.update(id, {
            title: dto.title || materialImage.title,
            path: filePath || materialImage.path,
        });
    }

    async deleteMaterialImage(id: number): Promise<void> {
        const materialImage = await materialImageRepository.findById(id);
        if (!materialImage) {
            throw new Error(`Material image with ID ${id} not found`);
        }

        try {
            await fs.unlink(path.join(process.cwd(), materialImage.path));
        } catch (error) {
            console.warn(`Failed to delete image: ${materialImage.path}`, error);
        }

        await materialImageRepository.delete(id);
    }

    async deleteImagesByUrls(urls: string[]): Promise<{ deleted: number; notFound: number; images: string[] }> {
        const allImages = await materialImageRepository.findAll();
        const deletedPaths: string[] = [];
        let deletedCount = 0;
        let notFound = 0;

        for (const url of urls) {
            const filename = url.split("/").pop();
            if (!filename) {
                notFound += 1;
                continue;
            }

            const image = allImages.find(img => img.path.includes(filename));
            if (!image) {
                notFound += 1;
                continue;
            }

            try {
                await fs.unlink(path.join(process.cwd(), image.path));
            } catch (error) {
                console.warn(`Failed to delete image file: ${image.path}`, error);
            }

            await materialImageRepository.delete(image.id);
            deletedPaths.push(image.path);
            deletedCount += 1;
        }

        return {
            deleted: deletedCount,
            notFound,
            images: deletedPaths,
        };
    }

    async markImagesAsUsed(imageUrls: string[]): Promise<{ marked: number; notFound: number }> {
        // Extract image IDs from URLs or paths
        const imageIds: number[] = [];
        
        for (const url of imageUrls) {
            // Extract filename from URL
            const filename = url.split('/').pop();
            if (filename) {
                // Find image by path pattern
                const images = await materialImageRepository.findAll();
                const foundImage = images.find(img => img.path.includes(filename));
                if (foundImage) {
                    imageIds.push(foundImage.id);
                }
            }
        }

        const marked = await materialImageRepository.markAsUsed(imageIds);
        return {
            marked,
            notFound: imageUrls.length - marked
        };
    }

    async syncImageUsage(usedImageUrls: string[]): Promise<{ updated: number }> {
        // Get all current images
        const allImages = await materialImageRepository.findAll();
        const allImageIds = allImages.map(img => img.id);
        
        // Extract IDs from used URLs
        const usedIds: number[] = [];
        for (const url of usedImageUrls) {
            const filename = url.split('/').pop();
            if (filename) {
                const foundImage = allImages.find(img => img.path.includes(filename));
                if (foundImage) {
                    usedIds.push(foundImage.id);
                }
            }
        }

        // Mark used images
        await materialImageRepository.markAsUsed(usedIds);

        // Mark unused images (images not in the used list)
        const unusedIds = allImageIds.filter(id => !usedIds.includes(id));
        if (unusedIds.length > 0) {
            await materialImageRepository.markAsUnused(unusedIds);
        }

        return { updated: usedIds.length };
    }

    async cleanupUnusedImages(olderThanDays: number = 7): Promise<{ deleted: number; images: string[] }> {
        const unusedImages = await materialImageRepository.findUnusedImages(olderThanDays);
        const deletedPaths: string[] = [];

        for (const image of unusedImages) {
            try {
                await fs.unlink(path.join(process.cwd(), image.path));
                await materialImageRepository.delete(image.id);
                deletedPaths.push(image.path);
            } catch (error) {
                console.warn(`Failed to delete unused image: ${image.path}`, error);
            }
        }

        return {
            deleted: deletedPaths.length,
            images: deletedPaths
        };
    }
}

export default new MaterialImageService();
