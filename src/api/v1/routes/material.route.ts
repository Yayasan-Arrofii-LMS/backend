import { Router } from "express";
import { validateBody } from "../middlewares/schema.middleware";
import { createMaterialSchema, updateMaterialSchema } from "../schemas/material.schema";
import { MaterialController } from "../controllers/material.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyEnrollmentBySection } from "../middlewares/enrollment.middleware";

const materialRouter = Router({ mergeParams: true });
const materialController = new MaterialController();

materialRouter.get("/", authMiddleware, verifyEnrollmentBySection, (req, res) => materialController.getAllMaterials(req, res));
materialRouter.post("/", authMiddleware, verifyEnrollmentBySection, validateBody(createMaterialSchema), (req, res) => materialController.createMaterial(req, res));
materialRouter.patch("/:materialId", authMiddleware, verifyEnrollmentBySection, validateBody(updateMaterialSchema), (req, res) => materialController.updateMaterial(req, res));
materialRouter.delete("/:materialId", authMiddleware, verifyEnrollmentBySection, (req, res) => materialController.deleteMaterial(req, res));

export default materialRouter;