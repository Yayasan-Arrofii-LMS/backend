import { z } from "zod";

// Enroll to class
export const enrollClassSchema = z.object({
    classId: z.number().int().positive("Class ID must be a positive integer"),
});

// Unenroll from class
export const unenrollClassSchema = z.object({
    classId: z.number().int().positive("Class ID must be a positive integer"),
});

// Update applicant status (Teacher/Admin approval)
export const updateApplicantStatusSchema = z.object({
    status: z.enum(["APPROVED", "REJECTED"], {
        message: "Status must be either APPROVED or REJECTED",
    }),
});
