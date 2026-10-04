import { Material } from '@prisma/client';
import prisma from '../../../database';
import materialRepository from '../repositories/material.repository';
import categoryRepository from '../repositories/category.repository';
import { UpdateMaterialMetadataDto } from '../schemas/materialMetadata.schema';
import { NotFoundError } from '../errors/notfound.error';

type MaterialFilters = {
    categoryId?: number;
    difficulty?: string;
    mediaType?: string;
    search?: string;
};

export class MaterialMetadataService {
    async updateMetadata(materialId: number, data: UpdateMaterialMetadataDto) {
        const material = await materialRepository.findById(materialId);
        if (!material) {
            throw new NotFoundError('Material not found');
        }

        // Validate categoryId if provided
        if (data.categoryId !== undefined && data.categoryId !== null) {
            const category = await categoryRepository.findById(data.categoryId);
            if (!category) {
                throw new NotFoundError('Category not found');
            }
        }

        return await prisma.material.update({
            where: { id: materialId },
            data: {
                categoryId: data.categoryId,
                difficulty: data.difficulty,
                mediaType: data.mediaType,
            },
            include: {
                category: true,
                Section: true,
                Material_File: true,
            },
        });
    }

    async getMaterialsWithFilter(filters: MaterialFilters, page: number = 1, limit: number = 20) {
        const where: any = {};

        if (filters.categoryId) {
            where.categoryId = filters.categoryId;
        }
        if (filters.difficulty) {
            where.difficulty = filters.difficulty;
        }
        if (filters.mediaType) {
            where.mediaType = filters.mediaType;
        }
        if (filters.search) {
            where.title = {
                contains: filters.search,
            };
        }

        const offset = (page - 1) * limit;

        const [materials, totalItems] = await Promise.all([
            prisma.material.findMany({
                where,
                include: {
                    category: true,
                    Section: {
                        select: { id: true, title: true, classId: true },
                    },
                },
                orderBy: { createdAt: 'desc' },
                take: limit,
                skip: offset,
            }),
            prisma.material.count({ where }),
        ]);

        return {
            materials,
            meta: {
                totalItems,
                itemsPerPage: limit,
                totalPages: Math.ceil(totalItems / limit),
                currentPage: page,
            },
        };
    }
}

export default new MaterialMetadataService();
