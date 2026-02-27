/*
  Warnings:

  - You are about to drop the column `materialId` on the `Material_Image` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `Material_Image` DROP FOREIGN KEY `Material_Image_materialId_fkey`;

-- DropIndex
DROP INDEX `Material_Image_materialId_fkey` ON `Material_Image`;

-- AlterTable
ALTER TABLE `Material_Image` DROP COLUMN `materialId`;
