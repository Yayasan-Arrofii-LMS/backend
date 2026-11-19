import { Router } from "express";
import {
    getClasses,
    getPendingClasses,
    getClassById,
    createClass,
    updateClass,
    deleteClass,
    approveClass,
    rejectClass,
} from "../controllers/class.controller";
import { validateBody } from "../middlewares/schema.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";
import { createClassSchema, updateClassSchema, rejectClassSchema } from "../schemas/class.schema";
import upload from "../../../config/multer.config";

const classRouter = Router();

classRouter.get("/", getClasses);
classRouter.get("/pending", verifyRole(["Admin"]), getPendingClasses);
classRouter.get("/:id", getClassById);
classRouter.post("/", upload.single("file"), validateBody(createClassSchema), createClass);
classRouter.patch("/:id/approve", verifyRole(["Admin"]), approveClass);
classRouter.patch("/:id/reject", verifyRole(["Admin"]), validateBody(rejectClassSchema), rejectClass);
classRouter.patch("/:id", upload.single("file"), validateBody(updateClassSchema), updateClass);
classRouter.delete("/:id", deleteClass);

export default classRouter;