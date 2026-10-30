import prisma from '../../../database';
import materialRepository from '../repositories/material.repository';
import categoryRepository from '../repositories/category.repository';
import { UpdateMaterialMetadataDto } from '../schemas/materialMetadata.schema';
import { NotFoundError } from '../errors/notfound.error';
import { estimateMaterialDuration } from '../helpers/materialContent.helper';

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

        const updateData: Record<string, any> = {};
        if (data.categoryId !== undefined) updateData.categoryId = data.categoryId;
        if (data.difficulty !== undefined) updateData.difficulty = data.difficulty;
        if (data.mediaType !== undefined) updateData.mediaType = data.mediaType;

        if (data.duration_minutes !== undefined) {
            updateData.duration_minutes =
                data.duration_minutes ??
                estimateMaterialDuration({
                    content: material.content,
                    mediaType: data.mediaType !== undefined ? data.mediaType : material.mediaType,
                    videoLink: material.video_link,
                });
        } else if (data.mediaType !== undefined && material.duration_minutes === null) {
            updateData.duration_minutes = estimateMaterialDuration({
                content: material.content,
                mediaType: data.mediaType,
                videoLink: material.video_link,
            });
        }

        return await prisma.material.update({
            where: { id: materialId },
            data: updateData,
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
