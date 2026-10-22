-- AlterTable
ALTER TABLE `attemp_answer` ADD COLUMN `ability_after` DOUBLE NULL,
    ADD COLUMN `ability_before` DOUBLE NULL,
    ADD COLUMN `answered_at` DATETIME(3) NULL,
    ADD COLUMN `is_correct` BOOLEAN NULL,
    ADD COLUMN `order` INTEGER NULL,
    ADD COLUMN `served_at` DATETIME(3) NULL;

-- AlterTable
ALTER TABLE `quiz` ADD COLUMN `show_review` BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE `quiz_attempt` ADD COLUMN `ability_estimate` DOUBLE NULL;

-- AlterTable
ALTER TABLE `quiz_question` ADD COLUMN `difficulty` ENUM('Easy', 'Medium', 'Hard') NOT NULL DEFAULT 'Medium',
    ADD COLUMN `difficulty_rating` DOUBLE NOT NULL DEFAULT 0,
    ADD COLUMN `times_answered` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `times_correct` INTEGER NOT NULL DEFAULT 0,
    MODIFY `points` INTEGER NOT NULL DEFAULT 1;
