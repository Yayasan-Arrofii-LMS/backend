import { Router } from "express";
import materialImageController from "../controllers/materialImage.controller";
import { validateBody } from "../middlewares/schema.middleware";
import { 
    createMaterialImageSchema, 
    updateMaterialImageSchema,
    markImagesAsUsedSchema,
    syncImageUsageSchema,
    deleteImagesSchema
} from "../schemas/materialImage.schema";
import upload from "../../../config/multer.config";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";

const materialImageRouter = Router();

// Get all images (accessible by enrolled users)
materialImageRouter.get("/", authMiddleware, materialImageController.getAllMaterialImages);

// Get single image
materialImageRouter.get("/:imageID", authMiddleware, materialImageController.getMaterialImageById);

// Create a new image (only Teacher and Admin)
materialImageRouter.post(
    "/",
    authMiddleware,
    verifyRole(["Teacher"]),
    upload.single("image"),
    validateBody(createMaterialImageSchema),
    materialImageController.createMaterialImage
);

// Mark images as used (called when material is saved)
materialImageRouter.post(
    "/mark-used",
    authMiddleware,
    verifyRole(["Teacher"]),
    validateBody(markImagesAsUsedSchema),
    materialImageController.markImagesAsUsed
);

// Sync image usage - mark used images and unmark unused ones
materialImageRouter.post(
    "/sync-usage",
    authMiddleware,
    verifyRole(["Teacher"]),
    validateBody(syncImageUsageSchema),
    materialImageController.syncImageUsage
);

// Cleanup unused images (Admin only, can be run via cron job)
materialImageRouter.delete(
    "/cleanup-unused",
    authMiddleware,
    verifyRole(["Admin"]),
    materialImageController.cleanupUnusedImages
);

// Delete images by urls (Teacher/Admin)
materialImageRouter.delete(
    "/",
    authMiddleware,
    verifyRole(["Teacher"]),
    validateBody(deleteImagesSchema),
    materialImageController.deleteImagesByUrls
);

// Update an image (only Teacher and Admin)
materialImageRouter.patch(
    "/:imageID",
    authMiddleware,
    verifyRole(["Teacher"]),
    upload.single("image"),
    validateBody(updateMaterialImageSchema),
    materialImageController.updateMaterialImage
);

// Delete an image (only Teacher and Admin)
materialImageRouter.delete(
    "/:imageID",
    authMiddleware,
    verifyRole(["Teacher"]),
    materialImageController.deleteMaterialImage
);

export default materialImageRouter;
