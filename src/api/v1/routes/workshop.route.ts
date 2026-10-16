import { Router } from "express";
import {
    getWorkshops,
    getWorkshopById,
    createWorkshop,
    updateWorkshop,
    deleteWorkshop,
    registerWorkshop,
    cancelWorkshopRegistration,
    getWorkshopParticipants,
} from "../controllers/workshop.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";
import { validateBody } from "../middlewares/schema.middleware";
import { createWorkshopSchema, updateWorkshopSchema } from "../schemas/workshop.schema";
import upload from "../../../config/multer.config";

const workshopRouter = Router();

const workshopUpload = [
    upload.fields([
        { name: "file", maxCount: 1 },
        { name: "thumbnail", maxCount: 1 },
    ]),
    (req: any, _res: any, next: any) => {
        if (!req.file && req.files) {
            req.file = req.files.file?.[0] || req.files.thumbnail?.[0];
        }
        next();
    },
];

workshopRouter.get("/", getWorkshops);
workshopRouter.get("/:id", getWorkshopById);

workshopRouter.post(
    "/",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    workshopUpload,
    validateBody(createWorkshopSchema),
    createWorkshop
);

workshopRouter.put(
    "/:id",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    workshopUpload,
    validateBody(updateWorkshopSchema),
    updateWorkshop
);

workshopRouter.patch(
    "/:id",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    workshopUpload,
    validateBody(updateWorkshopSchema),
    updateWorkshop
);

workshopRouter.delete("/:id", authMiddleware, verifyRole(["Admin", "Teacher"]), deleteWorkshop);

workshopRouter.post("/:id/register", authMiddleware, registerWorkshop);
workshopRouter.delete("/:id/register", authMiddleware, cancelWorkshopRegistration);
workshopRouter.get("/:id/participants", authMiddleware, verifyRole(["Admin", "Teacher"]), getWorkshopParticipants);

export default workshopRouter;
