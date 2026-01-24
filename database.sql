/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.1.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: sekolah_alam
-- ------------------------------------------------------
-- Server version	12.1.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `Assignment`
--

DROP TABLE IF EXISTS `Assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` varchar(191) NOT NULL,
  `open_at` datetime(3) NOT NULL,
  `close_at` datetime(3) NOT NULL,
  `xp` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `sectionId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Assignment_sectionId_fkey` (`sectionId`),
  CONSTRAINT `Assignment_sectionId_fkey` FOREIGN KEY (`sectionId`) REFERENCES `Section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Assignment`
--

LOCK TABLES `Assignment` WRITE;
/*!40000 ALTER TABLE `Assignment` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Assignment` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Attemp_Answer`
--

DROP TABLE IF EXISTS `Attemp_Answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Attemp_Answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(191) DEFAULT NULL,
  `answer` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `attemptId` int(11) NOT NULL,
  `questionId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Attemp_Answer_attemptId_questionId_key` (`attemptId`,`questionId`),
  KEY `Attemp_Answer_questionId_fkey` (`questionId`),
  CONSTRAINT `Attemp_Answer_attemptId_fkey` FOREIGN KEY (`attemptId`) REFERENCES `Quiz_Attempt` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Attemp_Answer_questionId_fkey` FOREIGN KEY (`questionId`) REFERENCES `Quiz_Question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Attemp_Answer`
--

LOCK TABLES `Attemp_Answer` WRITE;
/*!40000 ALTER TABLE `Attemp_Answer` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Attemp_Answer` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Attemp_Multiple_Answer`
--

DROP TABLE IF EXISTS `Attemp_Multiple_Answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Attemp_Multiple_Answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `attempt_answerId` int(11) NOT NULL,
  `answerId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Attemp_Multiple_Answer_attempt_answerId_fkey` (`attempt_answerId`),
  KEY `Attemp_Multiple_Answer_answerId_fkey` (`answerId`),
  CONSTRAINT `Attemp_Multiple_Answer_answerId_fkey` FOREIGN KEY (`answerId`) REFERENCES `Quiz_Answer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Attemp_Multiple_Answer_attempt_answerId_fkey` FOREIGN KEY (`attempt_answerId`) REFERENCES `Attemp_Answer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Attemp_Multiple_Answer`
--

LOCK TABLES `Attemp_Multiple_Answer` WRITE;
/*!40000 ALTER TABLE `Attemp_Multiple_Answer` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Attemp_Multiple_Answer` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Class`
--

DROP TABLE IF EXISTS `Class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Class` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `description` longtext NOT NULL,
  `image_path` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Class`
--

LOCK TABLES `Class` WRITE;
/*!40000 ALTER TABLE `Class` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Class` VALUES
(1,'asperiores','eos tenetur asperiores quas doloribus rerum in unde non qui omnis sequi consequatur vitae et voluptate tenetur exercitationem sequi quasi rerum aliquid qui dicta dolores est hic quasi rerum quas','files/public/placeholder.png','2026-01-24 11:06:21.266','2026-01-24 11:06:21.266'),
(2,'vitae','repellat tenetur nostrum aut enim consequatur quaerat eos doloribus ipsum maiores tenetur dolores sit consequuntur doloribus excepturi et necessitatibus est sequi nemo fugit aliquid cupiditate non voluptatibus nulla tenetur sed','files/public/placeholder.png','2026-01-24 11:06:21.267','2026-01-24 11:06:21.267'),
(3,'quasi','fugit reiciendis nostrum labore aliquid dicta beatae commodi nulla ducimus unde omnis nulla exercitationem possimus deserunt sunt exercitationem possimus aut nemo sit voluptate ducimus tenetur omnis possimus est excepturi sunt','files/public/placeholder.png','2026-01-24 11:06:21.268','2026-01-24 11:06:21.268'),
(4,'ducimus','enim nostrum quasi exercitationem quasi nulla possimus sapiente sed error maiores reiciendis fugit ullam neque consequuntur voluptate excepturi maiores consectetur numquam quia quae est consequatur maiores et numquam deserunt non','files/public/placeholder.png','2026-01-24 11:06:21.269','2026-01-24 11:06:21.269'),
(5,'nihil','nihil deserunt asperiores labore beatae excepturi voluptate est voluptatem voluptatibus unde cupiditate quaerat omnis sed excepturi tenetur laborum enim aut voluptatem dolores omnis consequuntur beatae voluptatibus quas ducimus dolores neque','files/public/placeholder.png','2026-01-24 11:06:21.270','2026-01-24 11:06:21.270'),
(6,'aliquid','excepturi quas fugiat rerum et sed quas voluptatem qui qui quia quae nemo dicta commodi dolores ducimus quaerat dolores sapiente unde numquam numquam doloribus sunt at doloribus fugit unde id','files/public/placeholder.png','2026-01-24 11:06:21.271','2026-01-24 11:06:21.271'),
(7,'neque','dolores necessitatibus laborum dolores commodi sed commodi commodi dicta possimus sunt excepturi vitae voluptatem necessitatibus sequi tenetur sunt voluptatibus neque quas dolores id et quaerat aliquid dolores repellat quasi sequi','files/public/placeholder.png','2026-01-24 11:06:21.272','2026-01-24 11:06:21.272'),
(8,'consequatur','laborum omnis numquam dicta deserunt exercitationem blanditiis non est laborum nostrum quos error aliquid voluptate est tenetur commodi possimus qui quae est reiciendis quasi in esse dolores esse necessitatibus maiores','files/public/placeholder.png','2026-01-24 11:06:21.273','2026-01-24 11:06:21.273'),
(9,'quia','eos laborum consequatur fugiat sunt doloribus non repellat qui excepturi consequatur nulla nostrum consequuntur sit hic fugiat voluptate est qui voluptate non eos excepturi et fugit sit doloribus nulla cupiditate','files/public/placeholder.png','2026-01-24 11:06:21.274','2026-01-24 11:06:21.274'),
(10,'omnis','unde hic facilis error ipsum necessitatibus excepturi hic dolores fugiat quasi voluptatem rerum quas consequuntur et magnam omnis unde magnam est maiores est sapiente ducimus ullam exercitationem ipsum commodi rerum','files/public/placeholder.png','2026-01-24 11:06:21.275','2026-01-24 11:06:21.275'),
(11,'PPK','nostrum at aliquid fugit aut aut voluptatem vitae magnam neque et sunt fugit eos aut neque necessitatibus quae dicta maiores dicta occaecati rerum consequuntur nihil qui aliquid esse commodi dicta','files/public/placeholder.png','2026-01-24 11:06:21.398','2026-01-24 11:06:21.398'),
(12,'Pancasila','cupiditate esse fugiat hic ducimus sed laborum maiores doloribus et voluptatibus eos laborum eos reiciendis quos nostrum sit beatae maiores qui consequuntur error ullam nostrum unde esse nulla aut numquam','files/public/placeholder.png','2026-01-24 11:06:21.399','2026-01-24 11:06:21.399'),
(13,'Agama','beatae excepturi fugiat esse beatae quos nihil at error non quia quaerat facilis blanditiis esse sed sequi possimus nostrum est et quas quasi fugit asperiores ducimus consequuntur labore sequi in','files/public/placeholder.png','2026-01-24 11:06:21.400','2026-01-24 11:06:21.400'),
(14,'Bahasa Indonesia','ipsum asperiores unde fugiat rerum aliquid excepturi voluptate enim cupiditate voluptate hic consequuntur exercitationem unde dicta consequatur aliquid non consequatur et voluptatem quas nihil maiores sit tenetur cupiditate quasi aliquid','files/public/placeholder.png','2026-01-24 11:06:21.401','2026-01-24 11:06:21.401');
/*!40000 ALTER TABLE `Class` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `FileToken`
--

DROP TABLE IF EXISTS `FileToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `FileToken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(191) NOT NULL,
  `expireAt` datetime(3) NOT NULL,
  `materialFileId` int(11) NOT NULL,
  `userId` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `FileToken_token_key` (`token`),
  KEY `FileToken_materialFileId_fkey` (`materialFileId`),
  KEY `FileToken_userId_fkey` (`userId`),
  CONSTRAINT `FileToken_materialFileId_fkey` FOREIGN KEY (`materialFileId`) REFERENCES `Material_File` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FileToken_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FileToken`
--

LOCK TABLES `FileToken` WRITE;
/*!40000 ALTER TABLE `FileToken` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `FileToken` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Material`
--

DROP TABLE IF EXISTS `Material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Material` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `content` longtext NOT NULL,
  `xp` int(11) NOT NULL DEFAULT 10,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `video_link` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Material_sectionId_fkey` (`sectionId`),
  CONSTRAINT `Material_sectionId_fkey` FOREIGN KEY (`sectionId`) REFERENCES `Section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Material`
--

LOCK TABLES `Material` WRITE;
/*!40000 ALTER TABLE `Material` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Material` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Material_File`
--

DROP TABLE IF EXISTS `Material_File`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Material_File` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `path` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `materialId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Material_File_materialId_fkey` (`materialId`),
  CONSTRAINT `Material_File_materialId_fkey` FOREIGN KEY (`materialId`) REFERENCES `Material` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Material_File`
--

LOCK TABLES `Material_File` WRITE;
/*!40000 ALTER TABLE `Material_File` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Material_File` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `OTP_Token`
--

DROP TABLE IF EXISTS `OTP_Token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `OTP_Token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(191) NOT NULL,
  `type` enum('PasswordReset','EmailVerification') NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `userId` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `OTP_Token_userId_fkey` (`userId`),
  CONSTRAINT `OTP_Token_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OTP_Token`
--

LOCK TABLES `OTP_Token` WRITE;
/*!40000 ALTER TABLE `OTP_Token` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `OTP_Token` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Quiz`
--

DROP TABLE IF EXISTS `Quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Quiz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` longtext NOT NULL,
  `max_attempts` int(11) NOT NULL,
  `time_limit` int(11) NOT NULL,
  `open_at` datetime(3) NOT NULL,
  `close_at` datetime(3) NOT NULL,
  `passing_grade` int(11) NOT NULL,
  `xp` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `sectionId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Quiz_sectionId_fkey` (`sectionId`),
  CONSTRAINT `Quiz_sectionId_fkey` FOREIGN KEY (`sectionId`) REFERENCES `Section` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Quiz`
--

LOCK TABLES `Quiz` WRITE;
/*!40000 ALTER TABLE `Quiz` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Quiz` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Quiz_Answer`
--

DROP TABLE IF EXISTS `Quiz_Answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Quiz_Answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer` varchar(191) NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `questionId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Quiz_Answer_questionId_fkey` (`questionId`),
  CONSTRAINT `Quiz_Answer_questionId_fkey` FOREIGN KEY (`questionId`) REFERENCES `Quiz_Question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Quiz_Answer`
--

LOCK TABLES `Quiz_Answer` WRITE;
/*!40000 ALTER TABLE `Quiz_Answer` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Quiz_Answer` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Quiz_Attempt`
--

DROP TABLE IF EXISTS `Quiz_Attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Quiz_Attempt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) NOT NULL,
  `quizId` int(11) NOT NULL,
  `is_graded` tinyint(1) NOT NULL DEFAULT 0,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `submitted_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Quiz_Attempt_userId_fkey` (`userId`),
  KEY `Quiz_Attempt_quizId_fkey` (`quizId`),
  CONSTRAINT `Quiz_Attempt_quizId_fkey` FOREIGN KEY (`quizId`) REFERENCES `Quiz` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Quiz_Attempt_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Quiz_Attempt`
--

LOCK TABLES `Quiz_Attempt` WRITE;
/*!40000 ALTER TABLE `Quiz_Attempt` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Quiz_Attempt` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Quiz_Question`
--

DROP TABLE IF EXISTS `Quiz_Question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Quiz_Question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(191) NOT NULL,
  `type` enum('MultipleChoice','TrueFalse','Essay') NOT NULL,
  `points` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `quizId` int(11) NOT NULL,
  `explanation` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Quiz_Question_quizId_fkey` (`quizId`),
  CONSTRAINT `Quiz_Question_quizId_fkey` FOREIGN KEY (`quizId`) REFERENCES `Quiz` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Quiz_Question`
--

LOCK TABLES `Quiz_Question` WRITE;
/*!40000 ALTER TABLE `Quiz_Question` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Quiz_Question` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Reset_Token`
--

DROP TABLE IF EXISTS `Reset_Token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reset_Token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Reset_Token_token_key` (`token`),
  KEY `Reset_Token_userId_fkey` (`userId`),
  CONSTRAINT `Reset_Token_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reset_Token`
--

LOCK TABLES `Reset_Token` WRITE;
/*!40000 ALTER TABLE `Reset_Token` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Reset_Token` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Role_name_key` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Role`
--

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Role` VALUES
(1,'Admin','2026-01-24 11:06:19.749','2026-01-24 11:06:19.749'),
(2,'Teacher','2026-01-24 11:06:19.749','2026-01-24 11:06:19.749'),
(3,'Student','2026-01-24 11:06:19.749','2026-01-24 11:06:19.749');
/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Section`
--

DROP TABLE IF EXISTS `Section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Section` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `order` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `classId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Section_classId_fkey` (`classId`),
  CONSTRAINT `Section_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `Class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Section`
--

LOCK TABLES `Section` WRITE;
/*!40000 ALTER TABLE `Section` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Section` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `username` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `profileImage` varchar(191) NOT NULL,
  `verified_at` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `roleId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`),
  UNIQUE KEY `User_username_key` (`username`),
  KEY `User_roleId_fkey` (`roleId`),
  CONSTRAINT `User_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `Role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `User` VALUES
('001d29a6-3b8d-499e-85ca-16becd577c54','student471@example.com','student471','Elisabeth.Ðekić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+471&background=random','2026-01-24 11:06:20.648','2022-10-15 11:14:20.144','2026-01-24 11:06:20.648',3),
('005569f0-217e-4f16-a62e-38e130b49489','teacher40@example.com','teacher40','Santosh_Þórðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+40&background=random','2026-01-24 11:06:19.873','2022-07-27 13:27:26.907','2026-01-24 11:06:19.873',2),
('00829b40-9c2b-4399-9167-1d1e2fa7586a','student104@example.com','student104','Amiyt_Suwan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+104&background=random','2026-01-24 11:06:20.189','2024-02-26 06:58:20.394','2026-01-24 11:06:20.190',3),
('00cdcfb5-58b0-4077-878f-920128909475','student380@example.com','student380','Victoria_Beneš68','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+380&background=random','2026-01-24 11:06:20.545','2024-05-16 20:02:22.895','2026-01-24 11:06:20.546',3),
('00dc8309-c888-49c4-848e-8d3c43d7b34a','student224@example.com','student224','Nicola_Förster4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+224&background=random','2026-01-24 11:06:20.346','2024-08-31 09:00:09.216','2026-01-24 11:06:20.347',3),
('00f56be6-2d1a-4b9e-88de-7a1e0e03770f','student503@example.com','student503','Thulani.Vásquez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+503&background=random','2026-01-24 11:06:20.682','2025-02-15 00:06:43.399','2026-01-24 11:06:20.683',3),
('00fd836b-2977-4e6f-909c-e1eb34ca4cb5','student998@example.com','student998','Jerzy_Sukkasem','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+998&background=random','2026-01-24 11:06:21.260','2023-03-29 19:26:33.295','2026-01-24 11:06:21.260',3),
('015ca042-fbe0-4888-8eaf-d8059b186264','student718@example.com','student718','Fiona.Zemanová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+718&background=random','2026-01-24 11:06:20.921','2024-05-08 07:34:09.871','2026-01-24 11:06:20.922',3),
('01f4c984-42b5-483d-84d0-80e6e3935cc7','student541@example.com','student541','Takeshi_Ágústsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+541&background=random','2026-01-24 11:06:20.724','2023-10-15 18:12:18.315','2026-01-24 11:06:20.725',3),
('020e8652-9d8a-4232-a25d-235ad51ae77a','student321@example.com','student321','Jianhua_Sigurðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+321&background=random','2026-01-24 11:06:20.470','2023-08-05 10:38:37.724','2026-01-24 11:06:20.471',3),
('02456806-3d20-44fd-9a39-8e746546c017','student78@example.com','student78','Jan_Herrera59','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+78&background=random','2026-01-24 11:06:20.161','2021-03-13 07:54:06.900','2026-01-24 11:06:20.161',3),
('025e07e4-5c93-4352-8f52-eba641c60707','student207@example.com','student207','Birna.Flores','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+207&background=random','2026-01-24 11:06:20.326','2023-04-14 20:41:44.463','2026-01-24 11:06:20.327',3),
('026cae53-9071-469d-a330-55fe6885dc60','student588@example.com','student588','Qing.Köhler','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+588&background=random','2026-01-24 11:06:20.777','2021-12-12 13:15:10.218','2026-01-24 11:06:20.778',3),
('02cdc479-c894-43e1-9063-75e4c4c6045a','student301@example.com','student301','Petra_Schütz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+301&background=random','2026-01-24 11:06:20.444','2024-07-29 17:18:12.985','2026-01-24 11:06:20.445',3),
('02e99b85-ba0d-4fbc-ad81-741e5bd89b7e','student750@example.com','student750','Shizuko.Vos','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+750&background=random','2026-01-24 11:06:20.959','2021-10-13 23:18:20.858','2026-01-24 11:06:20.960',3),
('030e0f41-e2c2-458d-9158-2f4e2522ef1c','student670@example.com','student670','Yael.Mutuku14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+670&background=random','2026-01-24 11:06:20.866','2021-03-19 07:31:33.660','2026-01-24 11:06:20.867',3),
('038fa0b2-cac0-4dcf-9d47-333d32e97133','student277@example.com','student277','Tal_Żak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+277&background=random','2026-01-24 11:06:20.413','2021-07-08 12:25:27.707','2026-01-24 11:06:20.414',3),
('03b3ab6e-298b-4e2e-b545-28c76c318c14','student427@example.com','student427','Sammy_Fröhlich','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+427&background=random','2026-01-24 11:06:20.601','2025-02-19 09:15:35.113','2026-01-24 11:06:20.601',3),
('03e2ee66-a9ef-4730-8a5f-1ecf043777d7','student700@example.com','student700','Anong_Zemanová10','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+700&background=random','2026-01-24 11:06:20.900','2023-12-07 13:43:16.759','2026-01-24 11:06:20.901',3),
('04cd5111-febd-453f-9cc0-192c63659c6d','student572@example.com','student572','Galina.Walters','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+572&background=random','2026-01-24 11:06:20.759','2022-01-28 05:43:06.862','2026-01-24 11:06:20.760',3),
('055d956f-0783-4b11-995f-d9b008a56861','teacher111@example.com','teacher111','Bin_Wambui24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+111&background=random','2026-01-24 11:06:19.960','2024-03-13 21:48:47.149','2026-01-24 11:06:19.961',2),
('0579bf97-db96-4817-a470-b631cb8e3289','student678@example.com','student678','Suman_Goto15','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+678&background=random','2026-01-24 11:06:20.874','2021-03-30 09:27:51.975','2026-01-24 11:06:20.875',3),
('05cbd5df-467a-409b-a5ed-84185ee7f196','teacher117@example.com','teacher117','Mercy.Gísladóttir42','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+117&background=random','2026-01-24 11:06:19.968','2025-10-09 20:35:12.007','2026-01-24 11:06:19.968',2),
('06139f57-1836-4109-9bcb-33386f70d8d1','teacher10@example.com','teacher10','Wilai_Halldórsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+10&background=random','2026-01-24 11:06:19.836','2021-03-19 09:43:15.128','2026-01-24 11:06:19.837',2),
('063cb91e-5a29-405e-83a6-0da74160489a','student303@example.com','student303','Rachel_Ota','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+303&background=random','2026-01-24 11:06:20.447','2023-03-03 00:35:04.497','2026-01-24 11:06:20.448',3),
('06495d36-6988-4c5d-a1c2-a08eacc5b8f0','teacher176@example.com','teacher176','Dorota_Ríos','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+176&background=random','2026-01-24 11:06:20.038','2021-05-03 20:07:21.116','2026-01-24 11:06:20.039',2),
('0650d028-d4a2-4f33-933f-d0c7b2395fda','student872@example.com','student872','Renate_Dvořák','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+872&background=random','2026-01-24 11:06:21.108','2026-01-03 15:12:12.578','2026-01-24 11:06:21.108',3),
('06721735-70ed-4c66-8eb7-41b99ada4665','teacher150@example.com','teacher150','Sachiko.Kato4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+150&background=random','2026-01-24 11:06:20.007','2023-03-13 07:04:53.118','2026-01-24 11:06:20.008',2),
('06ef95fc-589a-4e01-b7c5-f938759c2b5c','student67@example.com','student67','Anna.Ramírez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+67&background=random','2026-01-24 11:06:20.149','2023-06-29 07:44:06.467','2026-01-24 11:06:20.150',3),
('06fb0ddf-a270-4461-b41f-0765a40f9c76','student849@example.com','student849','Marcin.Hoffmann45','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+849&background=random','2026-01-24 11:06:21.083','2021-11-14 00:11:29.922','2026-01-24 11:06:21.084',3),
('07035faa-0acb-4240-a371-f0a245da98e1','teacher2@example.com','teacher2','Tomasz_Xie','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+2&background=random','2026-01-24 11:06:19.825','2021-03-23 05:35:14.787','2026-01-24 11:06:19.826',2),
('07082237-88e8-461d-a8a6-c35034709880','student119@example.com','student119','Raphael_Jiménez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+119&background=random','2026-01-24 11:06:20.210','2025-09-09 00:18:47.507','2026-01-24 11:06:20.211',3),
('070f93a0-1d45-45e3-8572-30d7c466b0d6','teacher169@example.com','teacher169','Rafael.Hájek86','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+169&background=random','2026-01-24 11:06:20.030','2023-02-27 08:54:50.772','2026-01-24 11:06:20.031',2),
('071ea6c0-c940-4698-b102-aa80f087b188','teacher75@example.com','teacher75','Dmitry_Martin66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+75&background=random','2026-01-24 11:06:19.919','2024-11-03 21:48:19.290','2026-01-24 11:06:19.919',2),
('072733a3-022a-4481-b4b2-3340c237e29c','student512@example.com','student512','Lilian.Pokorná50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+512&background=random','2026-01-24 11:06:20.693','2023-05-10 09:57:30.223','2026-01-24 11:06:20.693',3),
('072d858f-a7b7-4933-a7ba-8ea0b4cc8478','student784@example.com','student784','Tatyana.Suarez59','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+784&background=random','2026-01-24 11:06:20.997','2024-12-18 19:20:18.732','2026-01-24 11:06:20.997',3),
('0747142d-2610-4b64-86f0-c7c4858cd4b2','student137@example.com','student137','Lin_Veselá','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+137&background=random','2026-01-24 11:06:20.231','2025-11-08 20:01:44.269','2026-01-24 11:06:20.231',3),
('07705aec-47c0-4955-8e96-1aa1dca34ea3','student562@example.com','student562','Kiran_Kučerová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+562&background=random','2026-01-24 11:06:20.748','2024-10-14 21:05:21.698','2026-01-24 11:06:20.749',3),
('07a8967c-4464-49d1-9376-e96f051f0325','student875@example.com','student875','Dennis.Jiménez12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+875&background=random','2026-01-24 11:06:21.111','2024-08-01 05:42:08.888','2026-01-24 11:06:21.111',3),
('07c8627c-d6cc-4ff9-b665-90662b501721','student568@example.com','student568','Brian.Nyambura98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+568&background=random','2026-01-24 11:06:20.755','2021-08-28 06:20:00.286','2026-01-24 11:06:20.756',3),
('07d571fb-b64c-43e1-bd7c-6a9e9c270dc0','student504@example.com','student504','Rose.Baldursdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+504&background=random','2026-01-24 11:06:20.683','2022-02-20 18:38:07.202','2026-01-24 11:06:20.684',3),
('0817eaad-42b3-4a76-bac3-ecaadb1f5b4f','student694@example.com','student694','Christopher_Haraldsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+694&background=random','2026-01-24 11:06:20.893','2024-09-27 02:56:33.260','2026-01-24 11:06:20.893',3),
('083a8dc0-2ce8-4387-a3f6-749662836047','student539@example.com','student539','Patrick.Dvořáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+539&background=random','2026-01-24 11:06:20.722','2024-06-14 08:36:01.524','2026-01-24 11:06:20.723',3),
('0856215f-810a-4aec-ad76-1421af9d98c4','student509@example.com','student509','Pilar.Göbel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+509&background=random','2026-01-24 11:06:20.689','2023-07-14 13:09:58.588','2026-01-24 11:06:20.690',3),
('08998ae2-bc47-4a81-9da1-d3f5b0283e91','student34@example.com','student34','Sabine.Einarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+34&background=random','2026-01-24 11:06:20.111','2025-11-26 09:44:50.806','2026-01-24 11:06:20.112',3),
('08a704be-e791-4c8d-995b-8a5c81eb8a60','student756@example.com','student756','Gabra.Kobayashi9','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+756&background=random','2026-01-24 11:06:20.965','2021-05-31 02:51:41.452','2026-01-24 11:06:20.966',3),
('08a7bc26-eb7f-4f36-86bf-d25f37d511f2','student203@example.com','student203','Kiyoko_König','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+203&background=random','2026-01-24 11:06:20.321','2025-07-02 23:45:36.459','2026-01-24 11:06:20.322',3),
('08aa5684-f8b3-40b6-9b5b-9295285d43f9','teacher28@example.com','teacher28','Iwona.Sánchez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+28&background=random','2026-01-24 11:06:19.858','2024-04-25 10:04:19.951','2026-01-24 11:06:19.859',2),
('0917518b-a074-4653-8068-ee8e38f0592a','student906@example.com','student906','Justyna_Ito68','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+906&background=random','2026-01-24 11:06:21.147','2025-08-15 16:44:43.393','2026-01-24 11:06:21.147',3),
('091e73b0-a575-4081-a5a4-692b75d1f17b','student782@example.com','student782','Miyoko.Pálsdóttir8','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+782&background=random','2026-01-24 11:06:20.995','2023-12-07 23:19:28.046','2026-01-24 11:06:20.995',3),
('096b872f-a7b9-4ce6-a136-4d86af25620b','student16@example.com','student16','Miyoko.Yadav93','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+16&background=random','2026-01-24 11:06:20.086','2021-10-31 12:49:50.331','2026-01-24 11:06:20.087',3),
('09d945bb-bf23-4f50-918b-4d821b6e4d09','student812@example.com','student812','Muhammed.Kamiński88','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+812&background=random','2026-01-24 11:06:21.028','2021-04-09 09:57:09.983','2026-01-24 11:06:21.029',3),
('0a3fe4a9-2c53-4b8f-93f5-14efbb404382','student975@example.com','student975','Lilian.Thompson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+975&background=random','2026-01-24 11:06:21.235','2021-06-10 08:42:07.209','2026-01-24 11:06:21.235',3),
('0a88956b-97d1-4251-9cda-3587460a4564','student402@example.com','student402','Yasuko_Urbański19','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+402&background=random','2026-01-24 11:06:20.571','2023-06-15 02:46:39.333','2026-01-24 11:06:20.572',3),
('0ad82d65-b868-478a-8baf-70ebb1920694','student526@example.com','student526','Amina.Audu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+526&background=random','2026-01-24 11:06:20.708','2024-06-01 12:55:48.476','2026-01-24 11:06:20.708',3),
('0aea5d96-0b31-49b3-b48a-e72cdd36f225','student122@example.com','student122','Shankar.Devi83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+122&background=random','2026-01-24 11:06:20.214','2023-10-20 10:41:18.536','2026-01-24 11:06:20.214',3),
('0af4298e-ffcf-430a-9e29-42ff7705859b','student260@example.com','student260','Rose.Sigurjónsdóttir18','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+260&background=random','2026-01-24 11:06:20.391','2025-08-01 05:04:18.843','2026-01-24 11:06:20.391',3),
('0b2d9757-bc44-400c-84e5-856c03accb41','student194@example.com','student194','Joan.Kumar','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+194&background=random','2026-01-24 11:06:20.309','2022-05-07 03:57:31.658','2026-01-24 11:06:20.310',3),
('0b4c163b-df58-446e-82be-295206aeb047','student666@example.com','student666','Krzysztof_Müller','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+666&background=random','2026-01-24 11:06:20.862','2023-05-28 13:14:33.146','2026-01-24 11:06:20.863',3),
('0b90055a-0f45-4064-9617-cbf39798f03b','student955@example.com','student955','Vincent_Ríos','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+955&background=random','2026-01-24 11:06:21.210','2024-04-30 20:58:15.590','2026-01-24 11:06:21.210',3),
('0ba67943-df63-4480-99d5-104cada84a49','student614@example.com','student614','Rong.Kim','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+614&background=random','2026-01-24 11:06:20.805','2021-11-18 03:29:24.359','2026-01-24 11:06:20.806',3),
('0bde2af6-ad06-4975-9032-76cfcb5aaeb9','student258@example.com','student258','Charles_Ūsas98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+258&background=random','2026-01-24 11:06:20.388','2024-02-06 16:01:17.335','2026-01-24 11:06:20.389',3),
('0c61fddc-a6cd-48b5-800d-9aff71656e0e','student304@example.com','student304','Eva_Hofmann38','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+304&background=random','2026-01-24 11:06:20.449','2021-07-13 21:04:40.820','2026-01-24 11:06:20.450',3),
('0c783c20-6d83-47a2-96d3-8ebcbb5f70cb','student743@example.com','student743','Yuval.Molefe80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+743&background=random','2026-01-24 11:06:20.951','2024-01-27 09:54:15.138','2026-01-24 11:06:20.952',3),
('0cd2722b-e5af-4db0-a5ed-907717e140a6','teacher181@example.com','teacher181','Edda_Davies','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+181&background=random','2026-01-24 11:06:20.044','2022-09-12 06:22:35.898','2026-01-24 11:06:20.044',2),
('0cecc70f-1929-4866-8530-0ece79fb8cf1','teacher76@example.com','teacher76','Xiaoyan_Ūžien','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+76&background=random','2026-01-24 11:06:19.920','2021-12-02 18:40:38.126','2026-01-24 11:06:19.921',2),
('0e2b8928-184a-462c-a7c9-38e1c3f16124','student634@example.com','student634','Otieno.Olszewski44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+634&background=random','2026-01-24 11:06:20.827','2022-04-08 01:12:52.930','2026-01-24 11:06:20.827',3),
('0e5da772-7656-4817-8a9f-aa9147bd1069','student172@example.com','student172','Guy.Barman71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+172&background=random','2026-01-24 11:06:20.276','2024-04-02 08:24:40.804','2026-01-24 11:06:20.277',3),
('0e7a98bd-668f-40cd-be32-2805d86f70e3','student617@example.com','student617','Emma.Kristjánsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+617&background=random','2026-01-24 11:06:20.808','2022-07-26 17:29:15.866','2026-01-24 11:06:20.809',3),
('0e7b42f2-b9cc-47fa-ab85-921bbfff48d3','student642@example.com','student642','Fran.López','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+642&background=random','2026-01-24 11:06:20.836','2021-07-08 22:17:40.771','2026-01-24 11:06:20.837',3),
('0ea90dcc-8c7c-4b6c-99d5-bdfea8da099c','teacher6@example.com','teacher6','Fiona.Hopkins5','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+6&background=random','2026-01-24 11:06:19.831','2024-10-20 15:35:44.750','2026-01-24 11:06:19.832',2),
('0ead2f29-dde8-4b96-8532-79504f40cf58','student57@example.com','student57','Idris_Pétursdóttir87','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+57&background=random','2026-01-24 11:06:20.138','2021-10-01 02:21:54.326','2026-01-24 11:06:20.138',3),
('0ec21412-417d-4e88-88f8-0013c4dc36db','student448@example.com','student448','Anan.Magnúsdóttir7','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+448&background=random','2026-01-24 11:06:20.623','2025-04-08 14:59:26.837','2026-01-24 11:06:20.624',3),
('0ee3af87-f4e7-4eb3-ab1c-f56a25c27b6f','student377@example.com','student377','Claudia_Böttcher92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+377&background=random','2026-01-24 11:06:20.541','2024-08-22 10:49:51.183','2026-01-24 11:06:20.541',3),
('0eecba2b-b018-432c-8737-64b1ca30227b','student52@example.com','student52','Sita_Audu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+52&background=random','2026-01-24 11:06:20.132','2023-02-06 22:03:33.113','2026-01-24 11:06:20.133',3),
('0eecc562-81e5-4749-a39a-1f0043572ddf','student535@example.com','student535','Somkhit.Göbel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+535&background=random','2026-01-24 11:06:20.717','2025-08-14 09:22:22.310','2026-01-24 11:06:20.718',3),
('0ef0e4b2-b256-434e-8a2e-0c8e82547739','teacher135@example.com','teacher135','Kazuo_Mabaso','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+135&background=random','2026-01-24 11:06:19.990','2025-10-17 21:41:29.303','2026-01-24 11:06:19.991',2),
('0f1c5eeb-6c4d-472b-ba15-4684a07290ca','student592@example.com','student592','Andries_Mori','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+592&background=random','2026-01-24 11:06:20.781','2021-10-20 18:18:52.291','2026-01-24 11:06:20.782',3),
('0f723fdc-23ab-4bf0-afaf-66944ca3fd2e','student369@example.com','student369','Chan.Núñez83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+369&background=random','2026-01-24 11:06:20.530','2023-07-06 12:22:26.822','2026-01-24 11:06:20.531',3),
('0f7c05ca-a73e-4b99-8e45-d4fd61b03f8f','student865@example.com','student865','Barbara_Kristinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+865&background=random','2026-01-24 11:06:21.100','2024-09-03 21:24:28.281','2026-01-24 11:06:21.101',3),
('0f7ed54a-afff-42b0-83cd-17cd63faa71a','student898@example.com','student898','Petra.Žukauskienė','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+898&background=random','2026-01-24 11:06:21.138','2023-03-11 00:21:09.709','2026-01-24 11:06:21.139',3),
('0f8d826b-112f-415c-8068-6c8fb697aebc','student671@example.com','student671','Ekaterina.Andreeva76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+671&background=random','2026-01-24 11:06:20.867','2023-06-14 04:10:19.362','2026-01-24 11:06:20.868',3),
('0fd7d54f-f0cb-4f3d-acef-c525f79a2a0d','student962@example.com','student962','Cheng.Sigurðsson98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+962&background=random','2026-01-24 11:06:21.218','2025-11-20 06:19:43.832','2026-01-24 11:06:21.219',3),
('10063a41-25e6-457c-b2db-d69be3ef1909','student68@example.com','student68','Julie_Maluleke25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+68&background=random','2026-01-24 11:06:20.150','2023-05-12 12:44:32.148','2026-01-24 11:06:20.151',3),
('10628160-74c7-47bf-baa4-5898a69635d2','student683@example.com','student683','Koichi_Karlsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+683&background=random','2026-01-24 11:06:20.881','2022-04-13 18:42:29.143','2026-01-24 11:06:20.881',3),
('10c58476-093e-49d3-84dd-1d4e3a7eb374','student542@example.com','student542','Joyce_Guzmán28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+542&background=random','2026-01-24 11:06:20.725','2024-07-14 12:58:01.508','2026-01-24 11:06:20.725',3),
('11891992-020f-4610-8afc-587fd6e0200f','teacher130@example.com','teacher130','Blessing_Schulz69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+130&background=random','2026-01-24 11:06:19.985','2023-05-19 10:57:53.357','2026-01-24 11:06:19.985',2),
('11d97f83-1c84-4280-807a-4cec95fbbfbc','student869@example.com','student869','Aleksandra_Li','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+869&background=random','2026-01-24 11:06:21.105','2025-01-31 11:50:35.124','2026-01-24 11:06:21.105',3),
('1232c9e5-3a56-439f-8c9a-ab84bd117e29','student205@example.com','student205','Jose-Antonio_Pospíšil62','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+205&background=random','2026-01-24 11:06:20.323','2025-03-15 13:57:47.681','2026-01-24 11:06:20.324',3),
('123a8fc3-8d82-4a19-9110-0d4961fbc596','student117@example.com','student117','Steinunn_Castro34','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+117&background=random','2026-01-24 11:06:20.208','2024-02-21 05:05:09.231','2026-01-24 11:06:20.209',3),
('12f95561-c551-4068-b6d0-90651fdffbde','student882@example.com','student882','Marek.Stefánsson37','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+882&background=random','2026-01-24 11:06:21.117','2023-06-04 01:06:29.774','2026-01-24 11:06:21.118',3),
('135b77e5-14c3-493d-bca7-ab74a238aa68','student465@example.com','student465','Sabine.Procházková49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+465&background=random','2026-01-24 11:06:20.641','2022-12-04 04:42:40.577','2026-01-24 11:06:20.642',3),
('1367b5c2-5b6d-435e-8784-9f6a0f3e86d1','student950@example.com','student950','Tomasz.König99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+950&background=random','2026-01-24 11:06:21.203','2021-10-30 12:50:28.047','2026-01-24 11:06:21.204',3),
('1373ea30-54a3-48e3-b59b-0406886d66e3','student735@example.com','student735','Hadiza_Egorova','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+735&background=random','2026-01-24 11:06:20.941','2022-02-27 21:40:35.592','2026-01-24 11:06:20.942',3),
('13bdb485-052d-4236-a67d-e167e42610c5','student594@example.com','student594','Xiaohong.Hen98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+594&background=random','2026-01-24 11:06:20.784','2022-08-10 06:17:45.408','2026-01-24 11:06:20.784',3),
('13d83121-bfc2-4e77-87ea-11da8fe1a735','student163@example.com','student163','Brigitte_Ram','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+163&background=random','2026-01-24 11:06:20.263','2025-02-01 17:30:56.370','2026-01-24 11:06:20.264',3),
('13dbcd69-c2b3-4d7a-83b3-5e4de6d470fb','student649@example.com','student649','Hadiza_Simiyu22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+649&background=random','2026-01-24 11:06:20.845','2022-03-10 16:23:08.179','2026-01-24 11:06:20.845',3),
('1450ae49-8c86-4959-bd85-5730fe311a35','student38@example.com','student38','Andreas.Pfeiffer','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+38&background=random','2026-01-24 11:06:20.116','2021-05-06 08:26:10.044','2026-01-24 11:06:20.116',3),
('149ca957-73da-46f4-b508-83f107755ae9','student366@example.com','student366','Emiko.Magnússon2','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+366&background=random','2026-01-24 11:06:20.527','2024-12-14 09:39:40.425','2026-01-24 11:06:20.528',3),
('14c50fb7-ef15-497e-ad4a-1bcbb327674a','student125@example.com','student125','Daniyel_Löffler','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+125&background=random','2026-01-24 11:06:20.216','2025-10-31 11:33:01.779','2026-01-24 11:06:20.217',3),
('150e45e4-c53a-46a3-abbd-316a07b10490','student725@example.com','student725','Mali_Schäfer','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+725&background=random','2026-01-24 11:06:20.930','2025-08-13 09:56:01.211','2026-01-24 11:06:20.931',3),
('153eaba1-318c-490e-8319-6ca941b4779f','student940@example.com','student940','Emiko.Ortiz85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+940&background=random','2026-01-24 11:06:21.188','2023-08-01 08:54:56.563','2026-01-24 11:06:21.188',3),
('15a95993-cb6f-4876-b67a-ba16d559eb54','teacher143@example.com','teacher143','Anastasiya_Žukauskienė','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+143&background=random','2026-01-24 11:06:19.999','2025-04-23 03:11:07.273','2026-01-24 11:06:20.000',2),
('15deb96d-d95a-4ca8-b94b-b287da8b4f41','student900@example.com','student900','Ning.Khatib50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+900&background=random','2026-01-24 11:06:21.140','2022-01-23 10:47:52.264','2026-01-24 11:06:21.141',3),
('160eff5b-724c-4c23-aba8-0935aa16b476','student343@example.com','student343','Lyudmila_Isaac','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+343&background=random','2026-01-24 11:06:20.497','2021-12-26 20:35:38.725','2026-01-24 11:06:20.498',3),
('161ec210-501c-4892-9ec1-cf1b8ea9d07d','student39@example.com','student39','Cristina_Procházková7','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+39&background=random','2026-01-24 11:06:20.117','2022-07-28 16:18:31.824','2026-01-24 11:06:20.117',3),
('1633e3fd-9bad-4ba6-8a59-0b274f7c720d','student729@example.com','student729','Ning.Díaz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+729&background=random','2026-01-24 11:06:20.934','2025-05-05 09:08:10.159','2026-01-24 11:06:20.935',3),
('163a737d-021b-4a8c-8025-2903b877910c','teacher26@example.com','teacher26','Christine.Gunnarsson68','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+26&background=random','2026-01-24 11:06:19.855','2023-12-16 09:27:46.765','2026-01-24 11:06:19.856',2),
('169d6622-7eb8-487f-9227-2932329015b3','student267@example.com','student267','Nicola_Procházka','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+267&background=random','2026-01-24 11:06:20.399','2025-05-01 07:54:31.541','2026-01-24 11:06:20.400',3),
('17078081-21de-4136-9943-495dccea5785','student686@example.com','student686','Tebogo.Czarnecki','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+686&background=random','2026-01-24 11:06:20.884','2025-07-04 00:25:51.992','2026-01-24 11:06:20.885',3),
('170ec190-64ba-4543-9497-b79c57af7c59','student290@example.com','student290','Birgit.Schäfer99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+290&background=random','2026-01-24 11:06:20.430','2025-07-04 11:53:32.215','2026-01-24 11:06:20.431',3),
('17142570-f33d-4f37-8923-54e28a47bef8','student533@example.com','student533','Ming.Kučera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+533&background=random','2026-01-24 11:06:20.715','2021-03-15 06:25:02.410','2026-01-24 11:06:20.716',3),
('17282e57-5e2c-43f2-bcb6-cf34d11d6f2d','student131@example.com','student131','Sunita_Zieliński86','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+131&background=random','2026-01-24 11:06:20.223','2024-06-03 04:50:11.661','2026-01-24 11:06:20.224',3),
('176b585a-09fb-4f2d-b376-e05d740c601a','student793@example.com','student793','Ning_Garza','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+793&background=random','2026-01-24 11:06:21.007','2021-05-26 12:41:27.678','2026-01-24 11:06:21.007',3),
('1775af03-4059-47ca-a8ae-b9a4fc4744b2','teacher32@example.com','teacher32','Noriko_Horák63','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+32&background=random','2026-01-24 11:06:19.863','2025-03-17 10:31:20.361','2026-01-24 11:06:19.863',2),
('183a6382-117b-4c0b-869f-389a04a64d57','student800@example.com','student800','Wanchai.Neumann','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+800&background=random','2026-01-24 11:06:21.015','2025-04-16 16:51:11.546','2026-01-24 11:06:21.016',3),
('18539446-bc5c-4774-b143-c4aa2a89ef54','student726@example.com','student726','Svetlana.Xiao','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+726&background=random','2026-01-24 11:06:20.931','2021-06-25 15:20:07.736','2026-01-24 11:06:20.932',3),
('18812488-d494-47c0-a4f2-561dc4d17de5','student713@example.com','student713','Rose.Zieliński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+713&background=random','2026-01-24 11:06:20.915','2023-05-12 06:13:38.873','2026-01-24 11:06:20.916',3),
('192a8734-af35-4c42-8737-cd86bb5a4083','teacher58@example.com','teacher58','Ivan.Huisman97','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+58&background=random','2026-01-24 11:06:19.897','2022-04-28 18:59:13.334','2026-01-24 11:06:19.898',2),
('19651dcd-e806-435d-a6c3-6878346daccc','student175@example.com','student175','Yukio.Pretorius94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+175&background=random','2026-01-24 11:06:20.280','2025-01-20 19:34:13.926','2026-01-24 11:06:20.281',3),
('197244b6-b68f-4943-b93c-2da7d13521f1','student316@example.com','student316','Bernd_Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+316&background=random','2026-01-24 11:06:20.464','2022-09-11 11:59:42.159','2026-01-24 11:06:20.465',3),
('19819f98-4e5c-49f2-8a60-9498b05c55be','student220@example.com','student220','Victor_Martínez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+220&background=random','2026-01-24 11:06:20.342','2024-12-17 11:44:41.428','2026-01-24 11:06:20.342',3),
('19d86207-15b6-469b-8dae-ca40cfcd501f','student449@example.com','student449','Iwona_Chávez48','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+449&background=random','2026-01-24 11:06:20.624','2021-12-11 09:57:22.900','2026-01-24 11:06:20.625',3),
('19f10bdb-59a1-45d2-b6fa-69ee3a1e5265','student147@example.com','student147','Zhen.Fernández','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+147&background=random','2026-01-24 11:06:20.241','2024-04-28 03:30:12.985','2026-01-24 11:06:20.242',3),
('1a0b5b98-0282-4cd8-870f-5fe7c8f67cfd','student270@example.com','student270','Mikhail_Pálsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+270&background=random','2026-01-24 11:06:20.403','2025-09-05 04:56:15.526','2026-01-24 11:06:20.404',3),
('1a17a000-3ef0-4c6b-ae62-18d4647a178b','student146@example.com','student146','Sergey.Černá','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+146&background=random','2026-01-24 11:06:20.240','2021-12-09 12:39:07.351','2026-01-24 11:06:20.241',3),
('1adedce4-f320-4519-9a83-ad8daba84e6d','teacher112@example.com','teacher112','Musa_Þórðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+112&background=random','2026-01-24 11:06:19.961','2022-09-29 08:49:13.012','2026-01-24 11:06:19.962',2),
('1ae03448-a15b-4389-a43a-955a4c178fc1','student140@example.com','student140','Robert.Ivanov','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+140&background=random','2026-01-24 11:06:20.234','2025-09-29 04:36:31.948','2026-01-24 11:06:20.235',3),
('1b2f59fe-11ce-41c5-abf6-57378c661676','teacher19@example.com','teacher19','Ying.Þorsteinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+19&background=random','2026-01-24 11:06:19.847','2021-04-25 20:20:19.304','2026-01-24 11:06:19.848',2),
('1b52ec49-b632-4c3c-a803-7a69f1d9d476','teacher11@example.com','teacher11','Otieno.Sunday','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+11&background=random','2026-01-24 11:06:19.838','2022-01-17 03:01:54.405','2026-01-24 11:06:19.839',2),
('1bad06e0-bcf3-4faf-89a4-b5ab1c034075','student365@example.com','student365','Igor_Procházka','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+365&background=random','2026-01-24 11:06:20.526','2023-08-23 16:43:10.302','2026-01-24 11:06:20.527',3),
('1bb42e83-a2c0-46b5-bdbe-1ea48b150ec6','student587@example.com','student587','Qing.Chávez88','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+587&background=random','2026-01-24 11:06:20.776','2024-11-12 20:44:33.945','2026-01-24 11:06:20.777',3),
('1c312f44-102f-4813-aa46-a9b0d19cda22','student442@example.com','student442','Mark.Harðardóttir18','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+442&background=random','2026-01-24 11:06:20.617','2021-05-14 13:31:20.024','2026-01-24 11:06:20.618',3),
('1c694b38-8894-41b3-8dec-a672caac7a23','student891@example.com','student891','Ian_Ásgeirsdóttir9','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+891&background=random','2026-01-24 11:06:21.129','2025-08-31 11:56:33.266','2026-01-24 11:06:21.130',3),
('1cafd56f-387a-4e74-85e4-547824b93a1d','student364@example.com','student364','Wanjiru_Baker','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+364&background=random','2026-01-24 11:06:20.525','2025-03-26 10:00:58.430','2026-01-24 11:06:20.525',3),
('1d3f5b6c-3c55-4a34-bd28-aa3ebec0989f','student773@example.com','student773','Hui_Pietrzak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+773&background=random','2026-01-24 11:06:20.986','2021-10-28 06:28:56.562','2026-01-24 11:06:20.986',3),
('1d667fdc-d821-4559-af09-adbbcb281f5e','student734@example.com','student734','Yoko_Árnason','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+734&background=random','2026-01-24 11:06:20.940','2025-03-29 04:24:53.198','2026-01-24 11:06:20.940',3),
('1d71b4d2-dcd8-4a6f-a883-1b4939480b25','teacher161@example.com','teacher161','Sanjay.Jäger','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+161&background=random','2026-01-24 11:06:20.020','2021-02-20 05:26:49.528','2026-01-24 11:06:20.021',2),
('1d87bc5a-c2ef-44c2-9f3b-54fb71b865e0','student570@example.com','student570','Sara_Schäfer','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+570&background=random','2026-01-24 11:06:20.757','2025-04-23 04:12:07.230','2026-01-24 11:06:20.758',3),
('1dda3d62-6016-4c37-96a0-0f93e96a81a7','student691@example.com','student691','Somkhit_Björnsson9','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+691&background=random','2026-01-24 11:06:20.890','2023-09-23 13:35:49.513','2026-01-24 11:06:20.890',3),
('1e104a28-d2d8-46f7-b70d-bc41ab8e3d2d','student861@example.com','student861','Koji.Xiao78','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+861&background=random','2026-01-24 11:06:21.096','2022-06-19 22:51:24.576','2026-01-24 11:06:21.097',3),
('1e1a13cf-9a36-4272-8ad2-57d7eb83f637','student935@example.com','student935','Gang.Zemanová94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+935&background=random','2026-01-24 11:06:21.181','2022-04-18 18:40:04.005','2026-01-24 11:06:21.182',3),
('1e5562b7-3304-494e-951d-e7a0ba09dbd3','student325@example.com','student325','Joan_Jia79','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+325&background=random','2026-01-24 11:06:20.476','2024-11-06 17:41:40.598','2026-01-24 11:06:20.477',3),
('1e9aa297-c34c-43a5-ae16-6a11da93c466','student760@example.com','student760','Suman.Pugh89','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+760&background=random','2026-01-24 11:06:20.971','2021-10-03 03:26:30.525','2026-01-24 11:06:20.971',3),
('1ed38b66-16ad-4335-8cfb-c64a74011ef5','student585@example.com','student585','Jean_Łukaszewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+585&background=random','2026-01-24 11:06:20.774','2021-04-02 05:31:09.484','2026-01-24 11:06:20.774',3),
('1f0def7b-0bbf-4332-92d7-cf114643c9aa','student160@example.com','student160','Andrew.Pálsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+160&background=random','2026-01-24 11:06:20.259','2021-05-24 02:39:06.173','2026-01-24 11:06:20.259',3),
('1f33be9f-4e98-4cc8-b2ee-003d2baf99b2','student318@example.com','student318','Thabo_Köhler89','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+318&background=random','2026-01-24 11:06:20.467','2021-03-17 03:56:02.958','2026-01-24 11:06:20.467',3),
('1f47a039-dc07-472e-90ae-30238a4182a0','teacher138@example.com','teacher138','Tebogo_Mohamed63','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+138&background=random','2026-01-24 11:06:19.994','2025-07-07 02:36:50.213','2026-01-24 11:06:19.994',2),
('1f50c457-0840-41ba-ba7e-3ed1eabd34ca','student876@example.com','student876','Thulani.Clarke51','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+876&background=random','2026-01-24 11:06:21.111','2025-05-11 13:42:36.920','2026-01-24 11:06:21.112',3),
('1f765095-1d0d-43cb-9f88-882293eb6529','student624@example.com','student624','Bartosz.Æbeltoft','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+624&background=random','2026-01-24 11:06:20.815','2023-06-21 11:39:18.469','2026-01-24 11:06:20.816',3),
('1fd0418a-af60-4fc6-8e54-f06709b4233a','student394@example.com','student394','Steinunn_Löffler','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+394&background=random','2026-01-24 11:06:20.561','2023-01-22 09:11:18.619','2026-01-24 11:06:20.562',3),
('1fd4b34d-be42-4451-bc64-9daee7a6a46a','student458@example.com','student458','Koichi.Novotná67','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+458&background=random','2026-01-24 11:06:20.633','2024-12-09 02:21:52.975','2026-01-24 11:06:20.634',3),
('20092983-071c-4363-8e32-50bc7abb444c','student333@example.com','student333','Qing.Svobodová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+333&background=random','2026-01-24 11:06:20.486','2022-08-03 15:16:50.184','2026-01-24 11:06:20.486',3),
('200bfc3e-65ed-4ba3-b507-3cc6bbe33edf','student307@example.com','student307','Rekha_Svobodová72','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+307&background=random','2026-01-24 11:06:20.453','2025-07-21 12:03:57.053','2026-01-24 11:06:20.453',3),
('2025d7b4-03dd-48fd-83d9-1b7454cbf31e','teacher20@example.com','teacher20','Xiaoping.Mitchell40','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+20&background=random','2026-01-24 11:06:19.848','2023-02-15 08:37:26.750','2026-01-24 11:06:19.849',2),
('20330faf-cdd6-483c-b5c0-1774b3d36b18','student605@example.com','student605','Ping_Őllösová92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+605&background=random','2026-01-24 11:06:20.795','2021-12-25 09:31:11.262','2026-01-24 11:06:20.796',3),
('2082830e-ef40-41fd-a2c5-4d6a5d688b1c','student351@example.com','student351','Magda_Pálsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+351&background=random','2026-01-24 11:06:20.508','2021-12-01 11:45:13.309','2026-01-24 11:06:20.509',3),
('20c3e00a-7c93-4282-b0c3-10c76d72c318','student1000@example.com','student1000','Bin.Jóhannesdóttir46','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+1000&background=random','2026-01-24 11:06:21.262','2025-12-01 21:20:40.188','2026-01-24 11:06:21.263',3),
('20d0b20d-e88d-4684-9c10-0d62ba431652','student918@example.com','student918','Sam_Samuel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+918&background=random','2026-01-24 11:06:21.162','2022-10-19 08:17:53.726','2026-01-24 11:06:21.162',3),
('20dab6b7-7ce9-459d-a99d-98e201d9d9a5','student827@example.com','student827','Andreas.Chen','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+827&background=random','2026-01-24 11:06:21.059','2024-05-10 06:36:09.799','2026-01-24 11:06:21.059',3),
('20ed3153-f65d-4df1-9274-f2e4a73645ed','student571@example.com','student571','Asha_Meißner85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+571&background=random','2026-01-24 11:06:20.758','2024-07-21 15:51:15.389','2026-01-24 11:06:20.759',3),
('20fd8499-7aec-4b52-b10e-6b44b50b81e0','student152@example.com','student152','Eunice.Venter','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+152&background=random','2026-01-24 11:06:20.249','2024-01-19 05:33:42.222','2026-01-24 11:06:20.249',3),
('216959dc-32d8-4616-b576-bcba0f5fe732','student991@example.com','student991','Dorota_Gupta','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+991&background=random','2026-01-24 11:06:21.252','2022-12-06 16:43:41.905','2026-01-24 11:06:21.252',3),
('22a2f552-9556-4de1-b9ef-e5dfd6828931','student385@example.com','student385','Yasuko.Kučerová35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+385&background=random','2026-01-24 11:06:20.551','2021-05-17 21:23:34.934','2026-01-24 11:06:20.552',3),
('22e404c2-0354-47be-90f1-0f95e95d3e02','teacher119@example.com','teacher119','Eunice.Schütz36','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+119&background=random','2026-01-24 11:06:19.970','2022-06-04 06:47:16.908','2026-01-24 11:06:19.971',2),
('22eede7f-d5ae-4a29-aaa6-fd9b0825ecaa','student717@example.com','student717','Mieko_Wright98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+717&background=random','2026-01-24 11:06:20.920','2021-11-28 20:09:42.864','2026-01-24 11:06:20.920',3),
('22fc182a-a5ad-4a52-a8d5-9bb21c1774e1','student524@example.com','student524','Kiran.Őzse','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+524&background=random','2026-01-24 11:06:20.706','2023-10-29 23:11:45.726','2026-01-24 11:06:20.706',3),
('22fc46cf-d269-4940-acd3-7217f10aafce','student409@example.com','student409','Salisu_Mthembu48','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+409&background=random','2026-01-24 11:06:20.580','2025-07-12 22:47:30.352','2026-01-24 11:06:20.581',3),
('23225f4f-cc6d-42e3-b4c5-59ff0f12b165','teacher127@example.com','teacher127','Carol_Urbański21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+127&background=random','2026-01-24 11:06:19.980','2021-12-09 12:37:09.859','2026-01-24 11:06:19.980',2),
('233913ac-4f4e-4302-b5f3-22c565979a7a','student798@example.com','student798','Gerhard.Pálsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+798&background=random','2026-01-24 11:06:21.013','2024-11-24 10:16:17.641','2026-01-24 11:06:21.014',3),
('2344bf9a-f203-4b9f-a649-92d69a6c662f','teacher168@example.com','teacher168','Wilai_Wolf31','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+168&background=random','2026-01-24 11:06:20.029','2024-11-19 00:32:21.001','2026-01-24 11:06:20.030',2),
('2351564d-1407-4b99-ad16-ef723fdb341f','student854@example.com','student854','Waraphon_Øvergård39','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+854&background=random','2026-01-24 11:06:21.088','2022-07-11 19:22:43.909','2026-01-24 11:06:21.089',3),
('23d77562-146f-4dfe-b72c-8fcfd0067e69','teacher100@example.com','teacher100','Kazuo.Muhammad9','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+100&background=random','2026-01-24 11:06:19.947','2024-03-19 21:29:46.030','2026-01-24 11:06:19.948',2),
('241308e2-c063-4b45-ae7d-f3beea9bfff0','teacher199@example.com','teacher199','Svetlana_Marin29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+199&background=random','2026-01-24 11:06:20.064','2021-10-09 11:10:22.753','2026-01-24 11:06:20.065',2),
('24217207-6907-44cf-9e5c-1ac7f6bdbadb','student647@example.com','student647','Pieter_Sisuk78','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+647&background=random','2026-01-24 11:06:20.843','2025-08-05 10:43:56.545','2026-01-24 11:06:20.843',3),
('248db3fd-538e-4f5a-b972-36fe4c2a6b28','student995@example.com','student995','Somchit.Benešová7','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+995&background=random','2026-01-24 11:06:21.256','2023-10-29 02:18:17.739','2026-01-24 11:06:21.257',3),
('249eb204-63a1-4167-a38e-640ecf0c618d','teacher115@example.com','teacher115','Ravi.Pokorná29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+115&background=random','2026-01-24 11:06:19.966','2024-12-24 21:43:24.723','2026-01-24 11:06:19.966',2),
('24c1a079-0f51-4af3-9a10-32eb5ae38cb8','student259@example.com','student259','Berglind_Kristjánsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+259&background=random','2026-01-24 11:06:20.390','2021-02-10 08:43:11.624','2026-01-24 11:06:20.390',3),
('24c38cb9-38c9-417e-b383-8ee00e3d2a8f','student656@example.com','student656','Aminu.Aguilar','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+656&background=random','2026-01-24 11:06:20.852','2022-07-19 04:07:20.124','2026-01-24 11:06:20.853',3),
('24d02fe3-3476-47cf-9390-9abee6da0117','student755@example.com','student755','Yun.Zhang','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+755&background=random','2026-01-24 11:06:20.964','2023-10-09 10:14:46.618','2026-01-24 11:06:20.965',3),
('252416b5-9413-4907-9815-972705026689','student285@example.com','student285','Ping_Žáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+285&background=random','2026-01-24 11:06:20.424','2022-05-24 16:43:39.051','2026-01-24 11:06:20.425',3),
('2548bcf1-c09a-402b-9f20-627c1f13fc9a','teacher57@example.com','teacher57','Jin.Okoth','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+57&background=random','2026-01-24 11:06:19.896','2025-02-20 13:45:25.063','2026-01-24 11:06:19.896',2),
('258db4f0-4776-44fa-8d54-dbfff5c918f2','student112@example.com','student112','Mitsuo.Schneider15','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+112&background=random','2026-01-24 11:06:20.203','2025-01-29 13:51:09.889','2026-01-24 11:06:20.203',3),
('25f0fea0-8986-4aca-947e-08adf4019de8','student682@example.com','student682','Kabiru.Æbeltoft47','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+682&background=random','2026-01-24 11:06:20.880','2024-07-16 01:56:15.597','2026-01-24 11:06:20.880',3),
('2618e8e2-56e6-4c58-94d4-2a2193abf059','student414@example.com','student414','Jose-Maria_Hashimoto3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+414&background=random','2026-01-24 11:06:20.587','2022-02-13 11:39:36.504','2026-01-24 11:06:20.587',3),
('263a5814-5944-489d-9fc4-3b16b4b9a5e7','student779@example.com','student779','Yhudah.Žáková74','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+779&background=random','2026-01-24 11:06:20.992','2022-09-24 03:10:02.701','2026-01-24 11:06:20.992',3),
('265e65b2-fbce-46ea-bb4b-ac57c895eb80','student840@example.com','student840','Xiaoping_Martínez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+840&background=random','2026-01-24 11:06:21.072','2025-01-19 20:31:28.959','2026-01-24 11:06:21.073',3),
('26ed59ea-1318-4340-a5e0-7f6e82699289','student519@example.com','student519','Martha.Szczepański','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+519&background=random','2026-01-24 11:06:20.700','2022-09-21 19:52:27.191','2026-01-24 11:06:20.701',3),
('27125320-c617-4610-8ccb-ff30dc2c7367','student487@example.com','student487','Somphong_Yamada','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+487&background=random','2026-01-24 11:06:20.664','2025-11-26 07:47:48.359','2026-01-24 11:06:20.665',3),
('2733e017-ea52-420d-b51a-27f29f220353','student971@example.com','student971','Katsumi.Volkova84','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+971&background=random','2026-01-24 11:06:21.229','2021-04-09 00:59:21.333','2026-01-24 11:06:21.229',3),
('273e46bd-c1c3-492e-b35b-bb51e229557e','student583@example.com','student583','Michael_Ásgeirsdóttir80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+583&background=random','2026-01-24 11:06:20.771','2023-08-28 03:35:23.873','2026-01-24 11:06:20.772',3),
('27522aa0-ab18-4088-a03f-e61c5a1439fd','student32@example.com','student32','Aleksander.Khan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+32&background=random','2026-01-24 11:06:20.108','2022-01-30 19:23:20.498','2026-01-24 11:06:20.109',3),
('2776789c-a166-4e0a-8b19-cf5a7ac7ee9f','student684@example.com','student684','Justyna_Pospíšil','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+684&background=random','2026-01-24 11:06:20.882','2023-06-03 16:32:54.021','2026-01-24 11:06:20.883',3),
('27a4dff3-a38c-4493-80f5-6cf877ae9937','student564@example.com','student564','Suman_Kondo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+564&background=random','2026-01-24 11:06:20.751','2025-07-27 01:56:36.416','2026-01-24 11:06:20.751',3),
('28220334-8329-407b-8533-7ab16a8fcf5e','student115@example.com','student115','Anong_Tian','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+115&background=random','2026-01-24 11:06:20.206','2024-05-24 15:00:49.456','2026-01-24 11:06:20.207',3),
('2896b742-99d8-429f-92f5-3c2e8762bf33','student229@example.com','student229','Amina_Vásquez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+229&background=random','2026-01-24 11:06:20.352','2021-04-24 18:45:59.933','2026-01-24 11:06:20.353',3),
('28a634b8-ffc2-4c06-91f4-efe8afb4bb8f','student7@example.com','student7','Elizabeth_Van-den-Berg85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+7&background=random','2026-01-24 11:06:20.074','2023-12-28 04:42:02.822','2026-01-24 11:06:20.075',3),
('28dd79e0-e949-45a3-a756-76c92b14ce65','teacher182@example.com','teacher182','Ana.Zemanová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+182&background=random','2026-01-24 11:06:20.045','2023-11-09 21:29:20.739','2026-01-24 11:06:20.046',2),
('28fa01d3-fa94-44b5-8aad-5449f992f53e','student688@example.com','student688','Janusz_Jónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+688&background=random','2026-01-24 11:06:20.886','2024-08-26 04:48:18.333','2026-01-24 11:06:20.887',3),
('29352468-4638-408a-8c2c-2d4df9d0d747','student992@example.com','student992','Santosh_Igwe31','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+992&background=random','2026-01-24 11:06:21.253','2025-09-29 08:02:52.577','2026-01-24 11:06:21.253',3),
('2971935a-3617-4b8e-8be3-a9a6c4452b5b','teacher106@example.com','teacher106','Sani.Kibet23','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+106&background=random','2026-01-24 11:06:19.954','2023-10-18 02:29:29.127','2026-01-24 11:06:19.955',2),
('2989388f-a841-49b3-b22a-f6e3025fb538','student97@example.com','student97','Peng_Zawadzki85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+97&background=random','2026-01-24 11:06:20.182','2025-03-22 00:52:39.291','2026-01-24 11:06:20.182',3),
('29f48f56-842c-473f-9162-e7c96dc7b1dd','student822@example.com','student822','Joy_Paswan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+822&background=random','2026-01-24 11:06:21.054','2024-09-09 18:51:02.365','2026-01-24 11:06:21.054',3),
('2a2fbdb5-ff17-44c7-b583-f5553ce7d7cb','student463@example.com','student463','Laura.Þórðardóttir49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+463&background=random','2026-01-24 11:06:20.639','2021-10-08 01:05:51.401','2026-01-24 11:06:20.640',3),
('2a54e1d9-62cb-41f3-9ecc-98317c7a29a2','teacher43@example.com','teacher43','James.Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+43&background=random','2026-01-24 11:06:19.876','2021-02-02 09:33:20.680','2026-01-24 11:06:19.877',2),
('2a7629fe-a202-4208-9a7e-66b90ca7bfed','student165@example.com','student165','Dariusz_Yoshida92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+165&background=random','2026-01-24 11:06:20.265','2023-06-27 12:25:28.230','2026-01-24 11:06:20.266',3),
('2aa320c6-7387-4e58-b5de-71ba12c4e820','student689@example.com','student689','Bjarni_Müller31','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+689&background=random','2026-01-24 11:06:20.888','2022-09-11 04:45:33.446','2026-01-24 11:06:20.888',3),
('2abfbe3d-9ff0-436c-826d-50e8b89506c0','student781@example.com','student781','Reiko_Králová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+781&background=random','2026-01-24 11:06:20.994','2021-02-13 07:46:12.750','2026-01-24 11:06:20.994',3),
('2ae39141-9e1b-492a-81df-0d43590537ab','teacher98@example.com','teacher98','Mohan.Kjartansdóttir90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+98&background=random','2026-01-24 11:06:19.945','2021-09-27 16:59:47.360','2026-01-24 11:06:19.946',2),
('2af88870-e25f-435b-b2de-14bdac1835d6','student719@example.com','student719','Andreas.Liu10','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+719&background=random','2026-01-24 11:06:20.922','2022-09-07 02:16:17.338','2026-01-24 11:06:20.923',3),
('2b2b376e-5cb1-414d-994e-06702b708f09','student556@example.com','student556','Haim.Cruz62','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+556&background=random','2026-01-24 11:06:20.741','2023-12-20 14:46:54.482','2026-01-24 11:06:20.742',3),
('2b32836b-0dbe-4342-8e8f-cb3cdb4dcec9','student315@example.com','student315','Nan_Hernandez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+315&background=random','2026-01-24 11:06:20.463','2025-04-01 03:49:57.680','2026-01-24 11:06:20.464',3),
('2b52ca6c-bf42-4896-8e7a-fb49dda56bd9','student511@example.com','student511','Nokuthula.Vega','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+511&background=random','2026-01-24 11:06:20.691','2021-05-07 19:28:40.404','2026-01-24 11:06:20.692',3),
('2bb517fe-044a-40df-895a-2011a8dc25ae','student908@example.com','student908','Fran_Jasiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+908&background=random','2026-01-24 11:06:21.150','2021-05-03 11:35:42.031','2026-01-24 11:06:21.150',3),
('2bcc1b2c-00c9-4b6e-a59c-067eb87d377a','teacher190@example.com','teacher190','Aleksandra.Óskarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+190&background=random','2026-01-24 11:06:20.054','2022-12-03 10:13:12.793','2026-01-24 11:06:20.055',2),
('2be772ea-430c-4ff1-aaa9-e71de22b074e','teacher74@example.com','teacher74','Lilja.Kristjánsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+74&background=random','2026-01-24 11:06:19.918','2021-06-14 04:12:05.583','2026-01-24 11:06:19.918',2),
('2c066e20-8194-4c65-afc1-f87e1c5eda6b','student615@example.com','student615','Charoen.Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+615&background=random','2026-01-24 11:06:20.806','2021-09-03 16:11:06.082','2026-01-24 11:06:20.807',3),
('2c0ca04f-0be0-4445-9482-ebd38ffb68e0','student98@example.com','student98','Xin_Ragnarsdóttir71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+98&background=random','2026-01-24 11:06:20.183','2023-09-16 17:43:09.008','2026-01-24 11:06:20.183',3),
('2c24ba15-af52-4d4b-8d37-5afe10e1723c','teacher45@example.com','teacher45','Liping.De-Bruijn','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+45&background=random','2026-01-24 11:06:19.879','2025-06-12 16:26:37.016','2026-01-24 11:06:19.880',2),
('2c29eaa8-c630-4b2e-82f3-a01172d048a9','teacher5@example.com','teacher5','Sipho.Magnúsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+5&background=random','2026-01-24 11:06:19.829','2024-04-14 18:50:15.907','2026-01-24 11:06:19.831',2),
('2c2dd6d4-e2f5-4100-b803-9f0f8ac6a869','student350@example.com','student350','Wilai_Ramirez83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+350&background=random','2026-01-24 11:06:20.507','2025-04-07 03:24:45.580','2026-01-24 11:06:20.507',3),
('2c3daec0-cec9-4a20-8ce8-ac0a60645b30','student209@example.com','student209','Heike.Edwards26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+209&background=random','2026-01-24 11:06:20.328','2021-02-09 01:53:55.874','2026-01-24 11:06:20.329',3),
('2c613a89-cb19-440d-8d8e-239b149e487f','student762@example.com','student762','Joy_Wambui','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+762&background=random','2026-01-24 11:06:20.973','2023-06-25 01:10:24.567','2026-01-24 11:06:20.973',3),
('2c63c2cc-d168-47b4-93c0-8f51f5e18a42','student810@example.com','student810','Wolfgang_Prieto6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+810&background=random','2026-01-24 11:06:21.026','2024-08-23 23:36:17.793','2026-01-24 11:06:21.027',3),
('2cb6acca-5ee4-4a6c-a396-0c9182906b48','student740@example.com','student740','Jose-Antonio.Pospíšil','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+740&background=random','2026-01-24 11:06:20.947','2023-02-01 17:55:43.804','2026-01-24 11:06:20.948',3),
('2cc0bbe8-2372-4a56-8b51-55238577ba75','student881@example.com','student881','Yu_Černá','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+881&background=random','2026-01-24 11:06:21.117','2021-08-11 17:08:07.263','2026-01-24 11:06:21.117',3),
('2cc8aec9-788b-4a01-b850-e7c6a3c1a609','student661@example.com','student661','Idris_Ðorðić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+661&background=random','2026-01-24 11:06:20.857','2023-03-24 12:24:02.702','2026-01-24 11:06:20.857',3),
('2cec373b-518b-41db-8190-6a2fe8f9d824','student953@example.com','student953','Xin.Kamiński37','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+953&background=random','2026-01-24 11:06:21.208','2024-02-09 23:37:10.352','2026-01-24 11:06:21.208',3),
('2cfb5cd6-de55-46eb-9d27-6041ef85ec37','student251@example.com','student251','Somnuek.Ragnarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+251&background=random','2026-01-24 11:06:20.381','2024-08-01 10:29:42.465','2026-01-24 11:06:20.381',3),
('2d7862b9-767d-4171-94de-cc2c0933a05d','student434@example.com','student434','Cheng_Amadi91','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+434&background=random','2026-01-24 11:06:20.608','2022-06-09 13:53:33.332','2026-01-24 11:06:20.609',3),
('2da3ae4c-a0f1-49d5-add8-d11d1f60ba83','student831@example.com','student831','Joyce.Khan10','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+831&background=random','2026-01-24 11:06:21.063','2024-02-26 15:14:36.136','2026-01-24 11:06:21.063',3),
('2da870a8-c940-4ccf-96c3-aef2090f8fea','student392@example.com','student392','Toshiko.Hasegawa33','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+392&background=random','2026-01-24 11:06:20.559','2021-06-24 14:33:22.304','2026-01-24 11:06:20.560',3),
('2dafb3c7-e241-409f-970a-4b3ec28a95cb','student73@example.com','student73','Adamu.Udo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+73&background=random','2026-01-24 11:06:20.155','2021-04-22 11:40:27.212','2026-01-24 11:06:20.156',3),
('2e474c4a-a4e6-49ef-a259-98545f0210dd','student786@example.com','student786','Luis_Halldórsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+786&background=random','2026-01-24 11:06:20.999','2021-03-24 12:10:35.753','2026-01-24 11:06:21.000',3),
('2e73341f-3742-4ffd-be10-c68c7295689a','student79@example.com','student79','Waraphon.Álvarez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+79&background=random','2026-01-24 11:06:20.162','2022-11-02 07:20:59.394','2026-01-24 11:06:20.162',3),
('2ed11103-0c84-4672-a941-36a940d6ec38','teacher81@example.com','teacher81','Sushila_Schröder','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+81&background=random','2026-01-24 11:06:19.926','2024-05-09 13:55:14.499','2026-01-24 11:06:19.926',2),
('2ee4b7a6-4c2e-452a-ac55-bd71b162681b','student951@example.com','student951','Chao_Harðardóttir59','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+951&background=random','2026-01-24 11:06:21.204','2024-01-23 01:13:40.829','2026-01-24 11:06:21.205',3),
('2f394f24-2c73-4cd9-adc1-bebafb32913e','student896@example.com','student896','Fatima.Žukauskas32','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+896&background=random','2026-01-24 11:06:21.136','2025-07-24 10:59:17.860','2026-01-24 11:06:21.136',3),
('2fbbd7fd-5455-470a-adb0-1e2da4ffb6ce','student200@example.com','student200','Asha_Árnason','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+200&background=random','2026-01-24 11:06:20.317','2023-12-17 18:50:48.224','2026-01-24 11:06:20.318',3),
('2fd1303b-a400-44fb-a312-f9429927cb76','student600@example.com','student600','Kazuo_Chávez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+600&background=random','2026-01-24 11:06:20.790','2024-01-02 22:40:04.834','2026-01-24 11:06:20.791',3),
('30061804-417d-40ca-b57a-17fefea7cf46','student985@example.com','student985','Nittaya_Jóhannesdóttir90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+985&background=random','2026-01-24 11:06:21.245','2021-07-13 06:09:58.990','2026-01-24 11:06:21.246',3),
('300bc406-6f61-4cc0-a58c-4e2b03cb4759','student943@example.com','student943','Steve.Jónsson41','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+943&background=random','2026-01-24 11:06:21.192','2024-09-07 15:59:00.645','2026-01-24 11:06:21.193',3),
('3035a707-4276-4e24-b8e5-80edddc36401','student110@example.com','student110','Viktor_Ragnarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+110&background=random','2026-01-24 11:06:20.200','2024-02-07 17:52:26.056','2026-01-24 11:06:20.200',3),
('305b2746-b5ef-48a6-a29c-6c1858401585','student965@example.com','student965','Mateusz.Vazquez13','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+965&background=random','2026-01-24 11:06:21.221','2024-06-24 20:43:24.211','2026-01-24 11:06:21.222',3),
('306084a9-15d1-4c68-b73a-a6ca3cfc69ec','teacher53@example.com','teacher53','Marek_Liu22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+53&background=random','2026-01-24 11:06:19.889','2023-02-09 01:35:19.919','2026-01-24 11:06:19.890',2),
('30671ba9-3fe8-41a7-b273-05d395535b8f','teacher114@example.com','teacher114','Jan_Liang44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+114&background=random','2026-01-24 11:06:19.964','2025-05-21 08:00:04.077','2026-01-24 11:06:19.965',2),
('308033af-3a83-4d20-8f51-4a3eb08eb33b','student261@example.com','student261','Ana-Maria.Janssen','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+261&background=random','2026-01-24 11:06:20.392','2021-03-07 15:42:50.844','2026-01-24 11:06:20.393',3),
('30cefe50-beca-4b34-86b9-94e9864525a2','student324@example.com','student324','Magda_Chepkemoi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+324&background=random','2026-01-24 11:06:20.475','2024-05-14 07:21:23.074','2026-01-24 11:06:20.475',3),
('315676e3-cfc0-411c-866a-7a132455e55d','student653@example.com','student653','Lyudmila.Gutiérrez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+653&background=random','2026-01-24 11:06:20.849','2024-04-29 19:48:58.372','2026-01-24 11:06:20.849',3),
('31583bf5-a6c6-4483-acfe-8d3ae3aae413','student809@example.com','student809','Josefa.Æbelø24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+809&background=random','2026-01-24 11:06:21.025','2021-08-28 02:56:51.722','2026-01-24 11:06:21.026',3),
('316d0458-a237-421f-b51b-af3269cf68a2','student6@example.com','student6','Noriko.Gísladóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+6&background=random','2026-01-24 11:06:20.073','2024-12-31 18:48:32.583','2026-01-24 11:06:20.073',3),
('3178d0b8-9fe5-40a1-9cd2-0212398dac08','teacher14@example.com','teacher14','Catherine_Möller','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+14&background=random','2026-01-24 11:06:19.842','2024-01-01 21:35:39.319','2026-01-24 11:06:19.842',2),
('3232e39d-22af-456c-b5b6-8b22d7dc2671','student332@example.com','student332','Jose.García15','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+332&background=random','2026-01-24 11:06:20.485','2023-08-08 05:33:17.586','2026-01-24 11:06:20.485',3),
('3274c680-cc1f-402d-ac37-4bcb8043aa25','student75@example.com','student75','Nan.Allen93','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+75&background=random','2026-01-24 11:06:20.157','2021-08-10 10:08:23.183','2026-01-24 11:06:20.158',3),
('32c63438-7860-4b31-b96c-2509335eb984','student852@example.com','student852','Joseph_Suzuki83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+852&background=random','2026-01-24 11:06:21.086','2025-02-15 09:15:16.856','2026-01-24 11:06:21.086',3),
('32ce8232-1200-4b12-b916-fa2ae21218ca','student844@example.com','student844','Kai_Krüger65','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+844&background=random','2026-01-24 11:06:21.077','2024-01-26 10:34:51.960','2026-01-24 11:06:21.078',3),
('32d4714d-ca7a-4d2b-8c0d-168ec4cb9e62','teacher107@example.com','teacher107','Yuriy.Øvergård','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+107&background=random','2026-01-24 11:06:19.956','2023-05-13 22:49:32.504','2026-01-24 11:06:19.956',2),
('32df1408-9b0e-4ec5-bcc0-f59d90e0d15d','teacher49@example.com','teacher49','Zandile_Sveinsdóttir97','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+49&background=random','2026-01-24 11:06:19.884','2023-03-18 01:05:51.162','2026-01-24 11:06:19.884',2),
('33a5a45d-31c3-4ebf-8c0a-709839857858','student879@example.com','student879','Aleksandra_Þórðardóttir7','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+879&background=random','2026-01-24 11:06:21.114','2022-02-13 15:59:45.707','2026-01-24 11:06:21.115',3),
('3448d136-d79f-4c9d-a3b1-c84234021ef2','student853@example.com','student853','Jackline.Gutiérrez40','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+853&background=random','2026-01-24 11:06:21.087','2021-04-11 12:37:38.133','2026-01-24 11:06:21.088',3),
('344f5b08-2378-4d63-b994-9dd51ebb3303','student976@example.com','student976','Sri.Baker95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+976&background=random','2026-01-24 11:06:21.236','2025-04-30 15:03:36.839','2026-01-24 11:06:21.237',3),
('347cdabc-973c-4d78-8c82-baa5090333e3','student19@example.com','student19','Suwit.Gísladóttir21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+19&background=random','2026-01-24 11:06:20.090','2024-07-12 19:29:08.464','2026-01-24 11:06:20.090',3),
('349dbba6-cc8c-4d49-b31a-c5d8340679b5','student818@example.com','student818','Ping.Maeda','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+818&background=random','2026-01-24 11:06:21.048','2025-01-13 10:02:56.079','2026-01-24 11:06:21.049',3),
('34ee5a22-8bb9-48d7-a9c0-60135827fa64','student845@example.com','student845','Amphon.Sakamoto','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+845&background=random','2026-01-24 11:06:21.079','2021-07-27 18:02:55.910','2026-01-24 11:06:21.079',3),
('3524e439-affc-47b5-bc60-88292b70d01f','student289@example.com','student289','Salisu.Wagner21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+289&background=random','2026-01-24 11:06:20.429','2025-12-25 02:16:43.996','2026-01-24 11:06:20.430',3),
('3547957c-56e0-438a-b559-04bb61ff6c7e','student954@example.com','student954','Tamar_Edwards','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+954&background=random','2026-01-24 11:06:21.209','2022-10-02 19:38:13.244','2026-01-24 11:06:21.209',3),
('35689f73-a072-46f2-b7cc-d2c47d45205c','student738@example.com','student738','Dmitry.Jóhannesson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+738&background=random','2026-01-24 11:06:20.945','2022-10-02 13:20:40.148','2026-01-24 11:06:20.946',3),
('356e9dee-3649-4d44-affc-9416434e0b08','teacher94@example.com','teacher94','Xiaohong_Walker','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+94&background=random','2026-01-24 11:06:19.939','2023-07-21 08:41:24.550','2026-01-24 11:06:19.940',2),
('3586dac8-b088-4596-ae60-b745bd27a739','teacher183@example.com','teacher183','Masami.Collins69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+183&background=random','2026-01-24 11:06:20.046','2023-07-12 12:55:23.379','2026-01-24 11:06:20.047',2),
('3632528e-1cdb-4983-9dce-41413e60284a','student479@example.com','student479','Kiyoko_Őllösová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+479&background=random','2026-01-24 11:06:20.656','2024-07-25 14:31:49.489','2026-01-24 11:06:20.657',3),
('36d67f69-f5ec-4b4f-b51a-827a6bc5d5b2','teacher25@example.com','teacher25','Masao.Ye','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+25&background=random','2026-01-24 11:06:19.854','2024-03-09 11:20:48.730','2026-01-24 11:06:19.855',2),
('36e9ecda-780b-46f1-a2b2-d5c5431b048e','teacher116@example.com','teacher116','Nadezhda.Guzmán69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+116&background=random','2026-01-24 11:06:19.967','2022-12-22 17:57:02.299','2026-01-24 11:06:19.967',2),
('36f00781-f8ba-4ff0-81fe-4c9551b8d304','student383@example.com','student383','Sebastian_Sun1','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+383&background=random','2026-01-24 11:06:20.549','2021-08-30 10:49:59.001','2026-01-24 11:06:20.549',3),
('370b08c0-7c5d-421a-9461-c6be592a56dd','student120@example.com','student120','Sushila_Chávez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+120&background=random','2026-01-24 11:06:20.211','2022-05-04 05:40:59.074','2026-01-24 11:06:20.212',3),
('371cb7ef-0977-426f-a1d0-1f5180456043','student981@example.com','student981','Joy.Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+981&background=random','2026-01-24 11:06:21.242','2023-11-28 02:50:51.868','2026-01-24 11:06:21.242',3),
('372b68df-f59b-4d3e-9901-dacf773c0cc1','student33@example.com','student33','Johannes.Þorsteinsdóttir58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+33&background=random','2026-01-24 11:06:20.110','2022-01-08 04:13:15.184','2026-01-24 11:06:20.111',3),
('3735b82d-69a4-4a5f-ba2e-905b96a0f9bc','student897@example.com','student897','Hiroko.Æbelø','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+897&background=random','2026-01-24 11:06:21.137','2021-03-06 20:28:49.849','2026-01-24 11:06:21.138',3),
('37745e83-9787-4df5-bcd0-8da9c3f62e40','student166@example.com','student166','Josefa.Pillay','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+166&background=random','2026-01-24 11:06:20.267','2024-09-16 12:18:14.488','2026-01-24 11:06:20.268',3),
('37788b8b-13e6-473d-a8e0-c0f3759ae436','student1@example.com','student1','Francisco-Javier.Ágústsdóttir12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+1&background=random','2026-01-24 11:06:20.067','2025-10-13 04:01:44.700','2026-01-24 11:06:20.068',3),
('37d0a29b-a23c-4020-ad50-47ea3c727809','student789@example.com','student789','George.Harle-Cowan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+789&background=random','2026-01-24 11:06:21.002','2026-01-14 23:04:50.376','2026-01-24 11:06:21.003',3),
('37e95bd4-6574-4518-b8a5-2acc9b444e1b','student914@example.com','student914','Yue.Das47','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+914&background=random','2026-01-24 11:06:21.157','2022-05-12 10:49:40.954','2026-01-24 11:06:21.157',3),
('381c6ba1-9d31-4551-af6e-69a93b8cbbe4','student80@example.com','student80','Somphon.Krüger','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+80&background=random','2026-01-24 11:06:20.163','2022-10-30 05:48:51.509','2026-01-24 11:06:20.164',3),
('383c194e-076c-477e-aa05-8047222c540a','teacher68@example.com','teacher68','Li.Owen98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+68&background=random','2026-01-24 11:06:19.911','2022-12-14 07:21:20.131','2026-01-24 11:06:19.911',2),
('38775fa2-591f-448d-ba9d-f69cbc521cc4','student171@example.com','student171','Hui.Jónasdóttir92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+171&background=random','2026-01-24 11:06:20.275','2023-10-29 05:16:20.368','2026-01-24 11:06:20.275',3),
('38a50dd8-9371-42d5-9863-6ca9b81ca1ae','teacher178@example.com','teacher178','Edda_Chauke','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+178&background=random','2026-01-24 11:06:20.041','2025-09-09 01:04:42.179','2026-01-24 11:06:20.041',2),
('38aa8fd1-5559-43e0-9385-6c83f2eb5522','student498@example.com','student498','Noriko.Æbeltoft66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+498&background=random','2026-01-24 11:06:20.677','2022-10-01 20:09:22.609','2026-01-24 11:06:20.677',3),
('38b9d83c-af44-4ae8-8285-53bd77f0a38e','teacher72@example.com','teacher72','Rebecca_Torres33','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+72&background=random','2026-01-24 11:06:19.916','2022-03-18 02:01:10.058','2026-01-24 11:06:19.916',2),
('38c8e733-1fe2-4e25-b951-018f2b277ee1','student87@example.com','student87','Ying_Smith27','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+87&background=random','2026-01-24 11:06:20.172','2024-04-30 18:51:03.723','2026-01-24 11:06:20.172',3),
('39ad2c8d-934c-48f9-80b0-546df8217d28','student695@example.com','student695','Grzegorz_Schröder','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+695&background=random','2026-01-24 11:06:20.894','2023-01-04 01:11:27.448','2026-01-24 11:06:20.895',3),
('39baa665-f6c6-4063-9676-c6966bb1e87b','student348@example.com','student348','Maria.Luo80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+348&background=random','2026-01-24 11:06:20.504','2024-09-16 21:47:13.953','2026-01-24 11:06:20.505',3),
('39f00fab-b292-4055-b316-ff848c02e3c5','student795@example.com','student795','Patricia_Ūžien','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+795&background=random','2026-01-24 11:06:21.009','2024-01-15 23:52:33.143','2026-01-24 11:06:21.009',3),
('3a42fe63-e7a4-4d93-8cdc-194910191166','student217@example.com','student217','Abdullahi.Kibet','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+217&background=random','2026-01-24 11:06:20.338','2025-10-01 18:17:28.329','2026-01-24 11:06:20.339',3),
('3a6ee6be-be51-4f72-bd2c-8e1d79ffae06','student271@example.com','student271','Koshi_Kwiatkowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+271&background=random','2026-01-24 11:06:20.404','2021-03-22 13:49:49.283','2026-01-24 11:06:20.405',3),
('3a9160db-ccca-49b9-8d79-b519b3210dba','student780@example.com','student780','Ling.Ota','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+780&background=random','2026-01-24 11:06:20.993','2025-01-08 03:53:59.149','2026-01-24 11:06:20.993',3),
('3a9acf60-1da5-4147-93da-a9ff82bac6ac','student266@example.com','student266','Dieter.Kučera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+266&background=random','2026-01-24 11:06:20.398','2021-05-28 02:58:48.627','2026-01-24 11:06:20.399',3),
('3aed6fb2-a0e3-410d-a23d-b0d7663935c2','student549@example.com','student549','Toshiko.Jóhannesdóttir98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+549&background=random','2026-01-24 11:06:20.734','2023-09-19 18:06:08.974','2026-01-24 11:06:20.734',3),
('3b1178d4-d0ac-448a-8de3-0404595c430e','teacher24@example.com','teacher24','Stephen_Veselý12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+24&background=random','2026-01-24 11:06:19.853','2022-03-23 19:00:55.940','2026-01-24 11:06:19.854',2),
('3b5dcd5f-92d6-4b7d-863f-4b89150f14b3','student977@example.com','student977','Piotr_Olszewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+977&background=random','2026-01-24 11:06:21.237','2021-03-29 05:32:03.445','2026-01-24 11:06:21.238',3),
('3ba311e5-14a8-4edb-a672-2d8598195aa8','student502@example.com','student502','Masami.Pétursdóttir59','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+502&background=random','2026-01-24 11:06:20.681','2024-09-03 21:36:14.513','2026-01-24 11:06:20.682',3),
('3bf880cd-d5a3-472f-9923-11746f373cf1','student723@example.com','student723','Miguel.Gutiérrez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+723&background=random','2026-01-24 11:06:20.927','2021-08-17 21:26:58.454','2026-01-24 11:06:20.927',3),
('3c523b6d-512d-4ad1-83fb-545efd1d572b','student74@example.com','student74','Ming.Mazurek','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+74&background=random','2026-01-24 11:06:20.156','2023-02-10 06:39:43.233','2026-01-24 11:06:20.157',3),
('3c5fb63a-1824-4f16-b9ff-44edb6c4000c','student746@example.com','student746','Ning_Vargas','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+746&background=random','2026-01-24 11:06:20.954','2025-05-06 02:59:04.832','2026-01-24 11:06:20.955',3),
('3cd4cfc9-100a-4f71-bca7-f21b4826a4ca','student778@example.com','student778','Gabra.Guzmán40','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+778&background=random','2026-01-24 11:06:20.991','2022-06-24 23:53:15.040','2026-01-24 11:06:20.991',3),
('3cd6f40e-e2e7-4531-9d6f-5730fa344486','student48@example.com','student48','Susan.Sigurðsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+48&background=random','2026-01-24 11:06:20.127','2024-08-26 13:08:08.557','2026-01-24 11:06:20.128',3),
('3cd7163a-1b07-460f-880d-28e6e6f313c1','student658@example.com','student658','Fran_Halldórsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+658&background=random','2026-01-24 11:06:20.854','2025-08-04 07:57:09.623','2026-01-24 11:06:20.854',3),
('3d076b9c-98d6-42ee-bf52-6e1ea7fff80f','student300@example.com','student300','Anan_Kristjánsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+300&background=random','2026-01-24 11:06:20.443','2022-02-26 13:35:48.788','2026-01-24 11:06:20.443',3),
('3d08c6a4-8665-49a7-b3e2-ff336444f180','teacher69@example.com','teacher69','Lijun.Jónasson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+69&background=random','2026-01-24 11:06:19.912','2023-07-25 08:41:16.514','2026-01-24 11:06:19.912',2),
('3d13f797-4042-49ac-bc90-29c4540b0760','teacher22@example.com','teacher22','Xiaoping_Guzmán','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+22&background=random','2026-01-24 11:06:19.851','2022-03-19 10:38:14.930','2026-01-24 11:06:19.852',2),
('3d142a1f-48ea-404c-a056-0811fd385d49','student230@example.com','student230','Vladimir_Gómez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+230&background=random','2026-01-24 11:06:20.353','2024-08-19 01:10:25.388','2026-01-24 11:06:20.354',3),
('3d1f7321-5d8d-4c9f-ba9c-aa3d02f3a175','student474@example.com','student474','Isah.Shi99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+474&background=random','2026-01-24 11:06:20.651','2024-08-26 15:12:52.981','2026-01-24 11:06:20.652',3),
('3d84406f-529a-42ce-bda3-18b84520b961','student772@example.com','student772','Jianhua_Vasilev21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+772&background=random','2026-01-24 11:06:20.985','2022-05-19 09:42:10.451','2026-01-24 11:06:20.985',3),
('3dfa3fd2-eaa0-4837-9a12-8b5791298a03','student473@example.com','student473','Michal.Pálsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+473&background=random','2026-01-24 11:06:20.650','2026-01-12 22:54:15.000','2026-01-24 11:06:20.651',3),
('3e70fabf-eb37-49e7-92e0-1b7390010067','student323@example.com','student323','Margaret_Chávez41','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+323&background=random','2026-01-24 11:06:20.473','2024-02-07 05:48:58.884','2026-01-24 11:06:20.473',3),
('4003594a-7284-4d6c-8c73-e73d3ffb9fa8','student997@example.com','student997','Philip.Jóhannsson35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+997&background=random','2026-01-24 11:06:21.258','2021-04-14 04:59:14.863','2026-01-24 11:06:21.259',3),
('4039483c-43ec-4693-8bdb-4849376e08ed','student807@example.com','student807','Yu.Yamamoto','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+807&background=random','2026-01-24 11:06:21.023','2024-04-08 06:06:54.063','2026-01-24 11:06:21.024',3),
('406fa850-b728-4247-9c0b-23746099e8f1','teacher108@example.com','teacher108','Yu_Kristjánsson17','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+108&background=random','2026-01-24 11:06:19.957','2021-06-15 16:15:17.477','2026-01-24 11:06:19.957',2),
('407569b0-ba53-4ea5-b54f-21f4265ad805','teacher139@example.com','teacher139','Shizuko_Sokołowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+139&background=random','2026-01-24 11:06:19.995','2023-11-03 13:49:16.712','2026-01-24 11:06:19.995',2),
('40974819-cf09-416e-9370-a87f56247c62','student846@example.com','student846','Pilar_Gómez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+846&background=random','2026-01-24 11:06:21.080','2021-08-25 04:12:03.666','2026-01-24 11:06:21.080',3),
('40b9efba-ff15-4e2e-a703-fc74e9d40fe8','student65@example.com','student65','Ali.Schmitz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+65&background=random','2026-01-24 11:06:20.147','2023-10-28 00:48:06.107','2026-01-24 11:06:20.148',3),
('40cefebb-3ebf-47a5-b222-e3e9719b170b','student397@example.com','student397','Rong.Huber22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+397&background=random','2026-01-24 11:06:20.564','2022-03-14 14:02:44.430','2026-01-24 11:06:20.565',3),
('411d8b15-4cf4-4e00-97ac-daf549c12ca4','teacher194@example.com','teacher194','Amnuai.Zieliński65','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+194&background=random','2026-01-24 11:06:20.058','2023-02-25 20:12:15.721','2026-01-24 11:06:20.059',2),
('41272e4f-e382-4e09-b470-3c9020783108','student472@example.com','student472','Sibusiso.Luo94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+472&background=random','2026-01-24 11:06:20.649','2024-02-09 10:05:50.786','2026-01-24 11:06:20.650',3),
('413d5b44-98c4-45ad-abc3-a4f5a0b3203a','student742@example.com','student742','Noam.Bunma66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+742&background=random','2026-01-24 11:06:20.950','2025-10-27 14:22:55.419','2026-01-24 11:06:20.950',3),
('41404c89-3acb-46d1-80b0-353d0c2fe48f','student305@example.com','student305','John_Rani','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+305&background=random','2026-01-24 11:06:20.450','2021-08-04 00:04:22.286','2026-01-24 11:06:20.451',3),
('417ff94a-aaaf-40fc-b378-5ce487e1422f','student44@example.com','student44','Gabra_Ólafsdóttir88','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+44&background=random','2026-01-24 11:06:20.122','2024-05-16 20:28:09.132','2026-01-24 11:06:20.123',3),
('42215a29-b567-4df2-b468-e37d78e02337','student452@example.com','student452','Ko_Jóhannesson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+452&background=random','2026-01-24 11:06:20.627','2023-02-26 20:12:21.502','2026-01-24 11:06:20.628',3),
('425386ca-6008-4f5a-8f4b-7abab95d64d4','student706@example.com','student706','Catherine_Radebe','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+706&background=random','2026-01-24 11:06:20.908','2022-04-17 21:47:59.130','2026-01-24 11:06:20.908',3),
('42756559-8290-4d89-b099-2a4852a7d808','student432@example.com','student432','Svetlana.Möller69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+432&background=random','2026-01-24 11:06:20.606','2024-01-29 06:22:08.159','2026-01-24 11:06:20.607',3),
('428c4718-0786-4d87-ac2b-dcc63172bacc','student488@example.com','student488','Karen.Okoro','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+488&background=random','2026-01-24 11:06:20.665','2025-11-06 05:31:26.146','2026-01-24 11:06:20.666',3),
('42ce4369-f03e-4fc6-9cb3-1bdd7234fd0a','student806@example.com','student806','Wei_Sigurðardóttir60','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+806&background=random','2026-01-24 11:06:21.022','2021-02-24 03:00:31.618','2026-01-24 11:06:21.023',3),
('4301af47-7453-4447-bbf1-483975c71d24','student234@example.com','student234','Tomiko.Tanaka','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+234&background=random','2026-01-24 11:06:20.358','2024-05-06 12:07:57.069','2026-01-24 11:06:20.359',3),
('430c4f4c-2e29-48e0-9b9c-8d474d1d8072','student433@example.com','student433','Michiko_Iglesias74','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+433&background=random','2026-01-24 11:06:20.607','2023-06-01 21:22:17.323','2026-01-24 11:06:20.608',3),
('4313b752-f1fc-4af8-aad4-adeae78769c4','student547@example.com','student547','Lijun.Guðmundsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+547&background=random','2026-01-24 11:06:20.731','2024-10-07 03:52:40.619','2026-01-24 11:06:20.732',3),
('436850a8-e7d5-47e9-ba97-2511870c7711','student99@example.com','student99','Ekaterina.Kaur','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+99&background=random','2026-01-24 11:06:20.183','2025-03-08 12:07:10.513','2026-01-24 11:06:20.184',3),
('43e707d2-ba55-415b-a25b-1ad7a48bb3ce','student561@example.com','student561','Mpho_Simiyu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+561&background=random','2026-01-24 11:06:20.747','2021-10-02 20:25:47.964','2026-01-24 11:06:20.748',3),
('44182347-7de9-4c3e-8566-66c6f7108b32','student417@example.com','student417','Joan_Nuñez51','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+417&background=random','2026-01-24 11:06:20.590','2021-05-29 16:11:31.017','2026-01-24 11:06:20.591',3),
('4467a1aa-a1cb-48ac-b352-77c76c4cf524','student189@example.com','student189','Jianhua_Þórðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+189&background=random','2026-01-24 11:06:20.302','2022-12-30 01:42:40.317','2026-01-24 11:06:20.303',3),
('4479cbc9-c210-480f-8c9c-e2a074f71ef4','student202@example.com','student202','Qing_Tan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+202&background=random','2026-01-24 11:06:20.320','2022-11-04 19:26:40.510','2026-01-24 11:06:20.320',3),
('44c0f912-383a-4958-903f-fbdf889f2899','student476@example.com','student476','Mohan_Weiß','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+476&background=random','2026-01-24 11:06:20.653','2025-06-21 13:21:56.416','2026-01-24 11:06:20.654',3),
('44c6b8f8-48c4-40ae-88cf-63b42fd27692','teacher128@example.com','teacher128','Andrzej.Benešová75','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+128&background=random','2026-01-24 11:06:19.981','2021-02-05 13:21:46.182','2026-01-24 11:06:19.982',2),
('45054925-f490-45af-a9a1-f289cdeb1e5c','student922@example.com','student922','Busisiwe_Kjartansson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+922&background=random','2026-01-24 11:06:21.166','2025-08-31 19:27:31.928','2026-01-24 11:06:21.167',3),
('45299cf6-cd2b-4f0c-866d-c57eb46ad41c','student704@example.com','student704','Jackline.Cruz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+704&background=random','2026-01-24 11:06:20.905','2024-07-26 11:45:18.630','2026-01-24 11:06:20.906',3),
('458b30a6-732c-4888-8360-72f1289ade74','student8@example.com','student8','Pawel.Ðekić98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+8&background=random','2026-01-24 11:06:20.076','2024-05-06 07:49:49.413','2026-01-24 11:06:20.077',3),
('45d05c7b-fdda-4cc6-a3fd-8dbffe344c3b','student530@example.com','student530','Heike.Pokorný','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+530&background=random','2026-01-24 11:06:20.712','2024-05-27 04:37:52.745','2026-01-24 11:06:20.713',3),
('45f30f1c-f92c-42f4-b513-2964330abe28','student520@example.com','student520','Birna_Wright98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+520&background=random','2026-01-24 11:06:20.701','2021-09-10 01:49:28.252','2026-01-24 11:06:20.702',3),
('45f5f14d-3b3a-45b0-8b20-d08b329b3f52','student667@example.com','student667','Hendrik_Olszewski71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+667&background=random','2026-01-24 11:06:20.863','2021-11-04 07:57:57.896','2026-01-24 11:06:20.863',3),
('461a6942-e43f-47a5-8a75-1dfd0eb3d63e','student927@example.com','student927','Artur_Isah','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+927&background=random','2026-01-24 11:06:21.171','2022-07-15 20:12:19.810','2026-01-24 11:06:21.172',3),
('46a22bf9-d964-482a-8447-5e20467d1a79','student728@example.com','student728','Nathan_Stefánsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+728&background=random','2026-01-24 11:06:20.933','2025-08-12 13:35:02.188','2026-01-24 11:06:20.934',3),
('46a28e05-130e-47b2-97f7-251d3a110846','student158@example.com','student158','Wilai.Sarkar66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+158&background=random','2026-01-24 11:06:20.257','2022-12-29 04:37:16.557','2026-01-24 11:06:20.257',3),
('46dbd5a8-c0ce-44ce-9ef7-b76f6e20ab88','teacher122@example.com','teacher122','John_Pétursson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+122&background=random','2026-01-24 11:06:19.974','2021-12-16 17:45:47.715','2026-01-24 11:06:19.975',2),
('46ef5692-7ca1-48b0-ac24-50dc04072095','student26@example.com','student26','Kasia_Goto','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+26&background=random','2026-01-24 11:06:20.099','2022-02-06 11:37:42.960','2026-01-24 11:06:20.100',3),
('47246333-500b-4506-b309-f8ad7d629f87','student393@example.com','student393','Usha.Pugh35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+393&background=random','2026-01-24 11:06:20.560','2024-02-14 23:18:17.674','2026-01-24 11:06:20.561',3),
('472a5aaf-e54c-422f-bbc7-f3a4c41d9b4d','student721@example.com','student721','Wilai.Pétursson90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+721&background=random','2026-01-24 11:06:20.924','2024-02-07 01:14:46.397','2026-01-24 11:06:20.925',3),
('4743d799-ef55-42e1-9629-d1dbe90aca50','student425@example.com','student425','Urmila_Das','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+425&background=random','2026-01-24 11:06:20.599','2024-05-23 03:58:48.949','2026-01-24 11:06:20.599',3),
('476c99bf-8c64-4904-9b54-94b8c3130411','student90@example.com','student90','Chayah_Svoboda','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+90&background=random','2026-01-24 11:06:20.175','2023-09-09 10:51:03.747','2026-01-24 11:06:20.175',3),
('47840ff1-ba22-4403-94a5-32739c0d6598','student58@example.com','student58','Ian.Wei62','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+58&background=random','2026-01-24 11:06:20.139','2022-11-19 13:19:49.816','2026-01-24 11:06:20.139',3),
('47a546c9-0e52-4cba-8bc4-b17f6c5cfb4b','student880@example.com','student880','Anita.Song','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+880&background=random','2026-01-24 11:06:21.116','2024-11-26 14:49:14.097','2026-01-24 11:06:21.116',3),
('47f9533b-6514-4200-8bcf-d4be127d8140','student580@example.com','student580','Atli_Łapiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+580&background=random','2026-01-24 11:06:20.768','2023-05-07 16:58:43.952','2026-01-24 11:06:20.769',3),
('484bcca9-18b7-4703-ac35-abd48eea363e','teacher102@example.com','teacher102','Jabulani.Karlsdóttir51','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+102&background=random','2026-01-24 11:06:19.950','2021-07-22 23:42:02.661','2026-01-24 11:06:19.951',2),
('488395f1-ccab-4ef3-9247-690972cbc5ca','student933@example.com','student933','Lukasz_Kučerová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+933&background=random','2026-01-24 11:06:21.178','2023-06-29 10:44:46.620','2026-01-24 11:06:21.179',3),
('488e9f37-121f-4736-9809-240a1858349b','student508@example.com','student508','Chao.Karlsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+508&background=random','2026-01-24 11:06:20.687','2024-01-08 06:22:18.248','2026-01-24 11:06:20.688',3),
('49261fda-81dd-4d96-bc90-48b72e8273a0','student284@example.com','student284','Mpho.Haraldsdóttir43','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+284&background=random','2026-01-24 11:06:20.423','2021-08-24 14:47:31.124','2026-01-24 11:06:20.424',3),
('4930b844-566f-4807-800c-f19038a0335b','student82@example.com','student82','Yoshie_Schmid','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+82&background=random','2026-01-24 11:06:20.166','2021-03-09 18:46:58.644','2026-01-24 11:06:20.167',3),
('495dbbdd-6e81-47f2-a446-e70376f23715','student527@example.com','student527','Lalita_Mhlongo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+527&background=random','2026-01-24 11:06:20.709','2022-04-18 06:05:46.841','2026-01-24 11:06:20.709',3),
('4978ca56-ddb5-4ae2-9fde-bfcb52bd5b1e','student925@example.com','student925','Aleksandr.Hájek','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+925&background=random','2026-01-24 11:06:21.169','2021-02-20 20:52:45.321','2026-01-24 11:06:21.170',3),
('49cda4af-0c4f-4489-a501-f095681abb25','student54@example.com','student54','Umar.Jóhannsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+54&background=random','2026-01-24 11:06:20.135','2024-04-28 15:25:11.236','2026-01-24 11:06:20.135',3),
('49d99061-0280-4498-9ba6-fb57ec9820ab','student581@example.com','student581','Victor.Guðmundsson65','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+581&background=random','2026-01-24 11:06:20.769','2025-01-09 05:11:16.903','2026-01-24 11:06:20.770',3),
('4a064a1c-89ba-49fa-9a7e-92f31318a25f','student864@example.com','student864','Hiromi_Owino','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+864&background=random','2026-01-24 11:06:21.099','2024-12-19 21:42:07.128','2026-01-24 11:06:21.100',3),
('4a28e1d7-0e9f-47b1-8826-e678be8c995d','teacher13@example.com','teacher13','Wichai_Łapiński28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+13&background=random','2026-01-24 11:06:19.840','2024-02-04 12:31:37.330','2026-01-24 11:06:19.841',2),
('4a33a163-4175-493f-a0e5-c801efe17fbc','student753@example.com','student753','Urmila.Krejčí44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+753&background=random','2026-01-24 11:06:20.962','2023-09-19 18:21:31.719','2026-01-24 11:06:20.963',3),
('4a4f3b2c-af7c-4c96-b645-fbcae9a1375f','student716@example.com','student716','Gary.Ren74','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+716&background=random','2026-01-24 11:06:20.918','2025-09-13 13:52:09.613','2026-01-24 11:06:20.919',3),
('4b0186de-ca1c-4d60-9205-f9a0f82ceceb','student183@example.com','student183','Noam_Guðjónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+183&background=random','2026-01-24 11:06:20.294','2023-12-25 12:01:28.538','2026-01-24 11:06:20.295',3),
('4bc40f07-9f81-4fc6-9c76-798e6fab6c0a','student748@example.com','student748','Agata.Omer82','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+748&background=random','2026-01-24 11:06:20.957','2024-12-09 07:05:11.232','2026-01-24 11:06:20.957',3),
('4c0df78b-41a5-41bf-a41e-1b7e9e126148','student490@example.com','student490','Helga.Schröder','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+490&background=random','2026-01-24 11:06:20.668','2025-10-22 23:11:25.668','2026-01-24 11:06:20.668',3),
('4c0fa961-b28f-4f5e-9745-2973addf27e5','student958@example.com','student958','Chanah_Ãshaikh','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+958&background=random','2026-01-24 11:06:21.214','2025-02-01 09:41:46.053','2026-01-24 11:06:21.214',3),
('4cba9316-e898-4583-b616-e3e3e473f108','student368@example.com','student368','Gita.Förster','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+368&background=random','2026-01-24 11:06:20.529','2023-07-20 22:38:20.878','2026-01-24 11:06:20.530',3),
('4d0bcb7b-355e-43de-b5d1-82da4b2e9d73','student296@example.com','student296','Sawat.White88','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+296&background=random','2026-01-24 11:06:20.437','2021-09-05 03:25:40.707','2026-01-24 11:06:20.438',3),
('4d5fca44-0cae-4b80-9815-88df8402c435','teacher165@example.com','teacher165','Sri_Gil24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+165&background=random','2026-01-24 11:06:20.026','2024-01-22 22:25:52.453','2026-01-24 11:06:20.026',2),
('4dca6c5f-a37c-4a7e-a73e-9790d8cb5114','student736@example.com','student736','Roy.Bala8','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+736&background=random','2026-01-24 11:06:20.942','2022-12-04 09:10:34.378','2026-01-24 11:06:20.943',3),
('4e0c6b9e-6124-46b4-86f3-ebfda13ca7e5','student184@example.com','student184','Kasia_Harðardóttir49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+184&background=random','2026-01-24 11:06:20.295','2024-06-11 07:57:33.477','2026-01-24 11:06:20.296',3),
('4e6e9e29-e434-4217-a47f-cc60d8180d18','student72@example.com','student72','Krishna.Szczepański','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+72&background=random','2026-01-24 11:06:20.154','2021-10-18 02:28:02.723','2026-01-24 11:06:20.155',3),
('4e6fec63-63fa-4716-adfa-085c548f2124','teacher160@example.com','teacher160','Lucy_Reuben','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+160&background=random','2026-01-24 11:06:20.019','2023-03-10 16:35:39.220','2026-01-24 11:06:20.020',2),
('4e932435-c5e2-4761-b579-c3ff25343801','student676@example.com','student676','Kamil.Pérez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+676&background=random','2026-01-24 11:06:20.872','2025-06-11 08:37:21.244','2026-01-24 11:06:20.873',3),
('4ec99c75-d28f-4cea-bb19-dbead559e640','student123@example.com','student123','Angela_Urbański89','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+123&background=random','2026-01-24 11:06:20.214','2021-12-30 06:52:43.361','2026-01-24 11:06:20.215',3),
('4efdd85b-b248-4906-a291-93e6864ed88d','student764@example.com','student764','Jianhua_Kamiński83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+764&background=random','2026-01-24 11:06:20.975','2021-05-16 16:35:01.921','2026-01-24 11:06:20.976',3),
('4f6a68ea-fdf5-4881-824d-96676b731e6a','student478@example.com','student478','Shizuko_Baldursdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+478&background=random','2026-01-24 11:06:20.655','2022-01-12 22:54:11.582','2026-01-24 11:06:20.656',3),
('4f6fcd60-4b58-48fc-b179-3cff035851bf','student944@example.com','student944','Yan.Göbel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+944&background=random','2026-01-24 11:06:21.194','2024-12-25 07:03:48.996','2026-01-24 11:06:21.195',3),
('4f70b22e-4c02-4d04-82ae-0e4a6ce9b31f','student506@example.com','student506','Yukio.Dekker','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+506&background=random','2026-01-24 11:06:20.685','2022-11-20 10:08:09.815','2026-01-24 11:06:20.686',3),
('4fb6ac8b-7c89-4f10-94b3-2af48bc458a6','student727@example.com','student727','Hong.Ðorðić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+727&background=random','2026-01-24 11:06:20.932','2024-08-17 11:32:50.290','2026-01-24 11:06:20.933',3),
('4fc03d4d-b084-4e21-b17b-af680dce83fc','student466@example.com','student466','Yan_Pillay73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+466&background=random','2026-01-24 11:06:20.642','2021-09-25 12:06:56.335','2026-01-24 11:06:20.643',3),
('4fcf7ff1-7eb3-4d66-8098-fc21dbeb4240','teacher61@example.com','teacher61','Vincent_Rutkowski87','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+61&background=random','2026-01-24 11:06:19.901','2022-10-02 12:16:07.410','2026-01-24 11:06:19.901',2),
('4fd25c4c-c63f-495f-8156-29a6b44f890d','student59@example.com','student59','Wirot_Kamiński62','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+59&background=random','2026-01-24 11:06:20.140','2025-05-28 02:50:17.439','2026-01-24 11:06:20.140',3),
('4fd42d06-2b1c-49a8-84e7-3878fe0b66f7','teacher151@example.com','teacher151','Sukanya_Ríos17','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+151&background=random','2026-01-24 11:06:20.008','2021-05-31 15:04:26.369','2026-01-24 11:06:20.009',2),
('5020cc7a-26ce-499c-bc7c-198e9a5c5b00','student312@example.com','student312','Eugenia_Muñoz20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+312&background=random','2026-01-24 11:06:20.459','2021-09-06 12:40:43.079','2026-01-24 11:06:20.460',3),
('50abf339-a2a1-4816-a188-1948cf47a9ef','student870@example.com','student870','Marta.Van-den-Berg45','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+870&background=random','2026-01-24 11:06:21.106','2023-11-19 02:54:08.450','2026-01-24 11:06:21.106',3),
('50b5c527-d40f-41b1-9ab9-7d310fa94020','teacher50@example.com','teacher50','Santosh_Halldórsdóttir99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+50&background=random','2026-01-24 11:06:19.885','2021-12-29 00:15:42.141','2026-01-24 11:06:19.886',2),
('50e681e3-edd6-42c2-8b06-e3831f0ff0d9','student984@example.com','student984','Patricia.Jabłoński63','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+984&background=random','2026-01-24 11:06:21.244','2023-09-18 05:31:53.815','2026-01-24 11:06:21.245',3),
('50fa6bb1-60fe-41c7-b264-bf5f07730bbb','student636@example.com','student636','Yue_García29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+636&background=random','2026-01-24 11:06:20.829','2024-03-14 21:56:34.696','2026-01-24 11:06:20.830',3),
('5100857a-e190-455a-8f22-a01ab96e3bf3','student24@example.com','student24','Xiaoping.Cohen','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+24&background=random','2026-01-24 11:06:20.097','2025-11-01 00:51:57.066','2026-01-24 11:06:20.098',3),
('5148289e-312f-47d2-8629-321dc4dd85d7','student747@example.com','student747','Shay.Förster','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+747&background=random','2026-01-24 11:06:20.956','2024-04-21 01:55:25.951','2026-01-24 11:06:20.956',3),
('521b7594-17b0-4949-8f50-3f1c627a968c','student994@example.com','student994','Christine.Árnason','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+994&background=random','2026-01-24 11:06:21.255','2024-01-25 22:15:39.662','2026-01-24 11:06:21.256',3),
('52ad9f87-9ee8-4b69-bffb-c8bf2a384b7d','student894@example.com','student894','Jesus.Pétursson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+894&background=random','2026-01-24 11:06:21.133','2024-11-10 20:16:41.414','2026-01-24 11:06:21.133',3),
('52c788f2-a514-44be-a77f-9c5031328f31','student601@example.com','student601','Avraham.Chanthara8','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+601&background=random','2026-01-24 11:06:20.791','2024-06-21 04:35:18.684','2026-01-24 11:06:20.792',3),
('52fb0321-1f62-4c8b-bf0d-f2c564b54e53','student401@example.com','student401','Ning_Gonzalez76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+401&background=random','2026-01-24 11:06:20.570','2025-08-21 07:01:55.866','2026-01-24 11:06:20.570',3),
('531fc8cc-1b32-4155-b048-7e46f00e6a61','student291@example.com','student291','Gerhard_Procházka','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+291&background=random','2026-01-24 11:06:20.431','2025-12-19 16:59:15.562','2026-01-24 11:06:20.432',3),
('532c1d4b-cce9-40e5-834f-180642ca5a85','student280@example.com','student280','Ryan_Sahu15','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+280&background=random','2026-01-24 11:06:20.418','2022-08-03 10:04:45.778','2026-01-24 11:06:20.418',3),
('53578dc1-8317-4025-80a7-c9994e874fbb','student722@example.com','student722','Na.Yakubu50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+722&background=random','2026-01-24 11:06:20.925','2025-09-11 15:07:13.775','2026-01-24 11:06:20.926',3),
('53baad3a-b26e-442c-89e3-3e098483e6c2','student510@example.com','student510','Jianping_Gao99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+510&background=random','2026-01-24 11:06:20.690','2023-05-07 07:03:20.240','2026-01-24 11:06:20.691',3),
('53c914a7-01c0-47d1-8160-e6f895c4c3b1','student522@example.com','student522','Akira_Kjartansdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+522&background=random','2026-01-24 11:06:20.703','2025-08-19 05:45:54.677','2026-01-24 11:06:20.704',3),
('53fae72f-8bf6-4fdb-addf-3f7b4ce8f41e','student162@example.com','student162','Lan.Martínez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+162&background=random','2026-01-24 11:06:20.262','2023-08-29 20:26:40.946','2026-01-24 11:06:20.262',3),
('5422a85b-cf62-4e89-8efc-5af756354ddc','student915@example.com','student915','Blessing_Jiménez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+915&background=random','2026-01-24 11:06:21.158','2023-01-13 02:07:23.888','2026-01-24 11:06:21.158',3),
('5425c9c5-e69a-4221-88b2-4b470d7c8e8c','student28@example.com','student28','Konstantin.Halldórsson77','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+28&background=random','2026-01-24 11:06:20.102','2022-02-25 03:08:31.245','2026-01-24 11:06:20.103',3),
('5436b84e-46db-4729-a3d9-a6da748ad538','teacher170@example.com','teacher170','Ping.Sibiya22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+170&background=random','2026-01-24 11:06:20.031','2023-10-02 15:52:31.863','2026-01-24 11:06:20.032',2),
('544c9432-43f0-4a30-ae3f-0e897c52a45c','student255@example.com','student255','Jason.Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+255&background=random','2026-01-24 11:06:20.385','2021-02-28 09:08:06.223','2026-01-24 11:06:20.386',3),
('546749d1-c720-4069-9b50-0a10a3e67ec9','student705@example.com','student705','Yu_Novotný','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+705&background=random','2026-01-24 11:06:20.906','2024-02-06 17:33:04.082','2026-01-24 11:06:20.907',3),
('547a58b8-317a-43bc-b60c-3dc7c673bc50','student788@example.com','student788','Sara_Baloyi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+788&background=random','2026-01-24 11:06:21.001','2023-01-10 00:32:21.684','2026-01-24 11:06:21.002',3),
('54932903-3fd7-4e20-a206-c9cd5725113b','student830@example.com','student830','Dilip_Mohammed14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+830&background=random','2026-01-24 11:06:21.062','2025-04-23 09:52:34.507','2026-01-24 11:06:21.063',3),
('54acdcb7-7123-4c74-9199-e6f0609285c4','student145@example.com','student145','Lihua_Hughes25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+145&background=random','2026-01-24 11:06:20.239','2025-05-26 10:32:19.294','2026-01-24 11:06:20.240',3),
('54af80cc-614f-4e74-ad32-c2579525ff62','teacher167@example.com','teacher167','William_Gísladóttir22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+167&background=random','2026-01-24 11:06:20.028','2025-11-23 09:39:02.121','2026-01-24 11:06:20.029',2),
('54e3b445-e081-4d74-9371-e3cf7e66ac4c','teacher197@example.com','teacher197','Aliyu_Horák','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+197&background=random','2026-01-24 11:06:20.062','2022-05-11 19:11:31.979','2026-01-24 11:06:20.063',2),
('5503007e-1c97-446d-af7e-feaca97e4c31','student949@example.com','student949','Elisabeth_Gunnarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+949&background=random','2026-01-24 11:06:21.202','2023-10-27 10:49:24.380','2026-01-24 11:06:21.202',3),
('5564ba19-d76b-48b8-b7f1-402665857fd4','student921@example.com','student921','Lijun_Halldórsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+921&background=random','2026-01-24 11:06:21.165','2024-06-26 03:07:56.825','2026-01-24 11:06:21.166',3),
('55baf29a-6940-4813-9f74-2c7cb34694d9','teacher179@example.com','teacher179','Salisu.Őhlschlägerová18','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+179&background=random','2026-01-24 11:06:20.042','2024-01-06 09:17:04.331','2026-01-24 11:06:20.042',2),
('55c6bc93-0f8d-4676-955a-dafce7419e65','student596@example.com','student596','Ying.Urbański64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+596&background=random','2026-01-24 11:06:20.786','2022-03-26 02:16:51.372','2026-01-24 11:06:20.786',3),
('564de3fb-534a-422e-8628-95fbb2500f1a','student744@example.com','student744','Birgit.Kučera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+744&background=random','2026-01-24 11:06:20.952','2025-05-15 02:43:36.493','2026-01-24 11:06:20.953',3),
('565b507b-da16-47d1-a208-12086d51255e','student839@example.com','student839','Hans-Ulrich_Pétursdóttir90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+839&background=random','2026-01-24 11:06:21.071','2022-07-22 06:27:45.231','2026-01-24 11:06:21.072',3),
('566fce92-a726-4ce2-9aa0-cebfa40c5538','student499@example.com','student499','Tal_Björnsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+499&background=random','2026-01-24 11:06:20.678','2021-03-21 07:34:30.373','2026-01-24 11:06:20.678',3),
('569274db-f9fb-4724-98e7-1e374d49921c','teacher104@example.com','teacher104','Salisu_Kok6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+104&background=random','2026-01-24 11:06:19.952','2021-01-26 20:34:10.270','2026-01-24 11:06:19.953',2),
('57a4c294-6092-447a-aad8-0d340bb96c50','student543@example.com','student543','Xiaoyan_Őri18','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+543&background=random','2026-01-24 11:06:20.726','2021-12-08 20:08:00.368','2026-01-24 11:06:20.727',3),
('586b56d1-6602-438e-89ab-d54ed1165664','student699@example.com','student699','Dorota_Matthews','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+699&background=random','2026-01-24 11:06:20.899','2023-07-03 07:38:58.191','2026-01-24 11:06:20.899',3),
('5879b531-5fd9-4380-b746-23541724786c','student168@example.com','student168','Qiang.Mhamid9','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+168&background=random','2026-01-24 11:06:20.270','2025-03-10 10:11:41.543','2026-01-24 11:06:20.271',3),
('58c0fe43-f19c-4c17-ac59-14c6ced38adf','student652@example.com','student652','Shoji_Łuczak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+652&background=random','2026-01-24 11:06:20.848','2024-03-19 12:51:20.607','2026-01-24 11:06:20.848',3),
('58d85c69-07f3-4b06-8c25-da2d447a21e8','teacher172@example.com','teacher172','Maksim_Lange','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+172&background=random','2026-01-24 11:06:20.034','2023-02-21 16:20:56.406','2026-01-24 11:06:20.034',2),
('592b2a76-c34b-4fe6-a8e8-eff33d5bc7aa','teacher97@example.com','teacher97','Somphong.Kjartansson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+97&background=random','2026-01-24 11:06:19.943','2026-01-07 14:33:26.747','2026-01-24 11:06:19.944',2),
('597360a5-6c99-4bf0-87de-c75dc9c16b06','student639@example.com','student639','Adamu.Yamaguchi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+639&background=random','2026-01-24 11:06:20.833','2023-03-15 04:37:52.827','2026-01-24 11:06:20.833',3),
('59b2a6b4-ace5-499a-9b7c-2f521132913d','student662@example.com','student662','Heike.Procházka','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+662&background=random','2026-01-24 11:06:20.858','2025-12-19 10:12:35.918','2026-01-24 11:06:20.858',3),
('5a2be748-a9f6-44cc-957c-5209f89b3fe7','student92@example.com','student92','Kai_Jakubowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+92&background=random','2026-01-24 11:06:20.177','2021-03-31 12:18:23.966','2026-01-24 11:06:20.177',3),
('5a55e015-34c4-4dae-97f8-570fecc9edd4','student855@example.com','student855','Yoko.Marková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+855&background=random','2026-01-24 11:06:21.089','2021-08-18 18:25:17.426','2026-01-24 11:06:21.090',3),
('5a71f496-d75e-4cf7-9cbb-c9eddd354b35','student843@example.com','student843','Jianping.Gutiérrez66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+843&background=random','2026-01-24 11:06:21.076','2022-12-26 12:59:40.501','2026-01-24 11:06:21.077',3),
('5aa438f9-da52-4226-9f42-1de5005608b8','student337@example.com','student337','Chen.Björnsson22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+337&background=random','2026-01-24 11:06:20.490','2023-03-01 08:36:44.166','2026-01-24 11:06:20.491',3),
('5afca1ca-b633-4923-a21d-7ea5006f68c7','student665@example.com','student665','Jin_Stefánsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+665&background=random','2026-01-24 11:06:20.861','2021-10-23 20:58:26.458','2026-01-24 11:06:20.862',3),
('5b2c7ee0-2adb-42d9-9959-a77c1d1a15b5','teacher166@example.com','teacher166','Rattana_Romanova57','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+166&background=random','2026-01-24 11:06:20.027','2022-03-08 22:33:10.149','2026-01-24 11:06:20.028',2),
('5b7a921c-cfc0-41bb-b88f-702435f75f54','student127@example.com','student127','Ivan_Chauke34','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+127&background=random','2026-01-24 11:06:20.219','2022-02-03 07:09:15.492','2026-01-24 11:06:20.219',3),
('5bb8ff63-0c8a-4f4e-a011-e431f0b88091','teacher99@example.com','teacher99','Joanna_Greenberg','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+99&background=random','2026-01-24 11:06:19.946','2025-08-07 01:50:31.036','2026-01-24 11:06:19.947',2),
('5c4ccbf7-1b3b-4f1e-bf56-b2992d7c67f5','teacher193@example.com','teacher193','Urmila_Ðekić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+193&background=random','2026-01-24 11:06:20.057','2024-08-08 07:02:15.133','2026-01-24 11:06:20.058',2),
('5c73dc54-5b1f-4970-86ce-d53e5464820c','student701@example.com','student701','Ping_Jabarin','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+701&background=random','2026-01-24 11:06:20.902','2022-11-12 22:47:58.339','2026-01-24 11:06:20.902',3),
('5c804bc3-70e7-4d5e-974e-71728464b7f1','teacher30@example.com','teacher30','Yong_Haraldsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+30&background=random','2026-01-24 11:06:19.860','2025-05-25 12:26:47.792','2026-01-24 11:06:19.861',2),
('5ca1ed1b-e470-4bf4-ab37-5ee951e352bb','student51@example.com','student51','Yun.Pérez65','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+51&background=random','2026-01-24 11:06:20.131','2023-03-11 10:09:27.803','2026-01-24 11:06:20.132',3),
('5cac5908-6c9d-4819-930d-2d0cb3010b0f','student418@example.com','student418','Zandile.Sun','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+418&background=random','2026-01-24 11:06:20.591','2024-10-10 17:51:15.075','2026-01-24 11:06:20.592',3),
('5d3a2ea0-dcad-4a5d-8a61-af7785e24128','teacher157@example.com','teacher157','Cheng.Mtshali73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+157&background=random','2026-01-24 11:06:20.015','2024-02-25 05:44:51.366','2026-01-24 11:06:20.016',2),
('5d4ef931-2b6d-4d93-8e44-96283cd2c697','student848@example.com','student848','Bello.Rogers21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+848&background=random','2026-01-24 11:06:21.082','2025-01-25 22:55:26.900','2026-01-24 11:06:21.083',3),
('5d6a5909-065c-47e4-adbd-f91f7e2fc142','student648@example.com','student648','Prasit_Tshabalala97','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+648&background=random','2026-01-24 11:06:20.844','2024-05-26 06:52:22.953','2026-01-24 11:06:20.844',3),
('5d7c42d1-22c6-487f-b36b-866023554ca0','student609@example.com','student609','Masao_Novotný','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+609&background=random','2026-01-24 11:06:20.800','2025-10-11 17:05:28.468','2026-01-24 11:06:20.800',3),
('5d8b6a17-e630-4992-9713-0efdebef1ada','student84@example.com','student84','Latda_Khumalo44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+84&background=random','2026-01-24 11:06:20.168','2025-11-01 04:31:12.478','2026-01-24 11:06:20.169',3),
('5e0c7b1b-770d-46e9-9c86-20bc1a7f1c90','student603@example.com','student603','Zanele_Li40','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+603&background=random','2026-01-24 11:06:20.793','2022-01-02 04:30:29.902','2026-01-24 11:06:20.794',3),
('5e33ca4b-b100-412a-8db3-db2366373be4','student513@example.com','student513','Haruna.Kumari','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+513&background=random','2026-01-24 11:06:20.694','2025-12-12 04:00:20.429','2026-01-24 11:06:20.695',3),
('5e85a594-666f-407f-a5c5-66d36d7c7945','student919@example.com','student919','Mikhail.Jónasson10','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+919&background=random','2026-01-24 11:06:21.163','2021-03-29 06:38:11.242','2026-01-24 11:06:21.164',3),
('5e9f024b-d7b3-46a0-8141-9a33142af4e5','student796@example.com','student796','Karen_Olszewski42','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+796&background=random','2026-01-24 11:06:21.010','2024-03-17 03:43:06.771','2026-01-24 11:06:21.010',3),
('5ea8dfec-4bba-49fb-be21-84a7562f32d1','teacher46@example.com','teacher46','Jianguo.Einarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+46&background=random','2026-01-24 11:06:19.880','2021-08-18 23:49:07.918','2026-01-24 11:06:19.881',2),
('5ebdd9f0-b0da-4853-b573-c79527f89cd4','student754@example.com','student754','Yu.Óskarsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+754&background=random','2026-01-24 11:06:20.963','2026-01-19 01:57:22.561','2026-01-24 11:06:20.964',3),
('5ec2291a-b2e0-4d51-a3a9-e800086c069e','student43@example.com','student43','Jackline_Krejčí72','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+43&background=random','2026-01-24 11:06:20.121','2025-03-23 06:41:31.092','2026-01-24 11:06:20.122',3),
('5f22e17e-3d2e-47d2-93a4-61b0fc0ec385','student10@example.com','student10','Xiaoli.Malinowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+10&background=random','2026-01-24 11:06:20.078','2025-12-28 02:33:34.929','2026-01-24 11:06:20.079',3),
('5fa6e350-a62e-4192-ae62-b4583e6b5aa5','student150@example.com','student150','Anah.Pétursson64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+150&background=random','2026-01-24 11:06:20.245','2021-05-05 00:35:05.761','2026-01-24 11:06:20.246',3),
('5fa83dd7-145c-4c08-8f97-5dfce0e5c407','student215@example.com','student215','Radha.Pan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+215&background=random','2026-01-24 11:06:20.336','2021-04-23 09:11:46.643','2026-01-24 11:06:20.336',3),
('602197b9-2db4-47f0-8a23-bf9435a9dd30','student370@example.com','student370','Werner_Ólafsdóttir86','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+370&background=random','2026-01-24 11:06:20.532','2024-12-19 07:52:17.847','2026-01-24 11:06:20.532',3),
('609d2e36-70db-4347-b770-0ad2a0dce139','student3@example.com','student3','Lilian.Žáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+3&background=random','2026-01-24 11:06:20.069','2022-10-13 08:26:19.948','2026-01-24 11:06:20.070',3),
('60e73acd-93f2-44c3-9969-a4e5aa6ab312','student198@example.com','student198','Omer.Jankowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+198&background=random','2026-01-24 11:06:20.314','2021-04-26 13:18:15.459','2026-01-24 11:06:20.315',3),
('60fa0e69-4ff4-43ce-9eb9-6677aa9f7953','student593@example.com','student593','Sunthon.Löffler','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+593&background=random','2026-01-24 11:06:20.783','2023-03-30 20:31:32.016','2026-01-24 11:06:20.783',3),
('611b54e1-41ca-4001-a900-791e766a744a','student732@example.com','student732','Shlomo_Jasiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+732&background=random','2026-01-24 11:06:20.938','2021-04-17 17:21:21.702','2026-01-24 11:06:20.938',3),
('61335215-9e18-489e-8392-47ce831ca9c5','student480@example.com','student480','Claudia_Guðmundsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+480&background=random','2026-01-24 11:06:20.657','2021-07-29 04:11:12.068','2026-01-24 11:06:20.658',3),
('6171bbbf-1065-4839-9ad4-c21491bb0f7e','student628@example.com','student628','Sombat_Guðmundsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+628&background=random','2026-01-24 11:06:20.821','2025-05-23 15:13:01.268','2026-01-24 11:06:20.821',3),
('6260713d-d36d-4d9d-9604-1aa54f9e72ea','student544@example.com','student544','Yong.Serrano','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+544&background=random','2026-01-24 11:06:20.727','2022-05-19 10:46:19.580','2026-01-24 11:06:20.728',3),
('62717d30-4b84-4eb6-8a77-bbe22eaaa18a','student602@example.com','student602','Yue.Zieliński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+602&background=random','2026-01-24 11:06:20.792','2024-05-20 19:42:52.735','2026-01-24 11:06:20.793',3),
('62b68b6d-e598-4ed4-a2e9-4d378c289291','student360@example.com','student360','William.Ivanova52','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+360&background=random','2026-01-24 11:06:20.519','2022-05-08 09:51:40.101','2026-01-24 11:06:20.520',3),
('62c2ca4b-bbae-48a6-9a54-77157e5daca1','student367@example.com','student367','Caroline_Fröhlich','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+367&background=random','2026-01-24 11:06:20.528','2021-11-17 07:12:58.104','2026-01-24 11:06:20.529',3),
('62ebb5f6-c241-4f56-a812-c96a5864d5ed','student516@example.com','student516','Alan_Veselý94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+516&background=random','2026-01-24 11:06:20.697','2021-02-28 00:37:54.344','2026-01-24 11:06:20.698',3),
('6327264e-c3d1-4c88-b0ff-febfb133b03c','student273@example.com','student273','Olga_Ramírez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+273&background=random','2026-01-24 11:06:20.407','2023-11-12 22:33:03.417','2026-01-24 11:06:20.408',3),
('639c5f34-bd7d-4735-b23b-cfea59039fb5','student384@example.com','student384','Edda_Braun50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+384&background=random','2026-01-24 11:06:20.550','2025-01-22 11:37:19.092','2026-01-24 11:06:20.550',3),
('63c2c076-2702-4af5-9899-1d42a72e07c3','student650@example.com','student650','Alina.López73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+650&background=random','2026-01-24 11:06:20.846','2021-12-02 07:15:52.411','2026-01-24 11:06:20.846',3),
('6401ac9a-e1e7-4430-a5a9-a2794dcb458e','student235@example.com','student235','Yoshie.Delgado','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+235&background=random','2026-01-24 11:06:20.360','2022-08-11 00:43:16.314','2026-01-24 11:06:20.360',3),
('6415ed3f-c591-43ba-8759-4781db048bde','student733@example.com','student733','Somkhit.Magnússon47','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+733&background=random','2026-01-24 11:06:20.939','2021-09-15 20:02:22.221','2026-01-24 11:06:20.939',3),
('642828f4-67aa-4c60-90d6-63f4692c34c0','student309@example.com','student309','Nokuthula.Őzse','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+309&background=random','2026-01-24 11:06:20.456','2024-06-24 18:25:14.618','2026-01-24 11:06:20.456',3),
('64623fcc-aac0-482d-ad82-f80edde59dae','student616@example.com','student616','Jose-Luis.Castillo4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+616&background=random','2026-01-24 11:06:20.807','2025-01-05 12:15:22.978','2026-01-24 11:06:20.808',3),
('64ed0eb6-f370-468e-8f45-f53a86455222','student936@example.com','student936','Jose-Maria.Braun14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+936&background=random','2026-01-24 11:06:21.182','2024-06-07 14:31:47.682','2026-01-24 11:06:21.183',3),
('64fad699-19c1-49f6-8c84-b33c84731f86','teacher192@example.com','teacher192','Michal.Rubio','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+192&background=random','2026-01-24 11:06:20.056','2024-02-07 21:55:53.642','2026-01-24 11:06:20.057',2),
('658bedfe-f701-4721-bf42-b6798aaf2beb','student675@example.com','student675','Tal.Piotrowski98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+675&background=random','2026-01-24 11:06:20.871','2021-03-18 09:43:22.094','2026-01-24 11:06:20.871',3),
('65967720-ed23-42a5-ac3c-92d1aa8bf5ac','student802@example.com','student802','Mariya_Shapiro68','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+802&background=random','2026-01-24 11:06:21.017','2022-12-12 15:42:24.502','2026-01-24 11:06:21.018',3),
('65dab660-d5c6-41fa-a23e-000e61024fe2','student178@example.com','student178','Jan_Friðriksson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+178&background=random','2026-01-24 11:06:20.285','2022-02-17 17:33:01.920','2026-01-24 11:06:20.286',3),
('65f98361-0822-4312-91fa-798a162485f5','teacher73@example.com','teacher73','Ming_Adamczyk38','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+73&background=random','2026-01-24 11:06:19.917','2024-08-20 09:59:57.289','2026-01-24 11:06:19.917',2),
('663c52c9-d965-433f-b5fb-d459993df8c4','student274@example.com','student274','Hideo.Suarez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+274&background=random','2026-01-24 11:06:20.409','2023-09-03 09:49:59.460','2026-01-24 11:06:20.409',3),
('669b4a44-dbd9-4ca7-afef-fc84a38f2e4d','student53@example.com','student53','Jose-Manuel_Muñoz58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+53&background=random','2026-01-24 11:06:20.134','2022-06-14 16:38:15.122','2026-01-24 11:06:20.134',3),
('66a3cde7-9b38-4553-bb74-af1241741ed4','student507@example.com','student507','Hauwa.Gonzales','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+507&background=random','2026-01-24 11:06:20.686','2023-09-07 06:50:20.084','2026-01-24 11:06:20.687',3),
('66eb473a-ffcc-4d89-aeac-58f87e26ce32','student886@example.com','student886','Marina.Peña','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+886&background=random','2026-01-24 11:06:21.123','2024-06-07 18:34:46.811','2026-01-24 11:06:21.124',3),
('6789cc34-d84b-4590-8e36-c103032272bf','student771@example.com','student771','Heike.Harðarson76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+771&background=random','2026-01-24 11:06:20.983','2022-04-14 12:36:35.357','2026-01-24 11:06:20.984',3),
('67d69810-3c5d-4bae-abcf-2fdd88036eee','student835@example.com','student835','Manfred.Prins','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+835&background=random','2026-01-24 11:06:21.067','2022-01-13 10:31:06.433','2026-01-24 11:06:21.068',3),
('68419814-3d60-4922-bcbf-99f8a9c881c4','student29@example.com','student29','Jean.Núñez100','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+29&background=random','2026-01-24 11:06:20.103','2023-09-11 04:30:35.613','2026-01-24 11:06:20.104',3),
('684797bc-78c7-4a53-93fa-68c3467f48ae','student799@example.com','student799','Samran.Helgadóttir71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+799&background=random','2026-01-24 11:06:21.014','2024-06-03 10:27:01.302','2026-01-24 11:06:21.015',3),
('68eec5fa-62fe-440c-a44c-ae01ca276f47','student540@example.com','student540','Amina.Morales76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+540&background=random','2026-01-24 11:06:20.723','2025-05-24 00:44:59.427','2026-01-24 11:06:20.724',3),
('68f33d8e-7d8a-4a91-a7cc-f11e1d288439','student142@example.com','student142','Piotr.Nkosi72','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+142&background=random','2026-01-24 11:06:20.236','2024-04-06 11:21:51.452','2026-01-24 11:06:20.237',3),
('68f9304d-d62a-4ee7-a5d4-3711437637fe','student826@example.com','student826','Zanele.Árnadóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+826&background=random','2026-01-24 11:06:21.058','2021-04-05 23:08:10.962','2026-01-24 11:06:21.058',3),
('69001612-eb28-4eae-b14c-d90a5ceb038d','teacher39@example.com','teacher39','Mohan_Cheruiyot64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+39&background=random','2026-01-24 11:06:19.871','2025-12-20 23:42:43.045','2026-01-24 11:06:19.872',2),
('69063fe8-db8b-4525-90ad-17674efae07c','student752@example.com','student752','Yun.Őzse','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+752&background=random','2026-01-24 11:06:20.961','2025-09-23 04:00:17.096','2026-01-24 11:06:20.962',3),
('69750e26-1d50-43ec-8bcf-23751b1993ac','student573@example.com','student573','Hideo.Procházka','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+573&background=random','2026-01-24 11:06:20.760','2022-01-31 19:37:48.866','2026-01-24 11:06:20.761',3),
('69a9325c-e749-4e71-a499-e4edf98ca21d','teacher90@example.com','teacher90','Kai.Björnsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+90&background=random','2026-01-24 11:06:19.935','2021-03-04 12:01:42.542','2026-01-24 11:06:19.936',2),
('69e7bbee-1c99-4ef7-aa59-5a968b7432d6','teacher153@example.com','teacher153','Sergey_Ãshaikh','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+153&background=random','2026-01-24 11:06:20.011','2025-04-29 02:44:43.584','2026-01-24 11:06:20.011',2),
('6a3878c8-d9da-477f-880e-938b8861a0d1','teacher171@example.com','teacher171','Anan_Ríos28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+171&background=random','2026-01-24 11:06:20.032','2023-05-24 06:58:35.953','2026-01-24 11:06:20.033',2),
('6a7c4253-08dc-4b07-8190-18de9ec14f8f','student199@example.com','student199','Anan_Pétursson73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+199&background=random','2026-01-24 11:06:20.316','2024-07-29 01:10:54.769','2026-01-24 11:06:20.316',3),
('6ad43dfc-0a68-4340-9381-56cb9dba6d86','student531@example.com','student531','Mukesh.Morgan67','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+531&background=random','2026-01-24 11:06:20.713','2021-05-05 04:34:37.543','2026-01-24 11:06:20.714',3),
('6aec7acc-f1fc-47dc-b6d3-736c9db68f97','teacher80@example.com','teacher80','Sabine.Chávez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+80&background=random','2026-01-24 11:06:19.925','2022-06-26 23:06:18.991','2026-01-24 11:06:19.925',2),
('6aefb11c-4346-4a1b-b4fa-9f7bb322ab9c','student477@example.com','student477','David_Wang','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+477&background=random','2026-01-24 11:06:20.654','2025-12-24 20:32:46.196','2026-01-24 11:06:20.655',3),
('6b6b439c-7aa2-4c77-89b2-4ee5dc12e952','teacher121@example.com','teacher121','Birgit_Isah37','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+121&background=random','2026-01-24 11:06:19.973','2025-01-12 20:42:08.962','2026-01-24 11:06:19.973',2),
('6b822a1d-6fd7-43c1-9484-b11f672137c6','teacher60@example.com','teacher60','Alan_Khoza80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+60&background=random','2026-01-24 11:06:19.899','2021-07-14 04:56:44.814','2026-01-24 11:06:19.900',2),
('6bb83df7-35e5-4986-b723-990d87ca4290','student49@example.com','student49','Sunthon.Lavyan3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+49&background=random','2026-01-24 11:06:20.128','2021-02-28 17:39:26.796','2026-01-24 11:06:20.129',3),
('6c286826-7b18-4e04-968c-f66174ab56e8','student679@example.com','student679','Yuriy.Novák','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+679&background=random','2026-01-24 11:06:20.876','2022-07-16 09:00:36.656','2026-01-24 11:06:20.877',3),
('6c3b5b0f-ebf5-436c-94dd-e93bb5da37aa','teacher8@example.com','teacher8','Anton_Pawłowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+8&background=random','2026-01-24 11:06:19.834','2023-06-18 19:15:55.891','2026-01-24 11:06:19.835',2),
('6ce340cc-6cdb-4523-b193-bdf0260cb856','student233@example.com','student233','Hulda_Howells','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+233&background=random','2026-01-24 11:06:20.357','2023-05-01 08:38:39.374','2026-01-24 11:06:20.358',3),
('6cff569d-4a6d-4bc6-9277-366b45564186','student22@example.com','student22','Hui_Pétursson52','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+22&background=random','2026-01-24 11:06:20.094','2023-03-12 06:17:05.209','2026-01-24 11:06:20.095',3),
('6d114f6c-54cd-4fa2-87e6-a0332068e8a2','student186@example.com','student186','Takeshi.Æbeltoft','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+186&background=random','2026-01-24 11:06:20.298','2025-09-02 05:07:12.012','2026-01-24 11:06:20.299',3),
('6d21e919-804b-4c86-a662-d916e5bf532a','student578@example.com','student578','Jianjun.Rodríguez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+578&background=random','2026-01-24 11:06:20.766','2025-09-26 06:45:00.442','2026-01-24 11:06:20.766',3),
('6d51578d-239a-4420-bc0e-63f918e5a0b5','teacher86@example.com','teacher86','Moshe_Novotná14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+86&background=random','2026-01-24 11:06:19.931','2022-07-18 10:21:08.310','2026-01-24 11:06:19.932',2),
('6dd9270c-6b8b-42f3-9206-c067e8fe4cec','teacher123@example.com','teacher123','Lisa_Szczepański75','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+123&background=random','2026-01-24 11:06:19.975','2025-08-01 22:48:25.086','2026-01-24 11:06:19.976',2),
('6decef33-c192-4ef4-85d4-292ec9808a65','student973@example.com','student973','Hiromi.Ágústsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+973&background=random','2026-01-24 11:06:21.232','2023-09-21 15:01:22.912','2026-01-24 11:06:21.233',3),
('6e6d81cc-d1b5-4d9e-987b-aa3aa0b12aa1','teacher148@example.com','teacher148','Santosh_Chávez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+148&background=random','2026-01-24 11:06:20.005','2025-03-19 16:38:54.992','2026-01-24 11:06:20.006',2),
('6eebda17-35ca-48f8-bf33-efcdbfbbbc15','student357@example.com','student357','Jennifer.Harðarson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+357&background=random','2026-01-24 11:06:20.515','2024-03-29 12:21:30.393','2026-01-24 11:06:20.516',3),
('6ef03697-82da-4b64-80ff-c0c27e0dda8c','student972@example.com','student972','Jorge_Gao','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+972&background=random','2026-01-24 11:06:21.230','2022-06-16 09:31:07.154','2026-01-24 11:06:21.231',3),
('6efa86b0-02f5-463e-b128-bdfcebffeb5b','student101@example.com','student101','Andrzej.Isaac','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+101&background=random','2026-01-24 11:06:20.186','2025-01-11 22:53:47.051','2026-01-24 11:06:20.186',3),
('6f413591-332c-4319-90a5-76bc8f04ba5a','student559@example.com','student559','Steve_Chanthara','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+559&background=random','2026-01-24 11:06:20.744','2025-05-14 02:00:26.009','2026-01-24 11:06:20.745',3),
('6fe6d712-26cb-492c-8b4c-de9cd3f503a1','student389@example.com','student389','Joyce_Van-den-Berg','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+389&background=random','2026-01-24 11:06:20.556','2022-06-29 02:26:58.796','2026-01-24 11:06:20.557',3),
('70087217-648e-4b50-a241-c15d2832ec98','student632@example.com','student632','Mardkhay_Muhammad','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+632&background=random','2026-01-24 11:06:20.825','2024-12-14 16:55:55.562','2026-01-24 11:06:20.826',3),
('7039d9cf-718f-4fb4-b424-1b5d27530caa','student783@example.com','student783','Yun.Scott','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+783&background=random','2026-01-24 11:06:20.996','2022-11-26 02:26:22.922','2026-01-24 11:06:20.996',3),
('707b213d-e82c-4737-803d-551078245d05','student641@example.com','student641','Joan_Horák49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+641&background=random','2026-01-24 11:06:20.835','2023-06-28 23:05:39.505','2026-01-24 11:06:20.836',3),
('70954edb-9d8b-4f9b-a208-3a641c6f8156','student595@example.com','student595','Avraham_Pawłowski25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+595&background=random','2026-01-24 11:06:20.785','2021-11-26 09:18:23.692','2026-01-24 11:06:20.785',3),
('7199d41f-f654-4d29-9a63-4865c64d211b','student495@example.com','student495','Tal_Sekh','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+495&background=random','2026-01-24 11:06:20.674','2022-10-02 13:48:40.776','2026-01-24 11:06:20.674',3),
('71c4afc4-401d-47ab-83f1-c98a047b62fc','student698@example.com','student698','Jason_Kim','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+698&background=random','2026-01-24 11:06:20.898','2025-09-02 13:45:55.456','2026-01-24 11:06:20.898',3),
('71e4f6a1-3e68-4a59-8cb3-1c8b829c4354','student770@example.com','student770','Kseniya_Baker24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+770&background=random','2026-01-24 11:06:20.982','2024-03-27 18:37:01.253','2026-01-24 11:06:20.982',3),
('7228933f-821b-4689-bbf0-4228bc2f0a60','student668@example.com','student668','Sabine_Soto89','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+668&background=random','2026-01-24 11:06:20.864','2024-04-10 06:00:54.352','2026-01-24 11:06:20.864',3),
('7232df56-1f6e-4b1a-86e9-fe9b7831d5fa','student966@example.com','student966','Gabra.Guðjónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+966&background=random','2026-01-24 11:06:21.223','2021-02-06 17:58:35.701','2026-01-24 11:06:21.223',3),
('72641467-ab77-416a-b3ad-8966560b78e7','student2@example.com','student2','Anita.Powell','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+2&background=random','2026-01-24 11:06:20.068','2025-03-29 22:51:44.320','2026-01-24 11:06:20.069',3),
('72a47618-20da-40ef-802b-d739cb531b57','teacher59@example.com','teacher59','Nadezhda.Koch82','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+59&background=random','2026-01-24 11:06:19.898','2021-02-03 10:11:17.449','2026-01-24 11:06:19.899',2),
('72f291cc-49b9-441a-9c34-69463c6f8994','student352@example.com','student352','Li_Bauer','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+352&background=random','2026-01-24 11:06:20.509','2024-08-06 15:13:51.635','2026-01-24 11:06:20.510',3),
('72f7eaff-1497-4872-83e3-30e4260e8aea','student327@example.com','student327','Ryoko.Malinowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+327&background=random','2026-01-24 11:06:20.479','2021-11-08 22:04:02.947','2026-01-24 11:06:20.479',3),
('737ed70a-cdaa-4deb-8c74-c9361dfa30be','student46@example.com','student46','Joy_Vargas14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+46&background=random','2026-01-24 11:06:20.125','2022-06-23 18:09:31.971','2026-01-24 11:06:20.125',3),
('738180ec-90c3-4bec-b5f4-f5d57ae4d73a','student553@example.com','student553','Johanna_Hájek','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+553&background=random','2026-01-24 11:06:20.738','2023-06-21 19:46:43.709','2026-01-24 11:06:20.739',3),
('73e57171-e8bf-40ee-8e00-5a00b9aa9794','student130@example.com','student130','Kiyoko_Ellis47','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+130&background=random','2026-01-24 11:06:20.222','2023-09-03 02:21:46.800','2026-01-24 11:06:20.223',3),
('73f7ed66-83c8-4910-beed-48fce4426e29','student858@example.com','student858','Xiaoyan.Smirnova','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+858&background=random','2026-01-24 11:06:21.092','2022-04-24 02:10:37.724','2026-01-24 11:06:21.093',3),
('741d8a36-eac4-4835-b09e-53d19da63047','student917@example.com','student917','Jakub.Ota22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+917&background=random','2026-01-24 11:06:21.160','2021-09-12 05:29:26.857','2026-01-24 11:06:21.160',3),
('7456efd9-affc-4eb1-a4ba-5e3070a4a549','student659@example.com','student659','Sunil.Schäfer','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+659&background=random','2026-01-24 11:06:20.855','2021-12-30 13:56:30.943','2026-01-24 11:06:20.855',3),
('74ad302c-4268-4cd5-b263-3b65fdfb1920','student88@example.com','student88','Ingrid.Inoue87','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+88&background=random','2026-01-24 11:06:20.173','2024-07-16 02:53:15.987','2026-01-24 11:06:20.173',3),
('74e0a2b9-b5bb-40ba-a0f3-b7d8890e92c1','student149@example.com','student149','Ngozi.Peña81','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+149&background=random','2026-01-24 11:06:20.243','2025-06-19 04:49:09.932','2026-01-24 11:06:20.244',3),
('7535a2a1-3100-469b-91b1-c64e21bddc32','student387@example.com','student387','Gareth.Esteban','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+387&background=random','2026-01-24 11:06:20.554','2024-11-09 03:35:28.257','2026-01-24 11:06:20.555',3),
('75438fbd-eb0f-4ef8-a7ac-eefa30b1d7f1','student990@example.com','student990','Sveinn_Jabłoński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+990&background=random','2026-01-24 11:06:21.251','2022-11-09 01:55:46.408','2026-01-24 11:06:21.251',3),
('758aded9-ae0f-438d-85d1-2447968e1aa7','student766@example.com','student766','Hendrik_Mutua4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+766&background=random','2026-01-24 11:06:20.978','2024-07-10 22:47:25.198','2026-01-24 11:06:20.978',3),
('75b9ced3-8ffd-4bd5-8dfb-f40107ff641d','student138@example.com','student138','Wirot.Meyer24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+138&background=random','2026-01-24 11:06:20.232','2023-04-04 06:25:36.734','2026-01-24 11:06:20.232',3),
('75df8e3e-3c24-443d-ba78-8681f10ff47f','student745@example.com','student745','Karl-Heinz_Cao62','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+745&background=random','2026-01-24 11:06:20.953','2022-02-03 03:17:24.429','2026-01-24 11:06:20.954',3),
('7653da4d-e41d-44c4-937b-2b5a3e402c7c','teacher15@example.com','teacher15','Wei.Nuñez36','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+15&background=random','2026-01-24 11:06:19.843','2023-11-18 10:47:08.172','2026-01-24 11:06:19.843',2),
('76877d53-873e-48a0-99ab-888f126357a6','student967@example.com','student967','Fran.Yakubu33','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+967&background=random','2026-01-24 11:06:21.224','2025-11-09 10:53:01.503','2026-01-24 11:06:21.224',3),
('76e323e4-9c7a-4e93-b3ff-60979a64f1e2','student30@example.com','student30','Shoshanah_Novák','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+30&background=random','2026-01-24 11:06:20.105','2024-05-28 12:29:21.861','2026-01-24 11:06:20.105',3),
('77083ee6-68e8-4949-96cf-89ea38062edf','teacher21@example.com','teacher21','Akira_Guðjónsson85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+21&background=random','2026-01-24 11:06:19.850','2022-08-20 08:27:50.512','2026-01-24 11:06:19.850',2),
('772028f3-0dfe-466b-b53f-de9ffb19b68e','teacher41@example.com','teacher41','Mo_Bibi46','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+41&background=random','2026-01-24 11:06:19.874','2022-01-22 12:29:54.503','2026-01-24 11:06:19.875',2),
('777c559e-7949-4ae9-9b1d-0fcda01d1066','student887@example.com','student887','Birgir_Øvergård96','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+887&background=random','2026-01-24 11:06:21.124','2023-07-06 14:04:32.082','2026-01-24 11:06:21.125',3),
('77b43cf6-c4f1-4fb0-a959-5cda459b483d','student560@example.com','student560','Irina_Łapiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+560&background=random','2026-01-24 11:06:20.746','2021-09-21 03:58:07.641','2026-01-24 11:06:20.746',3),
('77b58571-0c87-4386-8904-a9372ad07749','teacher120@example.com','teacher120','Vinod.Méndez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+120&background=random','2026-01-24 11:06:19.971','2022-09-23 17:06:37.740','2026-01-24 11:06:19.972',2),
('77d8dd3e-18d3-48b1-a266-fe13df9a36c3','student946@example.com','student946','Andreas_Helgadóttir26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+946&background=random','2026-01-24 11:06:21.197','2022-11-15 04:06:42.418','2026-01-24 11:06:21.198',3),
('77e2e32f-137a-44d1-955e-b6308b2fe83f','teacher34@example.com','teacher34','Heike.Fiala73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+34&background=random','2026-01-24 11:06:19.865','2022-05-02 23:02:07.154','2026-01-24 11:06:19.866',2),
('7800f5f6-2ea9-4a8c-ba28-5554c20502fa','student257@example.com','student257','Lyubov.Sveinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+257&background=random','2026-01-24 11:06:20.387','2023-11-14 04:35:00.424','2026-01-24 11:06:20.388',3),
('78437296-b3e7-439e-98d8-689d9c5a86e6','student191@example.com','student191','Emiko.Pokorná','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+191&background=random','2026-01-24 11:06:20.305','2021-10-24 04:50:11.795','2026-01-24 11:06:20.306',3),
('785b99b9-71fe-40fa-b3b0-d5719a5ae287','student381@example.com','student381','Andrew_Svobodová69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+381&background=random','2026-01-24 11:06:20.546','2023-03-02 11:40:10.093','2026-01-24 11:06:20.547',3),
('786271bd-b87f-4609-97fa-ae059e0ef42e','student610@example.com','student610','Jose-Manuel.Feng4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+610&background=random','2026-01-24 11:06:20.801','2022-01-05 10:12:42.472','2026-01-24 11:06:20.801',3),
('78b1abe2-3498-4cf0-82c4-26df51fbfa8f','student376@example.com','student376','Peter_Simiyu89','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+376&background=random','2026-01-24 11:06:20.539','2025-01-06 02:17:39.250','2026-01-24 11:06:20.539',3),
('78f26637-f551-4bf4-a925-b17f0acb1b5b','student114@example.com','student114','Elizabeth_Mofokeng35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+114&background=random','2026-01-24 11:06:20.205','2022-03-01 01:02:02.689','2026-01-24 11:06:20.206',3),
('790ad272-1198-4120-95c5-a3b9393e9648','student182@example.com','student182','Magda_Förster','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+182&background=random','2026-01-24 11:06:20.292','2024-09-22 11:18:25.751','2026-01-24 11:06:20.293',3),
('790bd052-d416-4648-8143-ffe1669787f9','student176@example.com','student176','Mpho_Jankowski90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+176&background=random','2026-01-24 11:06:20.282','2025-05-01 18:10:07.506','2026-01-24 11:06:20.283',3),
('7942bcf5-dae7-4c15-834f-511152020644','student529@example.com','student529','Xiaoping_Zhao11','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+529&background=random','2026-01-24 11:06:20.711','2023-02-13 09:23:33.352','2026-01-24 11:06:20.711',3),
('79f9f431-6e2b-449b-8342-f3e086b5d1b4','teacher51@example.com','teacher51','Joy_Tshabalala99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+51&background=random','2026-01-24 11:06:19.886','2022-04-01 02:52:41.785','2026-01-24 11:06:19.887',2),
('7a416a2e-fef3-47df-9389-2b855841e0f7','student89@example.com','student89','Santosh.Liu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+89&background=random','2026-01-24 11:06:20.174','2022-09-14 06:10:47.625','2026-01-24 11:06:20.174',3),
('7a45a8cb-c5c0-4ba6-883c-238c09dc05d7','student15@example.com','student15','Pilar_Guðmundsdóttir16','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+15&background=random','2026-01-24 11:06:20.085','2025-08-30 10:07:54.756','2026-01-24 11:06:20.085',3),
('7a4e21e5-f3e7-49f3-822b-9e79b14549cf','student983@example.com','student983','Karen.Veselá','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+983&background=random','2026-01-24 11:06:21.244','2021-05-04 01:22:04.161','2026-01-24 11:06:21.244',3),
('7a9f1627-5d6b-44a8-be2b-9f677e651603','student690@example.com','student690','Wei_Baldursdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+690&background=random','2026-01-24 11:06:20.889','2024-08-01 09:01:09.402','2026-01-24 11:06:20.889',3),
('7b3868c3-f571-4ed8-a6a2-8c658274af42','student937@example.com','student937','Marina_Óskarsdóttir12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+937&background=random','2026-01-24 11:06:21.183','2021-06-27 07:33:11.485','2026-01-24 11:06:21.184',3),
('7b74fa94-7dd3-48c6-a37a-2b893b0126c0','student769@example.com','student769','Agata_Gutiérrez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+769&background=random','2026-01-24 11:06:20.981','2022-04-04 07:51:23.239','2026-01-24 11:06:20.981',3),
('7b8005c8-ae9c-4420-96d0-edb18b6c30e6','student422@example.com','student422','Christian_Árnadóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+422&background=random','2026-01-24 11:06:20.596','2025-08-06 21:52:18.046','2026-01-24 11:06:20.596',3),
('7b9c9343-c421-4681-aadb-3b1b2e3086f8','student982@example.com','student982','Jianhua_Aliev33','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+982&background=random','2026-01-24 11:06:21.243','2024-11-25 13:42:34.107','2026-01-24 11:06:21.243',3),
('7bb5af96-b9e1-45c0-b95e-36dcc13d2c38','student500@example.com','student500','Claire.Maseko49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+500&background=random','2026-01-24 11:06:20.679','2022-03-18 18:22:15.309','2026-01-24 11:06:20.680',3),
('7bddf41c-34c8-48bb-a54d-2c7c5a50c0e1','student489@example.com','student489','Akira.Ðekić41','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+489&background=random','2026-01-24 11:06:20.666','2022-05-18 09:25:43.827','2026-01-24 11:06:20.667',3),
('7bf09d46-bb42-4cba-b318-e1245a543487','teacher87@example.com','teacher87','Andrzej_Jankowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+87&background=random','2026-01-24 11:06:19.932','2022-10-29 01:57:52.783','2026-01-24 11:06:19.933',2),
('7c328311-e0f7-44b3-a8d9-b43e03c6db60','student672@example.com','student672','Nicola_Muñoz54','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+672&background=random','2026-01-24 11:06:20.868','2023-03-27 08:08:34.023','2026-01-24 11:06:20.868',3),
('7c353ff1-8588-4756-a4f0-051170a02141','student239@example.com','student239','Ana.Árnadóttir76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+239&background=random','2026-01-24 11:06:20.365','2022-07-28 21:09:59.739','2026-01-24 11:06:20.366',3),
('7c42c15e-183e-4df4-9b05-f4e679c93db0','student31@example.com','student31','Ravi.Schulz44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+31&background=random','2026-01-24 11:06:20.107','2022-01-07 11:02:00.268','2026-01-24 11:06:20.108',3),
('7c4adde3-d56c-4658-872b-d69c94c57a87','student536@example.com','student536','Einar.Yamashita','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+536&background=random','2026-01-24 11:06:20.718','2023-09-06 11:49:09.870','2026-01-24 11:06:20.719',3),
('7ca813d2-4afa-43a7-8d7c-f7fd6fc47d73','student154@example.com','student154','Sri.Czarnecki','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+154&background=random','2026-01-24 11:06:20.251','2025-06-01 11:55:11.668','2026-01-24 11:06:20.252',3),
('7d287230-2413-46dd-826b-62ebff35c1c2','student654@example.com','student654','Daniel.Saidu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+654&background=random','2026-01-24 11:06:20.850','2023-03-06 11:45:06.804','2026-01-24 11:06:20.850',3),
('7d337fb4-c753-4d7d-9153-a1e7d9542e23','student299@example.com','student299','Nokuthula.Ohana78','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+299&background=random','2026-01-24 11:06:20.441','2022-09-24 06:03:52.084','2026-01-24 11:06:20.441',3),
('7da444f3-73d4-48d5-b6a6-92ff45c16dbb','student496@example.com','student496','Idris.Zalewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+496&background=random','2026-01-24 11:06:20.675','2024-04-19 16:34:54.152','2026-01-24 11:06:20.675',3),
('7e57c9c6-f24a-47f5-a575-e4325e605987','student749@example.com','student749','Sanjay.Saidu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+749&background=random','2026-01-24 11:06:20.958','2023-04-25 06:23:38.547','2026-01-24 11:06:20.959',3),
('7e7c2833-9548-473d-b514-380f861c2c46','student85@example.com','student85','Helen.Černý','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+85&background=random','2026-01-24 11:06:20.169','2023-07-28 00:46:54.872','2026-01-24 11:06:20.170',3),
('7ea949b4-76c3-4fd0-b470-4842463a8aff','student440@example.com','student440','Dolores_Halldórsdóttir36','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+440&background=random','2026-01-24 11:06:20.615','2024-04-17 09:57:30.059','2026-01-24 11:06:20.615',3),
('7eb7ebe8-14d4-4b49-bde7-079259d6e5c2','student868@example.com','student868','Nobuko_Horák49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+868&background=random','2026-01-24 11:06:21.104','2024-04-21 11:08:23.189','2026-01-24 11:06:21.104',3),
('7f31fdec-a5ff-41b6-82bf-6c28da03e198','student423@example.com','student423','Gisela.Kristjánsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+423&background=random','2026-01-24 11:06:20.596','2023-11-15 21:55:07.877','2026-01-24 11:06:20.597',3),
('7f9f2496-86b6-4f29-ab39-e0e6b3c21861','student980@example.com','student980','Kanchana_Sokołowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+980&background=random','2026-01-24 11:06:21.240','2021-01-28 21:14:49.030','2026-01-24 11:06:21.241',3),
('7fbea9fa-8993-4759-81d9-5bd380710c0a','student371@example.com','student371','Themba.Halldórsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+371&background=random','2026-01-24 11:06:20.533','2024-09-08 21:42:42.648','2026-01-24 11:06:20.534',3),
('7fc9735c-dd66-4abc-9469-93db9c0211c9','student153@example.com','student153','Kun.Chepkemoi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+153&background=random','2026-01-24 11:06:20.250','2021-04-19 11:38:06.743','2026-01-24 11:06:20.251',3),
('7ffa69d5-b101-41a7-a221-276c955bc81b','student767@example.com','student767','Grace.Hájek25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+767&background=random','2026-01-24 11:06:20.979','2025-02-22 00:26:11.188','2026-01-24 11:06:20.979',3),
('80355aa2-7bea-4c46-b666-75ff5d84508f','student331@example.com','student331','Miykhal_Jóhannsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+331&background=random','2026-01-24 11:06:20.483','2023-04-13 15:36:37.738','2026-01-24 11:06:20.484',3),
('80d1071c-334b-43c2-9773-863ac95733ed','teacher152@example.com','teacher152','Somphon_Þórðardóttir3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+152&background=random','2026-01-24 11:06:20.010','2021-02-02 16:02:56.130','2026-01-24 11:06:20.010',2),
('80e66ff1-f009-46e5-92c4-06b7886de518','teacher103@example.com','teacher103','Ragnar.Gómez28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+103&background=random','2026-01-24 11:06:19.951','2023-02-24 22:00:52.494','2026-01-24 11:06:19.952',2),
('80fb3693-4d05-4ff2-97df-1374c32f642b','student256@example.com','student256','Claire_Pétursson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+256&background=random','2026-01-24 11:06:20.386','2025-01-19 04:22:20.785','2026-01-24 11:06:20.387',3),
('81303102-65a1-410a-9ef6-c8e4f5c2d66f','student373@example.com','student373','Yoshiko_Kamiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+373&background=random','2026-01-24 11:06:20.535','2022-05-15 01:41:17.057','2026-01-24 11:06:20.536',3),
('8155c414-b778-4bc3-ab6e-287b21b01387','teacher156@example.com','teacher156','Faith.Guðjónsdóttir64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+156&background=random','2026-01-24 11:06:20.014','2025-03-26 16:09:43.009','2026-01-24 11:06:20.015',2),
('8180df0b-edad-4c5e-92bd-135b11795911','teacher129@example.com','teacher129','Charoen.Kučera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+129&background=random','2026-01-24 11:06:19.983','2025-04-03 03:39:54.262','2026-01-24 11:06:19.983',2),
('81889941-4207-4538-95db-314002d1a188','student81@example.com','student81','Pushpa_Böttcher','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+81&background=random','2026-01-24 11:06:20.165','2021-10-13 11:47:06.476','2026-01-24 11:06:20.166',3),
('819541ca-2702-4247-8422-b7346aab362e','student167@example.com','student167','Monika_Kamiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+167&background=random','2026-01-24 11:06:20.269','2023-08-04 21:50:31.979','2026-01-24 11:06:20.270',3),
('81958b99-9744-4249-800d-31aa6f114d77','student413@example.com','student413','Mali_Müller','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+413&background=random','2026-01-24 11:06:20.586','2024-05-09 19:28:28.119','2026-01-24 11:06:20.586',3),
('81c92b3c-e56c-4e83-b606-8b4edeb54218','student577@example.com','student577','Karolina_Pietrzak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+577&background=random','2026-01-24 11:06:20.764','2021-08-24 02:30:23.184','2026-01-24 11:06:20.765',3),
('820003a8-b335-4874-9b32-cc3e0eafaa20','student148@example.com','student148','Daniel.Kozlov','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+148&background=random','2026-01-24 11:06:20.242','2022-05-30 16:16:20.543','2026-01-24 11:06:20.243',3),
('829917fc-0545-4a9a-9fc0-d5db993d3b4f','student141@example.com','student141','Shay.Kristjánsdóttir99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+141&background=random','2026-01-24 11:06:20.235','2025-07-07 03:16:00.273','2026-01-24 11:06:20.236',3),
('82b94f70-7e69-450a-8314-64b66a5ae006','student597@example.com','student597','Hassan_Kjartansdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+597&background=random','2026-01-24 11:06:20.787','2021-12-07 20:18:16.406','2026-01-24 11:06:20.787',3),
('82bc3269-1602-41c9-b4fe-32296d3a908b','student889@example.com','student889','Min_Fialová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+889&background=random','2026-01-24 11:06:21.126','2024-07-31 08:29:22.001','2026-01-24 11:06:21.127',3),
('82d3c128-daa6-48f8-910a-fb8c639d17be','student501@example.com','student501','Hildur_Øvergård','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+501&background=random','2026-01-24 11:06:20.680','2022-06-18 23:05:14.297','2026-01-24 11:06:20.681',3),
('8398ecfa-1d9a-4f62-92c0-e9fc6ef288f3','teacher109@example.com','teacher109','Andrzej.Jónasson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+109&background=random','2026-01-24 11:06:19.958','2022-01-14 19:53:43.796','2026-01-24 11:06:19.958',2),
('83a32f23-3441-4497-b29f-73bf44a77d79','student76@example.com','student76','Jerzy_Cheruiyot19','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+76&background=random','2026-01-24 11:06:20.158','2025-01-29 21:30:09.711','2026-01-24 11:06:20.159',3),
('83c22c90-b15c-4054-a880-c779c9218632','student354@example.com','student354','Colin.Nel12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+354&background=random','2026-01-24 11:06:20.512','2023-10-04 07:52:45.164','2026-01-24 11:06:20.512',3),
('84027b2c-9dfe-451e-b123-22b0f44b75f8','student863@example.com','student863','Irina_García10','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+863&background=random','2026-01-24 11:06:21.098','2025-10-31 12:06:24.819','2026-01-24 11:06:21.099',3),
('84231085-a6de-4c83-9b76-0605cc4dfe85','teacher188@example.com','teacher188','Sarah.Őrségi-Zölderdő','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+188&background=random','2026-01-24 11:06:20.052','2025-08-27 14:51:00.347','2026-01-24 11:06:20.052',2),
('8464573b-7c7b-4a8d-86be-ed4a234d640e','teacher92@example.com','teacher92','Josefa_Őzse','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+92&background=random','2026-01-24 11:06:19.937','2023-07-08 11:58:42.096','2026-01-24 11:06:19.938',2),
('8466ad78-32b7-4d18-b501-076169545d75','student187@example.com','student187','Joseph.Liang16','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+187&background=random','2026-01-24 11:06:20.299','2024-05-22 21:00:11.237','2026-01-24 11:06:20.300',3),
('84de3691-75c3-4506-9b95-b0d8e9afea81','student640@example.com','student640','Josef.Sithole','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+640&background=random','2026-01-24 11:06:20.834','2023-07-22 01:30:59.986','2026-01-24 11:06:20.834',3),
('8593e286-56d0-4ecc-afe6-d76e7b783163','student161@example.com','student161','Amnuai_Černý12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+161&background=random','2026-01-24 11:06:20.260','2023-02-25 18:48:12.562','2026-01-24 11:06:20.261',3),
('85c54248-5aec-424f-a3b7-623336d8e488','student899@example.com','student899','Kai_Chebet14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+899&background=random','2026-01-24 11:06:21.139','2024-12-27 20:45:15.105','2026-01-24 11:06:21.140',3),
('86449f58-006b-49ae-a669-ff4bced55f66','student485@example.com','student485','Joyce_Endo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+485&background=random','2026-01-24 11:06:20.662','2025-07-17 02:24:17.585','2026-01-24 11:06:20.663',3),
('86bd4cb8-e4bf-41a7-914b-bee3f8d81912','student55@example.com','student55','Magdalena_Yin34','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+55&background=random','2026-01-24 11:06:20.136','2022-03-27 03:37:48.578','2026-01-24 11:06:20.136',3),
('86dfd4a4-51b4-4bbd-8b91-8d33181383af','student245@example.com','student245','Haiyan_Jónasdóttir34','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+245&background=random','2026-01-24 11:06:20.373','2021-02-19 08:50:05.163','2026-01-24 11:06:20.374',3),
('86ec7ef9-f753-4cda-933b-907c7923c476','student554@example.com','student554','Francisco.Navarro25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+554&background=random','2026-01-24 11:06:20.739','2021-04-08 19:50:26.185','2026-01-24 11:06:20.740',3),
('86ed823d-67ea-4104-bef5-a9c41166a227','student720@example.com','student720','Atli.Goldstein','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+720&background=random','2026-01-24 11:06:20.923','2025-09-27 00:57:12.768','2026-01-24 11:06:20.924',3),
('86f78ebe-6f94-4c4d-aa57-47dca0772af5','student192@example.com','student192','Sommai_Lebedeva98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+192&background=random','2026-01-24 11:06:20.307','2023-05-03 15:57:00.833','2026-01-24 11:06:20.307',3),
('8765e4c6-33b6-4ebe-b13b-0eaea7eedb36','student643@example.com','student643','Kenneth_Æbelø','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+643&background=random','2026-01-24 11:06:20.839','2022-04-07 10:40:10.952','2026-01-24 11:06:20.839',3),
('8782440f-1014-45c4-a320-10c32202c271','student109@example.com','student109','Yusuf.Ólafsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+109&background=random','2026-01-24 11:06:20.198','2021-11-21 17:41:17.428','2026-01-24 11:06:20.199',3),
('87c13c62-a3fa-4d88-884e-68c913ef3b02','student907@example.com','student907','Nadezhda.Pétursson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+907&background=random','2026-01-24 11:06:21.149','2022-05-19 17:35:15.854','2026-01-24 11:06:21.149',3),
('88882e83-c203-40d6-8ef5-ecc20c958952','student885@example.com','student885','Shoji.Fernandez78','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+885&background=random','2026-01-24 11:06:21.121','2022-07-29 00:32:42.519','2026-01-24 11:06:21.121',3),
('89622724-42c8-4f9d-b5dd-238db0f101d0','teacher23@example.com','teacher23','Uriy.Mishra','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+23&background=random','2026-01-24 11:06:19.852','2021-05-25 06:56:55.691','2026-01-24 11:06:19.853',2),
('8a28973e-70bc-4f92-921c-5bd81904cf2c','student491@example.com','student491','Carol.Lopez35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+491&background=random','2026-01-24 11:06:20.669','2024-07-09 03:24:39.438','2026-01-24 11:06:20.669',3),
('8a2e9635-7351-473c-94be-ac9183840af2','student143@example.com','student143','Kelvin.Óskarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+143&background=random','2026-01-24 11:06:20.237','2025-06-10 18:53:58.800','2026-01-24 11:06:20.238',3),
('8a34df60-9db7-41ee-ae0b-50f145b7d455','student517@example.com','student517','Bunmi_Agbaria','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+517&background=random','2026-01-24 11:06:20.698','2025-07-18 23:36:31.123','2026-01-24 11:06:20.699',3),
('8a4491a4-d7f7-4ffe-80b4-a11a69b2e8f9','student313@example.com','student313','Manju_Þorsteinsson58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+313&background=random','2026-01-24 11:06:20.461','2025-04-06 22:58:37.068','2026-01-24 11:06:20.461',3),
('8a9d2618-b88b-43f2-9eff-97820a411879','student867@example.com','student867','Xiang_Jónasdóttir90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+867&background=random','2026-01-24 11:06:21.103','2025-07-22 11:33:05.898','2026-01-24 11:06:21.103',3),
('8aba55e3-77ba-46b8-bda7-48863a3324c8','student421@example.com','student421','Erna_Bjarnadóttir10','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+421&background=random','2026-01-24 11:06:20.594','2024-12-23 01:15:05.375','2026-01-24 11:06:20.595',3),
('8b1da611-f1f6-43bd-a932-bb8d013f2837','student751@example.com','student751','Dariusz.Jasiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+751&background=random','2026-01-24 11:06:20.960','2021-02-13 03:18:57.504','2026-01-24 11:06:20.961',3),
('8b4f7a07-7e06-4536-a377-11e4ba48bfec','student27@example.com','student27','Natalya.Fernández70','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+27&background=random','2026-01-24 11:06:20.101','2025-08-14 17:28:34.210','2026-01-24 11:06:20.101',3),
('8b5ffd76-0442-40be-88f5-2c46003ec21e','student724@example.com','student724','Nobuko_Grabowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+724&background=random','2026-01-24 11:06:20.928','2021-03-15 01:40:24.920','2026-01-24 11:06:20.929',3),
('8b7f12af-08b1-4454-a444-965c7cd724cb','teacher200@example.com','teacher200','Themba.Schäfer63','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+200&background=random','2026-01-24 11:06:20.065','2024-01-05 19:47:51.754','2026-01-24 11:06:20.066',2),
('8b933fd3-8fa3-43c7-8422-84cfb0f560d3','student518@example.com','student518','Ming_Wairimu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+518&background=random','2026-01-24 11:06:20.699','2025-08-09 00:20:45.949','2026-01-24 11:06:20.700',3),
('8b99bbb9-bb10-45c2-90a1-ecefa30ba9cc','student834@example.com','student834','Chan_Chávez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+834&background=random','2026-01-24 11:06:21.066','2021-05-08 02:46:41.016','2026-01-24 11:06:21.067',3),
('8ba3fbd2-6f54-4e44-bb80-dd6c6e973bb2','student408@example.com','student408','Inga.Lloyd','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+408&background=random','2026-01-24 11:06:20.579','2022-06-07 15:33:20.078','2026-01-24 11:06:20.580',3),
('8bcdfb1a-1802-4969-8f25-b2f5b4e4d809','student133@example.com','student133','Yoshimi.Æbeltoft','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+133&background=random','2026-01-24 11:06:20.226','2021-05-09 05:48:06.062','2026-01-24 11:06:20.227',3),
('8bd89b3e-1514-462a-8d22-e9ccb404a174','teacher131@example.com','teacher131','Vladimir_Smirnova31','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+131&background=random','2026-01-24 11:06:19.986','2022-09-07 22:19:00.232','2026-01-24 11:06:19.986',2),
('8c06716d-2b3e-493b-80a9-7012701133f4','teacher93@example.com','teacher93','Nonhlanhla_Gísladóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+93&background=random','2026-01-24 11:06:19.938','2023-01-17 13:50:47.505','2026-01-24 11:06:19.939',2),
('8c2207c1-35b1-4315-bfe8-41f215dc255a','student557@example.com','student557','Yu_Walczak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+557&background=random','2026-01-24 11:06:20.742','2023-06-30 16:28:26.670','2026-01-24 11:06:20.743',3),
('8c38b4fb-e57e-4ea4-bb89-8009755fcb8a','student957@example.com','student957','Rakesh_Meyer17','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+957&background=random','2026-01-24 11:06:21.212','2021-07-05 15:05:59.387','2026-01-24 11:06:21.213',3),
('8c7a7589-092d-4aff-bc09-d74af9122a49','student86@example.com','student86','Somchit_Prieto71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+86&background=random','2026-01-24 11:06:20.170','2023-12-03 04:55:17.730','2026-01-24 11:06:20.171',3),
('8c8e575a-d5bb-4835-af37-6c1077edd3b2','student837@example.com','student837','Purity.Andreeva','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+837&background=random','2026-01-24 11:06:21.069','2025-11-10 11:56:31.107','2026-01-24 11:06:21.070',3),
('8d0e82d2-a9d7-4ca9-9ae6-585d3d456d23','student693@example.com','student693','Purity.Ragnarsdóttir37','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+693&background=random','2026-01-24 11:06:20.892','2024-11-28 01:15:49.217','2026-01-24 11:06:20.892',3),
('8d238f23-9de3-41c3-9cee-141641bd41e0','student190@example.com','student190','Mei_Guðmundsdóttir2','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+190&background=random','2026-01-24 11:06:20.304','2023-04-29 09:56:03.023','2026-01-24 11:06:20.305',3),
('8d44a412-df2c-478c-a254-619b2d64f58e','teacher66@example.com','teacher66','Jin.Jóhannesson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+66&background=random','2026-01-24 11:06:19.908','2022-10-20 17:27:48.265','2026-01-24 11:06:19.909',2),
('8d9f139b-5b1e-4773-b279-16c0add45b88','student429@example.com','student429','Lilian.Mikhaylova','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+429&background=random','2026-01-24 11:06:20.603','2024-01-27 13:23:29.532','2026-01-24 11:06:20.604',3),
('8da7ed80-fc0a-42a9-94f8-63e2bed16bd0','student219@example.com','student219','Rita.Arnarson21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+219&background=random','2026-01-24 11:06:20.341','2022-04-09 02:49:57.883','2026-01-24 11:06:20.341',3),
('8daf004a-20b4-47da-b28c-e7d83404a675','student461@example.com','student461','Arnar.Kamiński36','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+461&background=random','2026-01-24 11:06:20.637','2025-07-23 09:54:01.911','2026-01-24 11:06:20.638',3),
('8ddbf458-8eb1-4581-9332-4317f1fac7f2','student866@example.com','student866','Ilya.Davis85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+866&background=random','2026-01-24 11:06:21.101','2023-04-11 16:53:34.660','2026-01-24 11:06:21.102',3),
('8ddec308-27c4-4866-8305-2957c863460f','student947@example.com','student947','Sombat.Ito58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+947&background=random','2026-01-24 11:06:21.199','2023-08-12 22:26:15.062','2026-01-24 11:06:21.200',3),
('8dfc8273-48e7-4cb9-b290-03f63628e3ae','student814@example.com','student814','Maria-Pilar_Chepkemoi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+814&background=random','2026-01-24 11:06:21.030','2025-01-03 17:29:15.334','2026-01-24 11:06:21.031',3),
('8e621676-034a-4c09-b8e2-c6bd8a869716','student677@example.com','student677','Bin_Mustapha28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+677&background=random','2026-01-24 11:06:20.873','2021-06-01 01:30:29.916','2026-01-24 11:06:20.874',3),
('8e7ed90d-d89c-4af2-83b6-0016b10508c3','student567@example.com','student567','Margaret.Patel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+567&background=random','2026-01-24 11:06:20.754','2025-12-03 02:24:18.063','2026-01-24 11:06:20.755',3),
('8eea18e1-7f77-4c50-8d49-3f7b41d99749','teacher91@example.com','teacher91','Shigeru.Umar1','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+91&background=random','2026-01-24 11:06:19.936','2021-01-28 06:14:06.213','2026-01-24 11:06:19.937',2),
('8f058c9d-063e-49d8-8912-a8d1859be40c','student555@example.com','student555','Jianjun.Fukuda57','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+555&background=random','2026-01-24 11:06:20.740','2022-07-28 14:21:34.347','2026-01-24 11:06:20.741',3),
('8f1b5fef-d64f-4cfb-b9a6-cd8eb808de4d','student619@example.com','student619','Roman_Gunnarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+619&background=random','2026-01-24 11:06:20.811','2023-10-27 03:37:07.459','2026-01-24 11:06:20.811',3),
('8f85e190-97df-439c-b8e2-d1bb7e5944e9','student403@example.com','student403','Iwona_Popova','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+403&background=random','2026-01-24 11:06:20.572','2024-06-09 11:29:40.248','2026-01-24 11:06:20.573',3),
('8f86d549-dc75-4620-8dda-71b64e4fbf7c','student151@example.com','student151','Mieko.Pokorná','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+151&background=random','2026-01-24 11:06:20.247','2025-04-22 07:59:06.413','2026-01-24 11:06:20.248',3),
('8fd22f91-d4be-4d95-aa90-787a37e62a20','student952@example.com','student952','Adiy.Árnadóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+952&background=random','2026-01-24 11:06:21.205','2025-04-28 03:18:07.150','2026-01-24 11:06:21.206',3),
('90208eb9-36bc-4c4c-bafe-59971dec0c03','student128@example.com','student128','Jose-Manuel.Guðmundsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+128&background=random','2026-01-24 11:06:20.220','2025-08-27 02:42:31.206','2026-01-24 11:06:20.221',3),
('9033d22d-330b-4948-be8f-fd2ee881f6f3','teacher31@example.com','teacher31','Qiang.Jenkins','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+31&background=random','2026-01-24 11:06:19.862','2023-08-14 19:18:27.857','2026-01-24 11:06:19.862',2),
('903b39aa-96de-4079-81de-e4d7147b2ae0','student156@example.com','student156','Irina_Oakley86','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+156&background=random','2026-01-24 11:06:20.254','2022-03-12 03:40:53.152','2026-01-24 11:06:20.254',3),
('904f3b4d-3788-4e2a-a412-f0d0fba4e558','student177@example.com','student177','Heinz.Gísladóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+177&background=random','2026-01-24 11:06:20.284','2023-10-20 03:31:11.801','2026-01-24 11:06:20.284',3),
('905bef7a-256c-4d38-a68f-8956e03c74ff','teacher83@example.com','teacher83','Somnuek.Xu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+83&background=random','2026-01-24 11:06:19.928','2021-02-05 02:24:30.136','2026-01-24 11:06:19.929',2),
('908c6f8f-0386-428c-aa19-ca6cf00cf644','student993@example.com','student993','Nittaya_Oakley42','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+993&background=random','2026-01-24 11:06:21.254','2022-04-04 21:09:19.270','2026-01-24 11:06:21.255',3),
('90a7ca16-3f4d-45b3-8667-146cc0d14800','student711@example.com','student711','Heike.Kaur14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+711&background=random','2026-01-24 11:06:20.913','2024-03-13 04:51:00.824','2026-01-24 11:06:20.914',3),
('913de85b-a7fc-4068-ba69-7a9b74fa0828','student776@example.com','student776','Wirat_Bunsi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+776&background=random','2026-01-24 11:06:20.988','2024-12-07 14:44:47.246','2026-01-24 11:06:20.989',3),
('91500b31-48da-4d26-a2b3-2271ed7019ea','student462@example.com','student462','Yhudah_Amadi40','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+462&background=random','2026-01-24 11:06:20.638','2022-04-09 11:44:47.162','2026-01-24 11:06:20.639',3),
('917d1e6b-cb04-48cb-b684-6bc38124d0b9','student264@example.com','student264','Wanjiru_Förster70','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+264&background=random','2026-01-24 11:06:20.396','2023-06-16 11:31:41.178','2026-01-24 11:06:20.397',3),
('918653e6-d6be-4075-9012-623250505270','student910@example.com','student910','Eliyahu_Árnadóttir23','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+910&background=random','2026-01-24 11:06:21.152','2022-01-12 03:57:41.045','2026-01-24 11:06:21.153',3),
('91a0f988-050d-4702-91ae-0960bd047766','student232@example.com','student232','Tebogo_Fiala','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+232&background=random','2026-01-24 11:06:20.356','2023-07-22 16:12:53.793','2026-01-24 11:06:20.357',3),
('9215e623-3ab8-40b7-8dbc-da289fde2866','student330@example.com','student330','Andrea_Maseko13','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+330&background=random','2026-01-24 11:06:20.482','2023-08-28 22:31:43.677','2026-01-24 11:06:20.483',3),
('9227b37c-e56f-47c1-adaf-d195657595de','student404@example.com','student404','Petra.Sánchez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+404&background=random','2026-01-24 11:06:20.574','2023-08-10 19:21:31.184','2026-01-24 11:06:20.575',3),
('923940ef-d257-40c3-bcb1-18cf70be9c9b','teacher70@example.com','teacher70','Shankar_Isaac','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+70&background=random','2026-01-24 11:06:19.913','2024-12-15 01:26:03.256','2026-01-24 11:06:19.914',2),
('923f9cc1-74c4-4385-b86c-d52ee221fb3d','student934@example.com','student934','Xiang.Fan59','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+934&background=random','2026-01-24 11:06:21.180','2021-06-05 14:44:11.836','2026-01-24 11:06:21.181',3),
('926fa423-f86b-43ee-afc6-e7d1f047efc7','student860@example.com','student860','Kelvin.Ruiz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+860&background=random','2026-01-24 11:06:21.095','2024-03-28 01:51:09.434','2026-01-24 11:06:21.096',3),
('929459ee-3a07-4c73-961b-47928c311586','student64@example.com','student64','Ramesh.Groß50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+64&background=random','2026-01-24 11:06:20.145','2024-03-31 20:40:56.447','2026-01-24 11:06:20.146',3),
('92ade9f3-ad95-4abc-9a96-5aaf64cf0eeb','student374@example.com','student374','Angela_Möller','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+374&background=random','2026-01-24 11:06:20.536','2023-03-10 07:26:37.130','2026-01-24 11:06:20.537',3),
('92ce5f96-8b77-4884-bd49-041847a6d551','student702@example.com','student702','Paulina_Magnússon','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+702&background=random','2026-01-24 11:06:20.903','2025-11-26 05:26:32.582','2026-01-24 11:06:20.904',3),
('92d04b6c-4521-45e0-b591-be7f79163503','student288@example.com','student288','Xiaoli.Jóhannesson82','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+288&background=random','2026-01-24 11:06:20.428','2022-07-12 16:08:21.593','2026-01-24 11:06:20.429',3),
('930ae4e1-d353-4b80-b1c0-a522390b4dd8','student638@example.com','student638','Hiroko_Baldursdóttir16','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+638&background=random','2026-01-24 11:06:20.831','2023-06-25 00:03:34.671','2026-01-24 11:06:20.832',3),
('931af060-f207-4676-903f-57182aa23be6','student895@example.com','student895','Anan_Nakajima','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+895&background=random','2026-01-24 11:06:21.134','2021-12-16 22:47:33.412','2026-01-24 11:06:21.135',3),
('93468d9a-552c-4239-9704-87a29fe6ab30','student62@example.com','student62','Dilip.Jóhannesson19','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+62&background=random','2026-01-24 11:06:20.143','2021-08-12 15:47:02.898','2026-01-24 11:06:20.144',3),
('934a379a-8a84-47a3-b773-c7a04316d1fd','student363@example.com','student363','Hadiza_Žukauskas56','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+363&background=random','2026-01-24 11:06:20.523','2025-11-19 10:34:31.660','2026-01-24 11:06:20.524',3),
('93644338-272c-4f5f-b770-d72665489d77','teacher4@example.com','teacher4','Ingrid_Clarke','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+4&background=random','2026-01-24 11:06:19.828','2023-08-19 07:00:56.652','2026-01-24 11:06:19.829',2),
('941e87a2-fe0d-4703-8d02-0490691e7ebf','student61@example.com','student61','Monika.Govender6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+61&background=random','2026-01-24 11:06:20.142','2025-11-02 17:17:03.669','2026-01-24 11:06:20.142',3),
('943708af-49a0-4773-bd85-0d321d15823b','student979@example.com','student979','David_Ðorðić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+979&background=random','2026-01-24 11:06:21.239','2024-10-11 08:39:25.423','2026-01-24 11:06:21.240',3),
('94788d32-45f0-4468-8733-c5a47c8c3ca1','student493@example.com','student493','Richard_Gómez58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+493&background=random','2026-01-24 11:06:20.671','2022-04-21 09:35:22.924','2026-01-24 11:06:20.672',3),
('9486d9d8-e6ac-4efa-8eae-bd248edb2954','teacher64@example.com','teacher64','Hassan_Mthethwa95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+64&background=random','2026-01-24 11:06:19.904','2023-01-02 23:20:38.904','2026-01-24 11:06:19.905',2),
('94b36c94-ab46-4697-b19a-fad431c33d07','teacher101@example.com','teacher101','Yue.Dauda21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+101&background=random','2026-01-24 11:06:19.949','2023-01-01 22:53:31.241','2026-01-24 11:06:19.949',2),
('94b8f56a-1dbf-415b-bcb3-8b6d7748d01d','student460@example.com','student460','Alan_Žukauskas','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+460&background=random','2026-01-24 11:06:20.636','2024-01-12 18:02:09.397','2026-01-24 11:06:20.637',3),
('94d4e34d-bc49-4bdd-9c25-6c6ca22cd402','student774@example.com','student774','Colin_Jónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+774&background=random','2026-01-24 11:06:20.987','2022-04-22 23:15:33.161','2026-01-24 11:06:20.987',3),
('94d5b62d-4410-4b1b-8ef2-fd204828fc94','student492@example.com','student492','Hauwa_Jónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+492&background=random','2026-01-24 11:06:20.670','2023-07-18 07:04:02.252','2026-01-24 11:06:20.671',3),
('952baedf-8b39-4367-b458-274fc72b0b01','student551@example.com','student551','Jorge_Őllösová50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+551&background=random','2026-01-24 11:06:20.736','2023-08-24 09:17:05.054','2026-01-24 11:06:20.737',3),
('955a2f82-dc1f-4454-8148-99812db509e1','student253@example.com','student253','Jorge_Kongkaeo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+253&background=random','2026-01-24 11:06:20.383','2023-12-30 14:02:15.060','2026-01-24 11:06:20.383',3),
('95934c5c-f878-44b1-b2c9-fefd93212a15','student353@example.com','student353','Pilar.Krüger','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+353&background=random','2026-01-24 11:06:20.510','2025-06-23 21:34:24.165','2026-01-24 11:06:20.511',3),
('9595036a-00fd-4c21-aff1-13243a64eb9b','student525@example.com','student525','Kanchana_Árnadóttir2','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+525&background=random','2026-01-24 11:06:20.707','2024-03-21 20:39:53.510','2026-01-24 11:06:20.707',3),
('960b3293-032e-46c4-bdad-cbf418b6531e','student340@example.com','student340','Yoko.Olszewski1','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+340&background=random','2026-01-24 11:06:20.494','2023-03-12 11:13:54.073','2026-01-24 11:06:20.494',3),
('960efc82-f2ea-4765-83da-1a634d7d94ca','student410@example.com','student410','Jose-Manuel.Hájek','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+410&background=random','2026-01-24 11:06:20.581','2024-01-04 13:00:16.786','2026-01-24 11:06:20.582',3),
('9619957f-39c0-4d3e-837f-600316d46c43','student960@example.com','student960','Kanchana.Jóhannesson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+960&background=random','2026-01-24 11:06:21.216','2021-05-06 05:40:25.825','2026-01-24 11:06:21.216',3),
('962eac82-fddf-44fb-9f51-e712d6ead493','student108@example.com','student108','Watsana.Omondi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+108&background=random','2026-01-24 11:06:20.197','2024-05-02 06:27:21.119','2026-01-24 11:06:20.198',3),
('964708da-926b-49ea-a459-58c39abb6942','student833@example.com','student833','Hideo_Saetang45','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+833&background=random','2026-01-24 11:06:21.065','2024-12-10 02:10:50.961','2026-01-24 11:06:21.065',3),
('96815528-d4b8-4669-b6dd-30c5671ca5bc','student633@example.com','student633','Watsana.Aliyu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+633&background=random','2026-01-24 11:06:20.826','2025-10-08 05:11:31.337','2026-01-24 11:06:20.827',3),
('96ecf934-0d42-484b-a02c-122bafe1bece','student197@example.com','student197','Dolores.Álvarez57','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+197&background=random','2026-01-24 11:06:20.313','2025-08-13 07:03:52.159','2026-01-24 11:06:20.314',3),
('96ee0b3a-64b6-4c80-9bf0-7c496e18baa4','teacher62@example.com','teacher62','Nikita_Pillay','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+62&background=random','2026-01-24 11:06:19.902','2021-03-23 06:17:16.122','2026-01-24 11:06:19.903',2),
('970a4918-06f0-4025-90e2-2874269a764b','student714@example.com','student714','Magdalena_Gupta','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+714&background=random','2026-01-24 11:06:20.916','2023-10-10 05:30:52.658','2026-01-24 11:06:20.917',3),
('974b48ce-8ac3-4795-8c28-e5666db0b455','student765@example.com','student765','Bernd_Pokorný','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+765&background=random','2026-01-24 11:06:20.976','2023-09-07 08:47:21.320','2026-01-24 11:06:20.977',3),
('9757fd04-a27f-4e4a-bbcd-a9c5db8de0ff','student308@example.com','student308','Takako.Svobodová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+308&background=random','2026-01-24 11:06:20.454','2024-10-11 04:07:54.220','2026-01-24 11:06:20.455',3),
('97f98be4-2721-49d7-90fd-bbb68e38acf6','student930@example.com','student930','Dieter_Groß73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+930&background=random','2026-01-24 11:06:21.175','2021-01-25 20:50:14.852','2026-01-24 11:06:21.175',3),
('985ff234-0294-4e2a-ad0c-969d02b22db5','teacher154@example.com','teacher154','Pavel.Ðekić29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+154&background=random','2026-01-24 11:06:20.012','2024-09-21 03:44:02.267','2026-01-24 11:06:20.013',2),
('9920af04-89ef-45bb-8478-a31dd053b8e6','student847@example.com','student847','Pavel_Kucharski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+847&background=random','2026-01-24 11:06:21.081','2022-02-14 13:08:48.879','2026-01-24 11:06:21.082',3),
('996becd9-307c-48ce-832a-b6e0463234b1','student941@example.com','student941','Rose_Álvarez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+941&background=random','2026-01-24 11:06:21.189','2021-10-20 07:45:15.849','2026-01-24 11:06:21.190',3),
('9993c3e9-1b8c-45ff-8fa1-c32282db551d','student805@example.com','student805','Catherine.Fialová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+805&background=random','2026-01-24 11:06:21.021','2024-12-01 08:31:33.323','2026-01-24 11:06:21.022',3),
('99ab554c-fdf4-4496-983c-4b762e92a4ac','student445@example.com','student445','Emiko.Ðorðić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+445&background=random','2026-01-24 11:06:20.620','2025-04-24 16:27:32.571','2026-01-24 11:06:20.621',3),
('99bb262f-5e0b-41cc-aacb-387277ece120','student692@example.com','student692','Isa.Jiménez6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+692&background=random','2026-01-24 11:06:20.891','2025-03-21 09:33:42.226','2026-01-24 11:06:20.891',3),
('9a601d0e-472b-4509-b5d5-79dfa2d55f66','teacher173@example.com','teacher173','Edda_Marková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+173&background=random','2026-01-24 11:06:20.035','2021-02-28 12:25:33.184','2026-01-24 11:06:20.035',2),
('9af0c507-f3dd-4160-8480-53897d389180','student938@example.com','student938','Richard_Starr53','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+938&background=random','2026-01-24 11:06:21.185','2025-12-24 13:05:07.005','2026-01-24 11:06:21.185',3),
('9b9336c9-4506-49f3-98e7-2f6b625c0d88','student446@example.com','student446','Prasoet_Nyambura76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+446&background=random','2026-01-24 11:06:20.621','2024-12-12 13:22:12.814','2026-01-24 11:06:20.621',3),
('9b97a7a1-4b8b-481a-8e41-10ff6503caa4','student968@example.com','student968','Somkhit.Horáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+968&background=random','2026-01-24 11:06:21.225','2023-01-04 19:48:33.200','2026-01-24 11:06:21.225',3),
('9b9bdd19-884f-48e9-8a2b-8809cbcd7661','student901@example.com','student901','Katsumi.Kato73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+901&background=random','2026-01-24 11:06:21.141','2021-05-08 16:40:57.425','2026-01-24 11:06:21.142',3),
('9bec9603-7912-4797-824b-fd5af8fba6a1','student909@example.com','student909','Simon_Jasiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+909&background=random','2026-01-24 11:06:21.151','2024-05-05 20:05:08.007','2026-01-24 11:06:21.151',3),
('9c2f4853-3403-4d64-929f-21ce5b9653d3','student874@example.com','student874','Maciej.Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+874&background=random','2026-01-24 11:06:21.110','2023-01-17 00:44:21.708','2026-01-24 11:06:21.110',3),
('9c7aedd1-4e3a-4bd7-9b2b-b63ce250dc2f','student102@example.com','student102','Omer_Marková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+102&background=random','2026-01-24 11:06:20.187','2023-06-21 16:28:41.341','2026-01-24 11:06:20.187',3),
('9d529920-a74c-4194-aeb7-5fcffad44320','student680@example.com','student680','Tadashi_Mkhize','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+680&background=random','2026-01-24 11:06:20.877','2025-05-02 10:52:32.289','2026-01-24 11:06:20.878',3),
('9d887094-52fc-42d5-a30f-7b9ff5379868','student320@example.com','student320','Hulda.Jackson77','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+320&background=random','2026-01-24 11:06:20.469','2022-12-14 23:28:19.487','2026-01-24 11:06:20.470',3),
('9dd4c328-055f-4015-9a59-053194b44813','student538@example.com','student538','Rong_Behera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+538&background=random','2026-01-24 11:06:20.720','2026-01-01 19:57:13.662','2026-01-24 11:06:20.721',3),
('9dd4ec58-6273-4eeb-b0c2-90140644efec','student813@example.com','student813','Mahmood.Ðekić94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+813&background=random','2026-01-24 11:06:21.029','2021-10-01 20:55:14.246','2026-01-24 11:06:21.030',3),
('9de6cabf-f121-4512-b404-b41f80f07bbb','student355@example.com','student355','Mariya_Mohamed73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+355&background=random','2026-01-24 11:06:20.513','2024-01-05 10:22:57.473','2026-01-24 11:06:20.514',3),
('9e165e67-82dc-4492-b3a3-1ee88410dbe9','student514@example.com','student514','Umar_Pal','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+514&background=random','2026-01-24 11:06:20.695','2022-07-17 02:17:29.711','2026-01-24 11:06:20.696',3),
('9e23017a-e33a-489d-9a80-4c56665573dd','teacher174@example.com','teacher174','Nancy_Björnsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+174&background=random','2026-01-24 11:06:20.036','2025-12-09 14:29:27.395','2026-01-24 11:06:20.036',2),
('9e2e9c9f-e7d4-4122-9915-d642372b559a','teacher184@example.com','teacher184','Sibongile.Harðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+184&background=random','2026-01-24 11:06:20.047','2025-05-23 12:43:34.766','2026-01-24 11:06:20.048',2),
('9e5a56ed-6638-47fd-9f5f-97d498fc2152','student801@example.com','student801','Wanphen.Abdullahi95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+801&background=random','2026-01-24 11:06:21.016','2024-03-09 00:55:10.375','2026-01-24 11:06:21.017',3),
('9e629773-10c3-47a1-8da6-d8b832de1341','student66@example.com','student66','Maksim.Tang24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+66&background=random','2026-01-24 11:06:20.148','2023-05-14 20:27:06.003','2026-01-24 11:06:20.149',3),
('9e72ea1b-0b1a-4510-badf-db5058c4d594','student932@example.com','student932','Faith_Song','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+932&background=random','2026-01-24 11:06:21.177','2023-04-02 12:45:45.022','2026-01-24 11:06:21.178',3),
('9e954976-f933-4c61-a834-a880df0ad8cd','teacher147@example.com','teacher147','Somchit.Diaz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+147&background=random','2026-01-24 11:06:20.004','2025-03-07 05:20:14.253','2026-01-24 11:06:20.005',2),
('9ec74d85-03c2-44f7-8cbd-2bf25bd14164','student635@example.com','student635','Hiromi_Ūžien54','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+635&background=random','2026-01-24 11:06:20.828','2023-11-06 17:29:35.740','2026-01-24 11:06:20.828',3),
('9ed396ba-8d33-41ec-a05c-9116ed02cd40','student534@example.com','student534','Jianguo.Dvořáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+534&background=random','2026-01-24 11:06:20.716','2021-10-23 07:30:55.492','2026-01-24 11:06:20.717',3),
('9ee9fcf2-f914-499c-ac06-9d3db356e7cf','student838@example.com','student838','Ian.Óskarsdóttir78','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+838&background=random','2026-01-24 11:06:21.070','2025-05-27 05:47:38.120','2026-01-24 11:06:21.071',3),
('9f4b7352-908c-4edd-b7b8-d2048aac25c4','student591@example.com','student591','Qing_Fernández26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+591&background=random','2026-01-24 11:06:20.780','2023-11-01 12:31:57.387','2026-01-24 11:06:20.781',3),
('9f60b17f-d4f1-4b2c-8d2f-72c7022c269b','student790@example.com','student790','Jose-Antonio_Pawlak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+790&background=random','2026-01-24 11:06:21.003','2025-03-23 20:24:26.607','2026-01-24 11:06:21.004',3),
('9f8d281d-8fe8-40ac-ae64-3dd561bf1dc1','student709@example.com','student709','Birgir.Dudek','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+709&background=random','2026-01-24 11:06:20.911','2022-07-08 22:53:14.738','2026-01-24 11:06:20.911',3),
('9f9c408d-8afa-489a-bb09-aee48fcd5c70','student435@example.com','student435','Laxmi_Björnsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+435&background=random','2026-01-24 11:06:20.610','2025-07-23 03:31:41.910','2026-01-24 11:06:20.610',3),
('9fd31646-a9b3-4d89-a8f1-fe7324c84a61','student923@example.com','student923','Sunthon_Okoth40','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+923&background=random','2026-01-24 11:06:21.167','2024-10-03 10:39:09.848','2026-01-24 11:06:21.168',3),
('a0297148-9284-4aea-af25-a2bd30e562af','student238@example.com','student238','Uwe.Bello','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+238&background=random','2026-01-24 11:06:20.363','2024-06-26 19:42:07.703','2026-01-24 11:06:20.364',3),
('a07704f3-4e91-477a-abce-6c55b2c8cecc','student787@example.com','student787','Haiyan.Watson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+787&background=random','2026-01-24 11:06:21.000','2024-02-09 00:26:31.068','2026-01-24 11:06:21.001',3),
('a0f21ba0-6ca9-4341-92fe-8914c9dbe3cd','student339@example.com','student339','Mpho.Dudek43','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+339&background=random','2026-01-24 11:06:20.493','2024-11-29 04:32:16.916','2026-01-24 11:06:20.493',3),
('a0f62f77-5afe-44c7-8eed-a6183c538aab','student586@example.com','student586','Purity_Abubakar20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+586&background=random','2026-01-24 11:06:20.775','2025-09-14 22:51:59.727','2026-01-24 11:06:20.776',3),
('a106522e-3982-4ac8-b16e-f4625662cce5','student328@example.com','student328','Hans_Saidu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+328&background=random','2026-01-24 11:06:20.480','2021-03-11 16:37:16.006','2026-01-24 11:06:20.480',3),
('a13a1898-e842-4aeb-b6dc-701396cb399b','student240@example.com','student240','Mohan_Nel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+240&background=random','2026-01-24 11:06:20.367','2024-04-10 21:59:26.259','2026-01-24 11:06:20.367',3),
('a14bf88d-25ec-4a41-9511-188f1dda6f0c','student563@example.com','student563','Hui.Ødegård90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+563&background=random','2026-01-24 11:06:20.749','2025-06-19 09:13:52.826','2026-01-24 11:06:20.750',3),
('a162255a-a874-4947-a016-2d1b0741ff39','teacher29@example.com','teacher29','Andri.Baldursdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+29&background=random','2026-01-24 11:06:19.859','2024-02-09 21:20:00.127','2026-01-24 11:06:19.860',2),
('a1655fb8-c135-4879-920c-22bab8ac83c2','teacher18@example.com','teacher18','Amnuai_Veselý58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+18&background=random','2026-01-24 11:06:19.846','2022-02-06 01:23:59.502','2026-01-24 11:06:19.847',2),
('a1b071d7-2e6c-4450-9f27-e3f83e100ede','student13@example.com','student13','Lilian.Göbel62','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+13&background=random','2026-01-24 11:06:20.083','2025-02-28 20:24:46.324','2026-01-24 11:06:20.083',3),
('a1bf832b-0ba5-405f-a607-1c5b73dd2f18','student386@example.com','student386','Ajay_Novák44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+386&background=random','2026-01-24 11:06:20.552','2024-10-26 15:53:57.036','2026-01-24 11:06:20.553',3),
('a1d85e66-1c6f-441c-8b04-49603327e11f','student11@example.com','student11','Jane_Fröhlich64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+11&background=random','2026-01-24 11:06:20.080','2023-05-24 01:05:10.693','2026-01-24 11:06:20.080',3),
('a216f037-1b94-48f9-98c3-e86eb94829d6','student741@example.com','student741','Nkosinathi_Smirnova97','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+741&background=random','2026-01-24 11:06:20.949','2023-10-02 16:05:18.452','2026-01-24 11:06:20.949',3),
('a2596a83-1689-4c30-8c0e-da17e15d627e','student36@example.com','student36','Sita_Benešová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+36&background=random','2026-01-24 11:06:20.113','2021-06-14 10:38:33.919','2026-01-24 11:06:20.114',3),
('a27ada98-7c4c-4243-87c7-bf578e80b273','student565@example.com','student565','Nathan.Tomaszewski18','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+565&background=random','2026-01-24 11:06:20.752','2022-12-21 16:06:38.638','2026-01-24 11:06:20.752',3),
('a2d6a12d-69a9-4497-bac0-de2e7b1b6945','student228@example.com','student228','Na.Halldórsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+228&background=random','2026-01-24 11:06:20.350','2023-02-07 10:45:21.042','2026-01-24 11:06:20.351',3),
('a2fe4b15-8a9c-4091-b72d-92a1fc8f151b','student263@example.com','student263','Min.Pérez7','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+263&background=random','2026-01-24 11:06:20.395','2023-03-21 00:19:18.283','2026-01-24 11:06:20.396',3),
('a32998f8-b54b-4700-8052-d9034769aa38','student372@example.com','student372','Urai.Hill','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+372&background=random','2026-01-24 11:06:20.534','2023-12-31 09:09:03.908','2026-01-24 11:06:20.535',3),
('a332858f-fb97-4aca-ae94-cf7e04fb08b4','student132@example.com','student132','Prasoet.Ūsas','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+132&background=random','2026-01-24 11:06:20.224','2025-04-30 15:44:27.117','2026-01-24 11:06:20.225',3),
('a36d0256-28c9-4b28-a35b-5185728cc7d4','student582@example.com','student582','Mo_Köhler5','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+582&background=random','2026-01-24 11:06:20.770','2025-08-13 05:56:59.920','2026-01-24 11:06:20.771',3),
('a37c86cd-da4f-4835-82e6-26fc4a72900d','teacher132@example.com','teacher132','Petrus.Žáková22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+132&background=random','2026-01-24 11:06:19.987','2025-03-24 03:40:14.101','2026-01-24 11:06:19.987',2),
('a3a796de-5791-4e66-addc-f370b700cbf0','student969@example.com','student969','Anna.Bauer80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+969&background=random','2026-01-24 11:06:21.226','2021-10-21 12:00:51.321','2026-01-24 11:06:21.227',3),
('a3f85e52-9cdd-4583-9859-c4f3184b1e7d','student707@example.com','student707','Yelena.Nkosi85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+707&background=random','2026-01-24 11:06:20.909','2024-07-28 01:04:23.479','2026-01-24 11:06:20.909',3),
('a42426fe-c2b7-4448-8b5d-14a168530c24','student775@example.com','student775','Chao_Abdi77','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+775&background=random','2026-01-24 11:06:20.988','2022-03-24 18:47:35.719','2026-01-24 11:06:20.988',3),
('a4ae0708-56e0-46f9-a8dd-6fd1c34ec39d','student687@example.com','student687','Inga_Zakharov61','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+687&background=random','2026-01-24 11:06:20.885','2023-04-25 21:31:48.358','2026-01-24 11:06:20.886',3),
('a4d7187e-f397-408f-8304-b50b267e886c','student620@example.com','student620','Sibongile_Masarweh93','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+620&background=random','2026-01-24 11:06:20.812','2021-11-20 04:43:04.985','2026-01-24 11:06:20.812',3),
('a4d75280-c79c-46e7-a307-d68de698bc01','student537@example.com','student537','Dorota_Svobodová90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+537&background=random','2026-01-24 11:06:20.720','2024-07-23 06:52:42.110','2026-01-24 11:06:20.720',3),
('a505409a-8f80-43d7-af70-d00623915fd3','student599@example.com','student599','Somnuek_Óskarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+599&background=random','2026-01-24 11:06:20.789','2021-07-16 17:01:39.962','2026-01-24 11:06:20.790',3),
('a52acd23-2e1f-4080-bf9e-aa81711b1ce2','teacher27@example.com','teacher27','Jan_Novotný0','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+27&background=random','2026-01-24 11:06:19.856','2022-02-10 22:12:03.041','2026-01-24 11:06:19.857',2),
('a5883a12-320f-4f76-93a9-9b701b8006bb','student459@example.com','student459','Magda_Jóhannsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+459&background=random','2026-01-24 11:06:20.635','2025-04-14 19:35:51.056','2026-01-24 11:06:20.636',3),
('a59f0451-2885-4e23-b76e-283e48c21f70','student470@example.com','student470','Mark.Valdez27','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+470&background=random','2026-01-24 11:06:20.647','2024-09-03 23:53:13.421','2026-01-24 11:06:20.647',3),
('a5b7cfcd-9edc-4ae0-a9a0-f21ed8c0ab40','student103@example.com','student103','Sawat.Jónsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+103&background=random','2026-01-24 11:06:20.188','2021-03-11 04:18:42.725','2026-01-24 11:06:20.189',3),
('a5e19d0c-e8a3-4ee9-91cb-99336c9f933a','student60@example.com','student60','Linda.Abdullahi72','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+60&background=random','2026-01-24 11:06:20.141','2024-11-02 02:29:24.908','2026-01-24 11:06:20.141',3),
('a6284e7f-b655-457d-ab3c-ba1997cd262c','student246@example.com','student246','Ingrid.Halldórsson59','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+246&background=random','2026-01-24 11:06:20.374','2025-02-09 15:46:48.737','2026-01-24 11:06:20.375',3),
('a66260f7-abab-4ac2-816b-61a4045686fa','student655@example.com','student655','Sebastian.Jónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+655&background=random','2026-01-24 11:06:20.851','2021-07-18 23:12:40.024','2026-01-24 11:06:20.851',3),
('a67ce615-8362-41c9-b54f-c2895199beac','student139@example.com','student139','Blessing_Horáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+139&background=random','2026-01-24 11:06:20.233','2021-03-01 23:58:28.329','2026-01-24 11:06:20.233',3),
('a6c81fb4-3d2c-4a96-8a37-732473594f81','student295@example.com','student295','Miguel_Yang','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+295&background=random','2026-01-24 11:06:20.436','2022-06-11 03:51:51.349','2026-01-24 11:06:20.437',3),
('a6f805c1-3e05-484b-88bb-58076b6ad870','student106@example.com','student106','Ryoko_Nowakowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+106&background=random','2026-01-24 11:06:20.192','2021-02-13 10:44:27.311','2026-01-24 11:06:20.193',3),
('a782731b-58f7-44d0-a866-c82e71e3a833','student181@example.com','student181','Antonia.Gumede','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+181&background=random','2026-01-24 11:06:20.291','2026-01-13 16:59:23.831','2026-01-24 11:06:20.291',3),
('a86bd3b7-f053-4503-8524-537a0883b3a8','student287@example.com','student287','Hanna.Weiß','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+287&background=random','2026-01-24 11:06:20.427','2022-07-14 22:39:41.856','2026-01-24 11:06:20.427',3),
('a877660c-6051-4034-a636-0fc007574296','student988@example.com','student988','Yun.Őhlschlägerová21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+988&background=random','2026-01-24 11:06:21.249','2023-10-08 11:33:28.147','2026-01-24 11:06:21.249',3),
('a8f7f21d-0083-4231-a490-4009b5648ba9','student737@example.com','student737','Ana.Ólafsdóttir99','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+737&background=random','2026-01-24 11:06:20.944','2024-04-13 21:24:30.373','2026-01-24 11:06:20.945',3),
('a90a9d15-82c9-4922-925e-281f0a9b2c33','teacher35@example.com','teacher35','Katsumi_Volkova66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+35&background=random','2026-01-24 11:06:19.866','2021-06-14 20:48:02.989','2026-01-24 11:06:19.867',2),
('a9651a6f-17c8-4005-bc6f-a1ca961e9658','student644@example.com','student644','Adiy_Pospíšilová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+644&background=random','2026-01-24 11:06:20.840','2022-12-13 20:15:00.797','2026-01-24 11:06:20.840',3),
('a9af7a4e-9235-4c22-9f94-736fbc37fe29','student420@example.com','student420','Carol.Pétursson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+420&background=random','2026-01-24 11:06:20.593','2023-10-12 08:40:21.069','2026-01-24 11:06:20.594',3),
('a9d36b9b-afbb-4cd2-bd61-567427f06e57','student456@example.com','student456','Kristina_Owino','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+456&background=random','2026-01-24 11:06:20.631','2021-06-20 10:20:54.263','2026-01-24 11:06:20.632',3),
('aa27d228-76b0-44bb-9e0a-6220686e79f6','student712@example.com','student712','Rachel.Birgisdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+712&background=random','2026-01-24 11:06:20.914','2025-05-25 00:39:05.841','2026-01-24 11:06:20.915',3),
('aa7f9320-2745-4833-95a8-cef27f1d195b','student598@example.com','student598','Cristina_Karlsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+598&background=random','2026-01-24 11:06:20.788','2021-03-16 02:17:30.347','2026-01-24 11:06:20.788',3),
('aab9b5e1-a946-4efb-9ad5-a2acdfa02ff7','student286@example.com','student286','Barbara_Saengthong','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+286&background=random','2026-01-24 11:06:20.426','2021-06-16 02:16:37.713','2026-01-24 11:06:20.426',3),
('aabd5e7e-d0d8-43d7-9bb1-d2dc99cd3582','student310@example.com','student310','Omer.Khan96','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+310&background=random','2026-01-24 11:06:20.457','2024-11-27 18:34:14.477','2026-01-24 11:06:20.458',3),
('aabeaeb8-0865-44a2-9824-9dd596780eb2','teacher105@example.com','teacher105','Aisha.Stepanov','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+105&background=random','2026-01-24 11:06:19.953','2025-04-08 03:02:49.177','2026-01-24 11:06:19.954',2),
('aae7ead0-02d0-4081-8eed-153cde77e1ca','student216@example.com','student216','Pieter_Hill','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+216&background=random','2026-01-24 11:06:20.337','2022-07-25 07:23:33.384','2026-01-24 11:06:20.338',3),
('ab85cd7a-708e-4f86-89bc-06ba980040c0','student824@example.com','student824','Alina.Cheruiyot','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+824&background=random','2026-01-24 11:06:21.056','2025-03-08 14:41:18.801','2026-01-24 11:06:21.057',3),
('ab95e1cc-1395-40d7-adca-3d9d76004581','student532@example.com','student532','Michal_Hughes12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+532&background=random','2026-01-24 11:06:20.714','2025-01-11 09:03:07.072','2026-01-24 11:06:20.715',3),
('ac2e6d87-85e3-4fdc-9e95-a627efb5c253','student326@example.com','student326','Mark_Jónsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+326&background=random','2026-01-24 11:06:20.477','2022-03-13 07:08:15.947','2026-01-24 11:06:20.478',3),
('ac6c767b-b568-41d9-8c4b-199435ec62b8','student208@example.com','student208','Sawat_Þórðarson57','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+208&background=random','2026-01-24 11:06:20.327','2024-01-01 03:10:07.392','2026-01-24 11:06:20.328',3),
('ac74a2d6-125b-44b9-87de-2d09098b3b87','student576@example.com','student576','Koshi_Gil94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+576&background=random','2026-01-24 11:06:20.764','2022-07-16 07:13:25.789','2026-01-24 11:06:20.764',3),
('ac785e0b-f80d-40d6-9293-94f20ab3a22b','student618@example.com','student618','Sita_Þorsteinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+618&background=random','2026-01-24 11:06:20.809','2024-01-11 00:51:01.225','2026-01-24 11:06:20.810',3),
('acfec4ca-976f-4d86-b8ac-73695cc72b23','student159@example.com','student159','Zhen.Lange54','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+159&background=random','2026-01-24 11:06:20.258','2021-02-13 01:35:20.401','2026-01-24 11:06:20.258',3),
('ad5b9e81-7f6d-4c6e-a685-6f2826ff088e','student877@example.com','student877','Yong.Sisuk','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+877&background=random','2026-01-24 11:06:21.112','2022-06-11 09:12:08.321','2026-01-24 11:06:21.113',3),
('ae1140be-6828-4955-9277-9f80d81746c9','student254@example.com','student254','Agnieszka_Tang95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+254&background=random','2026-01-24 11:06:20.384','2022-10-08 08:47:59.157','2026-01-24 11:06:20.384',3),
('ae4d40d4-1bfb-45e5-af65-45d642e80733','student196@example.com','student196','Hildur.Robinson79','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+196&background=random','2026-01-24 11:06:20.312','2024-06-19 12:46:35.238','2026-01-24 11:06:20.313',3),
('ae6bb7ed-4aab-4c3c-9385-c72e9095fd2b','student279@example.com','student279','Zainab_Davies69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+279&background=random','2026-01-24 11:06:20.417','2024-12-31 09:53:02.428','2026-01-24 11:06:20.417',3),
('ae6f0ebe-bdbb-43d7-805e-3a8da3c43fd2','student342@example.com','student342','Wei_Ramírez39','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+342&background=random','2026-01-24 11:06:20.496','2021-04-13 06:04:54.500','2026-01-24 11:06:20.497',3),
('ae7ff81c-874d-48bd-bad2-8264314b3094','student155@example.com','student155','Miguel-Angel.Hernández','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+155&background=random','2026-01-24 11:06:20.252','2021-11-16 06:04:36.863','2026-01-24 11:06:20.253',3),
('ae822604-419a-46f9-8610-eecb6b96a44b','student528@example.com','student528','Simon_Paswan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+528&background=random','2026-01-24 11:06:20.710','2025-04-19 03:54:13.260','2026-01-24 11:06:20.710',3),
('aee62657-3be0-4285-abcc-22b66b77959c','student113@example.com','student113','Helga.Ramírez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+113&background=random','2026-01-24 11:06:20.204','2022-12-17 23:41:43.733','2026-01-24 11:06:20.204',3),
('aef755c2-2082-4f98-b396-9f362a6bf26e','teacher96@example.com','teacher96','Zhen.Guðmundsdóttir22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+96&background=random','2026-01-24 11:06:19.942','2024-12-31 13:02:02.212','2026-01-24 11:06:19.942',2),
('af2773c3-2508-4b5b-b3b2-d817f5a1873c','teacher164@example.com','teacher164','Maksim.Dvořáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+164&background=random','2026-01-24 11:06:20.024','2024-02-04 13:21:16.292','2026-01-24 11:06:20.025',2),
('af8e5e0d-6459-4e25-804b-0df1e3d32752','student272@example.com','student272','Sunita_Torres76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+272&background=random','2026-01-24 11:06:20.406','2023-09-18 16:26:09.837','2026-01-24 11:06:20.407',3),
('afb6feb2-f728-4f34-9713-70a0685ccd4d','student912@example.com','student912','Hauwa_Halldórsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+912&background=random','2026-01-24 11:06:21.154','2023-12-06 04:38:00.724','2026-01-24 11:06:21.155',3),
('afcce2dc-8ca4-4bd0-ac5c-680dc30cff83','student486@example.com','student486','Maryam.Nováková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+486&background=random','2026-01-24 11:06:20.663','2024-08-07 10:19:28.044','2026-01-24 11:06:20.664',3),
('afeff6a5-9c0e-43ce-b708-15f9811c0c16','student334@example.com','student334','Marek.Pavlov','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+334&background=random','2026-01-24 11:06:20.487','2025-04-11 11:01:36.241','2026-01-24 11:06:20.488',3),
('aff65cf1-c05e-4ea9-ad92-192245a8ec2d','student388@example.com','student388','Nan.Haraldsdóttir20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+388&background=random','2026-01-24 11:06:20.555','2023-11-03 12:36:17.883','2026-01-24 11:06:20.556',3),
('b05975d9-9c6d-4edb-85c3-b371d3a0131a','student942@example.com','student942','Shay.Günther29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+942&background=random','2026-01-24 11:06:21.190','2023-05-21 00:11:12.618','2026-01-24 11:06:21.191',3),
('b0c1fd76-3134-4d14-99dc-12fb5c946021','student999@example.com','student999','David.Kjartansson4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+999&background=random','2026-01-24 11:06:21.261','2024-04-11 07:02:15.916','2026-01-24 11:06:21.261',3),
('b0c6495e-0c49-47a2-ab6d-0b9e2cc4b236','teacher144@example.com','teacher144','Jabulani_Blanco78','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+144&background=random','2026-01-24 11:06:20.000','2022-04-19 15:42:36.005','2026-01-24 11:06:20.001',2),
('b10564fb-56a1-48a9-bced-53e10b8877ed','teacher126@example.com','teacher126','Ming.Rodríguez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+126&background=random','2026-01-24 11:06:19.978','2025-10-28 12:14:24.796','2026-01-24 11:06:19.979',2),
('b11844ec-a6d8-474b-adef-834cda5da270','student45@example.com','student45','Somphong_Jiménez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+45&background=random','2026-01-24 11:06:20.124','2023-02-16 09:30:24.234','2026-01-24 11:06:20.124',3),
('b165cbd6-525f-4694-989a-91b8589655ad','student494@example.com','student494','Yun_Álvarez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+494&background=random','2026-01-24 11:06:20.672','2025-02-15 17:38:04.986','2026-01-24 11:06:20.673',3),
('b1b39396-a218-424e-bcfa-4bf848d650bd','teacher47@example.com','teacher47','Rut.Köhler','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+47&background=random','2026-01-24 11:06:19.881','2022-08-11 02:32:59.743','2026-01-24 11:06:19.882',2),
('b1c55506-b5e5-4fbc-8a0a-a1704a29fed6','teacher9@example.com','teacher9','Somnuek.Botha25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+9&background=random','2026-01-24 11:06:19.835','2025-05-03 23:39:58.292','2026-01-24 11:06:19.836',2),
('b1e048c9-56eb-49c3-b901-18965dce9dd6','teacher125@example.com','teacher125','Mina.Szczepański54','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+125&background=random','2026-01-24 11:06:19.977','2025-11-24 13:31:37.818','2026-01-24 11:06:19.978',2),
('b2261508-93e1-4715-827f-a024eea6f0f6','student928@example.com','student928','Kamil.Morozov18','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+928&background=random','2026-01-24 11:06:21.172','2021-05-28 12:06:03.841','2026-01-24 11:06:21.173',3),
('b2e539c6-939b-4bb0-a2f1-db737a20d9b9','teacher84@example.com','teacher84','Ming.Ivanova74','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+84&background=random','2026-01-24 11:06:19.929','2025-12-25 15:30:34.967','2026-01-24 11:06:19.930',2),
('b33c2fb6-c25b-40d6-bbbf-11d755acf136','student457@example.com','student457','Pawel.Feldman24','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+457&background=random','2026-01-24 11:06:20.632','2022-02-02 22:54:13.315','2026-01-24 11:06:20.633',3),
('b41d98e3-8c1c-4039-8b76-24926151eff6','student890@example.com','student890','Mukesh.Andreev50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+890&background=random','2026-01-24 11:06:21.128','2024-12-16 03:28:39.203','2026-01-24 11:06:21.128',3),
('b443fc36-f05e-490f-bb4a-216887893e62','student657@example.com','student657','Mo_Tshabalala','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+657&background=random','2026-01-24 11:06:20.853','2021-11-16 00:41:44.799','2026-01-24 11:06:20.853',3),
('b447fb3d-0d2e-4031-beb9-3a9b008fd184','student575@example.com','student575','Janet_James','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+575&background=random','2026-01-24 11:06:20.763','2023-04-23 06:09:06.703','2026-01-24 11:06:20.763',3),
('b48d5125-8277-4dcd-9a82-ac5e4770eff3','student375@example.com','student375','Peter.Bjarnadóttir11','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+375&background=random','2026-01-24 11:06:20.537','2023-08-19 08:57:20.939','2026-01-24 11:06:20.538',3),
('b4f3d0d3-2b2d-4ca0-9e8b-65f1f9d582b8','student482@example.com','student482','Toshio_Fang15','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+482&background=random','2026-01-24 11:06:20.659','2025-05-24 12:17:09.959','2026-01-24 11:06:20.660',3),
('b4f5af5f-9cbb-41a3-ae06-66bcd4c490e9','student989@example.com','student989','Purity.Huang','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+989&background=random','2026-01-24 11:06:21.250','2022-08-14 08:19:09.126','2026-01-24 11:06:21.250',3),
('b54c5d0d-7178-4a2e-a525-cda30205e6de','student674@example.com','student674','Joan.Elbaz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+674&background=random','2026-01-24 11:06:20.870','2023-09-10 22:19:28.172','2026-01-24 11:06:20.870',3),
('b58d56ea-6924-49e5-905c-c408645e2c88','student214@example.com','student214','Sipho_Segel','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+214&background=random','2026-01-24 11:06:20.335','2025-10-18 10:07:58.808','2026-01-24 11:06:20.335',3),
('b5a897bb-9353-4415-a396-3790688535eb','student913@example.com','student913','Hong.Sánchez14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+913&background=random','2026-01-24 11:06:21.155','2022-12-27 04:06:28.634','2026-01-24 11:06:21.156',3),
('b60850b3-a016-4db6-9c51-c7bbc90ec4b9','student179@example.com','student179','Yoshimi.Pérez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+179&background=random','2026-01-24 11:06:20.287','2023-09-25 10:03:20.610','2026-01-24 11:06:20.288',3),
('b63b814d-c0eb-4afd-91e1-0b316d1cf28a','student201@example.com','student201','Faith.Rodríguez68','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+201&background=random','2026-01-24 11:06:20.318','2023-06-02 16:18:37.285','2026-01-24 11:06:20.319',3),
('b6920df5-12b1-4d3d-9f9c-008986d32854','student135@example.com','student135','Hiroshi_Jónsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+135&background=random','2026-01-24 11:06:20.228','2025-11-10 15:52:46.920','2026-01-24 11:06:20.229',3),
('b6ef04ee-c496-41b4-b39c-2a7bcc4f13b7','teacher38@example.com','teacher38','Atli_Óskarsdóttir6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+38&background=random','2026-01-24 11:06:19.870','2024-09-19 21:27:36.139','2026-01-24 11:06:19.871',2),
('b78dfc6a-a3bd-475a-a7e3-3f85c2925386','teacher187@example.com','teacher187','Esther.Dube20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+187&background=random','2026-01-24 11:06:20.050','2023-12-15 08:19:16.494','2026-01-24 11:06:20.051',2),
('b7a5d7cc-1ed0-4ef1-a46a-493ebb565548','student407@example.com','student407','Alyona.Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+407&background=random','2026-01-24 11:06:20.578','2025-10-13 17:51:06.092','2026-01-24 11:06:20.579',3),
('b7b99f63-bfa9-4d0d-b9f8-f507360f99e7','student411@example.com','student411','Beata.Möller5','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+411&background=random','2026-01-24 11:06:20.583','2024-01-12 05:04:02.576','2026-01-24 11:06:20.583',3),
('b7de428b-e3b4-4d9f-ad0d-52a0a50a24cc','student223@example.com','student223','Ahmad_López52','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+223&background=random','2026-01-24 11:06:20.345','2025-03-16 21:46:40.841','2026-01-24 11:06:20.346',3),
('b7fa2f74-d41d-4f88-b445-c25e973ce603','teacher85@example.com','teacher85','Masao.Smits','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+85&background=random','2026-01-24 11:06:19.930','2025-11-03 10:12:02.248','2026-01-24 11:06:19.931',2),
('b826de43-0eec-478a-84ed-b6ab31173069','student939@example.com','student939','Kseniya.Popova66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+939&background=random','2026-01-24 11:06:21.186','2024-01-06 04:17:35.974','2026-01-24 11:06:21.187',3),
('b847c0de-aca7-40b3-98eb-2c7bfc3999ff','student94@example.com','student94','Karin.Vásquez57','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+94&background=random','2026-01-24 11:06:20.179','2023-11-27 23:56:39.748','2026-01-24 11:06:20.179',3),
('b8701a77-5775-4aaa-b314-5d63b35de8cc','student222@example.com','student222','Joyce_Tomaszewski12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+222&background=random','2026-01-24 11:06:20.344','2021-06-03 11:25:36.735','2026-01-24 11:06:20.345',3),
('b8737d85-b507-4e8d-a779-5e9e1a19e5d0','student419@example.com','student419','Kjartan.Žukauskienė','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+419&background=random','2026-01-24 11:06:20.592','2025-11-15 17:06:13.813','2026-01-24 11:06:20.593',3),
('b88e3fd9-4b54-42f7-bf69-45795799d606','student319@example.com','student319','Joan.Őhlschlägerová23','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+319&background=random','2026-01-24 11:06:20.468','2021-01-28 19:41:45.726','2026-01-24 11:06:20.468',3),
('b914f8e5-7658-4732-a1b8-e4db39622684','student715@example.com','student715','Joan_Abe','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+715&background=random','2026-01-24 11:06:20.917','2025-11-30 01:46:49.027','2026-01-24 11:06:20.918',3),
('b9275802-a68b-4ae1-8bf2-1f520ff76892','student345@example.com','student345','Karen.Szymański','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+345&background=random','2026-01-24 11:06:20.500','2023-06-28 09:42:10.349','2026-01-24 11:06:20.501',3),
('b940aeef-ff37-439e-8213-2c7133dd3713','student791@example.com','student791','Ko_Kristinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+791&background=random','2026-01-24 11:06:21.005','2024-09-06 22:46:32.227','2026-01-24 11:06:21.005',3),
('b99cbebd-c6f0-4e77-9b05-179890c61f80','student231@example.com','student231','Hong_Maeda','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+231&background=random','2026-01-24 11:06:20.354','2025-08-25 05:56:22.008','2026-01-24 11:06:20.355',3),
('b9f5074b-61a5-482d-9343-19822f3fe6c8','student606@example.com','student606','Mardkhay.Feng77','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+606&background=random','2026-01-24 11:06:20.796','2024-07-01 23:27:34.574','2026-01-24 11:06:20.797',3),
('b9f7b9fb-8ee9-4e26-b7da-7e0d8309a995','student763@example.com','student763','Roman_Diaz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+763&background=random','2026-01-24 11:06:20.974','2022-04-15 17:20:21.802','2026-01-24 11:06:20.975',3),
('ba073afa-5277-4e74-8f5d-4d833462b3c5','student206@example.com','student206','Nicola_Einarsdóttir50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+206&background=random','2026-01-24 11:06:20.325','2021-10-25 18:34:05.253','2026-01-24 11:06:20.326',3),
('ba0958b9-2c82-4186-beb8-18ab409d5a46','student250@example.com','student250','Abdullahi.Günther29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+250&background=random','2026-01-24 11:06:20.379','2023-12-19 15:29:34.212','2026-01-24 11:06:20.380',3),
('ba8d6139-4122-4edf-9df5-45b18b83a0ae','student116@example.com','student116','Wilai_Einarsdóttir50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+116&background=random','2026-01-24 11:06:20.207','2023-10-02 10:49:45.911','2026-01-24 11:06:20.208',3),
('baac4ef1-d750-4a4d-b5e5-7d70e64ad685','student37@example.com','student37','Gita.Ðorðić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+37&background=random','2026-01-24 11:06:20.114','2024-12-20 05:13:46.613','2026-01-24 11:06:20.115',3),
('badd888d-e956-427c-b8e9-569201b4d8d3','teacher137@example.com','teacher137','Tadashi.Yosef73','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+137&background=random','2026-01-24 11:06:19.993','2022-03-15 20:45:25.577','2026-01-24 11:06:19.993',2),
('badf4aea-5953-41fc-9265-cb3da3e794b4','student651@example.com','student651','Francis.Kristjánsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+651&background=random','2026-01-24 11:06:20.847','2024-04-09 16:30:25.132','2026-01-24 11:06:20.847',3),
('baf66708-bde2-489f-a38b-ab179b39ca7f','student69@example.com','student69','Anah_Sharabi84','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+69&background=random','2026-01-24 11:06:20.151','2025-04-04 02:54:07.581','2026-01-24 11:06:20.152',3),
('bb58278e-8377-4c4d-9a9b-171ef3926273','student329@example.com','student329','Johan_Novák80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+329&background=random','2026-01-24 11:06:20.481','2024-10-09 18:36:30.086','2026-01-24 11:06:20.482',3),
('bb9028f6-f3f6-41bb-9f2d-8c7873c0cbbf','student356@example.com','student356','Karen_Barasa72','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+356&background=random','2026-01-24 11:06:20.514','2025-10-08 01:09:50.271','2026-01-24 11:06:20.515',3),
('bbb33650-4d8b-4846-b97e-a3d5e9f5d32b','student584@example.com','student584','Marina.Rani96','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+584&background=random','2026-01-24 11:06:20.773','2021-07-21 10:15:50.354','2026-01-24 11:06:20.773',3),
('bbc8e02e-edef-4b55-848c-b723af790dd6','teacher42@example.com','teacher42','Ping_Kuipers','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+42&background=random','2026-01-24 11:06:19.875','2023-08-29 16:38:21.127','2026-01-24 11:06:19.876',2),
('bbf123da-fd13-4587-a2f0-fcffc9d12887','student566@example.com','student566','Xiaohong_Allen5','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+566&background=random','2026-01-24 11:06:20.753','2021-07-08 15:55:56.193','2026-01-24 11:06:20.753',3),
('bc6ac4f1-35fc-465a-9ccd-10ea722cf9c0','student646@example.com','student646','Francisco_Novotný','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+646&background=random','2026-01-24 11:06:20.842','2021-02-01 16:28:14.585','2026-01-24 11:06:20.842',3),
('bc6bc6f0-efc9-4e59-8e20-56916795c4c5','teacher54@example.com','teacher54','Ann.Kamiński13','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+54&background=random','2026-01-24 11:06:19.891','2023-01-07 00:07:44.476','2026-01-24 11:06:19.892',2),
('bccf16f7-f7e2-499d-a4ee-bfe0f2335347','student685@example.com','student685','Koichi_Pétursdóttir37','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+685&background=random','2026-01-24 11:06:20.883','2021-09-03 16:05:18.598','2026-01-24 11:06:20.884',3),
('bd8b49db-fa2b-4422-914f-d55488b8771f','student569@example.com','student569','Zhen_Ðorðić','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+569&background=random','2026-01-24 11:06:20.756','2022-02-27 16:45:42.846','2026-01-24 11:06:20.757',3),
('be11de4a-853e-487d-9ff9-5b2116918da1','teacher175@example.com','teacher175','Vijay.Wolf35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+175&background=random','2026-01-24 11:06:20.037','2024-09-25 05:23:36.734','2026-01-24 11:06:20.038',2),
('be356efc-a9d5-4924-be93-9d35eacfbb8d','student883@example.com','student883','Lalita.Ødegård','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+883&background=random','2026-01-24 11:06:21.118','2025-04-04 04:48:32.145','2026-01-24 11:06:21.119',3),
('be4ea663-b097-40e6-8274-9c939f4fff92','teacher142@example.com','teacher142','Raj.Jóhannesdóttir13','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+142&background=random','2026-01-24 11:06:19.998','2023-08-28 18:01:29.285','2026-01-24 11:06:19.999',2),
('be4f8d79-630c-40da-a5e5-160dff78c456','student336@example.com','student336','Masami.Wood3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+336&background=random','2026-01-24 11:06:20.489','2022-10-17 18:08:08.305','2026-01-24 11:06:20.490',3),
('be8bccb0-0616-4ccb-b649-c7a3ce0163ea','teacher79@example.com','teacher79','Valentina_Friðriksson84','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+79&background=random','2026-01-24 11:06:19.924','2024-01-16 17:32:44.791','2026-01-24 11:06:19.924',2),
('be96b5d1-ebff-4db8-807a-b82aedcae3ae','student341@example.com','student341','Prani_Nuñez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+341&background=random','2026-01-24 11:06:20.495','2022-01-16 18:18:48.261','2026-01-24 11:06:20.495',3),
('be9c4df7-0ae6-4bcc-a808-62739a2489b4','student819@example.com','student819','Sita.Aliev','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+819&background=random','2026-01-24 11:06:21.050','2021-10-17 21:09:58.144','2026-01-24 11:06:21.051',3),
('beb19ff9-1b12-485d-bf5a-d8cbb6d87fe6','student497@example.com','student497','Ko_Einarsdóttir90','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+497&background=random','2026-01-24 11:06:20.676','2021-08-23 13:37:38.750','2026-01-24 11:06:20.676',3),
('bebafd13-778e-4e97-8130-f76640cc9080','student924@example.com','student924','Ibrahim.Pospíšilová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+924&background=random','2026-01-24 11:06:21.168','2025-06-21 04:31:13.559','2026-01-24 11:06:21.169',3),
('bec7f008-eebd-44a4-bc7a-9c25f42006b4','student545@example.com','student545','Amnuai_Kučera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+545&background=random','2026-01-24 11:06:20.728','2022-07-30 13:19:05.669','2026-01-24 11:06:20.729',3),
('beef8877-c040-4210-a521-2dab2558ed18','student911@example.com','student911','Eva.Mutuku','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+911&background=random','2026-01-24 11:06:21.153','2025-11-06 01:10:13.905','2026-01-24 11:06:21.154',3),
('bf9ccc1d-eaf2-4b7a-a558-e1bb31b0ff05','student347@example.com','student347','Werner.Králová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+347&background=random','2026-01-24 11:06:20.503','2022-12-08 02:56:18.483','2026-01-24 11:06:20.503',3),
('bfcae7f8-d13f-4351-9499-60a00ded16ff','student731@example.com','student731','Leah.Veselá7','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+731&background=random','2026-01-24 11:06:20.936','2023-11-27 13:07:28.021','2026-01-24 11:06:20.937',3),
('c0298e4c-e32b-4e32-bd1d-bcabb35a16da','student210@example.com','student210','Sebastian.Akpan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+210&background=random','2026-01-24 11:06:20.330','2022-10-19 10:34:39.810','2026-01-24 11:06:20.331',3),
('c0cc57c0-5302-4f7b-ade0-d07fdbed77e0','student467@example.com','student467','Linda.Ota52','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+467&background=random','2026-01-24 11:06:20.644','2025-08-19 20:14:09.899','2026-01-24 11:06:20.645',3),
('c0d7302b-54f9-4fbe-821a-a968ffe6a695','student604@example.com','student604','Samran.Méndez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+604&background=random','2026-01-24 11:06:20.794','2024-01-19 02:21:30.094','2026-01-24 11:06:20.795',3),
('c132f139-18c7-4b25-a641-d1d38ecb1d8b','student311@example.com','student311','Sushila.Ueda','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+311&background=random','2026-01-24 11:06:20.458','2021-07-24 04:28:14.954','2026-01-24 11:06:20.459',3),
('c136944b-801c-4289-991a-fbc3ed97abfa','student349@example.com','student349','Sani.Guðjónsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+349&background=random','2026-01-24 11:06:20.506','2025-12-18 17:03:13.720','2026-01-24 11:06:20.506',3),
('c15abfb2-e96e-40e9-a2b6-8e65f5b17895','student188@example.com','student188','Cheng_Kumar','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+188&background=random','2026-01-24 11:06:20.301','2025-03-24 13:37:31.546','2026-01-24 11:06:20.301',3),
('c15ba2d3-e6cd-43dd-992f-64fa943b117e','student124@example.com','student124','Prasoet.Ólafsson56','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+124&background=random','2026-01-24 11:06:20.215','2025-05-20 00:49:51.734','2026-01-24 11:06:20.216',3),
('c16776a1-7b23-4bd8-8dab-8b5a340ef0dc','student850@example.com','student850','Inga.Walker29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+850&background=random','2026-01-24 11:06:21.084','2021-03-09 17:55:53.891','2026-01-24 11:06:21.085',3),
('c172a96b-b581-4ec1-afdc-287983de1f86','student335@example.com','student335','Wirat_König','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+335&background=random','2026-01-24 11:06:20.488','2022-01-17 13:48:51.286','2026-01-24 11:06:20.489',3),
('c1927970-6b2e-4ccd-8221-f7e2d029d63c','student282@example.com','student282','Somkhit_Tian20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+282&background=random','2026-01-24 11:06:20.420','2025-10-01 06:35:54.913','2026-01-24 11:06:20.421',3),
('c19ce9ff-fa80-4aa4-bab2-518c19804459','student739@example.com','student739','Lakshmi.Adebayo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+739&background=random','2026-01-24 11:06:20.946','2024-02-01 15:39:12.080','2026-01-24 11:06:20.947',3),
('c210eebf-8df6-4511-8771-0b2102fd45a7','student817@example.com','student817','Sani.Æbelø71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+817&background=random','2026-01-24 11:06:21.034','2024-12-20 01:01:46.495','2026-01-24 11:06:21.035',3),
('c2554e7f-3ac1-423d-a8ea-f4d0ebddccba','student552@example.com','student552','Beata.Fröhlich15','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+552&background=random','2026-01-24 11:06:20.737','2025-06-19 09:47:43.055','2026-01-24 11:06:20.738',3),
('c2e0fa1d-44ea-453e-a55c-246076f77aa4','teacher189@example.com','teacher189','Haruna.Klein','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+189&background=random','2026-01-24 11:06:20.053','2021-03-13 02:35:02.293','2026-01-24 11:06:20.054',2),
('c2e6f5e4-ff1a-42dd-aa7e-25c4f8a2abc8','teacher88@example.com','teacher88','Lilian_Santos6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+88&background=random','2026-01-24 11:06:19.933','2021-04-13 02:33:33.540','2026-01-24 11:06:19.934',2),
('c2e72502-5a8b-4f7f-b538-a5e667e439c4','student50@example.com','student50','Sarah.Óskarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+50&background=random','2026-01-24 11:06:20.129','2023-08-04 00:02:18.873','2026-01-24 11:06:20.130',3),
('c2f45bd3-50b8-4f36-8390-7915c004b9f3','student660@example.com','student660','Eliyahu_Urbański','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+660&background=random','2026-01-24 11:06:20.856','2024-10-31 15:49:42.700','2026-01-24 11:06:20.856',3),
('c3090130-47da-426c-bf54-0522fb06e0c6','student447@example.com','student447','Einar_Őhlschlägerová93','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+447&background=random','2026-01-24 11:06:20.622','2021-07-18 04:34:35.673','2026-01-24 11:06:20.623',3),
('c342b6a8-e38e-4c4f-a15e-edd7ac6f3fce','student484@example.com','student484','Linda_Pawlak93','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+484&background=random','2026-01-24 11:06:20.661','2023-11-21 07:42:26.621','2026-01-24 11:06:20.662',3),
('c35ca001-e635-46a1-8ab2-37a58b6104c0','student621@example.com','student621','Agnieszka.Jóhannsdóttir38','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+621&background=random','2026-01-24 11:06:20.813','2025-03-12 17:47:54.854','2026-01-24 11:06:20.813',3),
('c3c9e1cc-00c5-41fd-91da-099515a38ed2','teacher145@example.com','teacher145','Darya.Das','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+145&background=random','2026-01-24 11:06:20.002','2023-05-19 13:10:53.037','2026-01-24 11:06:20.002',2),
('c449a9d2-6228-4a0c-afc2-102a68b42d37','student964@example.com','student964','Charoen.Ngobeni95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+964&background=random','2026-01-24 11:06:21.220','2021-12-18 11:52:50.871','2026-01-24 11:06:21.221',3),
('c46eab11-0eb2-45b5-ba27-497fb85ebc50','student225@example.com','student225','Sunday.Göbel16','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+225&background=random','2026-01-24 11:06:20.347','2021-09-05 12:46:29.974','2026-01-24 11:06:20.348',3),
('c475ed00-3981-4a82-8b8e-a2d1a75330ea','student862@example.com','student862','Lihua.Watanabe','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+862&background=random','2026-01-24 11:06:21.097','2024-09-16 20:57:46.226','2026-01-24 11:06:21.098',3),
('c479fbca-66de-4c85-bd5c-0a8274ac7d73','student903@example.com','student903','Na_Sadowski27','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+903&background=random','2026-01-24 11:06:21.144','2024-09-20 23:51:18.711','2026-01-24 11:06:21.144',3),
('c50bad88-d654-4d8c-b2aa-38a7856a4268','teacher37@example.com','teacher37','Evgeniy_Sigurjónsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+37&background=random','2026-01-24 11:06:19.869','2025-09-19 21:15:20.234','2026-01-24 11:06:19.870',2),
('c5109cf4-4d07-40b4-966f-46b1cf40a913','teacher95@example.com','teacher95','Rafael_Őzse83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+95&background=random','2026-01-24 11:06:19.940','2021-03-29 10:19:14.638','2026-01-24 11:06:19.941',2),
('c55b19ce-6648-44d9-b4b4-5ccdf51867f7','student346@example.com','student346','Joan_Cohen','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+346&background=random','2026-01-24 11:06:20.501','2024-08-24 06:39:08.450','2026-01-24 11:06:20.502',3),
('c55f5984-5f43-4dcc-9c62-ce8521992452','student759@example.com','student759','Sushila.Pálsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+759&background=random','2026-01-24 11:06:20.969','2022-07-18 16:48:30.453','2026-01-24 11:06:20.969',3),
('c5c51c23-a27b-4e70-ba15-0375f1e12f1b','student708@example.com','student708','Suresh_Krejčí','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+708&background=random','2026-01-24 11:06:20.910','2024-01-16 09:47:48.194','2026-01-24 11:06:20.910',3),
('c5d930ae-affb-40da-a3e5-0310c0961070','student41@example.com','student41','Vinod_Cele20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+41&background=random','2026-01-24 11:06:20.119','2021-02-03 11:38:59.443','2026-01-24 11:06:20.120',3),
('c5ddc351-ca3d-42c8-aefa-9861f6b7c9e2','student857@example.com','student857','Samran.Łuczak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+857&background=random','2026-01-24 11:06:21.091','2021-03-10 20:22:24.497','2026-01-24 11:06:21.092',3),
('c5e27509-9006-4a77-8974-4367b4daeda7','student443@example.com','student443','Wilai_Van-der-Linden','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+443&background=random','2026-01-24 11:06:20.618','2025-12-20 16:47:30.576','2026-01-24 11:06:20.619',3),
('c6ccf1f8-2053-4c14-a5f6-8c0a36afd259','student970@example.com','student970','Josefa.Visser88','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+970&background=random','2026-01-24 11:06:21.227','2025-10-31 19:28:45.030','2026-01-24 11:06:21.228',3),
('c6f9287e-9b49-4a72-82e7-1c4e883a15b1','student627@example.com','student627','Miykhal.Isaac20','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+627&background=random','2026-01-24 11:06:20.819','2025-12-30 19:00:26.348','2026-01-24 11:06:20.820',3),
('c756be79-4588-4d3f-86d2-2ff0fb2c62c4','student483@example.com','student483','Ming.Meißner71','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+483&background=random','2026-01-24 11:06:20.660','2022-08-09 07:49:22.564','2026-01-24 11:06:20.661',3),
('c781aa7e-dc5a-497b-af1e-e0dfda6a774a','student441@example.com','student441','Lilian_Ágústsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+441&background=random','2026-01-24 11:06:20.616','2024-08-15 07:44:13.999','2026-01-24 11:06:20.617',3),
('c79eb23d-05f8-4fb4-abdd-f87052804214','student144@example.com','student144','Justyna_Sánchez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+144&background=random','2026-01-24 11:06:20.238','2022-11-02 00:57:41.898','2026-01-24 11:06:20.239',3),
('c7b398b0-10e8-4dca-a711-891f66012084','student851@example.com','student851','Erika.Ólafsdóttir92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+851&background=random','2026-01-24 11:06:21.085','2025-12-05 10:43:58.539','2026-01-24 11:06:21.085',3),
('c7e74aa2-d681-478f-a2af-b872dbf8b78e','teacher177@example.com','teacher177','Yoshimi_Barman','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+177&background=random','2026-01-24 11:06:20.039','2023-08-25 21:59:33.195','2026-01-24 11:06:20.040',2),
('c82bee97-ba10-4485-9161-500417bad83b','student455@example.com','student455','Karl.Óskarsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+455&background=random','2026-01-24 11:06:20.630','2025-06-22 03:34:50.243','2026-01-24 11:06:20.631',3),
('c85dbc88-9f27-4472-abc7-806ac90e1a70','teacher158@example.com','teacher158','Xiaohong.Sukkasem25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+158&background=random','2026-01-24 11:06:20.016','2025-05-27 07:24:36.531','2026-01-24 11:06:20.017',2),
('c8703151-bdf2-4bbc-ab99-dffc2702ca53','student9@example.com','student9','Sam.Van-der-Heijden4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+9&background=random','2026-01-24 11:06:20.077','2021-06-23 08:36:17.486','2026-01-24 11:06:20.078',3),
('c8ad8e3d-3e83-42cb-951d-fd26e1090a5c','student987@example.com','student987','Diego.Sveinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+987&background=random','2026-01-24 11:06:21.248','2025-10-10 00:45:20.758','2026-01-24 11:06:21.248',3),
('c9488c6e-debc-4a5f-903c-3998d9831e97','student248@example.com','student248','Somchit_Krüger66','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+248&background=random','2026-01-24 11:06:20.377','2021-06-26 20:44:51.130','2026-01-24 11:06:20.378',3),
('c95209a9-348f-48bb-9497-84654a012b60','student703@example.com','student703','Kiran_Ūžien','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+703&background=random','2026-01-24 11:06:20.904','2024-03-04 17:10:04.559','2026-01-24 11:06:20.905',3),
('c9a717d2-879c-48da-adf7-bc5e3d2f590d','student426@example.com','student426','Sombun.Zoabi','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+426&background=random','2026-01-24 11:06:20.600','2024-06-16 09:22:30.987','2026-01-24 11:06:20.600',3),
('c9d00bcd-aa49-4109-85a4-a1b61d92e118','student637@example.com','student637','Yuliya.Mkhize80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+637&background=random','2026-01-24 11:06:20.830','2024-03-12 11:15:31.574','2026-01-24 11:06:20.831',3),
('c9fe18d2-73b3-455c-9b77-bb726ee991e8','teacher124@example.com','teacher124','Sabine.Fialová96','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+124&background=random','2026-01-24 11:06:19.976','2022-09-11 07:33:46.196','2026-01-24 11:06:19.977',2),
('ca1b0dc4-9b04-4db1-ba0a-269133a91d39','student396@example.com','student396','Francisco_Meißner','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+396&background=random','2026-01-24 11:06:20.564','2022-03-29 15:42:38.325','2026-01-24 11:06:20.564',3),
('cab2c12e-8328-4226-b82c-e283a264caf3','student673@example.com','student673','Bin.Jónsdóttir64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+673&background=random','2026-01-24 11:06:20.869','2025-04-10 00:38:39.817','2026-01-24 11:06:20.869',3),
('cb0d21fe-dff6-4c67-a6f5-4e170ac1f7cc','student622@example.com','student622','Sushila.Jäger12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+622&background=random','2026-01-24 11:06:20.814','2021-12-25 22:12:25.905','2026-01-24 11:06:20.814',3),
('cb1cb9d1-967e-4482-82a5-26e13145998d','student193@example.com','student193','Kristinn_Hernández','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+193&background=random','2026-01-24 11:06:20.308','2022-12-29 11:45:47.561','2026-01-24 11:06:20.308',3),
('cb224538-ba9b-4d52-aebf-a6b584d20011','student213@example.com','student213','Denis_Kučera13','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+213&background=random','2026-01-24 11:06:20.334','2025-06-30 19:39:11.018','2026-01-24 11:06:20.334',3),
('cb2b7a10-6a51-4fc9-9e46-33089292bf5e','student416@example.com','student416','Usha.Kucharski22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+416&background=random','2026-01-24 11:06:20.589','2022-03-03 07:25:07.162','2026-01-24 11:06:20.590',3),
('cb8c91ce-e287-44b0-9a28-2b01a38aaa9c','student276@example.com','student276','Katsumi_Löffler96','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+276&background=random','2026-01-24 11:06:20.412','2022-08-17 11:34:10.418','2026-01-24 11:06:20.412',3),
('cbbe202c-f13f-4f86-8296-6295f4e2fb54','teacher149@example.com','teacher149','Angela.Wilson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+149&background=random','2026-01-24 11:06:20.006','2025-07-13 03:23:36.677','2026-01-24 11:06:20.007',2),
('cc2040a0-f962-45b1-ba3e-de8b41ca6596','student630@example.com','student630','Busisiwe.Jiménez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+630&background=random','2026-01-24 11:06:20.823','2024-11-30 15:33:26.488','2026-01-24 11:06:20.824',3),
('ccb8b2cb-0c87-4f4a-8551-8241bbb7fc7b','student631@example.com','student631','Bin.Sukkasem21','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+631&background=random','2026-01-24 11:06:20.824','2024-10-11 00:36:24.618','2026-01-24 11:06:20.825',3),
('cd2ce449-5495-4b58-bab9-c9092bfbe7eb','student431@example.com','student431','Sharon_Sigurjónsson77','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+431&background=random','2026-01-24 11:06:20.605','2025-05-31 05:04:19.660','2026-01-24 11:06:20.606',3),
('cd4b788f-cd8d-42f4-a3ca-9fc547332503','teacher3@example.com','teacher3','Samuel_Nováková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+3&background=random','2026-01-24 11:06:19.827','2024-09-23 20:36:45.241','2026-01-24 11:06:19.828',2),
('cd9ad762-3ca2-4138-bc22-d1d89b4d774e','teacher12@example.com','teacher12','Amphon_Neumann75','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+12&background=random','2026-01-24 11:06:19.839','2021-10-28 09:52:32.470','2026-01-24 11:06:19.840',2),
('cdac1895-fffc-4657-b618-85754f26a354','student12@example.com','student12','Wirat_Łapiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+12&background=random','2026-01-24 11:06:20.081','2021-05-17 10:24:56.443','2026-01-24 11:06:20.082',3),
('cdb6ff0b-8d49-4215-a946-a0aecd47bc35','student5@example.com','student5','Birna_Birgisdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+5&background=random','2026-01-24 11:06:20.071','2022-09-05 14:37:50.567','2026-01-24 11:06:20.072',3),
('cdfe6d33-b457-41cf-a9ab-0044e67a907d','student126@example.com','student126','Themba_Helgadóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+126&background=random','2026-01-24 11:06:20.217','2023-10-31 06:56:52.270','2026-01-24 11:06:20.218',3),
('ce086b69-5b0d-4525-b374-0b75579a12b9','student20@example.com','student20','Hauwa_Hughes58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+20&background=random','2026-01-24 11:06:20.091','2022-12-18 04:12:26.804','2026-01-24 11:06:20.092',3),
('ce0d8b98-af3b-4d93-a008-493f3ccb0ae5','student361@example.com','student361','Iwona.Beneš48','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+361&background=random','2026-01-24 11:06:20.521','2022-12-14 22:45:24.619','2026-01-24 11:06:20.522',3),
('ce0e033d-d078-4e61-88cf-4d4c710a92f8','teacher118@example.com','teacher118','Lan_Hall','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+118&background=random','2026-01-24 11:06:19.969','2024-11-23 11:28:15.264','2026-01-24 11:06:19.970',2),
('ce115626-0920-48d9-a434-adb00adf15f3','student902@example.com','student902','Esther.Kimani63','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+902&background=random','2026-01-24 11:06:21.142','2023-11-05 09:49:08.761','2026-01-24 11:06:21.143',3),
('ce367cc3-51ac-4cd2-9cec-8525f0572f2c','student424@example.com','student424','Ping_Schmid','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+424&background=random','2026-01-24 11:06:20.598','2022-05-29 20:21:52.213','2026-01-24 11:06:20.598',3),
('ce6bf1eb-e478-45b5-80ce-6c031183c411','student438@example.com','student438','Petra.Goto','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+438&background=random','2026-01-24 11:06:20.612','2021-03-09 13:43:55.848','2026-01-24 11:06:20.613',3),
('ceb18800-f900-45cf-8563-242132fa2781','student247@example.com','student247','Adiy.Þorsteinsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+247&background=random','2026-01-24 11:06:20.375','2023-03-30 18:26:34.936','2026-01-24 11:06:20.376',3),
('cebe3a8c-83ee-43c0-9e76-31b94cdaecf8','student283@example.com','student283','Lilja_Jóhannesson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+283&background=random','2026-01-24 11:06:20.422','2023-01-04 17:27:55.932','2026-01-24 11:06:20.423',3),
('cee0a453-8973-4822-9aba-1beb0e3f2b6c','student378@example.com','student378','Bunmi.Halldórsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+378&background=random','2026-01-24 11:06:20.542','2025-11-14 05:15:33.987','2026-01-24 11:06:20.543',3),
('cf30d6a2-27af-41b1-a805-7e5f27621ec5','student893@example.com','student893','Patricia.Neumann','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+893&background=random','2026-01-24 11:06:21.132','2023-03-14 17:40:26.323','2026-01-24 11:06:21.132',3),
('cfc0ff0f-606f-4ab2-8db9-f9822086d16d','student47@example.com','student47','Edda_Czarnecki48','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+47&background=random','2026-01-24 11:06:20.126','2021-04-04 00:10:07.173','2026-01-24 11:06:20.127',3),
('cfc1106b-8350-4d3f-bd22-2526f305e611','student236@example.com','student236','Paula.Guðjónsdóttir32','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+236&background=random','2026-01-24 11:06:20.361','2025-07-01 15:37:16.234','2026-01-24 11:06:20.361',3),
('d018a934-6cea-4bf8-b411-3bfa4a2ae8e9','student986@example.com','student986','Laura_Kovalenko68','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+986&background=random','2026-01-24 11:06:21.247','2023-09-19 03:48:36.625','2026-01-24 11:06:21.247',3),
('d01ac3a4-19d2-4eef-81b8-8d823a034b89','student298@example.com','student298','Mahmood.Ólafsson26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+298&background=random','2026-01-24 11:06:20.440','2024-05-24 01:16:51.624','2026-01-24 11:06:20.440',3),
('d066d475-2cf0-44cd-9e4e-3cce7bbd04d5','teacher71@example.com','teacher71','Udom.Ólafsson95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+71&background=random','2026-01-24 11:06:19.914','2021-09-19 19:39:04.498','2026-01-24 11:06:19.915',2),
('d11a3171-6928-45b4-af30-ca69a7245c18','student121@example.com','student121','Hauwa.Þórðarson98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+121&background=random','2026-01-24 11:06:20.212','2023-07-14 02:41:17.820','2026-01-24 11:06:20.213',3),
('d1916ee7-64ac-4812-b499-ad6cd431e7d1','student390@example.com','student390','Li.Friðriksson26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+390&background=random','2026-01-24 11:06:20.557','2023-02-13 14:38:42.557','2026-01-24 11:06:20.558',3),
('d192fe1c-8401-477f-b59c-a86d1063fd6a','student871@example.com','student871','Victoria.Krüger52','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+871&background=random','2026-01-24 11:06:21.107','2025-03-18 06:16:16.056','2026-01-24 11:06:21.107',3),
('d1a5bb0d-aa04-4540-bed6-95bcaa16c609','student768@example.com','student768','Sri.Nakajima4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+768&background=random','2026-01-24 11:06:20.980','2024-06-03 11:04:14.420','2026-01-24 11:06:20.980',3),
('d1b3b62f-406a-4ba3-b9c5-676031ebced9','student905@example.com','student905','Carol_Mofokeng27','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+905&background=random','2026-01-24 11:06:21.146','2022-03-24 09:54:39.351','2026-01-24 11:06:21.146',3),
('d20a3ae6-b3c7-43a8-8687-acbfd5be4170','student439@example.com','student439','Masao_Kozłowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+439&background=random','2026-01-24 11:06:20.613','2025-08-19 12:27:23.881','2026-01-24 11:06:20.614',3),
('d22af69b-cb8d-4758-a938-34fdd7089f1f','student275@example.com','student275','Magdalena.Novotný14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+275&background=random','2026-01-24 11:06:20.410','2021-04-13 17:55:03.425','2026-01-24 11:06:20.411',3),
('d28aae54-1325-4205-9700-34a1e15b0152','student185@example.com','student185','Somnuek.Khoury','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+185&background=random','2026-01-24 11:06:20.297','2024-03-28 19:25:18.032','2026-01-24 11:06:20.298',3),
('d34e9ec4-5af6-4254-8c2f-50216b4267cb','student626@example.com','student626','Miykhal.Sokołowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+626&background=random','2026-01-24 11:06:20.818','2023-04-16 00:52:14.720','2026-01-24 11:06:20.819',3),
('d3da084c-2769-420c-b53d-539b87359962','student428@example.com','student428','Saman.Ding94','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+428&background=random','2026-01-24 11:06:20.602','2024-04-17 17:11:10.716','2026-01-24 11:06:20.603',3),
('d414c7a6-364d-4af9-b40a-7bf784b39ef5','teacher48@example.com','teacher48','Isah_Feldman','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+48&background=random','2026-01-24 11:06:19.883','2022-12-10 11:30:36.695','2026-01-24 11:06:19.883',2),
('d43db0a6-2f32-47de-9775-caac3b49b477','student792@example.com','student792','Eunice.Nováková74','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+792&background=random','2026-01-24 11:06:21.006','2022-06-15 16:07:16.422','2026-01-24 11:06:21.006',3),
('d444aa38-a8f3-4150-b1bd-9aca0372e390','student607@example.com','student607','Jan_Hernández','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+607&background=random','2026-01-24 11:06:20.798','2025-10-10 10:32:24.213','2026-01-24 11:06:20.798',3),
('d49a8a96-545f-48d8-a019-5f62cb9ae673','student829@example.com','student829','Somphon_Morris','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+829&background=random','2026-01-24 11:06:21.061','2023-06-19 05:39:28.282','2026-01-24 11:06:21.062',3),
('d4d8f2e1-267e-4ae4-8fb0-0b4f1b72070c','student920@example.com','student920','Catherine_Singh','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+920&background=random','2026-01-24 11:06:21.164','2021-06-25 17:20:14.840','2026-01-24 11:06:21.165',3),
('d517382b-b28d-4bf9-bf49-9dc35aaf9bcd','student379@example.com','student379','Susan.Cohen36','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+379&background=random','2026-01-24 11:06:20.544','2021-09-15 16:22:17.947','2026-01-24 11:06:20.544',3),
('d542c1cb-3155-4416-b4d8-d3e3adcbddc5','student405@example.com','student405','Sveinn.Dahan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+405&background=random','2026-01-24 11:06:20.575','2023-05-11 14:07:37.299','2026-01-24 11:06:20.576',3),
('d59f2691-af19-4874-b451-ac44468e1ca7','student794@example.com','student794','Martin.Wu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+794&background=random','2026-01-24 11:06:21.008','2023-10-01 03:26:28.613','2026-01-24 11:06:21.008',3),
('d5ee198b-0e26-44be-967f-8799f2383ede','student815@example.com','student815','Katsumi.Inoue','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+815&background=random','2026-01-24 11:06:21.031','2024-11-20 23:25:49.585','2026-01-24 11:06:21.032',3),
('d6114e8b-ebc0-4259-8a48-3d4b06804dd0','student710@example.com','student710','Jose-Antonio.Jasiński49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+710&background=random','2026-01-24 11:06:20.912','2025-04-17 18:09:42.271','2026-01-24 11:06:20.912',3),
('d6a4c319-b03b-4fd8-98a9-1fae2bef1b4b','student811@example.com','student811','Latda_Jónasson63','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+811&background=random','2026-01-24 11:06:21.027','2025-04-03 00:15:24.398','2026-01-24 11:06:21.028',3),
('d6b56517-0243-4a32-8448-7dcd0542f5be','student546@example.com','student546','Mariya_Lloyd14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+546&background=random','2026-01-24 11:06:20.730','2025-01-21 00:18:01.926','2026-01-24 11:06:20.730',3),
('d73cd348-5563-4755-bcf3-6949684f9319','student268@example.com','student268','Mieko_Jasiński19','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+268&background=random','2026-01-24 11:06:20.400','2025-09-01 20:08:31.019','2026-01-24 11:06:20.401',3),
('d774c17f-6e28-4d6e-9892-b939f5c77ce4','student269@example.com','student269','Lalita.Isa','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+269&background=random','2026-01-24 11:06:20.402','2024-07-10 00:24:41.095','2026-01-24 11:06:20.403',3),
('d778e841-00b2-434b-9cad-b9e8fb3d966e','student395@example.com','student395','Sommai.Ramírez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+395&background=random','2026-01-24 11:06:20.562','2021-10-21 22:19:27.811','2026-01-24 11:06:20.563',3),
('d792d52b-921f-435a-83fe-e23a03c79579','student18@example.com','student18','Wojciech_Morales','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+18&background=random','2026-01-24 11:06:20.088','2023-07-01 13:06:39.055','2026-01-24 11:06:20.089',3),
('d798f87f-0660-4ce1-95c4-34aa71a6657b','student118@example.com','student118','Aleksandr_Einarsdóttir76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+118&background=random','2026-01-24 11:06:20.209','2022-04-01 08:46:39.366','2026-01-24 11:06:20.210',3),
('d7bb81e2-8cb4-4d91-b807-89c667bfdfaf','student195@example.com','student195','Kamil_Murakami','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+195&background=random','2026-01-24 11:06:20.311','2023-11-07 16:05:25.474','2026-01-24 11:06:20.312',3),
('d80fd7f2-5c3a-4da3-94d4-3c989e478be7','student241@example.com','student241','Amiyr.Umar','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+241&background=random','2026-01-24 11:06:20.368','2024-06-25 06:26:17.775','2026-01-24 11:06:20.368',3),
('d852fa94-f917-46c4-83a9-0fa6397599e2','student42@example.com','student42','Wojciech.Benešová43','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+42&background=random','2026-01-24 11:06:20.120','2022-08-17 18:36:31.393','2026-01-24 11:06:20.121',3),
('d94b2ca9-6cba-4d6a-9d77-0114f52cfa22','student523@example.com','student523','Jerzy_Pokorná','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+523&background=random','2026-01-24 11:06:20.704','2021-04-12 19:07:40.912','2026-01-24 11:06:20.705',3),
('d956a35b-5174-4e0d-b3c7-66312b5d7931','student623@example.com','student623','Yhudah.Álvarez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+623&background=random','2026-01-24 11:06:20.814','2025-08-04 16:18:47.185','2026-01-24 11:06:20.815',3),
('d96505fa-047c-4ba2-afc4-12a8aefe78d2','student505@example.com','student505','Edda_Kjartansson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+505&background=random','2026-01-24 11:06:20.684','2024-09-21 17:00:02.444','2026-01-24 11:06:20.685',3),
('d9aefa7a-fd67-4844-b2ea-65b83ea6cf22','student93@example.com','student93','Aleksey_Dvořáková92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+93&background=random','2026-01-24 11:06:20.178','2025-08-18 21:27:31.353','2026-01-24 11:06:20.178',3),
('d9c00871-47f2-455f-ac77-84c1ec472a37','student70@example.com','student70','Jackline.Jung','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+70&background=random','2026-01-24 11:06:20.152','2023-05-19 05:39:00.549','2026-01-24 11:06:20.153',3),
('d9cd0756-e72c-42a3-a674-bda8e01ff1a2','student317@example.com','student317','Kamil_Makarov','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+317&background=random','2026-01-24 11:06:20.465','2021-10-21 21:37:32.105','2026-01-24 11:06:20.466',3),
('d9e84c2f-cbb5-430c-b908-584f1b7a3d75','student111@example.com','student111','Sani.Karlsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+111&background=random','2026-01-24 11:06:20.202','2023-06-11 03:09:53.002','2026-01-24 11:06:20.202',3),
('d9f09f6d-bc62-4ea0-bb30-136da9b5301f','student681@example.com','student681','Nicola.Shaikh','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+681&background=random','2026-01-24 11:06:20.878','2025-11-15 00:42:19.820','2026-01-24 11:06:20.879',3),
('da060b4c-cdf8-4668-a3f5-689afc4f157e','student697@example.com','student697','Hendrik_Veselá74','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+697&background=random','2026-01-24 11:06:20.896','2026-01-21 00:48:37.774','2026-01-24 11:06:20.897',3),
('da1440c3-5591-42ef-90aa-809a309c4283','student164@example.com','student164','Mercy.Kjartansdóttir50','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+164&background=random','2026-01-24 11:06:20.264','2024-02-26 00:48:31.851','2026-01-24 11:06:20.265',3),
('da228113-30ce-4574-83d5-cff4a286976e','student629@example.com','student629','Moshe_Schäfer67','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+629&background=random','2026-01-24 11:06:20.822','2025-02-28 18:13:40.915','2026-01-24 11:06:20.822',3),
('da629bf6-4a41-4351-93d6-7ca21420abee','teacher113@example.com','teacher113','Pawel.Paswan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+113&background=random','2026-01-24 11:06:19.963','2024-10-09 04:57:50.216','2026-01-24 11:06:19.964',2),
('da6f39d3-2931-4bda-824c-85f52b1f3615','student227@example.com','student227','Xiaohong.Ali','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+227&background=random','2026-01-24 11:06:20.349','2025-07-15 09:02:52.818','2026-01-24 11:06:20.350',3),
('dab5987f-e59e-4363-9dc9-091aec6ff9ef','student959@example.com','student959','Karolina_Sigurðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+959&background=random','2026-01-24 11:06:21.215','2022-09-21 04:20:27.450','2026-01-24 11:06:21.215',3),
('dac4bb4f-2055-4251-b127-a750c5b573b7','student294@example.com','student294','Rebecca.Kamiński','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+294&background=random','2026-01-24 11:06:20.435','2021-08-07 15:09:11.911','2026-01-24 11:06:20.436',3),
('db01e71a-2136-455e-8111-99d4a56dc6df','student904@example.com','student904','Werner.Macharia','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+904&background=random','2026-01-24 11:06:21.145','2024-04-29 20:20:41.902','2026-01-24 11:06:21.145',3),
('db3008f9-5fa8-4103-a218-3218291547ae','student956@example.com','student956','Jianhua_Salazar83','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+956&background=random','2026-01-24 11:06:21.211','2025-11-27 08:15:28.297','2026-01-24 11:06:21.212',3),
('db668429-106d-4ccc-bc5b-a54e3eef74db','student95@example.com','student95','Masao.Rowlands','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+95&background=random','2026-01-24 11:06:20.180','2021-05-30 10:23:21.895','2026-01-24 11:06:20.180',3),
('db82cb38-fa8a-4330-82ee-571aaa90798d','teacher65@example.com','teacher65','Zandile_Pospíšil','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+65&background=random','2026-01-24 11:06:19.907','2024-12-23 20:35:24.757','2026-01-24 11:06:19.908',2),
('db8ebb03-3773-42c4-9ada-60fc21e01d68','teacher89@example.com','teacher89','Shankar.Jóhannesdóttir96','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+89&background=random','2026-01-24 11:06:19.934','2025-01-29 12:30:09.032','2026-01-24 11:06:19.935',2),
('dc057f4b-f965-4d3a-98d2-ec1439218c90','teacher185@example.com','teacher185','Magda.Stefánsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+185&background=random','2026-01-24 11:06:20.048','2025-11-05 04:43:44.610','2026-01-24 11:06:20.049',2),
('dc138971-f944-4d35-b8af-5bfd7b0a722a','student777@example.com','student777','Sebastian.Sakai53','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+777&background=random','2026-01-24 11:06:20.989','2025-07-23 08:14:37.381','2026-01-24 11:06:20.990',3),
('dc3b31a1-d278-4aae-96ef-ecc278b93019','student842@example.com','student842','Alina.Procházka14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+842&background=random','2026-01-24 11:06:21.075','2021-04-17 22:41:51.125','2026-01-24 11:06:21.076',3),
('dc47e83d-4097-4a70-ba4c-010c3573015c','student451@example.com','student451','Wirat.Wagner','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+451&background=random','2026-01-24 11:06:20.626','2022-02-27 11:22:18.743','2026-01-24 11:06:20.627',3),
('dcbfd2d3-806a-49e1-818b-4985034c4b3b','teacher133@example.com','teacher133','Maria-Isabel.Olszewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+133&background=random','2026-01-24 11:06:19.988','2025-10-14 22:55:11.123','2026-01-24 11:06:19.988',2),
('dcc7b3e6-6118-4a32-a355-73a959f8befe','student996@example.com','student996','Katarzyna_Pokorný9','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+996&background=random','2026-01-24 11:06:21.257','2024-11-16 04:35:28.858','2026-01-24 11:06:21.258',3),
('dcc97337-021f-4cf0-a1ea-c2d5cc50e484','teacher33@example.com','teacher33','Hiromi_Novák52','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+33&background=random','2026-01-24 11:06:19.864','2022-05-25 20:51:17.619','2026-01-24 11:06:19.865',2),
('dcd47537-1247-4240-b88b-b62ddbe2b704','student916@example.com','student916','Josef_Procházková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+916&background=random','2026-01-24 11:06:21.159','2021-12-05 02:11:27.398','2026-01-24 11:06:21.159',3),
('dce72ba9-4ac4-4628-bf99-dc05ba376db0','student804@example.com','student804','Tatyana_Mtshali','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+804&background=random','2026-01-24 11:06:21.019','2022-02-16 10:47:08.133','2026-01-24 11:06:21.020',3),
('dd119656-22ba-474c-9061-e235de1f1fdb','teacher134@example.com','teacher134','Shay.Magnúsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+134&background=random','2026-01-24 11:06:19.989','2025-03-29 23:19:01.700','2026-01-24 11:06:19.990',2),
('dd32964e-40c5-484b-a97f-6263cbeeb87a','student180@example.com','student180','Alina_Makarov48','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+180&background=random','2026-01-24 11:06:20.289','2025-08-12 08:01:08.122','2026-01-24 11:06:20.290',3),
('de046926-fc4c-4af7-a6a5-42e0f4d4536c','student359@example.com','student359','Yan_Wieczorek','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+359&background=random','2026-01-24 11:06:20.517','2024-09-09 15:35:43.039','2026-01-24 11:06:20.518',3),
('de244b91-0c7d-4c4f-924f-b04ae775e8aa','student77@example.com','student77','Karolina.Peters','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+77&background=random','2026-01-24 11:06:20.159','2025-06-24 08:13:34.835','2026-01-24 11:06:20.160',3),
('dec97956-9b5f-4ee3-b520-d8f9e36051d8','student262@example.com','student262','Steven.Ding92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+262&background=random','2026-01-24 11:06:20.394','2023-07-18 06:11:00.553','2026-01-24 11:06:20.394',3),
('df445430-5271-4de1-b529-0738e94e7128','student136@example.com','student136','Busisiwe.Emmanuel39','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+136&background=random','2026-01-24 11:06:20.230','2023-03-29 10:04:05.309','2026-01-24 11:06:20.230',3),
('df5f6ad1-e748-4b55-9493-0f6d139af0e1','student173@example.com','student173','Yuko.Álvarez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+173&background=random','2026-01-24 11:06:20.277','2021-08-04 23:13:03.602','2026-01-24 11:06:20.278',3),
('e136cf69-ad5e-490b-afb9-1871a7328ef3','teacher163@example.com','teacher163','Ryoko_Morozova','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+163&background=random','2026-01-24 11:06:20.023','2022-11-04 23:25:49.370','2026-01-24 11:06:20.024',2),
('e13f3e2e-4327-4c8e-b06e-62f0a26dbc6b','student91@example.com','student91','Tal_Pálsdóttir37','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+91&background=random','2026-01-24 11:06:20.176','2021-05-25 18:59:48.464','2026-01-24 11:06:20.176',3),
('e147f92e-f513-44bd-9f81-3d19f17050e7','student974@example.com','student974','Sawat_Smirnov91','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+974&background=random','2026-01-24 11:06:21.234','2023-03-06 03:22:30.822','2026-01-24 11:06:21.234',3),
('e157b495-8cb9-4f04-b3f7-1e64b788187c','student212@example.com','student212','Karl.Singh64','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+212&background=random','2026-01-24 11:06:20.333','2021-07-16 21:00:10.743','2026-01-24 11:06:20.333',3),
('e1867356-6a50-4f81-9036-d72dfd57d685','student218@example.com','student218','Sushila_Böttcher87','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+218&background=random','2026-01-24 11:06:20.340','2022-01-29 14:17:18.904','2026-01-24 11:06:20.340',3),
('e221f653-3dcb-41ff-bbc9-cb2223e239af','student249@example.com','student249','Watsana_Beneš91','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+249&background=random','2026-01-24 11:06:20.378','2025-04-30 16:44:56.674','2026-01-24 11:06:20.379',3),
('e26c739f-3b5a-4f4e-a049-b1e34be1ef75','student398@example.com','student398','Inga_Evans','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+398&background=random','2026-01-24 11:06:20.566','2023-02-14 18:16:51.175','2026-01-24 11:06:20.566',3),
('e30225e0-d72e-4c6f-b514-9de8035df223','student4@example.com','student4','Li_Karlsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+4&background=random','2026-01-24 11:06:20.070','2022-09-11 04:09:49.524','2026-01-24 11:06:20.071',3),
('e31c5f32-1805-42cd-a1d4-6ef922409bf5','student63@example.com','student63','Zanele.Mkhize','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+63&background=random','2026-01-24 11:06:20.144','2023-08-06 06:57:51.852','2026-01-24 11:06:20.145',3),
('e337b54a-7544-4b54-8c0c-1a911635aa54','student436@example.com','student436','Ramesh_Sikora82','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+436&background=random','2026-01-24 11:06:20.611','2022-07-04 09:12:49.206','2026-01-24 11:06:20.611',3),
('e37bd8a2-393d-4dd5-81c3-0792105d423f','teacher67@example.com','teacher67','Francisco-Javier.Karanja','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+67&background=random','2026-01-24 11:06:19.910','2025-03-12 14:08:38.998','2026-01-24 11:06:19.910',2),
('e3df5a31-f93d-48d2-9ddd-2c3739e3e787','teacher198@example.com','teacher198','Maryam.Van-der-Linden','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+198&background=random','2026-01-24 11:06:20.063','2022-04-05 07:46:49.725','2026-01-24 11:06:20.064',2),
('e409ed53-3c4d-4722-a1f8-a5107acb2946','student521@example.com','student521','Lijun.De-Graaf','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+521&background=random','2026-01-24 11:06:20.702','2023-11-03 21:48:16.043','2026-01-24 11:06:20.703',3),
('e41000a1-054c-46ff-9355-bff71f63c641','student96@example.com','student96','Birgir.Guðmundsson69','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+96&background=random','2026-01-24 11:06:20.181','2021-05-23 00:34:12.989','2026-01-24 11:06:20.181',3),
('e43bb949-7de3-446a-8ffd-7817a298fd21','djamgt23@gmail.com','admin','Admin User','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Admin+User&background=random','2026-01-24 11:06:19.820','2025-06-27 05:50:22.915','2026-01-24 11:06:19.821',1),
('e45ed8e4-054b-4245-98c3-41650be10912','student785@example.com','student785','Sammy.Kristinsson39','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+785&background=random','2026-01-24 11:06:20.998','2024-06-29 20:55:34.763','2026-01-24 11:06:20.999',3),
('e46a295f-6c12-48a5-a778-5317bede7831','teacher44@example.com','teacher44','Yoshio.Aliev','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+44&background=random','2026-01-24 11:06:19.878','2025-07-11 03:47:09.024','2026-01-24 11:06:19.878',2),
('e481e668-0a47-4d20-a535-a01527f2c0f2','teacher141@example.com','teacher141','Somchai.Golan','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+141&background=random','2026-01-24 11:06:19.997','2021-07-17 19:10:39.670','2026-01-24 11:06:19.998',2),
('e4a51890-e394-4e55-bea7-02118b429700','student293@example.com','student293','Somkhit_Fernández47','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+293&background=random','2026-01-24 11:06:20.434','2022-09-15 09:03:58.216','2026-01-24 11:06:20.435',3),
('e4ce81d9-8758-4fb1-921f-7e4790c361db','student444@example.com','student444','Ragnar_Őllösová23','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+444&background=random','2026-01-24 11:06:20.619','2025-05-13 20:59:34.769','2026-01-24 11:06:20.620',3),
('e4d43a01-ce6b-47d7-ac41-77f717adfad6','student100@example.com','student100','Sri_Hauksdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+100&background=random','2026-01-24 11:06:20.185','2025-11-17 19:45:07.534','2026-01-24 11:06:20.185',3),
('e4f15138-4a67-4436-a460-74390e19de22','student56@example.com','student56','Lindiwe_Koch','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+56&background=random','2026-01-24 11:06:20.137','2024-11-25 15:59:54.048','2026-01-24 11:06:20.137',3),
('e5230600-773b-481e-9b4c-cf90a8ab677c','student558@example.com','student558','Ning_Magnússon','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+558&background=random','2026-01-24 11:06:20.743','2025-11-12 07:52:52.011','2026-01-24 11:06:20.744',3),
('e596912e-7302-4eaf-a365-b2c64bd64921','student399@example.com','student399','Toshiko.Khumalo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+399&background=random','2026-01-24 11:06:20.567','2022-05-04 04:38:19.812','2026-01-24 11:06:20.568',3),
('e5c1da70-353f-423d-b4c9-0d5ea283b174','student362@example.com','student362','Raj.Adamu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+362&background=random','2026-01-24 11:06:20.522','2023-12-29 00:57:03.695','2026-01-24 11:06:20.523',3),
('e5e482a1-b860-42e4-bacc-539d9e3c2c5a','student242@example.com','student242','Lakshmi_Urbański','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+242&background=random','2026-01-24 11:06:20.369','2024-07-20 12:52:06.166','2026-01-24 11:06:20.370',3),
('e5e94cfe-ac07-4347-ac19-db684c822167','student415@example.com','student415','Shankar.Őhlschlägerová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+415&background=random','2026-01-24 11:06:20.588','2022-10-15 04:43:14.756','2026-01-24 11:06:20.589',3),
('e674d431-3db9-4496-86dc-b6ff8c4fdebd','student608@example.com','student608','Johan.Sigurðsson39','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+608&background=random','2026-01-24 11:06:20.799','2024-02-24 00:08:39.776','2026-01-24 11:06:20.799',3),
('e687e31a-c577-4fe6-a800-c2676a0cacc6','student83@example.com','student83','Jin.Guðjónsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+83&background=random','2026-01-24 11:06:20.167','2023-02-18 13:25:08.869','2026-01-24 11:06:20.168',3),
('e6ac394e-1ec6-42a0-8fc1-9e1417bcb67e','teacher136@example.com','teacher136','Shizuko_Kok','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+136&background=random','2026-01-24 11:06:19.991','2022-05-20 16:00:57.812','2026-01-24 11:06:19.992',2),
('e6b8de5c-a230-4b98-86e4-324bd9ae281d','student468@example.com','student468','Miguel.Ágústsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+468&background=random','2026-01-24 11:06:20.645','2022-08-01 06:17:38.195','2026-01-24 11:06:20.646',3),
('e6d20e07-d354-47bc-a324-bfe1244de7a7','student244@example.com','student244','Irina_Stepanov6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+244&background=random','2026-01-24 11:06:20.371','2023-01-25 22:10:03.935','2026-01-24 11:06:20.372',3),
('e6d2b281-3028-43ab-9b81-f0ecfc2ceb35','student21@example.com','student21','Richard_Ren','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+21&background=random','2026-01-24 11:06:20.092','2024-10-31 07:18:05.516','2026-01-24 11:06:20.093',3),
('e6d5da1b-129c-4998-a1e6-533eac48491c','student730@example.com','student730','Lindiwe.Schmitz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+730&background=random','2026-01-24 11:06:20.935','2021-02-16 20:55:41.073','2026-01-24 11:06:20.936',3),
('e7153b36-4e00-4bb7-b374-784a83311417','student40@example.com','student40','Alejandro_Óskarsson80','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+40&background=random','2026-01-24 11:06:20.118','2021-04-11 15:14:06.570','2026-01-24 11:06:20.118',3),
('e71c115e-36e9-46ac-a168-fa1cf0e20e2e','student297@example.com','student297','Susanne.Ødegård','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+297&background=random','2026-01-24 11:06:20.438','2024-02-15 06:11:19.924','2026-01-24 11:06:20.439',3),
('e71de27a-5504-4612-9779-e5bed8e865f5','teacher191@example.com','teacher191','Udom.Böttcher','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+191&background=random','2026-01-24 11:06:20.055','2021-03-14 23:33:33.818','2026-01-24 11:06:20.056',2),
('e82f4778-263f-4c3f-a779-db02c45c95e6','teacher110@example.com','teacher110','Yoshimi_Wu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+110&background=random','2026-01-24 11:06:19.959','2025-10-12 19:20:24.224','2026-01-24 11:06:19.960',2),
('e85529c9-1809-40f8-8e72-2b4a1f050a81','student430@example.com','student430','Cristina.Harle','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+430&background=random','2026-01-24 11:06:20.604','2024-01-29 12:52:13.232','2026-01-24 11:06:20.605',3),
('e869672b-f4f8-4ab7-a3ea-dac4f846b830','student579@example.com','student579','Kiran_Müller','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+579&background=random','2026-01-24 11:06:20.767','2021-12-06 15:16:35.528','2026-01-24 11:06:20.767',3),
('e8cf835b-c9f2-4787-9b78-8798c0ddb587','student963@example.com','student963','Kabiru.Dube','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+963&background=random','2026-01-24 11:06:21.219','2025-03-21 00:48:00.818','2026-01-24 11:06:21.220',3),
('e8d72846-555f-4bb7-9d30-51cf78c37c52','student129@example.com','student129','Liping_Guðmundsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+129&background=random','2026-01-24 11:06:20.221','2025-11-26 07:46:52.287','2026-01-24 11:06:20.222',3),
('e8efb0fc-52f4-4709-89a2-8c537cb80571','student892@example.com','student892','Dariusz.Mizrahi42','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+892&background=random','2026-01-24 11:06:21.130','2024-07-12 01:18:50.305','2026-01-24 11:06:21.131',3),
('e92781e1-4587-4492-baf4-e59b81a97c1c','teacher78@example.com','teacher78','Narong.Weiß','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+78&background=random','2026-01-24 11:06:19.923','2022-03-19 15:04:55.607','2026-01-24 11:06:19.923',2),
('e9385fe1-9c23-4635-9023-ead0698a5aaa','teacher186@example.com','teacher186','Joan_Sisuk14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+186&background=random','2026-01-24 11:06:20.049','2024-03-06 08:43:36.791','2026-01-24 11:06:20.050',2),
('e9753024-db8a-4464-863e-3afdaf36c76e','student625@example.com','student625','Colin.Vásquez','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+625&background=random','2026-01-24 11:06:20.817','2022-02-07 13:47:59.557','2026-01-24 11:06:20.817',3),
('e9915d72-29ff-4abf-8237-2059772514ee','teacher82@example.com','teacher82','Shizuko_Æbeltoft','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+82&background=random','2026-01-24 11:06:19.927','2022-06-01 15:17:23.640','2026-01-24 11:06:19.927',2),
('e9ee13f3-a48a-4132-a82c-94996dce9e39','student548@example.com','student548','Chen_Nayak76','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+548&background=random','2026-01-24 11:06:20.732','2023-04-08 14:54:02.973','2026-01-24 11:06:20.733',3),
('ea172267-6dfe-469a-b8ef-56b12223b020','student931@example.com','student931','Willem.Mohamed81','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+931&background=random','2026-01-24 11:06:21.176','2023-06-08 17:41:01.953','2026-01-24 11:06:21.176',3),
('ea1e96cb-6b08-4ef4-9b2a-77dab0d56612','student105@example.com','student105','Mary.De-Jong25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+105&background=random','2026-01-24 11:06:20.190','2021-10-17 13:45:49.368','2026-01-24 11:06:20.191',3),
('ea484dab-7fdb-4db1-a8a1-b52ac67e350a','student464@example.com','student464','Dmitry_Ūžien34','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+464&background=random','2026-01-24 11:06:20.640','2021-11-30 04:00:36.043','2026-01-24 11:06:20.641',3),
('ea7247ad-8896-4571-ab34-f185b233c842','student391@example.com','student391','Pieter.Dayan85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+391&background=random','2026-01-24 11:06:20.558','2021-09-23 11:56:45.954','2026-01-24 11:06:20.559',3),
('eae45639-1c1d-4fed-8e96-ec1bd7b29684','student841@example.com','student841','Lukasz_Bjarnadóttir42','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+841&background=random','2026-01-24 11:06:21.074','2021-05-12 22:35:12.380','2026-01-24 11:06:21.074',3),
('eb6ad018-aac4-4071-974e-7b41b95e8f8b','student204@example.com','student204','Lakshmi.Ūžien93','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+204&background=random','2026-01-24 11:06:20.322','2023-11-10 23:14:44.856','2026-01-24 11:06:20.323',3),
('eb7cbbd4-89e6-4b7b-8d14-b986ffaa3853','student170@example.com','student170','Unnur_Őrségi-Zölderdő8','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+170&background=random','2026-01-24 11:06:20.273','2022-10-22 08:06:07.011','2026-01-24 11:06:20.274',3),
('eb962d07-de53-40a6-a398-f2209776ce1f','teachertestaccexample.com','teachertestacc','teachertestacc','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=teachertestacc&background=random','2026-01-24 11:06:21.263','2025-12-17 09:26:52.884','2026-01-24 11:06:21.264',2),
('ebb11133-a9bd-4435-8417-4be1320b02aa','student945@example.com','student945','Fiona_Zhu6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+945&background=random','2026-01-24 11:06:21.196','2023-08-04 16:04:30.299','2026-01-24 11:06:21.196',3),
('ebf57379-270a-4b07-88a7-17946edab05d','student856@example.com','student856','Graham.Magnúsdóttir28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+856&background=random','2026-01-24 11:06:21.090','2023-06-03 22:25:55.941','2026-01-24 11:06:21.091',3),
('ec42ffb1-ec0c-4371-9631-dc25caf41633','student382@example.com','student382','Monika.Sombun','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+382&background=random','2026-01-24 11:06:20.548','2022-12-22 10:27:55.447','2026-01-24 11:06:20.548',3),
('ec532b96-b261-40d0-aef2-a056bbcbd767','student412@example.com','student412','Sam.Stefánsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+412&background=random','2026-01-24 11:06:20.584','2025-06-23 20:07:37.090','2026-01-24 11:06:20.584',3),
('ec593d99-302f-434c-b84f-1e8644ebbd49','student174@example.com','student174','Salisu_Flores26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+174&background=random','2026-01-24 11:06:20.278','2024-02-24 22:04:18.172','2026-01-24 11:06:20.279',3),
('ecb5f7d7-e520-45b9-92c3-75fc0c9fff28','student450@example.com','student450','Isah.Peter','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+450&background=random','2026-01-24 11:06:20.625','2022-11-06 19:17:11.874','2026-01-24 11:06:20.625',3),
('ece7547e-3e36-443d-85dd-d6fe4d5fb9fe','student338@example.com','student338','Jean.Czarnecki','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+338&background=random','2026-01-24 11:06:20.491','2023-10-18 18:45:40.579','2026-01-24 11:06:20.492',3),
('ed50ccc3-ede0-4aa5-b9b5-1908d9d126c4','teacher195@example.com','teacher195','Mateusz.Köhler22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+195&background=random','2026-01-24 11:06:20.060','2022-12-16 17:29:00.046','2026-01-24 11:06:20.061',2),
('ed5f7e18-d8e2-4245-b3b7-644fe5b665b4','student107@example.com','student107','Hauwa.Edwards','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+107&background=random','2026-01-24 11:06:20.194','2025-03-13 09:19:23.163','2026-01-24 11:06:20.195',3),
('edb5d376-196b-44ee-b6de-eaa1c6f7f29f','student836@example.com','student836','Dinesh_Tomaszewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+836&background=random','2026-01-24 11:06:21.068','2025-07-12 09:24:12.845','2026-01-24 11:06:21.069',3),
('edbafc93-a7d0-42cf-8283-f31f7bf4009d','student808@example.com','student808','Zandile_Richards','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+808&background=random','2026-01-24 11:06:21.024','2025-07-25 15:07:43.343','2026-01-24 11:06:21.025',3),
('ee233102-e2e7-46b3-9d97-dfc06ccd432e','student590@example.com','student590','Gabra.Gil61','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+590&background=random','2026-01-24 11:06:20.779','2025-02-12 06:12:51.953','2026-01-24 11:06:20.780',3),
('ee291737-a731-481d-a66d-ab9cc0879a1e','student306@example.com','student306','Stephen_Gíslason60','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+306&background=random','2026-01-24 11:06:20.451','2021-06-26 20:15:37.061','2026-01-24 11:06:20.452',3),
('ee47ce55-cbb5-4b87-9f9c-1740ec970929','student454@example.com','student454','Nittaya.Marin','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+454&background=random','2026-01-24 11:06:20.629','2025-07-23 02:52:05.381','2026-01-24 11:06:20.630',3),
('ee959f9e-b8f3-447a-9f1b-434af862602b','student758@example.com','student758','Susanne_Pérez79','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+758&background=random','2026-01-24 11:06:20.967','2024-11-27 07:11:13.829','2026-01-24 11:06:20.968',3),
('ef30d21e-b5db-4c7b-8507-1d8a4efa947f','student859@example.com','student859','Karen_Rosenberg95','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+859&background=random','2026-01-24 11:06:21.093','2025-03-15 11:44:58.624','2026-01-24 11:06:21.094',3),
('ef316123-9e99-47b5-b7cc-5e6e2654a61c','student406@example.com','student406','Yuliya_Malkah42','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+406&background=random','2026-01-24 11:06:20.577','2022-03-12 04:13:07.896','2026-01-24 11:06:20.577',3),
('f07d852c-d4b3-4a42-b238-66dcd2e14c59','student832@example.com','student832','Yuriy.Watkins','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+832&background=random','2026-01-24 11:06:21.064','2024-10-15 04:05:47.662','2026-01-24 11:06:21.064',3),
('f0a7f5a8-7024-40c9-9073-833be88c0a86','student226@example.com','student226','Ana_Sigurðardóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+226&background=random','2026-01-24 11:06:20.348','2023-01-22 06:38:26.010','2026-01-24 11:06:20.349',3),
('f0b0e28b-73df-46de-9550-3bb88795c194','student400@example.com','student400','Winai.Bailey','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+400&background=random','2026-01-24 11:06:20.568','2022-01-22 03:47:50.914','2026-01-24 11:06:20.569',3),
('f0f830ec-c45d-409e-9453-80ab673108a0','student961@example.com','student961','Jorge_Kim49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+961&background=random','2026-01-24 11:06:21.217','2021-10-02 16:49:33.834','2026-01-24 11:06:21.217',3),
('f12cacc6-c4de-424a-98da-c5ff517e73b6','student453@example.com','student453','Andrzej_Shaikh3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+453&background=random','2026-01-24 11:06:20.628','2023-06-13 06:33:37.996','2026-01-24 11:06:20.629',3),
('f151a474-6532-488b-a686-58fe6adf9d23','teacher1@example.com','teacher1','Sita_Egorov','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+1&background=random','2026-01-24 11:06:19.823','2021-08-27 11:14:31.886','2026-01-24 11:06:19.824',2),
('f215965a-fb75-4c1c-b9d8-aa0ad886bf33','student344@example.com','student344','Radha.Esteban14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+344&background=random','2026-01-24 11:06:20.499','2023-04-09 05:01:23.638','2026-01-24 11:06:20.499',3),
('f23bfbf0-6e40-4cac-bfe7-4e784896789c','student663@example.com','student663','Lucy.Žáková81','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+663&background=random','2026-01-24 11:06:20.859','2022-10-22 00:11:36.845','2026-01-24 11:06:20.860',3),
('f2806049-51a2-4d79-9764-e204f1610ba3','student825@example.com','student825','Gary.Schäfer','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+825&background=random','2026-01-24 11:06:21.057','2026-01-22 19:54:04.745','2026-01-24 11:06:21.057',3),
('f29f6a12-da14-4fe7-af67-fa434dc7f786','student664@example.com','student664','Lihua.Procházková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+664&background=random','2026-01-24 11:06:20.860','2021-11-07 09:51:22.285','2026-01-24 11:06:20.861',3),
('f3463c9b-8d7d-442e-be2b-f08360f5e16c','teacher7@example.com','teacher7','Amnuai.Ahmad','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+7&background=random','2026-01-24 11:06:19.833','2021-07-26 14:06:12.649','2026-01-24 11:06:19.833',2),
('f3e5c4cf-887f-44e6-96c7-97f15d25f4df','student134@example.com','student134','Carol.Govender5','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+134&background=random','2026-01-24 11:06:20.227','2021-09-28 13:31:29.949','2026-01-24 11:06:20.228',3),
('f455d9f1-eeda-489a-9230-7ac71b4d1b6b','student816@example.com','student816','Shay_Pérez97','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+816&background=random','2026-01-24 11:06:21.033','2022-06-11 17:46:03.312','2026-01-24 11:06:21.033',3),
('f464a255-a090-4131-9f07-0cc78226ad95','student888@example.com','student888','Amiyt.Kristjánsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+888&background=random','2026-01-24 11:06:21.125','2025-06-17 12:33:20.945','2026-01-24 11:06:21.126',3),
('f4b9a636-585a-4b1f-b4ad-39a495494b21','teacher56@example.com','teacher56','Raj_Maluleke22','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+56&background=random','2026-01-24 11:06:19.894','2023-11-24 14:55:50.613','2026-01-24 11:06:19.895',2),
('f4c175a9-9592-45ea-a5bb-0512caa11600','student25@example.com','student25','Martha.Horáková28','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+25&background=random','2026-01-24 11:06:20.098','2022-03-06 03:21:43.449','2026-01-24 11:06:20.099',3),
('f4f784fc-18dc-48c0-936f-9aef42d0c1da','student437@example.com','student437','Artur_Saetang53','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+437&background=random','2026-01-24 11:06:20.612','2021-03-19 11:17:19.217','2026-01-24 11:06:20.612',3),
('f5076d48-21ed-404b-bc4f-ceaa662d9bd0','teacher196@example.com','teacher196','Bernd_Bos29','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+196&background=random','2026-01-24 11:06:20.061','2024-12-06 12:51:40.737','2026-01-24 11:06:20.062',2),
('f541f870-0804-4027-a0f1-03b28f356bc4','student978@example.com','student978','Maria-Jose_Sigurjónsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+978&background=random','2026-01-24 11:06:21.238','2021-04-26 19:59:41.957','2026-01-24 11:06:21.239',3),
('f55c1c31-ed94-4746-8ddb-03cd982f36c2','student237@example.com','student237','Yoshiko_Ghosh34','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+237&background=random','2026-01-24 11:06:20.362','2022-05-26 17:14:35.919','2026-01-24 11:06:20.363',3),
('f57e0017-d28a-46ca-aa9a-2a53bd44d291','student823@example.com','student823','Haruna_Ceng','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+823&background=random','2026-01-24 11:06:21.055','2022-03-07 19:51:33.856','2026-01-24 11:06:21.055',3),
('f59ba53f-de09-4d71-9de5-a468747f0ebf','student820@example.com','student820','Lei.Kjartansdóttir85','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+820&background=random','2026-01-24 11:06:21.051','2024-11-17 07:01:42.996','2026-01-24 11:06:21.052',3),
('f59f7da9-e380-4053-a7c2-c41e5cbe0700','teacher36@example.com','teacher36','Koshi_Ojo','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+36&background=random','2026-01-24 11:06:19.868','2024-05-22 15:22:23.158','2026-01-24 11:06:19.868',2),
('f62dd8e6-0184-465c-9c1b-4fc459ff8d42','student696@example.com','student696','Nikolay.Guzmán30','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+696&background=random','2026-01-24 11:06:20.895','2021-09-17 03:33:29.624','2026-01-24 11:06:20.896',3),
('f6dd6ea8-ee22-47fc-880f-0ce50a8f85de','student481@example.com','student481','Takako_Saetang58','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+481&background=random','2026-01-24 11:06:20.658','2022-02-22 09:59:35.308','2026-01-24 11:06:20.659',3),
('f6e3a08e-6192-497d-9832-30a2c7a13fa6','teacher52@example.com','teacher52','Zhen_Schmitz44','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+52&background=random','2026-01-24 11:06:19.888','2021-09-19 13:59:03.173','2026-01-24 11:06:19.888',2),
('f6fe4881-3db4-47f9-850a-aa52e1d55f84','student803@example.com','student803','Ann.Martínez47','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+803&background=random','2026-01-24 11:06:21.018','2025-09-21 04:39:31.815','2026-01-24 11:06:21.019',3),
('f7239297-49b8-4eb1-a1c0-8cd449e0f02d','student243@example.com','student243','Yuriy_Rivera','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+243&background=random','2026-01-24 11:06:20.370','2025-12-27 09:44:20.474','2026-01-24 11:06:20.371',3),
('f73694db-c86d-47d6-acc5-b33ce0f504b1','student17@example.com','student17','Berglind.Olszewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+17&background=random','2026-01-24 11:06:20.087','2023-08-06 06:35:45.336','2026-01-24 11:06:20.088',3),
('f78e18b1-5ed3-4778-90f3-6309859646df','student292@example.com','student292','Yael.Nikolaeva70','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+292&background=random','2026-01-24 11:06:20.432','2022-06-21 02:32:12.232','2026-01-24 11:06:20.433',3),
('f795319f-6a4f-4622-8fc9-235000e14ca6','student281@example.com','student281','Jianping.Bjarnadóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+281&background=random','2026-01-24 11:06:20.419','2021-10-11 05:16:34.480','2026-01-24 11:06:20.420',3),
('f80bba62-ae32-473a-a3b7-40b6a36c6537','student550@example.com','student550','Hisako_Saeli26','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+550&background=random','2026-01-24 11:06:20.735','2024-12-03 15:45:18.221','2026-01-24 11:06:20.735',3),
('f81a9001-6796-47cf-920d-ba5e659ec48b','student265@example.com','student265','Peng_Ghosh72','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+265&background=random','2026-01-24 11:06:20.397','2021-06-16 18:50:46.451','2026-01-24 11:06:20.398',3),
('f825042e-47fe-46f8-90ec-430d3b4bda87','student611@example.com','student611','Roman.Njoroge','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+611&background=random','2026-01-24 11:06:20.802','2025-10-20 04:54:35.795','2026-01-24 11:06:20.803',3),
('f8362cc1-e07e-4c3c-bb7f-1676296b0c35','student884@example.com','student884','Shay.Ólafsdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+884&background=random','2026-01-24 11:06:21.119','2021-10-10 01:00:23.959','2026-01-24 11:06:21.120',3),
('f83e3144-7c48-4b72-86e5-4d8d14adc312','teacher155@example.com','teacher155','Koji_Magnússon3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+155&background=random','2026-01-24 11:06:20.013','2023-05-21 12:09:12.009','2026-01-24 11:06:20.014',2),
('f849e978-42f7-4a82-8c37-f685a4f97fb8','student757@example.com','student757','Ana_Allen6','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+757&background=random','2026-01-24 11:06:20.966','2021-10-18 14:10:09.480','2026-01-24 11:06:20.967',3),
('f870ad6c-a64b-4924-98ad-27acd3dbd3d4','teacher162@example.com','teacher162','Hiroshi.Žáková45','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+162&background=random','2026-01-24 11:06:20.022','2024-05-31 13:35:54.753','2026-01-24 11:06:20.022',2),
('f8916c80-5025-4dca-9d09-2aa2caca90f7','student515@example.com','student515','Xiang_Veselý','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+515&background=random','2026-01-24 11:06:20.696','2022-11-25 17:24:33.104','2026-01-24 11:06:20.697',3),
('f8a4b714-5dff-489d-9f00-ddda37a3e136','student589@example.com','student589','Nicola_Kučerová','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+589&background=random','2026-01-24 11:06:20.778','2021-09-12 06:36:55.528','2026-01-24 11:06:20.779',3),
('f8db148f-d317-40f5-82d5-aaab39655048','student314@example.com','student314','Noriko.Jabłoński51','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+314&background=random','2026-01-24 11:06:20.462','2022-01-04 04:09:49.966','2026-01-24 11:06:20.463',3),
('f90a301c-61c3-4868-b516-3c0f43ed6dcd','student221@example.com','student221','Isabel_Hu35','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+221&background=random','2026-01-24 11:06:20.343','2021-05-25 16:50:48.228','2026-01-24 11:06:20.343',3),
('f92b24b8-d5b8-4fdd-8f2d-acddd76e2fbc','student358@example.com','student358','Ajay_Birgisdóttir','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+358&background=random','2026-01-24 11:06:20.516','2023-04-25 00:52:18.707','2026-01-24 11:06:20.517',3),
('f94a92b5-d523-4ca8-a6ab-01b4a3b0ee62','teacher16@example.com','teacher16','Zandile_Svobodová3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+16&background=random','2026-01-24 11:06:19.844','2022-06-10 00:27:28.602','2026-01-24 11:06:19.845',2),
('f9516ebc-4c96-4624-894b-3477a89096ca','student322@example.com','student322','Inga.Szymański49','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+322&background=random','2026-01-24 11:06:20.472','2023-02-18 21:41:32.929','2026-01-24 11:06:20.472',3),
('f965309c-be5f-4399-936a-34641ebe3b75','student211@example.com','student211','Somnuek_Þorsteinsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+211&background=random','2026-01-24 11:06:20.331','2025-10-13 11:14:10.742','2026-01-24 11:06:20.332',3),
('f9905390-a292-48e3-a1ca-37f51c42c1b9','teacher17@example.com','teacher17','Ekaterina.Wolf','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+17&background=random','2026-01-24 11:06:19.845','2021-08-01 20:44:07.243','2026-01-24 11:06:19.846',2),
('f9b5b2ad-5d2e-4abc-8cdd-e87d7fec7b04','student252@example.com','student252','Hauwa_Horáková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+252&background=random','2026-01-24 11:06:20.382','2024-07-03 13:48:16.992','2026-01-24 11:06:20.382',3),
('f9c6d3e5-f0b9-4513-88b4-4f3057a07abd','student878@example.com','student878','Ying_López','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+878&background=random','2026-01-24 11:06:21.113','2023-01-28 03:52:46.962','2026-01-24 11:06:21.114',3),
('f9c845e1-cf71-40bf-bf33-c28a98b2306e','student645@example.com','student645','Haruna.Wolf','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+645&background=random','2026-01-24 11:06:20.841','2022-05-01 08:55:13.769','2026-01-24 11:06:20.841',3),
('f9e2be42-785f-42f4-9666-b49c581c382a','student278@example.com','student278','Zhen_Shi54','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+278&background=random','2026-01-24 11:06:20.415','2022-08-23 23:03:34.568','2026-01-24 11:06:20.416',3),
('fa2322cf-1e8c-467c-b160-8af43f05163a','student302@example.com','student302','Jianhua.Wojciechowski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+302&background=random','2026-01-24 11:06:20.445','2023-02-01 01:40:46.248','2026-01-24 11:06:20.446',3),
('fa87f129-aede-4383-ac12-4fd41a2a2815','student157@example.com','student157','Usman_Jóhannsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+157&background=random','2026-01-24 11:06:20.255','2024-04-12 10:57:58.875','2026-01-24 11:06:20.256',3),
('fb4359cf-ae27-4cd1-bbbf-1738f845fbce','student929@example.com','student929','Darya.Günther','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+929&background=random','2026-01-24 11:06:21.173','2025-07-10 03:04:19.779','2026-01-24 11:06:21.174',3),
('fb5d1c84-0c7a-47fc-b067-97ff73d62e81','student71@example.com','student71','Mohammed_Cruz','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+71&background=random','2026-01-24 11:06:20.153','2022-06-25 12:37:10.840','2026-01-24 11:06:20.154',3),
('fb8ce74a-e159-4480-92ee-6793d4167347','student469@example.com','student469','Isa_Rodríguez3','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+469&background=random','2026-01-24 11:06:20.646','2023-06-27 21:58:45.232','2026-01-24 11:06:20.646',3),
('fbc0a179-f0b7-4c2f-a0b7-4d2569440668','student948@example.com','student948','Mikhail.Veselá','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+948&background=random','2026-01-24 11:06:21.200','2025-09-17 13:43:42.879','2026-01-24 11:06:21.201',3),
('fbca78d7-b580-4417-8b88-b0474c84d420','student797@example.com','student797','Galina_Shaw','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+797&background=random','2026-01-24 11:06:21.012','2024-02-24 13:28:25.108','2026-01-24 11:06:21.013',3),
('fbfaafa7-5cb0-4525-b335-a94e5e258fa6','teacher77@example.com','teacher77','Kjartan.Nováková','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+77&background=random','2026-01-24 11:06:19.921','2023-10-10 01:19:44.732','2026-01-24 11:06:19.922',2),
('fc11578f-fcb4-4698-8d91-ea98e74326d3','student669@example.com','student669','Maria-Pilar_Øvergård25','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+669&background=random','2026-01-24 11:06:20.865','2025-07-23 00:34:38.212','2026-01-24 11:06:20.865',3),
('fc6f092e-c0ca-4890-9812-b1e7bd726095','student475@example.com','student475','Haiyan_Owen','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+475&background=random','2026-01-24 11:06:20.652','2025-02-20 06:47:17.023','2026-01-24 11:06:20.653',3),
('fcd18a26-d8fc-411e-af5b-c1d96456563d','student574@example.com','student574','Yelena_Marciniak','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+574&background=random','2026-01-24 11:06:20.762','2024-05-21 11:52:43.098','2026-01-24 11:06:20.762',3),
('fce7fb15-57bf-4e46-a828-6e9853035347','student169@example.com','student169','Rita_Greenberg14','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+169&background=random','2026-01-24 11:06:20.272','2021-12-27 20:53:15.565','2026-01-24 11:06:20.272',3),
('fd33fec2-e317-4714-8db5-177c4f898320','teacher55@example.com','teacher55','Heike_Hasna','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+55&background=random','2026-01-24 11:06:19.893','2021-08-26 13:23:55.426','2026-01-24 11:06:19.893',2),
('fd64c015-4d99-4b12-bc2f-467b5e86a8a7','student35@example.com','student35','David_Aliyu','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+35&background=random','2026-01-24 11:06:20.112','2021-10-31 17:02:27.138','2026-01-24 11:06:20.113',3),
('fd87ac24-ee11-4a46-804b-61e856b4c2a6','teacher63@example.com','teacher63','Maria.Löffler61','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+63&background=random','2026-01-24 11:06:19.903','2024-02-08 04:03:05.091','2026-01-24 11:06:19.904',2),
('fd9f5a2d-73e0-4886-967f-781ebb5b791d','student23@example.com','student23','Sombat_Pálsson98','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+23&background=random','2026-01-24 11:06:20.096','2023-06-30 06:45:08.915','2026-01-24 11:06:20.097',3),
('fdfc75ec-f916-4321-a173-91ad1eee0c10','student828@example.com','student828','Pablo_Nowakowski31','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+828&background=random','2026-01-24 11:06:21.060','2022-07-21 18:26:41.262','2026-01-24 11:06:21.061',3),
('fe012949-7174-414b-a3eb-eb385e93b6a7','teacher159@example.com','teacher159','Maksim_Hughes12','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+159&background=random','2026-01-24 11:06:20.018','2021-02-18 16:33:02.804','2026-01-24 11:06:20.019',2),
('fe0f465c-cb2f-429b-b323-ec1a37ca7561','teacher180@example.com','teacher180','Lilian_Pálsson','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+180&background=random','2026-01-24 11:06:20.043','2023-11-05 12:44:23.762','2026-01-24 11:06:20.043',2),
('fe5a3e3d-fe60-4db8-b57f-a853a31d2cf2','student761@example.com','student761','Jose-Maria.Ãshaikh','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+761&background=random','2026-01-24 11:06:20.972','2022-04-01 14:03:02.112','2026-01-24 11:06:20.972',3),
('fe7bc826-16cf-4041-8833-83666af845b1','student821@example.com','student821','Ping.Szczepański1','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+821&background=random','2026-01-24 11:06:21.053','2022-08-26 02:39:12.446','2026-01-24 11:06:21.053',3),
('fe8ba4b6-ed08-42ce-a88f-c991116844f6','student612@example.com','student612','Masami_Horák','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+612&background=random','2026-01-24 11:06:20.803','2022-05-20 06:28:26.795','2026-01-24 11:06:20.804',3),
('fea9fee5-1407-4dad-9079-a8361fd6cfe2','teacher140@example.com','teacher140','Iwona_Saito92','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+140&background=random','2026-01-24 11:06:19.996','2023-11-25 15:57:42.890','2026-01-24 11:06:19.996',2),
('fef09296-b560-4df4-9ebc-379c889c9d23','student613@example.com','student613','Nadezhda_Kaiser','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+613&background=random','2026-01-24 11:06:20.804','2021-10-23 21:22:06.652','2026-01-24 11:06:20.805',3),
('fef4e473-890a-45b1-a29c-617e66649964','teacher146@example.com','teacher146','Karen_Yaakv32','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Teacher+146&background=random','2026-01-24 11:06:20.003','2021-06-27 13:54:12.140','2026-01-24 11:06:20.003',2),
('ff9c32ec-1399-4797-adf6-38540fa06fe1','student873@example.com','student873','Li.Łukaszewski','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+873&background=random','2026-01-24 11:06:21.109','2021-06-09 05:10:26.555','2026-01-24 11:06:21.109',3),
('ffef97cc-7600-4496-8a24-f9e6fff7e7b8','student926@example.com','student926','Zhen_Szczepański','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+926&background=random','2026-01-24 11:06:21.170','2025-01-09 09:13:37.316','2026-01-24 11:06:21.171',3),
('fffbbb2f-f1ab-4be3-b530-dce0dcf3899b','student14@example.com','student14','Anna_Krejčí4','$2b$10$WCxJGo08gVux1Q8AUATHSeU2esxmAjzMI1xXHDU50J5Q3Cho3lbIK','https://ui-avatars.com/api/?name=Student+14&background=random','2026-01-24 11:06:20.084','2023-08-08 21:56:49.958','2026-01-24 11:06:20.084',3);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `User_Assignment`
--

DROP TABLE IF EXISTS `User_Assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `User_Assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_graded` tinyint(1) NOT NULL DEFAULT 0,
  `grade` int(11) DEFAULT NULL,
  `path` varchar(191) DEFAULT NULL,
  `submitted_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) NOT NULL,
  `assignmentId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_Assignment_userId_assignmentId_key` (`userId`,`assignmentId`),
  KEY `User_Assignment_assignmentId_fkey` (`assignmentId`),
  CONSTRAINT `User_Assignment_assignmentId_fkey` FOREIGN KEY (`assignmentId`) REFERENCES `Assignment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `User_Assignment_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User_Assignment`
--

LOCK TABLES `User_Assignment` WRITE;
/*!40000 ALTER TABLE `User_Assignment` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `User_Assignment` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `User_Class`
--

DROP TABLE IF EXISTS `User_Class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `User_Class` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` enum('Student','Teacher','Admin') NOT NULL,
  `userId` varchar(191) NOT NULL,
  `classId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_Class_userId_classId_key` (`userId`,`classId`),
  KEY `User_Class_classId_fkey` (`classId`),
  CONSTRAINT `User_Class_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `Class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `User_Class_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User_Class`
--

LOCK TABLES `User_Class` WRITE;
/*!40000 ALTER TABLE `User_Class` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `User_Class` VALUES
(1,'Teacher','3b1178d4-d0ac-448a-8de3-0404595c430e',1,'2026-01-24 11:06:21.297','2026-01-24 11:06:21.297'),
(2,'Student','2c613a89-cb19-440d-8d8e-239b149e487f',1,'2026-01-24 11:06:21.299','2026-01-24 11:06:21.299'),
(3,'Student','4a33a163-4175-493f-a0e5-c801efe17fbc',1,'2026-01-24 11:06:21.300','2026-01-24 11:06:21.300'),
(4,'Student','65967720-ed23-42a5-ac3c-92d1aa8bf5ac',1,'2026-01-24 11:06:21.301','2026-01-24 11:06:21.301'),
(5,'Student','7d337fb4-c753-4d7d-9153-a1e7d9542e23',1,'2026-01-24 11:06:21.302','2026-01-24 11:06:21.302'),
(6,'Student','02cdc479-c894-43e1-9063-75e4c4c6045a',1,'2026-01-24 11:06:21.303','2026-01-24 11:06:21.303'),
(7,'Student','18812488-d494-47c0-a4f2-561dc4d17de5',1,'2026-01-24 11:06:21.304','2026-01-24 11:06:21.304'),
(8,'Student','1e104a28-d2d8-46f7-b70d-bc41ab8e3d2d',1,'2026-01-24 11:06:21.305','2026-01-24 11:06:21.305'),
(9,'Student','5fa83dd7-145c-4c08-8f97-5dfce0e5c407',1,'2026-01-24 11:06:21.305','2026-01-24 11:06:21.305'),
(10,'Student','1a17a000-3ef0-4c6b-ae62-18d4647a178b',1,'2026-01-24 11:06:21.306','2026-01-24 11:06:21.306'),
(11,'Student','76877d53-873e-48a0-99ab-888f126357a6',1,'2026-01-24 11:06:21.307','2026-01-24 11:06:21.307'),
(12,'Teacher','be8bccb0-0616-4ccb-b649-c7a3ce0163ea',2,'2026-01-24 11:06:21.308','2026-01-24 11:06:21.308'),
(13,'Student','4f70b22e-4c02-4d04-82ae-0e4a6ce9b31f',2,'2026-01-24 11:06:21.309','2026-01-24 11:06:21.309'),
(14,'Student','258db4f0-4776-44fa-8d54-dbfff5c918f2',2,'2026-01-24 11:06:21.310','2026-01-24 11:06:21.310'),
(15,'Student','f795319f-6a4f-4622-8fc9-235000e14ca6',2,'2026-01-24 11:06:21.311','2026-01-24 11:06:21.311'),
(16,'Student','34ee5a22-8bb9-48d7-a9c0-60135827fa64',2,'2026-01-24 11:06:21.312','2026-01-24 11:06:21.312'),
(17,'Student','3448d136-d79f-4c9d-a3b1-c84234021ef2',2,'2026-01-24 11:06:21.313','2026-01-24 11:06:21.313'),
(18,'Student','2351564d-1407-4b99-ad16-ef723fdb341f',2,'2026-01-24 11:06:21.314','2026-01-24 11:06:21.314'),
(19,'Student','0f723fdc-23ab-4bf0-afaf-66944ca3fd2e',2,'2026-01-24 11:06:21.315','2026-01-24 11:06:21.315'),
(20,'Student','22fc182a-a5ad-4a52-a8d5-9bb21c1774e1',2,'2026-01-24 11:06:21.316','2026-01-24 11:06:21.316'),
(21,'Student','083a8dc0-2ce8-4387-a3f6-749662836047',2,'2026-01-24 11:06:21.316','2026-01-24 11:06:21.316'),
(22,'Student','28a634b8-ffc2-4c06-91f4-efe8afb4bb8f',2,'2026-01-24 11:06:21.317','2026-01-24 11:06:21.317'),
(23,'Teacher','08aa5684-f8b3-40b6-9b5b-9295285d43f9',3,'2026-01-24 11:06:21.318','2026-01-24 11:06:21.318'),
(24,'Student','fe8ba4b6-ed08-42ce-a88f-c991116844f6',3,'2026-01-24 11:06:21.319','2026-01-24 11:06:21.319'),
(25,'Student','bec7f008-eebd-44a4-bc7a-9c25f42006b4',3,'2026-01-24 11:06:21.320','2026-01-24 11:06:21.320'),
(26,'Student','918653e6-d6be-4075-9012-623250505270',3,'2026-01-24 11:06:21.321','2026-01-24 11:06:21.321'),
(27,'Student','8a34df60-9db7-41ee-ae0b-50f145b7d455',3,'2026-01-24 11:06:21.322','2026-01-24 11:06:21.322'),
(28,'Student','9227b37c-e56f-47c1-adaf-d195657595de',3,'2026-01-24 11:06:21.323','2026-01-24 11:06:21.323'),
(29,'Student','8a9d2618-b88b-43f2-9eff-97820a411879',3,'2026-01-24 11:06:21.324','2026-01-24 11:06:21.324'),
(30,'Student','24c1a079-0f51-4af3-9a10-32eb5ae38cb8',3,'2026-01-24 11:06:21.325','2026-01-24 11:06:21.325'),
(31,'Student','5ebdd9f0-b0da-4853-b573-c79527f89cd4',3,'2026-01-24 11:06:21.326','2026-01-24 11:06:21.326'),
(32,'Student','a2fe4b15-8a9c-4091-b72d-92a1fc8f151b',3,'2026-01-24 11:06:21.327','2026-01-24 11:06:21.327'),
(33,'Student','42ce4369-f03e-4fc6-9cb3-1bdd7234fd0a',3,'2026-01-24 11:06:21.328','2026-01-24 11:06:21.328'),
(34,'Teacher','fd33fec2-e317-4714-8db5-177c4f898320',4,'2026-01-24 11:06:21.329','2026-01-24 11:06:21.329'),
(35,'Student','6c286826-7b18-4e04-968c-f66174ab56e8',4,'2026-01-24 11:06:21.330','2026-01-24 11:06:21.330'),
(36,'Student','33a5a45d-31c3-4ebf-8c0a-709839857858',4,'2026-01-24 11:06:21.331','2026-01-24 11:06:21.331'),
(37,'Student','77b43cf6-c4f1-4fb0-a959-5cda459b483d',4,'2026-01-24 11:06:21.332','2026-01-24 11:06:21.332'),
(38,'Student','b4f3d0d3-2b2d-4ca0-9e8b-65f1f9d582b8',4,'2026-01-24 11:06:21.333','2026-01-24 11:06:21.333'),
(39,'Student','42215a29-b567-4df2-b468-e37d78e02337',4,'2026-01-24 11:06:21.334','2026-01-24 11:06:21.334'),
(40,'Student','20d0b20d-e88d-4684-9c10-0d62ba431652',4,'2026-01-24 11:06:21.334','2026-01-24 11:06:21.334'),
(41,'Student','2082830e-ef40-41fd-a2c5-4d6a5d688b1c',4,'2026-01-24 11:06:21.335','2026-01-24 11:06:21.335'),
(42,'Student','20330faf-cdd6-483c-b5c0-1774b3d36b18',4,'2026-01-24 11:06:21.336','2026-01-24 11:06:21.336'),
(43,'Student','4a4f3b2c-af7c-4c96-b645-fbcae9a1375f',4,'2026-01-24 11:06:21.337','2026-01-24 11:06:21.337'),
(44,'Student','06fb0ddf-a270-4461-b41f-0765a40f9c76',4,'2026-01-24 11:06:21.338','2026-01-24 11:06:21.338'),
(45,'Teacher','cd4b788f-cd8d-42f4-a3ca-9fc547332503',5,'2026-01-24 11:06:21.339','2026-01-24 11:06:21.339'),
(46,'Student','ee959f9e-b8f3-447a-9f1b-434af862602b',5,'2026-01-24 11:06:21.340','2026-01-24 11:06:21.340'),
(47,'Student','a2fe4b15-8a9c-4091-b72d-92a1fc8f151b',5,'2026-01-24 11:06:21.341','2026-01-24 11:06:21.341'),
(48,'Student','9d887094-52fc-42d5-a30f-7b9ff5379868',5,'2026-01-24 11:06:21.342','2026-01-24 11:06:21.342'),
(49,'Student','b8737d85-b507-4e8d-a779-5e9e1a19e5d0',5,'2026-01-24 11:06:21.342','2026-01-24 11:06:21.342'),
(50,'Student','81958b99-9744-4249-800d-31aa6f114d77',5,'2026-01-24 11:06:21.343','2026-01-24 11:06:21.343'),
(51,'Student','93468d9a-552c-4239-9704-87a29fe6ab30',5,'2026-01-24 11:06:21.344','2026-01-24 11:06:21.344'),
(52,'Student','917d1e6b-cb04-48cb-b684-6bc38124d0b9',5,'2026-01-24 11:06:21.345','2026-01-24 11:06:21.345'),
(53,'Student','a07704f3-4e91-477a-abce-6c55b2c8cecc',5,'2026-01-24 11:06:21.346','2026-01-24 11:06:21.346'),
(54,'Student','ad5b9e81-7f6d-4c6e-a685-6f2826ff088e',5,'2026-01-24 11:06:21.347','2026-01-24 11:06:21.347'),
(55,'Student','da228113-30ce-4574-83d5-cff4a286976e',5,'2026-01-24 11:06:21.348','2026-01-24 11:06:21.348'),
(56,'Teacher','fd33fec2-e317-4714-8db5-177c4f898320',6,'2026-01-24 11:06:21.349','2026-01-24 11:06:21.349'),
(57,'Student','030e0f41-e2c2-458d-9158-2f4e2522ef1c',6,'2026-01-24 11:06:21.350','2026-01-24 11:06:21.350'),
(58,'Student','f4c175a9-9592-45ea-a5bb-0512caa11600',6,'2026-01-24 11:06:21.351','2026-01-24 11:06:21.351'),
(59,'Student','9595036a-00fd-4c21-aff1-13243a64eb9b',6,'2026-01-24 11:06:21.352','2026-01-24 11:06:21.352'),
(60,'Student','b443fc36-f05e-490f-bb4a-216887893e62',6,'2026-01-24 11:06:21.352','2026-01-24 11:06:21.352'),
(61,'Student','a6284e7f-b655-457d-ab3c-ba1997cd262c',6,'2026-01-24 11:06:21.353','2026-01-24 11:06:21.353'),
(62,'Student','a5e19d0c-e8a3-4ee9-91cb-99336c9f933a',6,'2026-01-24 11:06:21.354','2026-01-24 11:06:21.354'),
(63,'Student','a07704f3-4e91-477a-abce-6c55b2c8cecc',6,'2026-01-24 11:06:21.355','2026-01-24 11:06:21.355'),
(64,'Student','9b9bdd19-884f-48e9-8a2b-8809cbcd7661',6,'2026-01-24 11:06:21.356','2026-01-24 11:06:21.356'),
(65,'Student','a216f037-1b94-48f9-98c3-e86eb94829d6',6,'2026-01-24 11:06:21.357','2026-01-24 11:06:21.357'),
(66,'Student','8a9d2618-b88b-43f2-9eff-97820a411879',6,'2026-01-24 11:06:21.358','2026-01-24 11:06:21.358'),
(67,'Teacher','bc6bc6f0-efc9-4e59-8e20-56916795c4c5',7,'2026-01-24 11:06:21.359','2026-01-24 11:06:21.359'),
(68,'Student','9dd4ec58-6273-4eeb-b0c2-90140644efec',7,'2026-01-24 11:06:21.360','2026-01-24 11:06:21.360'),
(69,'Student','3035a707-4276-4e24-b8e5-80edddc36401',7,'2026-01-24 11:06:21.361','2026-01-24 11:06:21.361'),
(70,'Student','3632528e-1cdb-4983-9dce-41413e60284a',7,'2026-01-24 11:06:21.361','2026-01-24 11:06:21.361'),
(71,'Student','75b9ced3-8ffd-4bd5-8dfb-f40107ff641d',7,'2026-01-24 11:06:21.362','2026-01-24 11:06:21.362'),
(72,'Student','41404c89-3acb-46d1-80b0-353d0c2fe48f',7,'2026-01-24 11:06:21.363','2026-01-24 11:06:21.363'),
(73,'Student','7f9f2496-86b6-4f29-ab39-e0e6b3c21861',7,'2026-01-24 11:06:21.364','2026-01-24 11:06:21.364'),
(74,'Student','42756559-8290-4d89-b099-2a4852a7d808',7,'2026-01-24 11:06:21.365','2026-01-24 11:06:21.365'),
(75,'Student','37788b8b-13e6-473d-a8e0-c0f3759ae436',7,'2026-01-24 11:06:21.366','2026-01-24 11:06:21.366'),
(76,'Student','1fd4b34d-be42-4451-bc64-9daee7a6a46a',7,'2026-01-24 11:06:21.367','2026-01-24 11:06:21.367'),
(77,'Student','2cc0bbe8-2372-4a56-8b51-55238577ba75',7,'2026-01-24 11:06:21.367','2026-01-24 11:06:21.367'),
(78,'Teacher','9e2e9c9f-e7d4-4122-9915-d642372b559a',8,'2026-01-24 11:06:21.368','2026-01-24 11:06:21.368'),
(79,'Student','8d9f139b-5b1e-4773-b279-16c0add45b88',8,'2026-01-24 11:06:21.369','2026-01-24 11:06:21.369'),
(80,'Student','0eecc562-81e5-4749-a39a-1f0043572ddf',8,'2026-01-24 11:06:21.370','2026-01-24 11:06:21.370'),
(81,'Student','3a9acf60-1da5-4147-93da-a9ff82bac6ac',8,'2026-01-24 11:06:21.371','2026-01-24 11:06:21.371'),
(82,'Student','08a704be-e791-4c8d-995b-8a5c81eb8a60',8,'2026-01-24 11:06:21.372','2026-01-24 11:06:21.372'),
(83,'Student','2c0ca04f-0be0-4445-9482-ebd38ffb68e0',8,'2026-01-24 11:06:21.373','2026-01-24 11:06:21.373'),
(84,'Student','197244b6-b68f-4943-b93c-2da7d13521f1',8,'2026-01-24 11:06:21.373','2026-01-24 11:06:21.373'),
(85,'Student','2082830e-ef40-41fd-a2c5-4d6a5d688b1c',8,'2026-01-24 11:06:21.374','2026-01-24 11:06:21.374'),
(86,'Student','10628160-74c7-47bf-baa4-5898a69635d2',8,'2026-01-24 11:06:21.375','2026-01-24 11:06:21.375'),
(87,'Student','20d0b20d-e88d-4684-9c10-0d62ba431652',8,'2026-01-24 11:06:21.376','2026-01-24 11:06:21.376'),
(88,'Student','2a7629fe-a202-4208-9a7e-66b90ca7bfed',8,'2026-01-24 11:06:21.377','2026-01-24 11:06:21.377'),
(89,'Teacher','dcbfd2d3-806a-49e1-818b-4985034c4b3b',9,'2026-01-24 11:06:21.378','2026-01-24 11:06:21.378'),
(90,'Student','cf30d6a2-27af-41b1-a805-7e5f27621ec5',9,'2026-01-24 11:06:21.378','2026-01-24 11:06:21.378'),
(91,'Student','3cd6f40e-e2e7-4531-9d6f-5730fa344486',9,'2026-01-24 11:06:21.379','2026-01-24 11:06:21.379'),
(92,'Student','80fb3693-4d05-4ff2-97df-1374c32f642b',9,'2026-01-24 11:06:21.380','2026-01-24 11:06:21.380'),
(93,'Student','5fa6e350-a62e-4192-ae62-b4583e6b5aa5',9,'2026-01-24 11:06:21.381','2026-01-24 11:06:21.381'),
(94,'Student','7d337fb4-c753-4d7d-9153-a1e7d9542e23',9,'2026-01-24 11:06:21.382','2026-01-24 11:06:21.382'),
(95,'Student','00cdcfb5-58b0-4077-878f-920128909475',9,'2026-01-24 11:06:21.383','2026-01-24 11:06:21.383'),
(96,'Student','0f1c5eeb-6c4d-472b-ba15-4684a07290ca',9,'2026-01-24 11:06:21.384','2026-01-24 11:06:21.384'),
(97,'Student','10063a41-25e6-457c-b2db-d69be3ef1909',9,'2026-01-24 11:06:21.385','2026-01-24 11:06:21.385'),
(98,'Student','0eecc562-81e5-4749-a39a-1f0043572ddf',9,'2026-01-24 11:06:21.386','2026-01-24 11:06:21.386'),
(99,'Student','27125320-c617-4610-8ccb-ff30dc2c7367',9,'2026-01-24 11:06:21.387','2026-01-24 11:06:21.387'),
(100,'Teacher','6d51578d-239a-4420-bc0e-63f918e5a0b5',10,'2026-01-24 11:06:21.388','2026-01-24 11:06:21.388'),
(101,'Student','1d667fdc-d821-4559-af09-adbbcb281f5e',10,'2026-01-24 11:06:21.389','2026-01-24 11:06:21.389'),
(102,'Student','f0f830ec-c45d-409e-9453-80ab673108a0',10,'2026-01-24 11:06:21.389','2026-01-24 11:06:21.389'),
(103,'Student','a106522e-3982-4ac8-b16e-f4625662cce5',10,'2026-01-24 11:06:21.390','2026-01-24 11:06:21.390'),
(104,'Student','91a0f988-050d-4702-91ae-0960bd047766',10,'2026-01-24 11:06:21.391','2026-01-24 11:06:21.391'),
(105,'Student','913de85b-a7fc-4068-ba69-7a9b74fa0828',10,'2026-01-24 11:06:21.392','2026-01-24 11:06:21.392'),
(106,'Student','a0f62f77-5afe-44c7-8eed-a6183c538aab',10,'2026-01-24 11:06:21.393','2026-01-24 11:06:21.393'),
(107,'Student','a9d36b9b-afbb-4cd2-bd61-567427f06e57',10,'2026-01-24 11:06:21.394','2026-01-24 11:06:21.394'),
(108,'Student','8d9f139b-5b1e-4773-b279-16c0add45b88',10,'2026-01-24 11:06:21.395','2026-01-24 11:06:21.395'),
(109,'Student','be96b5d1-ebff-4db8-807a-b82aedcae3ae',10,'2026-01-24 11:06:21.396','2026-01-24 11:06:21.396'),
(110,'Student','931af060-f207-4676-903f-57182aa23be6',10,'2026-01-24 11:06:21.397','2026-01-24 11:06:21.397'),
(111,'Teacher','eb962d07-de53-40a6-a398-f2209776ce1f',11,'2026-01-24 11:06:21.404','2026-01-24 11:06:21.404'),
(112,'Student','53578dc1-8317-4025-80a7-c9994e874fbb',11,'2026-01-24 11:06:21.405','2026-01-24 11:06:21.405'),
(113,'Student','ac6c767b-b568-41d9-8c4b-199435ec62b8',11,'2026-01-24 11:06:21.406','2026-01-24 11:06:21.406'),
(114,'Student','a2596a83-1689-4c30-8c0e-da17e15d627e',11,'2026-01-24 11:06:21.407','2026-01-24 11:06:21.407'),
(115,'Student','a13a1898-e842-4aeb-b6dc-701396cb399b',11,'2026-01-24 11:06:21.408','2026-01-24 11:06:21.408'),
(116,'Student','a0297148-9284-4aea-af25-a2bd30e562af',11,'2026-01-24 11:06:21.409','2026-01-24 11:06:21.409'),
(117,'Student','9f8d281d-8fe8-40ac-ae64-3dd561bf1dc1',11,'2026-01-24 11:06:21.410','2026-01-24 11:06:21.410'),
(118,'Student','819541ca-2702-4247-8422-b7346aab362e',11,'2026-01-24 11:06:21.411','2026-01-24 11:06:21.411'),
(119,'Student','930ae4e1-d353-4b80-b1c0-a522390b4dd8',11,'2026-01-24 11:06:21.412','2026-01-24 11:06:21.412'),
(120,'Student','8c8e575a-d5bb-4835-af37-6c1077edd3b2',11,'2026-01-24 11:06:21.413','2026-01-24 11:06:21.413'),
(121,'Student','a332858f-fb97-4aca-ae94-cf7e04fb08b4',11,'2026-01-24 11:06:21.414','2026-01-24 11:06:21.414'),
(122,'Teacher','eb962d07-de53-40a6-a398-f2209776ce1f',12,'2026-01-24 11:06:21.415','2026-01-24 11:06:21.415'),
(123,'Student','a6284e7f-b655-457d-ab3c-ba1997cd262c',12,'2026-01-24 11:06:21.416','2026-01-24 11:06:21.416'),
(124,'Student','3ba311e5-14a8-4edb-a672-2d8598195aa8',12,'2026-01-24 11:06:21.417','2026-01-24 11:06:21.417'),
(125,'Student','790ad272-1198-4120-95c5-a3b9393e9648',12,'2026-01-24 11:06:21.418','2026-01-24 11:06:21.418'),
(126,'Student','2082830e-ef40-41fd-a2c5-4d6a5d688b1c',12,'2026-01-24 11:06:21.419','2026-01-24 11:06:21.419'),
(127,'Student','0bde2af6-ad06-4975-9032-76cfcb5aaeb9',12,'2026-01-24 11:06:21.420','2026-01-24 11:06:21.420'),
(128,'Student','2733e017-ea52-420d-b51a-27f29f220353',12,'2026-01-24 11:06:21.421','2026-01-24 11:06:21.421'),
(129,'Student','28fa01d3-fa94-44b5-8aad-5449f992f53e',12,'2026-01-24 11:06:21.422','2026-01-24 11:06:21.422'),
(130,'Student','038fa0b2-cac0-4dcf-9d47-333d32e97133',12,'2026-01-24 11:06:21.423','2026-01-24 11:06:21.423'),
(131,'Student','08998ae2-bc47-4a81-9da1-d3f5b0283e91',12,'2026-01-24 11:06:21.424','2026-01-24 11:06:21.424'),
(132,'Student','44c0f912-383a-4958-903f-fbdf889f2899',12,'2026-01-24 11:06:21.425','2026-01-24 11:06:21.425'),
(133,'Teacher','eb962d07-de53-40a6-a398-f2209776ce1f',13,'2026-01-24 11:06:21.427','2026-01-24 11:06:21.427'),
(134,'Student','7942bcf5-dae7-4c15-834f-511152020644',13,'2026-01-24 11:06:21.428','2026-01-24 11:06:21.428'),
(135,'Student','3cd6f40e-e2e7-4531-9d6f-5730fa344486',13,'2026-01-24 11:06:21.429','2026-01-24 11:06:21.429'),
(136,'Student','2c613a89-cb19-440d-8d8e-239b149e487f',13,'2026-01-24 11:06:21.430','2026-01-24 11:06:21.430'),
(137,'Student','8fd22f91-d4be-4d95-aa90-787a37e62a20',13,'2026-01-24 11:06:21.431','2026-01-24 11:06:21.431'),
(138,'Student','f8362cc1-e07e-4c3c-bb7f-1676296b0c35',13,'2026-01-24 11:06:21.432','2026-01-24 11:06:21.432'),
(139,'Student','a32998f8-b54b-4700-8052-d9034769aa38',13,'2026-01-24 11:06:21.433','2026-01-24 11:06:21.433'),
(140,'Student','b8701a77-5775-4aaa-b314-5d63b35de8cc',13,'2026-01-24 11:06:21.433','2026-01-24 11:06:21.433'),
(141,'Student','9993c3e9-1b8c-45ff-8fa1-c32282db551d',13,'2026-01-24 11:06:21.434','2026-01-24 11:06:21.434'),
(142,'Student','b4f3d0d3-2b2d-4ca0-9e8b-65f1f9d582b8',13,'2026-01-24 11:06:21.436','2026-01-24 11:06:21.436'),
(143,'Student','bbf123da-fd13-4587-a2f0-fcffc9d12887',13,'2026-01-24 11:06:21.436','2026-01-24 11:06:21.436'),
(144,'Teacher','eb962d07-de53-40a6-a398-f2209776ce1f',14,'2026-01-24 11:06:21.438','2026-01-24 11:06:21.438'),
(145,'Student','55c6bc93-0f8d-4676-955a-dafce7419e65',14,'2026-01-24 11:06:21.439','2026-01-24 11:06:21.439'),
(146,'Student','ae6f0ebe-bdbb-43d7-805e-3a8da3c43fd2',14,'2026-01-24 11:06:21.440','2026-01-24 11:06:21.440'),
(147,'Student','39f00fab-b292-4055-b316-ff848c02e3c5',14,'2026-01-24 11:06:21.441','2026-01-24 11:06:21.441'),
(148,'Student','11d97f83-1c84-4280-807a-4cec95fbbfbc',14,'2026-01-24 11:06:21.442','2026-01-24 11:06:21.442'),
(149,'Student','0f7ed54a-afff-42b0-83cd-17cd63faa71a',14,'2026-01-24 11:06:21.443','2026-01-24 11:06:21.443'),
(150,'Student','20d0b20d-e88d-4684-9c10-0d62ba431652',14,'2026-01-24 11:06:21.444','2026-01-24 11:06:21.444'),
(151,'Student','1fd4b34d-be42-4451-bc64-9daee7a6a46a',14,'2026-01-24 11:06:21.445','2026-01-24 11:06:21.445'),
(152,'Student','22a2f552-9556-4de1-b9ef-e5dfd6828931',14,'2026-01-24 11:06:21.446','2026-01-24 11:06:21.446'),
(153,'Student','2e73341f-3742-4ffd-be10-c68c7295689a',14,'2026-01-24 11:06:21.447','2026-01-24 11:06:21.447'),
(154,'Student','0ee3af87-f4e7-4eb3-ab1c-f56a25c27b6f',14,'2026-01-24 11:06:21.448','2026-01-24 11:06:21.448');
/*!40000 ALTER TABLE `User_Class` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `User_Material`
--

DROP TABLE IF EXISTS `User_Material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `User_Material` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_completed` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) NOT NULL,
  `materialId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_Material_userId_materialId_key` (`userId`,`materialId`),
  KEY `User_Material_materialId_fkey` (`materialId`),
  CONSTRAINT `User_Material_materialId_fkey` FOREIGN KEY (`materialId`) REFERENCES `Material` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `User_Material_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User_Material`
--

LOCK TABLES `User_Material` WRITE;
/*!40000 ALTER TABLE `User_Material` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `User_Material` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Xp`
--

DROP TABLE IF EXISTS `Xp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Xp` (
  `id` varchar(191) NOT NULL,
  `source` enum('Quiz','Assignment','Material') NOT NULL,
  `sourceId` varchar(191) NOT NULL,
  `points` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Xp_userId_fkey` (`userId`),
  CONSTRAINT `Xp_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Xp`
--

LOCK TABLES `Xp` WRITE;
/*!40000 ALTER TABLE `Xp` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Xp` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `_prisma_migrations` VALUES
('02b0f6ca-66a6-477b-abd0-c24107028c26','2f215409efb6a44d519d35a32f1c306105d6ce30a1a634b35446f82501aa3ab4','2026-01-24 11:06:17.266','20251113053041_add_youtube_link_to_section',NULL,NULL,'2026-01-24 11:06:17.260',1),
('40641cc2-0bf5-4025-b41d-407dcaf5f3d6','fa3516f81a29e403ca89eb0070f5b30e4a3152ff883a8bcff53ca3de09b31936','2026-01-24 11:06:17.272','20251125092404_add_explanation_to_quiz_question',NULL,NULL,'2026-01-24 11:06:17.266',1),
('8a7cf693-2c99-4e30-bb85-b53354778b73','8caead10a8318a42fbd12d7ff6f45dde64dee6ee5554a41f7a4c4dc1e0d83086','2026-01-24 11:06:17.283','20260106110855_move_video_link_to_material',NULL,NULL,'2026-01-24 11:06:17.273',1),
('a1878f44-765d-43b2-b50b-486aff645387','87e929063825514a08195476bcf01d59bc1e0797491d1dd4654a7f4b7526fece','2026-01-24 11:06:17.260','20251113042216_add_quiz_attempt_fields',NULL,NULL,'2026-01-24 11:06:17.250',1),
('bdeecd0f-6a48-4659-bfd0-b7b3b2d45368','7ad0f7eb8dce30d44b4a35141ca08ce672d5079238f6be5c2480dd4c6a1fc684','2026-01-24 11:06:17.242','20251029120503_init',NULL,NULL,'2026-01-24 11:06:16.982',1),
('d6df3120-6212-4dd1-9121-4ca6bdd1b1ae','0638659f6300d82d2ea03cfef51ce677c218e90d320687892fffadcc4f77402f','2026-01-24 11:06:17.249','20251113032949_add_order_to_materiall',NULL,NULL,'2026-01-24 11:06:17.243',1),
('e98cea33-8d7c-4d9e-9a28-2e0f9c58571c','64938c3f505a42a1f941ee9628a97e0ba329e44230d95f3b5998bda9ff1c20a5','2026-01-24 11:06:17.296','20260124110608_add_unique_attempt_question_id',NULL,NULL,'2026-01-24 11:06:17.284',1);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-01-24 18:19:35
