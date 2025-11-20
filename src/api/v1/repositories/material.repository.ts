import { Material, Material_File } from '@prisma/client';
import prisma from '../../../database';
import { generateFileToken } from '../helpers/fileToken';

type MaterialFileWithUrl = Material_File & { url: string };
type MaterialWithFiles = Material & { Material_File: MaterialFileWithUrl[] };
type MaterialWithSection = Material & {
    Section: { id: number; title: string; description: string | null; order: number; video_link: string | null; classId: number; createdAt: Date; updatedAt: Date };
    Material_File: MaterialFileWithUrl[]
};

export class MaterialRepository {
    private transformMaterialFiles(material: Material & { Material_File: Material_File[] }): MaterialWithFiles {
        const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "") + `:${process.env.PORT || 3001}`;

        return {
            ...material,
            Material_File: material.Material_File.map((file) => ({
                ...file,
                url: `${appUrl}/files/protected/${generateFileToken(file.path, 60)}`
            }))
        };
    }

    private transformMaterialFilesWithSection(material: Material & { Section: any; Material_File: Material_File[] }): MaterialWithSection {
        const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "") + `:${process.env.PORT || 3001}`;

        return {
            ...material,
            Material_File: material.Material_File.map((file) => ({
                ...file,
                url: `${appUrl}/files/protected/${generateFileToken(file.path, 60)}`
            }))
        };
    }

    async findAll(sectionId: number): Promise<MaterialWithFiles[]> {
        const materials = await prisma.material.findMany({
            where: { sectionId },
            include: {
                Material_File: true,
            },
            orderBy: { order: 'asc' },
        });
        return materials.map(material => this.transformMaterialFiles(material));
    }

    async findById(id: number): Promise<MaterialWithSection | null> {
        const material = await prisma.material.findUnique({
            where: { id },
            include: {
                Section: true,
                Material_File: true,
            },
        });
        return material ? this.transformMaterialFilesWithSection(material) : null;
    }

    async create(data: {
        title: string;
        content: string;
        xp: number;
        sectionId: number;
        order: number;
    }): Promise<MaterialWithFiles> {
        const material = await prisma.material.create({
            data,
            include: {
                Material_File: true,
            },
        });
        return this.transformMaterialFiles(material);
    }

    async update(id: number, data: Partial<{
        title: string;
        content: string;
        xp: number;
        sectionId: number;
        order: number;
    }>): Promise<MaterialWithFiles> {
        const material = await prisma.material.update({
            where: { id },
            data,
            include: {
                Material_File: true,
            },
        });
        return this.transformMaterialFiles(material);
    }

    async delete(id: number): Promise<Material> {
        return await prisma.material.delete({
            where: { id },
        });
    }
}

export default new MaterialRepository();