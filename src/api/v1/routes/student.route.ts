import { Router } from "express";
import studentController from "../controllers/student.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyEnrollmentBySection } from "../middlewares/enrollment.middleware";
import materialFileController from "../controllers/materialFile.controller";

const studentRouter = Router();

studentRouter.get("/classes/:id", authMiddleware, studentController.getClassById);

// Get materials by section
studentRouter.get(
    "/classes/sections/:sectionId/materials",
    authMiddleware,
    verifyEnrollmentBySection,
    studentController.getMaterialsBySection
);

// Get material files by material
studentRouter.get(
    "/classes/sections/materials/:materialId/files",
    authMiddleware,
    verifyEnrollmentBySection,
    materialFileController.getAllMaterialFiles
);

export default studentRouter;