import { Router } from "express";
import teacherRouter from "./teacher.route";
import dashboardRouter from "./dashboard.route";
import classRouter from "./class.route";
import authRouter from "./auth.route";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";
import { User } from "@prisma/client";
import materialRouter from "./material.route";
import materialFileRouter from "./materialFile.route";
import materialImageRouter from "./materialImage.route";
import sectionRouter from "./section.route";
import quizRouter from "./quiz.route";
import enrollmentRouter from "./enrollment.route";
import upload from "../../../config/multer.config";
import publicRouter from "./public.route";
import profileRouter from "./profile.route";
import studentRouter from "./student.route";
import categoryRouter from "./category.route";
import userInterestRouter from "./userInterest.route";
import materialActivityRouter from "./materialActivity.route";
import materialMetadataRouter from "./materialMetadata.route";


const router = Router();
upload;
declare module "express-serve-static-core" {
    interface Request {
        user?: Partial<User>;
        token?: string;
        role?: string;
    }
}


router.use("/teachers", authMiddleware, verifyRole(["Admin", "Teacher"]), teacherRouter);
router.use("/dashboard", authMiddleware, verifyRole(["Admin"]), dashboardRouter);
router.use("/classes/sections/:sectionId/quizzes", quizRouter);
router.use("/classes/sections/:sectionId/materials", materialRouter);
router.use("/classes", authMiddleware, verifyRole(["Admin", "Teacher"]), classRouter);
router.use("/classes/sections/materials/:materialId/files", materialFileRouter);
router.use("/material-images", materialImageRouter);
router.use("/enrollment", enrollmentRouter);
router.use("/classes/:classId/sections", sectionRouter);

router.use("/", authRouter)
router.use("/students", authMiddleware, verifyRole(["Student", "Teacher", "Admin"]), studentRouter);
router.use("/public", publicRouter);
router.use("/profile", profileRouter);

// New routes — Fondasi Rekomendasi API
router.use("/categories", categoryRouter);
router.use("/profile/interests", userInterestRouter);
router.use("/profile/activities", materialActivityRouter);
router.use("/materials", materialMetadataRouter);



export default router;
