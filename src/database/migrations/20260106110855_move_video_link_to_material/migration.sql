/*
  Warnings:

  - You are about to drop the column `video_link` on the `Section` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `Material` ADD COLUMN `video_link` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `Section` DROP COLUMN `video_link`;
