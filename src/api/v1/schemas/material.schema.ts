import { z } from 'zod';

export const createMaterialSchema = z.object({
    title: z.string().min(1, 'Title is required').max(255, 'Title is too long'),
    content: z.string().min(1, 'Content is required'),
    xp: z.number().int().min(0, 'XP must be a positive number').optional(),
    order: z.number().int().min(1, 'Order must be a positive number').optional(),
    categoryId: z.number().int().positive('Category ID must be a positive integer').nullable().optional(),
    video_link: z.string().url('Video link must be a valid URL').optional().nullable(),
    duration_minutes: z.number().int().min(1, 'Duration must be at least 1 minute').max(600, 'Duration cannot exceed 600 minutes').nullable().optional(),
    difficulty: z.enum(['Easy', 'Medium', 'Hard']).nullable().optional(),
    mediaType: z.string().trim().min(1).max(50).nullable().optional(),
});

export const updateMaterialSchema = z.object({
    title: z.string().min(1, 'Title is required').max(255, 'Title is too long').optional(),
    content: z.string().min(1, 'Content is required').optional(),
    xp: z.number().int().min(0, 'XP must be a positive number').optional(),
    order: z.number().int().min(1, 'Order must be a positive number').optional(),
    categoryId: z.number().int().positive('Category ID must be a positive integer').nullable().optional(),
    video_link: z.string().url('Video link must be a valid URL').optional().nullable(),
    duration_minutes: z.number().int().min(1, 'Duration must be at least 1 minute').max(600, 'Duration cannot exceed 600 minutes').nullable().optional(),
    difficulty: z.enum(['Easy', 'Medium', 'Hard']).nullable().optional(),
    mediaType: z.string().trim().min(1).max(50).nullable().optional(),
});

export type CreateMaterialDto = z.infer<typeof createMaterialSchema>;
export type UpdateMaterialDto = z.infer<typeof updateMaterialSchema>;
