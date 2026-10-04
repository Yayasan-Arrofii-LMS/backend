import { Router } from "express";
import materialActivityController from "../controllers/materialActivity.controller";
import { authMiddleware } from "../middlewares/auth.middleware";

const materialActivityRouter = Router();

// GET /profile/activities — get current user's learning activities (paginated)
materialActivityRouter.get(
    "/",
    authMiddleware,
    (req, res) => materialActivityController.getUserActivities(req, res)
);

export default materialActivityRouter;
