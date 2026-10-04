import { Category } from '@prisma/client';
import categoryRepository from '../repositories/category.repository';
import { CreateCategoryDto, UpdateCategoryDto } from '../schemas/category.schema';
import { NotFoundError } from '../errors/notfound.error';

export class CategoryService {
    async getAllCategories(): Promise<Category[]> {
        return await categoryRepository.findAll();
    }

    async getCategoryById(id: number): Promise<Category> {
        const category = await categoryRepository.findById(id);
        if (!category) {
            throw new NotFoundError('Category not found');
        }
        return category;
    }

    async createCategory(data: CreateCategoryDto): Promise<Category> {
        const existing = await categoryRepository.findByName(data.name);
        if (existing) {
            throw new Error('Category with this name already exists');
        }
        return await categoryRepository.create(data);
    }

    async updateCategory(id: number, data: UpdateCategoryDto): Promise<Category> {
        const category = await categoryRepository.findById(id);
        if (!category) {
            throw new NotFoundError('Category not found');
        }

        // Check if another category with the same name exists
        const existing = await categoryRepository.findByName(data.name);
        if (existing && existing.id !== id) {
            throw new Error('Category with this name already exists');
        }

        return await categoryRepository.update(id, data);
    }

    async deleteCategory(id: number): Promise<Category> {
        const category = await categoryRepository.findById(id);
        if (!category) {
            throw new NotFoundError('Category not found');
        }
        return await categoryRepository.delete(id);
    }
}

export default new CategoryService();
