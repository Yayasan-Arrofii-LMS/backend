import { Router } from "express";
import { validateBody } from "../middlewares/schema.middleware";
import { updateMaterialMetadataSchema } from "../schemas/materialMetadata.schema";
import materialMetadataController from "../controllers/materialMetadata.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";

const materialMetadataRouter = Router();

// GET /materials — all authenticated users, with optional filters
materialMetadataRouter.get(
    "/",
    authMiddleware,
    (req, res) => materialMetadataController.getMaterialsWithFilter(req, res)
);

// PATCH /materials/:materialId/metadata — Admin/Teacher only
materialMetadataRouter.patch(
    "/:materialId/metadata",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    validateBody(updateMaterialMetadataSchema),
    (req, res) => materialMetadataController.updateMaterialMetadata(req, res)
);

export default materialMetadataRouter;
