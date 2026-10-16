import z from "zod";
import { imageSchema } from "./image.schema";

export const createWorkshopSchema = z
    .object({
        title: z.string().min(1, "Judul workshop wajib diisi"),
        description: z.string().min(1, "Deskripsi workshop wajib diisi"),
        date: z.string().min(1, "Tanggal workshop wajib diisi"),
        startTime: z.string().min(1, "Waktu mulai wajib diisi"),
        endTime: z.string().min(1, "Waktu selesai wajib diisi"),
        type: z.enum(["Online", "Offline"]),
        location: z.string().optional().nullable(),
        meetingLink: z.string().optional().nullable(),
        quota: z.coerce.number().int().min(1, "Kuota minimal 1"),
        status: z.enum(["Upcoming", "Ongoing", "Completed", "Cancelled"]).optional(),
        categoryId: z.coerce.number().int().positive().optional().nullable(),
        category: z.string().optional(),
        thumbnail: z.string().optional(),
        file: imageSchema.optional(),
    })
    .superRefine((data, ctx) => {
        if (data.type === "Offline" && (!data.location || data.location.trim() === "")) {
            ctx.addIssue({
                code: z.ZodIssueCode.custom,
                path: ["location"],
                message: "Lokasi wajib diisi untuk workshop Offline",
            });
        }
        if (data.type === "Online" && (!data.meetingLink || data.meetingLink.trim() === "")) {
            ctx.addIssue({
                code: z.ZodIssueCode.custom,
                path: ["meetingLink"],
                message: "Link meeting wajib diisi untuk workshop Online",
            });
        }
    });

export const updateWorkshopSchema = z.object({
    title: z.string().min(1).optional(),
    description: z.string().min(1).optional(),
    date: z.string().min(1).optional(),
    startTime: z.string().min(1).optional(),
    endTime: z.string().min(1).optional(),
    type: z.enum(["Online", "Offline"]).optional(),
    location: z.string().optional().nullable(),
    meetingLink: z.string().optional().nullable(),
    quota: z.coerce.number().int().min(1, "Kuota minimal 1").optional(),
    status: z.enum(["Upcoming", "Ongoing", "Completed", "Cancelled"]).optional(),
    categoryId: z.coerce.number().int().positive().optional().nullable(),
    category: z.string().optional(),
    thumbnail: z.string().optional(),
    file: imageSchema.optional(),
});
