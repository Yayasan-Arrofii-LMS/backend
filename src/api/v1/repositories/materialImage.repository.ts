import { Material_Image } from "@prisma/client";
import prisma from "../../../database";

type MaterialImageWithUrl = Material_Image & { url: string };

export class MaterialImageRepository {
    private transformWithUrl(materialImage: Material_Image): MaterialImageWithUrl {
        const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "");
        return {
            ...materialImage,
            url: `${appUrl}/${materialImage.path}`
        };
    }

    async findAll(): Promise<MaterialImageWithUrl[]> {
        const images = await prisma.material_Image.findMany({
            orderBy: {
                createdAt: 'desc'
            }
        });
        return images.map(image => this.transformWithUrl(image));
    }

    async findById(id: number): Promise<MaterialImageWithUrl | null> {
        const image = await prisma.material_Image.findUnique({
            where: { id },
        });
        return image ? this.transformWithUrl(image) : null;
    }

    async create(data: { title: string; path: string }): Promise<MaterialImageWithUrl> {
        const image = await prisma.material_Image.create({
            data,
        });
        return this.transformWithUrl(image);
    }

    async update(id: number, data: Partial<{ title: string; path: string }>): Promise<MaterialImageWithUrl | null> {
        const image = await prisma.material_Image.update({
            where: { id },
            data,
        });
        return this.transformWithUrl(image);
    }

    async delete(id: number): Promise<Material_Image | null> {
        return await prisma.material_Image.delete({
            where: { id },
        });
    }

    async markAsUsed(imageIds: number[]): Promise<number> {
        const result = await prisma.material_Image.updateMany({
            where: {
                id: { in: imageIds }
            },
            data: {
                is_used: true,
                used_count: {
                    increment: 1
                }
            }
        });
        return result.count;
    }

    async markAsUnused(imageIds: number[]): Promise<number> {
        const result = await prisma.material_Image.updateMany({
            where: {
                id: { in: imageIds }
            },
            data: {
                is_used: false
            }
        });
        return result.count;
    }

    async findUnusedImages(olderThanDays: number = 7): Promise<MaterialImageWithUrl[]> {
        const dateThreshold = new Date();
        dateThreshold.setDate(dateThreshold.getDate() - olderThanDays);

        const images = await prisma.material_Image.findMany({
            where: {
                is_used: false,
                createdAt: {
                    lt: dateThreshold
                }
            }
        });
        return images.map(image => this.transformWithUrl(image));
    }
}

export default new MaterialImageRepository();
