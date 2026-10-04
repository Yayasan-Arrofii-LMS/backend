import { UserInterest } from '@prisma/client';
import prisma from '../../../database';

type UserInterestWithCategory = UserInterest & {
    category: { id: number; name: string };
};

export class UserInterestRepository {
    async findByUserId(userId: string): Promise<UserInterestWithCategory[]> {
        return await prisma.userInterest.findMany({
            where: { userId },
            include: {
                category: {
                    select: { id: true, name: true },
                },
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    async replaceUserInterests(userId: string, categoryIds: number[]): Promise<UserInterestWithCategory[]> {
        // Use transaction: delete all existing interests, then create new ones
        await prisma.$transaction(async (tx) => {
            await tx.userInterest.deleteMany({
                where: { userId },
            });

            if (categoryIds.length > 0) {
                await tx.userInterest.createMany({
                    data: categoryIds.map((categoryId) => ({
                        userId,
                        categoryId,
                    })),
                });
            }
        });

        // Return the newly created interests
        return this.findByUserId(userId);
    }
}

export default new UserInterestRepository();
