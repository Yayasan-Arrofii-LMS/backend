import { z } from 'zod';

export const updateMaterialMetadataSchema = z.object({
    categoryId: z.number().int().positive('Category ID must be a positive integer').nullable().optional(),
    difficulty: z.enum(['Easy', 'Medium', 'Hard']).nullable().optional(),
    mediaType: z.enum(['Video', 'Teks', 'Gambar', 'Kuis']).nullable().optional(),
});

export type UpdateMaterialMetadataDto = z.infer<typeof updateMaterialMetadataSchema>;
