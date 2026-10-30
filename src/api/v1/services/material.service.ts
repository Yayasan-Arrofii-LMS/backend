import { Material, xp_source } from '@prisma/client';
import prisma from '../../../database';
import materialRepository from '../repositories/material.repository';
import categoryRepository from '../repositories/category.repository';
import materialActivityService from './materialActivity.service';
import { CreateMaterialDto, UpdateMaterialDto } from '../schemas/material.schema';
import { NotFoundError } from '../errors/notfound.error';
import { estimateMaterialDuration } from '../helpers/materialContent.helper';

export interface CompleteMaterialResult {
    materialId: number;
    sectionId: number;
    isCompleted: boolean;
    xpEarned: number;
    sectionProgressPercent: number;
}

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
        let resolvedCategoryId = data.categoryId;
        if (resolvedCategoryId !== undefined && resolvedCategoryId !== null) {
            const cat = await categoryRepository.findById(resolvedCategoryId);
            if (!cat) throw new NotFoundError('Category not found');
        } else {
            const section = await prisma.section.findUnique({
                where: { id: sectionId },
                select: { Class: { select: { categoryId: true } } },
            });
            resolvedCategoryId = section?.Class?.categoryId ?? null;
        }

        // Write-time precomputation untuk estimasi durasi belajar apabila guru tidak mengisi manual
        const durationMinutes =
            data.duration_minutes !== undefined && data.duration_minutes !== null
                ? data.duration_minutes
                : estimateMaterialDuration({
                      content: data.content,
                      mediaType: data.mediaType,
                      videoLink: data.video_link,
                  });

        const lastMaterials = await materialRepository.findAll(sectionId);
        const order = data.order ?? lastMaterials.length + 1;

        return await materialRepository.create({
            ...data,
            categoryId: resolvedCategoryId,
            duration_minutes: durationMinutes,
            order,
            xp: data.xp ?? 10,
            sectionId,
        });
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

        const updatePayload: Record<string, any> = { ...data };

        // Jika konten/media berubah dan guru tidak mengirim duration_minutes manual, hitung ulang precomputation
        if (
            data.duration_minutes === undefined &&
            (data.content !== undefined || data.mediaType !== undefined || data.video_link !== undefined)
        ) {
            updatePayload.duration_minutes = estimateMaterialDuration({
                content: data.content ?? material.content,
                mediaType: data.mediaType !== undefined ? data.mediaType : material.mediaType,
                videoLink: data.video_link !== undefined ? data.video_link : material.video_link,
            });
        }

        return await materialRepository.update(id, updatePayload);
    }

    async deleteMaterial(id: number): Promise<Material> {
        const material = await materialRepository.findById(id);
        if (!material) {
            throw new NotFoundError('Material not found');
        }
        return await materialRepository.delete(id);
    }

    /**
     * Menandai materi selesai dipelajari oleh siswa:
     * 1. Upsert `User_Material` (`is_completed: true`)
     * 2. Berikan XP materi satu kali (idempoten)
     * 3. Catat `MaterialActivity` (`action: 'completed'`)
     * 4. Kembalikan persentase ketuntasan Section terbaru
     */
    async completeMaterial(userId: string, materialId: number): Promise<CompleteMaterialResult> {
        const material = await materialRepository.findById(materialId);
        if (!material) {
            throw new NotFoundError('Material not found');
        }

        let xpEarned = 0;

        await prisma.$transaction(async (tx) => {
            await tx.user_Material.upsert({
                where: {
                    userId_materialId: {
                        userId,
                        materialId,
                    },
                },
                update: { is_completed: true },
                create: {
                    userId,
                    materialId,
                    is_completed: true,
                },
            });

            const existingXp = await tx.xp.findFirst({
                where: {
                    userId,
                    source: xp_source.Material,
                    sourceId: String(materialId),
                },
            });

            if (!existingXp && material.xp > 0) {
                await tx.xp.create({
                    data: {
                        userId,
                        source: xp_source.Material,
                        sourceId: String(materialId),
                        points: material.xp,
                    },
                });
                xpEarned = material.xp;
            }
        });

        // Catat log aktivitas 'completed' (anti-spam 5 menit ditangani di service)
        await materialActivityService.trackActivity(userId, materialId, 'completed');

        // Hitung persentase ketuntasan Section terbaru (gabungan User_Material & MaterialActivity)
        const sectionMaterials = await prisma.material.findMany({
            where: { sectionId: material.sectionId },
            select: { id: true },
        });
        const sectionMaterialIds = sectionMaterials.map((m) => m.id);

        const [completedUserMats, completedActivities] = await Promise.all([
            prisma.user_Material.findMany({
                where: {
                    userId,
                    is_completed: true,
                    materialId: { in: sectionMaterialIds },
                },
                select: { materialId: true },
            }),
            prisma.materialActivity.findMany({
                where: {
                    userId,
                    action: 'completed',
                    materialId: { in: sectionMaterialIds },
                },
                select: { materialId: true },
            }),
        ]);

        const completedSet = new Set<number>([
            ...completedUserMats.map((m) => m.materialId),
            ...completedActivities.map((a) => a.materialId),
        ]);

        const sectionProgressPercent =
            sectionMaterialIds.length > 0
                ? Math.round((completedSet.size / sectionMaterialIds.length) * 100)
                : 100;

        return {
            materialId,
            sectionId: material.sectionId,
            isCompleted: true,
            xpEarned,
            sectionProgressPercent,
        };
    }
}

export default new MaterialService();
