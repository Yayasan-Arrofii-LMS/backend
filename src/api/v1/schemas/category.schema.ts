import { z } from 'zod';

export const createCategorySchema = z.object({
    name: z.string().min(1, 'Category name is required').max(100, 'Category name is too long'),
});

export const updateCategorySchema = z.object({
    name: z.string().min(1, 'Category name is required').max(100, 'Category name is too long'),
});

export type CreateCategoryDto = z.infer<typeof createCategorySchema>;
export type UpdateCategoryDto = z.infer<typeof updateCategorySchema>;
