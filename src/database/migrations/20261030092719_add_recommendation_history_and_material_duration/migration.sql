-- AlterTable
ALTER TABLE `material` ADD COLUMN `duration_minutes` INTEGER NULL;

-- CreateTable
CREATE TABLE `Recommendation_History` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` VARCHAR(191) NOT NULL,
    `materialId` INTEGER NOT NULL,
    `primary_reason` VARCHAR(191) NOT NULL,
    `reasons` JSON NOT NULL,
    `reason_text` TEXT NOT NULL,
    `score` INTEGER NOT NULL DEFAULT 0,
    `feedback` ENUM('relevant', 'neutral', 'not_relevant') NULL,
    `feedback_at` DATETIME(3) NULL,
    `first_recommended_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `last_recommended_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `Recommendation_History_userId_last_recommended_at_idx`(`userId`, `last_recommended_at`),
    INDEX `Recommendation_History_userId_primary_reason_idx`(`userId`, `primary_reason`),
    UNIQUE INDEX `Recommendation_History_userId_materialId_key`(`userId`, `materialId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Recommendation_History` ADD CONSTRAINT `Recommendation_History_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Recommendation_History` ADD CONSTRAINT `Recommendation_History_materialId_fkey` FOREIGN KEY (`materialId`) REFERENCES `Material`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
