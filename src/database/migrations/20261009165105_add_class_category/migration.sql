-- AlterTable
ALTER TABLE `class` ADD COLUMN `categoryId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Class` ADD CONSTRAINT `Class_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `Category`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
