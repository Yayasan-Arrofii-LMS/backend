import { Category } from '@prisma/client';
import prisma from '../../../database';

export class CategoryRepository {
    async findAll(): Promise<Category[]> {
        return await prisma.category.findMany({
            orderBy: { name: 'asc' },
            include: {
                _count: {
                    select: { materials: true, interests: true },
                },
            },
        });
    }

    async findById(id: number): Promise<Category | null> {
        return await prisma.category.findUnique({
            where: { id },
            include: {
                _count: {
                    select: { materials: true, interests: true },
                },
            },
        });
    }

    async findByName(name: string): Promise<Category | null> {
        return await prisma.category.findUnique({
            where: { name },
        });
    }

    async create(data: { name: string }): Promise<Category> {
        return await prisma.category.create({
            data,
            include: {
                _count: {
                    select: { materials: true, interests: true },
                },
            },
        });
    }

    async update(id: number, data: { name: string }): Promise<Category> {
        return await prisma.category.update({
            where: { id },
            data,
            include: {
                _count: {
                    select: { materials: true, interests: true },
                },
            },
        });
    }

    async delete(id: number): Promise<Category> {
        return await prisma.category.delete({
            where: { id },
        });
    }
}

export default new CategoryRepository();
