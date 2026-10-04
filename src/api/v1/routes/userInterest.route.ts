import { Router } from "express";
import { validateBody } from "../middlewares/schema.middleware";
import { updateUserInterestsSchema } from "../schemas/userInterest.schema";
import userInterestController from "../controllers/userInterest.controller";
import { authMiddleware } from "../middlewares/auth.middleware";

const userInterestRouter = Router();

// GET /profile/interests — get current user's interests
userInterestRouter.get(
    "/",
    authMiddleware,
    (req, res) => userInterestController.getUserInterests(req, res)
);

// PUT /profile/interests — replace current user's interests
userInterestRouter.put(
    "/",
    authMiddleware,
    validateBody(updateUserInterestsSchema),
    (req, res) => userInterestController.updateUserInterests(req, res)
);

export default userInterestRouter;
