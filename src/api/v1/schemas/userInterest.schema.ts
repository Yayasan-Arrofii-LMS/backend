import { z } from 'zod';

export const updateUserInterestsSchema = z.object({
    categoryIds: z
        .array(z.number().int().positive('Category ID must be a positive integer'))
        .min(1, 'At least one category is required'),
});

export type UpdateUserInterestsDto = z.infer<typeof updateUserInterestsSchema>;
