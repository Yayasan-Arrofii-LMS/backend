import { z } from 'zod';

export const ALLOWED_MEDIA_TYPES = [
    'Video',
    'Text',
    'Teks',
    'Artikel',
    'Gambar',
    'Pdf',
    'Kuis',
    'Modul Praktik',
    'Materi Interaktif',
] as const;

export const updateMaterialMetadataSchema = z.object({
    categoryId: z.number().int().positive('Category ID must be a positive integer').nullable().optional(),
    difficulty: z.enum(['Easy', 'Medium', 'Hard']).nullable().optional(),
    mediaType: z.enum(ALLOWED_MEDIA_TYPES).nullable().optional(),
    duration_minutes: z.number().int().min(1, 'Duration must be at least 1 minute').max(600, 'Duration cannot exceed 600 minutes').nullable().optional(),
});

export type UpdateMaterialMetadataDto = z.infer<typeof updateMaterialMetadataSchema>;
