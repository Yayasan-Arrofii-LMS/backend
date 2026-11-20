-- 1. Add approval metadata to Workshop (mark existing workshops as APPROVED, default for new rows PENDING_APPROVAL)
ALTER TABLE `Workshop`
    ADD COLUMN `approvalStatus` ENUM('PENDING_APPROVAL', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'APPROVED',
    ADD COLUMN `rejectionReason` TEXT NULL,
    ADD COLUMN `approvedById` VARCHAR(191) NULL,
    ADD COLUMN `approvedAt` DATETIME(3) NULL;

ALTER TABLE `Workshop`
    MODIFY COLUMN `approvalStatus` ENUM('PENDING_APPROVAL', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING_APPROVAL';

-- 2. Safely convert existing WorkshopParticipant string statuses before altering column to ENUM
UPDATE `WorkshopParticipant` SET `status` = 'APPROVED' WHERE `status` IN ('Terdaftar', 'APPROVED');
UPDATE `WorkshopParticipant` SET `status` = 'CANCELLED' WHERE `status` IN ('Dibatalkan', 'CANCELLED');
UPDATE `WorkshopParticipant` SET `status` = 'PENDING_APPROVAL' WHERE `status` NOT IN ('PENDING_APPROVAL', 'APPROVED', 'REJECTED', 'CANCELLED');

ALTER TABLE `WorkshopParticipant`
    MODIFY COLUMN `status` ENUM('PENDING_APPROVAL', 'APPROVED', 'REJECTED', 'CANCELLED') NOT NULL DEFAULT 'PENDING_APPROVAL',
    ADD COLUMN `rejectionReason` TEXT NULL,
    ADD COLUMN `approvedById` VARCHAR(191) NULL,
    ADD COLUMN `approvedAt` DATETIME(3) NULL;

-- 3. Add foreign keys
ALTER TABLE `Workshop` ADD CONSTRAINT `Workshop_approvedById_fkey` FOREIGN KEY (`approvedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `WorkshopParticipant` ADD CONSTRAINT `WorkshopParticipant_approvedById_fkey` FOREIGN KEY (`approvedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
