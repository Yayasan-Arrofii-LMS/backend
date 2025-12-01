import { Router } from "express";
import materialFileController from "../controllers/materialFile.controller";
import { validateBody } from "../middlewares/schema.middleware";
import { createMaterialFileSchema, updateMaterialFileSchema } from "../schemas/materialFile.schema";
import upload from "../../../config/multer.config";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyEnrollmentByMaterialFile } from "../middlewares/enrollment.middleware";

const materialFileRouter = Router({ mergeParams: true });

materialFileRouter.get("/", authMiddleware, verifyEnrollmentByMaterialFile, materialFileController.getAllMaterialFiles);
materialFileRouter.post("/", authMiddleware, verifyEnrollmentByMaterialFile, upload.single("file"), validateBody(createMaterialFileSchema), materialFileController.createMaterialFile);
materialFileRouter.patch("/:fileID", authMiddleware, verifyEnrollmentByMaterialFile, upload.single("file"), validateBody(updateMaterialFileSchema), materialFileController.updateMaterialFile);

materialFileRouter.delete("/:fileID", authMiddleware, verifyEnrollmentByMaterialFile, materialFileController.deleteMaterialFile);

export default materialFileRouter;