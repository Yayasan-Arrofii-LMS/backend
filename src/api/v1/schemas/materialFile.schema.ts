import { z } from "zod";
export const pdfSchema = z.any()
    .refine((file) => !!file, "File harus disertakan.")
    .refine((file) => ["application/pdf"].includes(file.mimetype), {
        message: "Format file tidak valid. Gunakan PDF.",
    })
    .refine((file) => file.size <= 100 * 1024 * 1024, {
        message: "Ukuran file maksimal 100MB.",
    });

export const imageSchema = z.any()
    .refine((file) => !!file, "File harus disertakan.")
    .refine((file) =>
        ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"].includes(file.mimetype), {
        message: "Format file tidak valid. Gunakan gambar (png, jpeg, jpg, gif, webp).",
    })
    .refine((file) => file.size <= 10 * 1024 * 1024, {
        message: "Ukuran gambar maksimal 10MB.",
    });

export const docSchema = z.any()
    .refine((file) => !!file, "File harus disertakan.")
    .refine((file) =>
        [
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "text/plain",
            "application/rtf",
        ].includes(file.mimetype), {
        message: "Format file tidak valid. Gunakan DOC atau DOCX.",
    })
    .refine((file) => file.size <= 20 * 1024 * 1024, {
        message: "Ukuran file maksimal 20MB.",
    });

export const pptSchema = z.any()
    .refine((file) => !!file, "File harus disertakan.")
    .refine((file) =>
        [
            "application/vnd.ms-powerpoint",
            "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        ].includes(file.mimetype), {
        message: "Format file tidak valid. Gunakan PPT atau PPTX.",
    })
    .refine((file) => file.size <= 50 * 1024 * 1024, {
        message: "Ukuran file maksimal 50MB.",
    });

export const createMaterialFileSchema = z.object({
    title: z.string().min(3, "Judul minimal 3 karakter."),
    file: z.union([pdfSchema, imageSchema, docSchema, pptSchema]),
});

export const updateMaterialFileSchema = createMaterialFileSchema.partial();
export type CreateMaterialFileDto = z.infer<typeof createMaterialFileSchema>;
export type UpdateMaterialFileDto = z.infer<typeof updateMaterialFileSchema>;