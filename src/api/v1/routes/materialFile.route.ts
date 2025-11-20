import { Router } from "express";
import materialFileController from "../controllers/materialFile.controller";
import { validateBody } from "../middlewares/schema.middleware";
import { createMaterialFileSchema, updateMaterialFileSchema } from "../schemas/materialFile.schema";
import upload from "../../../config/multer.config";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyEnrollmentBySection } from "../middlewares/enrollment.middleware";

const materialFileRouter = Router({ mergeParams: true });

materialFileRouter.get("/", authMiddleware, verifyEnrollmentBySection, materialFileController.getAllMaterialFiles);
materialFileRouter.post("/", authMiddleware, verifyEnrollmentBySection, upload.single("file"), validateBody(createMaterialFileSchema), materialFileController.createMaterialFile);
materialFileRouter.patch("/:fileID", authMiddleware, verifyEnrollmentBySection, upload.single("file"), validateBody(updateMaterialFileSchema), materialFileController.updateMaterialFile);

materialFileRouter.delete("/:fileID", authMiddleware, verifyEnrollmentBySection, materialFileController.deleteMaterialFile);

export default materialFileRouter;