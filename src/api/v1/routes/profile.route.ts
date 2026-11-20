import { Router } from "express";
import profileController from "../controllers/profile.controller";
import { AuthController } from "../controllers/auth.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { validateBody } from "../middlewares/schema.middleware";
import { updateProfileSchema } from "../schemas/profile.schema";
import { changePasswordSchema } from "../schemas/auth.schema";
import multer from "multer";

const profileRouter = Router();
const authController = new AuthController();
const upload = multer({ storage: multer.memoryStorage() });

// Get current user profile (all roles)
profileRouter.get("/", authMiddleware, profileController.getProfile);

// Update current user profile (all roles)
profileRouter.patch(
    "/",
    authMiddleware,
    upload.single("profileImage"),
    validateBody(updateProfileSchema),
    profileController.updateProfile
);

// Change password (RESTful profile endpoints)
profileRouter.post(
    "/change-password",
    authMiddleware,
    validateBody(changePasswordSchema),
    authController.changePassword
);
profileRouter.patch(
    "/change-password",
    authMiddleware,
    validateBody(changePasswordSchema),
    authController.changePassword
);

export default profileRouter;
