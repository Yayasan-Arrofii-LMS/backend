import { Router } from "express";
import studentController from "../controllers/student.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyEnrollmentBySection, verifyEnrollmentByMaterial } from "../middlewares/enrollment.middleware";
import materialFileController from "../controllers/materialFile.controller";
import materialService from "../services/material.service";

const studentRouter = Router();

studentRouter.get("/classes/:id", authMiddleware, studentController.getClassById);

// Get materials by section
studentRouter.get(
    "/classes/sections/:sectionId/materials",
    authMiddleware,
    verifyEnrollmentBySection,
    studentController.getMaterialsBySection
);

// Get material files by material (also auto-records student progress when opening material detail)
studentRouter.get(
    "/classes/sections/materials/:materialId/files",
    authMiddleware,
    verifyEnrollmentByMaterial,
    async (req, _res, next) => {
        const userId = req.user?.id;
        const materialId = parseInt(req.params.materialId);
        if (userId && !isNaN(materialId)) {
            try {
                await materialService.completeMaterial(userId, materialId);
            } catch (err) {
                console.warn("Auto-complete material skipped:", err);
            }
        }
        next();
    },
    materialFileController.getAllMaterialFiles
);

export default studentRouter;