-- AlterTable
ALTER TABLE `Material_Image` ADD COLUMN `is_used` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `used_count` INTEGER NOT NULL DEFAULT 0;
