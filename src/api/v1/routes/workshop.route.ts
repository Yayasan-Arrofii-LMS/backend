import { Router } from "express";
import {
    getWorkshops,
    getWorkshopById,
    createWorkshop,
    updateWorkshop,
    deleteWorkshop,
    approveWorkshop,
    rejectWorkshop,
    registerWorkshop,
    cancelWorkshopRegistration,
    getWorkshopParticipants,
    approveWorkshopParticipant,
    rejectWorkshopParticipant,
} from "../controllers/workshop.controller";
import { authMiddleware, optionalAuthMiddleware } from "../middlewares/auth.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";
import { validateBody } from "../middlewares/schema.middleware";
import {
    createWorkshopSchema,
    updateWorkshopSchema,
    rejectWorkshopSchema,
    rejectParticipantSchema,
} from "../schemas/workshop.schema";
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

workshopRouter.get("/", optionalAuthMiddleware, getWorkshops);
workshopRouter.get("/:id", optionalAuthMiddleware, getWorkshopById);

workshopRouter.post(
    "/",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    workshopUpload,
    validateBody(createWorkshopSchema),
    createWorkshop
);

workshopRouter.patch(
    "/:id/approve",
    authMiddleware,
    verifyRole(["Admin"]),
    approveWorkshop
);

workshopRouter.patch(
    "/:id/reject",
    authMiddleware,
    verifyRole(["Admin"]),
    validateBody(rejectWorkshopSchema),
    rejectWorkshop
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

workshopRouter.patch(
    "/:id/participants/:participantId/approve",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    approveWorkshopParticipant
);

workshopRouter.patch(
    "/:id/participants/:participantId/reject",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    validateBody(rejectParticipantSchema),
    rejectWorkshopParticipant
);

export default workshopRouter;
