import { Router } from "express";
import { validateBody } from "../middlewares/schema.middleware";
import { createCategorySchema, updateCategorySchema } from "../schemas/category.schema";
import categoryController from "../controllers/category.controller";
import { authMiddleware } from "../middlewares/auth.middleware";
import { verifyRole } from "../middlewares/verifyrole.middleware";

const categoryRouter = Router();

// GET /categories — all authenticated users can view categories
categoryRouter.get("/", authMiddleware, (req, res) => categoryController.getAllCategories(req, res));

// GET /categories/:categoryId — all authenticated users can view a single category
categoryRouter.get("/:categoryId", authMiddleware, (req, res) => categoryController.getCategoryById(req, res));

// POST /categories — Admin/Teacher only
categoryRouter.post(
    "/",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    validateBody(createCategorySchema),
    (req, res) => categoryController.createCategory(req, res)
);

// PATCH /categories/:categoryId — Admin/Teacher only
categoryRouter.patch(
    "/:categoryId",
    authMiddleware,
    verifyRole(["Admin", "Teacher"]),
    validateBody(updateCategorySchema),
    (req, res) => categoryController.updateCategory(req, res)
);

// DELETE /categories/:categoryId — Admin only
categoryRouter.delete(
    "/:categoryId",
    authMiddleware,
    verifyRole(["Admin"]),
    (req, res) => categoryController.deleteCategory(req, res)
);

export default categoryRouter;
