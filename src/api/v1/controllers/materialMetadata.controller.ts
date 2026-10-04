import { Request, Response } from 'express';
import { sendResponse } from '../helpers/baseResponse';
import { NotFoundError } from '../errors/notfound.error';
import materialMetadataService from '../services/materialMetadata.service';

export class MaterialMetadataController {
    async updateMaterialMetadata(req: Request, res: Response) {
        try {
            const materialId = parseInt(req.params.materialId);
            const material = await materialMetadataService.updateMetadata(materialId, req.body);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Material metadata updated successfully',
                data: material,
            });
        } catch (error) {
            const statusCode = error instanceof NotFoundError ? 404 : 500;
            return sendResponse({
                res,
                statusCode,
                success: false,
                message: error instanceof NotFoundError ? error.message : 'Failed to update material metadata',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }

    async getMaterialsWithFilter(req: Request, res: Response) {
        try {
            const filters = {
                categoryId: req.query.category ? parseInt(req.query.category as string) : undefined,
                difficulty: req.query.difficulty as string | undefined,
                mediaType: req.query.mediaType as string | undefined,
                search: req.query.search as string | undefined,
            };
            const page = parseInt(req.query.page as string) || 1;
            const limit = parseInt(req.query.limit as string) || 20;

            const result = await materialMetadataService.getMaterialsWithFilter(filters, page, limit);
            return sendResponse({
                res,
                statusCode: 200,
                success: true,
                message: 'Materials retrieved successfully',
                data: result.materials,
                meta: result.meta,
            });
        } catch (error) {
            return sendResponse({
                res,
                statusCode: 500,
                success: false,
                message: 'Failed to retrieve materials',
                data: null,
                errors: { global: [(error as Error).message] },
            });
        }
    }
}

export default new MaterialMetadataController();
