import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import { NotFoundError } from '../errors/notfound.error';
import categoryService from '../services/category.service';

export class CategoryController {
    async getAllCategories(req: Request, res: Response) {
        try {
            const categories = await categoryService.getAllCategories();
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Categories retrieved successfully',
                data: categories,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve categories',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }

    async getCategoryById(req: Request, res: Response) {
        try {
            const id = parseInt(req.params.categoryId);
            const category = await categoryService.getCategoryById(id);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Category retrieved successfully',
                data: category,
            });
        } catch (error) {
            const statusCode = error instanceof NotFoundError ? 404 : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: error instanceof NotFoundError ? error.message : 'Failed to retrieve category',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }

    async createCategory(req: Request, res: Response) {
        try {
            const category = await categoryService.createCategory(req.body);
            return sendResponse({
                res,
                statusCode: 201,
                success: true,
                message: 'Category created successfully',
                data: category,
            });
        } catch (error) {
            const message = (error as Error).message;
            const statusCode = message.includes('already exists') ? 409 : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: message.includes('already exists') ? message : 'Failed to create category',
                data: null,
                errors: { global: [message] },
            });
        }
    }

    async updateCategory(req: Request, res: Response) {
        try {
            const id = parseInt(req.params.categoryId);
            const category = await categoryService.updateCategory(id, req.body);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Category updated successfully',
                data: category,
            });
        } catch (error) {
            const message = (error as Error).message;
            let statusCode = 500;
            if (error instanceof NotFoundError) statusCode = 404;
            else if (message.includes('already exists')) statusCode = 409;

            return sendResponse({
                res,
                statusCode,
                success: false,
                message: error instanceof NotFoundError || message.includes('already exists')
                    ? message : 'Failed to update category',
                data: null,
                errors: { global: [message] },
            });
        }
    }

    async deleteCategory(req: Request, res: Response) {
        try {
            const id = parseInt(req.params.categoryId);
            await categoryService.deleteCategory(id);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Category deleted successfully',
                data: null,
            });
        } catch (error) {
            const statusCode = error instanceof NotFoundError ? 404 : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: error instanceof NotFoundError ? error.message : 'Failed to delete category',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }
}

export default new CategoryController();
