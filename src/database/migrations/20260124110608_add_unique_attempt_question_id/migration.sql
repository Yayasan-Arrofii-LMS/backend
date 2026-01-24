/*
  Warnings:

  - A unique constraint covering the columns `[attemptId,questionId]` on the table `Attemp_Answer` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX `Attemp_Answer_attemptId_questionId_key` ON `Attemp_Answer`(`attemptId`, `questionId`);
