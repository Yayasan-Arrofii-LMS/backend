-- AlterTable
ALTER TABLE `attemp_answer` ADD COLUMN `feedback` LONGTEXT NULL,
    ADD COLUMN `graded_at` DATETIME(3) NULL,
    ADD COLUMN `score` DOUBLE NULL,
    MODIFY `answer` LONGTEXT NULL;

-- AlterTable
ALTER TABLE `quiz_attempt` ADD COLUMN `grading_status` ENUM('AUTO_GRADED', 'WAITING_FOR_TEACHER', 'GRADED') NOT NULL DEFAULT 'AUTO_GRADED',
    ADD COLUMN `mcq_score` DOUBLE NULL;

-- AlterTable
ALTER TABLE `quiz_question` ADD COLUMN `instructions` LONGTEXT NULL,
    ADD COLUMN `rubric` LONGTEXT NULL;
