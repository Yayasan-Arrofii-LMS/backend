import { PrismaClient, Material_File } from "@prisma/client";
import prisma from "../../../database";
import { generateFileToken } from "../helpers/fileToken";

type MaterialFileWithUrl = Material_File & { url: string };

export class MaterialFileRepository {
    private transformWithToken(materialFile: Material_File): MaterialFileWithUrl {
        const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "");
        const token = generateFileToken(materialFile.path, 60);
        return {
            ...materialFile,
            url: `${appUrl}/files/protected/${token}`
        };
    }

    async findAll(): Promise<MaterialFileWithUrl[]> {
        const files = await prisma.material_File.findMany();
        return files.map(file => this.transformWithToken(file));
    }

    async findAllByMaterialId(materialId: number): Promise<MaterialFileWithUrl[]> {
        const files = await prisma.material_File.findMany({
            where: { materialId },
        });
        return files.map(file => this.transformWithToken(file));
    }

    async findById(id: number): Promise<MaterialFileWithUrl | null> {
        const file = await prisma.material_File.findUnique({
            where: { id },
        });
        return file ? this.transformWithToken(file) : null;
    }

    async create(data: { title: string; path: string; materialId: number }): Promise<MaterialFileWithUrl> {
        const file = await prisma.material_File.create({
            data,
        });
        return this.transformWithToken(file);
    }

    async update(id: number, data: Partial<{ title: string; path: string }>): Promise<MaterialFileWithUrl | null> {
        const file = await prisma.material_File.update({
            where: { id },
            data,
        });
        return this.transformWithToken(file);
    }

    async delete(id: number): Promise<Material_File | null> {
        return await prisma.material_File.delete({
            where: { id },
        });
    }
}

export default new MaterialFileRepository();