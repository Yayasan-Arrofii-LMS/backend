import materialActivityRepository from '../repositories/materialActivity.repository';
import materialRepository from '../repositories/material.repository';
import { NotFoundError } from '../errors/notfound.error';

const ANTI_SPAM_MINUTES = 5;

export class MaterialActivityService {
    async getUserActivities(userId: string, page: number = 1, limit: number = 20) {
        const offset = (page - 1) * limit;
        const [activities, totalItems] = await Promise.all([
            materialActivityRepository.findByUserId(userId, { limit, offset }),
            materialActivityRepository.countByUserId(userId),
        ]);

        return {
            activities,
            meta: {
                totalItems,
                itemsPerPage: limit,
                totalPages: Math.ceil(totalItems / limit),
                currentPage: page,
            },
        };
    }

    /**
     * Track material activity with anti-spam: same action on same material
     * within 5 minutes is ignored.
     */
    async trackActivity(userId: string, materialId: number, action: string) {
        // Verify material exists
        const material = await materialRepository.findById(materialId);
        if (!material) {
            throw new NotFoundError('Material not found');
        }

        // Anti-spam check: don't record same action within 5 minutes
        const lastActivity = await materialActivityRepository.findLastActivity(
            userId,
            materialId,
            action
        );

        if (lastActivity) {
            const diffMs = Date.now() - lastActivity.createdAt.getTime();
            const diffMinutes = diffMs / (1000 * 60);
            if (diffMinutes < ANTI_SPAM_MINUTES) {
                // Silently skip — don't create duplicate activity
                return null;
            }
        }

        return await materialActivityRepository.create({
            userId,
            materialId,
            action,
        });
    }
}

export default new MaterialActivityService();
