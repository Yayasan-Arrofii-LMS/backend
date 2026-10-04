import userInterestRepository from '../repositories/userInterest.repository';
import categoryRepository from '../repositories/category.repository';
import { UpdateUserInterestsDto } from '../schemas/userInterest.schema';
import { NotFoundError } from '../errors/notfound.error';

export class UserInterestService {
    async getUserInterests(userId: string) {
        return await userInterestRepository.findByUserId(userId);
    }

    async updateUserInterests(userId: string, data: UpdateUserInterestsDto) {
        // Validate all category IDs exist
        for (const categoryId of data.categoryIds) {
            const category = await categoryRepository.findById(categoryId);
            if (!category) {
                throw new NotFoundError(`Category with ID ${categoryId} not found`);
            }
        }

        // Remove duplicates
        const uniqueCategoryIds = [...new Set(data.categoryIds)];

        return await userInterestRepository.replaceUserInterests(userId, uniqueCategoryIds);
    }
}

export default new UserInterestService();
