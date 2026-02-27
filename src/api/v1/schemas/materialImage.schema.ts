import { z } from "zod";

export const materialImageSchema = z.any()
    .refine((file) => !!file, "File harus disertakan.")
    .refine((file) =>
        ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"].includes(file.mimetype), {
        message: "Format file tidak valid. Gunakan gambar (png, jpeg, jpg, gif, webp).",
    })
    .refine((file) => file.size <= 10 * 1024 * 1024, {
        message: "Ukuran gambar maksimal 10MB.",
    });

export const createMaterialImageSchema = z.object({
    title: z.string().min(3, "Judul minimal 3 karakter."),
});

export const updateMaterialImageSchema = z.object({
    title: z.string().min(3, "Judul minimal 3 karakter.").optional(),
});

export const markImagesAsUsedSchema = z.object({
    imageUrls: z.array(z.string()).min(1, "imageUrls harus memiliki minimal 1 URL"),
});

export const syncImageUsageSchema = z.object({
    imageUrls: z.array(z.string()),
});

export const deleteImagesSchema = z.object({
    urls: z.array(z.string()).min(1, "urls harus memiliki minimal 1 URL"),
});

export type CreateMaterialImageDto = z.infer<typeof createMaterialImageSchema>;
export type UpdateMaterialImageDto = z.infer<typeof updateMaterialImageSchema>;
export type MarkImagesAsUsedDto = z.infer<typeof markImagesAsUsedSchema>;
export type SyncImageUsageDto = z.infer<typeof syncImageUsageSchema>;
export type DeleteImagesDto = z.infer<typeof deleteImagesSchema>;
