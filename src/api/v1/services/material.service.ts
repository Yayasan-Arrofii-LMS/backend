import { Material } from '@prisma/client';
import prisma from '../../../database';
import materialRepository from '../repositories/material.repository';
import categoryRepository from '../repositories/category.repository';
import { CreateMaterialDto, UpdateMaterialDto } from '../schemas/material.schema';
import { NotFoundError } from '../errors/notfound.error';

export class MaterialService {
    async getAllMaterials(sectionId: number): Promise<Material[]> {
        return await materialRepository.findAll(sectionId);
    }

    async getMaterialById(id: number): Promise<Material> {
        const material = await materialRepository.findById(id);
        if (!material) {
            throw new NotFoundError('Material not found');
        }
        return material;
    }

    async createMaterial(data: CreateMaterialDto, sectionId: number): Promise<Material> {
        // ponytail: inherit sekali saat create saja; sinkron ulang saat Class.categoryId berubah ditunda sampai ada kebutuhan (backfill manual via PATCH /materials/:id/metadata).
        if (data.categoryId !== undefined && data.categoryId !== null) {
            const cat = await categoryRepository.findById(data.categoryId);
            if (!cat) throw new NotFoundError('Category not found');
        } else {
            const section = await prisma.section.findUnique({
                where: { id: sectionId },
                select: { Class: { select: { categoryId: true } } },
            });
            const inherited = section?.Class?.categoryId ?? null;
            if (inherited) (data as any).categoryId = inherited;
        }
        const lastMaterials = await materialRepository.findAll(sectionId);
        const order = lastMaterials.length + 1;
        return await materialRepository.create({ ...data, order, xp: 10, sectionId });
    }

    async updateMaterial(id: number, data: UpdateMaterialDto): Promise<Material> {
        const material = await materialRepository.findById(id);

        if (!material) {
            throw new NotFoundError('Material not found');
        }
        if (data.categoryId !== undefined && data.categoryId !== null) {
            const cat = await categoryRepository.findById(data.categoryId);
            if (!cat) throw new NotFoundError('Category not found');
        }

        return await materialRepository.update(id, data);
    }

    async deleteMaterial(id: number): Promise<Material> {
        const material = await materialRepository.findById(id);
        if (!material) {
            throw new NotFoundError('Material not found');
        }
        return await materialRepository.delete(id);
    }
}

export default new MaterialService();