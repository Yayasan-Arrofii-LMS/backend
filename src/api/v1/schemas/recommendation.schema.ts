import { z } from 'zod';

export const recommendationReasonEnum = z.enum(['remedial', 'minat', 'progres', 'lanjutan']);

export const recommendationFeedbackEnum = z.enum(['relevant', 'neutral', 'not_relevant']);

export const recommendationQuerySchema = z.object({
    type: recommendationReasonEnum.optional(),
    search: z.string().trim().max(200).optional(),
    limit: z.coerce.number().int().min(1).max(50).default(10),
});

export const recommendationHistoryQuerySchema = z.object({
    type: recommendationReasonEnum.optional(),
    search: z.string().trim().max(200).optional(),
    page: z.coerce.number().int().min(1).default(1),
    limit: z.coerce.number().int().min(1).max(50).default(10),
});

export const submitRecommendationFeedbackSchema = z.object({
    feedback: recommendationFeedbackEnum.nullable(),
});

export type RecommendationQueryDto = z.infer<typeof recommendationQuerySchema>;
export type RecommendationHistoryQueryDto = z.infer<typeof recommendationHistoryQuerySchema>;
export type SubmitRecommendationFeedbackDto = z.infer<typeof submitRecommendationFeedbackSchema>;
