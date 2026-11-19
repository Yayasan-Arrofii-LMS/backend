-- Expand enum to allow safe data migration without data loss
ALTER TABLE `class` MODIFY COLUMN `registrationType` ENUM('OPEN', 'APPROVAL', 'AUTO', 'MANUAL') NOT NULL DEFAULT 'AUTO';

-- Migrate existing values to AUTO / MANUAL
UPDATE `class` SET `registrationType` = 'AUTO' WHERE `registrationType` = 'OPEN';
UPDATE `class` SET `registrationType` = 'MANUAL' WHERE `registrationType` = 'APPROVAL';

-- Shrink enum to final AUTO / MANUAL values
ALTER TABLE `class` MODIFY COLUMN `registrationType` ENUM('AUTO', 'MANUAL') NOT NULL DEFAULT 'AUTO';
