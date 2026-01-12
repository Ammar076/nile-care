CREATE DATABASE  IF NOT EXISTS `nilecare_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `nilecare_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: nilecare_db
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` bigint NOT NULL AUTO_INCREMENT,
  `student_id` bigint NOT NULL,
  `slot_id` bigint NOT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  `notes` text,
  PRIMARY KEY (`appointment_id`),
  UNIQUE KEY `slot_id` (`slot_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`slot_id`) REFERENCES `counselor_availability` (`slot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `counselor_availability`
--

DROP TABLE IF EXISTS `counselor_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counselor_availability` (
  `slot_id` bigint NOT NULL AUTO_INCREMENT,
  `counselor_id` bigint NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `is_booked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`slot_id`),
  KEY `counselor_id` (`counselor_id`),
  CONSTRAINT `counselor_availability_ibfk_1` FOREIGN KEY (`counselor_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `counselor_availability`
--

LOCK TABLES `counselor_availability` WRITE;
/*!40000 ALTER TABLE `counselor_availability` DISABLE KEYS */;
/*!40000 ALTER TABLE `counselor_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `help_requests`
--

DROP TABLE IF EXISTS `help_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_requests` (
  `request_id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `message` text NOT NULL,
  `response` text,
  `status` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`request_id`),
  KEY `FK32v465gmq2jfev7b7wnfllv98` (`user_id`),
  CONSTRAINT `FK32v465gmq2jfev7b7wnfllv98` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_requests`
--

LOCK TABLES `help_requests` WRITE;
/*!40000 ALTER TABLE `help_requests` DISABLE KEYS */;
INSERT INTO `help_requests` VALUES (3,'Technical Issue','2025-12-05 23:54:30.000000','I keep getting an error when trying to open Module 3. The page loads but shows an error message.','This issue has been fixed. Please try logging out and back in. Clear your browser cache if the problem persists.','RESOLVED','Cannot access Module 3','2025-12-05 23:54:30.000000',3),(4,'Content Question','2025-12-05 23:54:30.000000','I would like more information about the breathing exercises mentioned in the mindfulness module. Are there any video tutorials?','Thank you for your question! We are reviewing your request and will provide detailed information about the breathing exercises soon. Our team is working on creating video tutorials as well.','IN_PROGRESS','Question about mindfulness exercises','2025-12-05 23:54:30.000000',3),(5,'Booking Issue','2025-12-05 23:54:30.000000','The calendar is not showing any available slots for next week. Can someone help me find an available time?',NULL,'IN_PROGRESS','Cannot book counseling appointment','2026-01-11 10:45:58.840459',3),(29,'Technical Issue','2025-12-07 17:08:07.736186','I cannot make a new account it say an eeror',NULL,'IN_PROGRESS','the register isn\'t working','2026-01-11 10:34:11.241119',3),(30,'Technical Issue','2025-12-07 17:09:51.349929','my acdcount registeration is shwoing errors',NULL,'IN_PROGRESS','I cannot refiste an account','2026-01-11 10:20:22.232672',3),(31,'Technical Issue','2025-12-07 18:09:10.239497','when I register its not working',NULL,'IN_PROGRESS','rigisteration not showing up','2026-01-11 10:20:19.574784',3),(32,'Technical Issue','2025-12-07 18:11:19.572473','my registeration not wokring','resolved','RESOLVED','rigisteration  j0to shwiing up','2026-01-11 11:11:32.317362',3),(33,'Account Issue','2025-12-08 16:20:59.068279','grdgrtgdr','wow','RESOLVED',' dgbrgdrs','2026-01-11 09:21:57.324296',3),(34,'Account Issue','2026-01-11 08:25:00.163214','Verify me','you can check now its verified','RESOLVED','Why am I not verified yet','2026-01-11 09:13:32.398151',3);
/*!40000 ALTER TABLE `help_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_modules`
--

DROP TABLE IF EXISTS `learning_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_modules` (
  `module_id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text,
  `content_url` varchar(255) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `difficulty_level` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`module_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_modules`
--

LOCK TABLES `learning_modules` WRITE;
/*!40000 ALTER TABLE `learning_modules` DISABLE KEYS */;
INSERT INTO `learning_modules` VALUES (1,'Stress Management Fundamentals','Learn effective techniques to identify, manage, and reduce stress in your daily life through connection with nature.','https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=800&q=80','Stress & Anxiety','Beginner','2025-12-06 12:23:11','2025-12-06 12:23:11'),(2,'Mindfulness & Meditation','Discover the power of mindfulness to improve mental clarity and reduce anxiety using simple breathing techniques.','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80','Mindfulness','Beginner','2025-12-06 12:23:11','2025-12-06 12:23:11'),(3,'Emotional Regulation Skills','Master techniques to understand and manage your emotions effectively in high-pressure situations.','https://images.unsplash.com/photo-1477346611705-65d1883cee1e?auto=format&fit=crop&w=800&q=80','Emotional Health','Intermediate','2025-12-06 12:23:11','2025-12-06 12:23:11'),(5,'The Power of Journaling','Explore how writing down your thoughts can help process complex emotions and reduce daily anxiety.','https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=800&q=80','Self-Help','Beginner','2025-12-06 12:23:11','2025-12-06 12:23:11'),(6,'Exercise for Mental Health','Learn the biological connection between physical activity and mental well-being, with simple workout plans.','https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80','Physical Health','Intermediate','2025-12-06 12:23:11','2025-12-06 12:23:11'),(7,'Overcoming Procrastination','Practical strategies to beat the habit of delaying tasks and reduce academic stress.','https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&w=800&q=80','Productivity','Advanced','2025-12-06 12:23:11','2025-12-06 12:23:11');
/*!40000 ALTER TABLE `learning_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lessons`
--

DROP TABLE IF EXISTS `lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lessons` (
  `lesson_id` bigint NOT NULL AUTO_INCREMENT,
  `module_id` bigint NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text,
  `content` text,
  `video_url` varchar(255) DEFAULT NULL,
  `lesson_order` int NOT NULL,
  `duration_minutes` int DEFAULT '25',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lessonId` bigint NOT NULL,
  PRIMARY KEY (`lesson_id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `learning_modules` (`module_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (1,3,'Introduction to Stress','Understanding what stress is and its impact on mental health.',NULL,NULL,1,20,'2025-12-06 13:20:34','2025-12-06 13:20:34',0),(2,3,'Identifying Stressors','Learn to identify personal stress triggers and patterns.',NULL,NULL,2,25,'2025-12-06 13:20:34','2025-12-06 13:20:34',0),(3,3,'Coping Strategies','Effective coping mechanisms for managing stress.',NULL,NULL,3,25,'2025-12-06 13:20:34','2025-12-06 13:20:34',0),(4,3,'Practical Exercises','Hands-on exercises to practice stress management techniques.',NULL,NULL,4,30,'2025-12-06 13:20:34','2025-12-06 13:20:34',0),(5,3,'Knowledge Check','Test your understanding of stress management concepts.',NULL,NULL,5,15,'2025-12-06 13:20:34','2025-12-06 13:20:34',0);
/*!40000 ALTER TABLE `lessons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (3,'ROLE_ADMIN'),(1,'ROLE_STUDENT');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_achievements`
--

DROP TABLE IF EXISTS `student_achievements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_achievements` (
  `achievement_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `achievement_type` varchar(50) DEFAULT NULL,
  `earned_at` timestamp NULL DEFAULT NULL,
  `is_earned` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`achievement_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_earned` (`is_earned`),
  CONSTRAINT `student_achievements_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_achievements`
--

LOCK TABLES `student_achievements` WRITE;
/*!40000 ALTER TABLE `student_achievements` DISABLE KEYS */;
INSERT INTO `student_achievements` VALUES (1,2,'First Steps','Completed your first module','FIRST_MODULE','2025-12-05 11:05:52',1),(2,2,'7-Day Streak','Logged in for 7 consecutive days','STREAK_7_DAYS','2025-12-05 11:05:52',1),(3,2,'Module Master','Completed 5 modules','MODULE_MASTER',NULL,0),(4,2,'Assessment Pro','Completed all self-assessments','ASSESSMENT_PRO',NULL,0),(5,2,'First Steps','Completed your first module','FIRST_MODULE','2025-12-05 11:14:40',1),(6,2,'7-Day Streak','Logged in for 7 consecutive days','STREAK_7_DAYS','2025-12-05 11:14:40',1),(7,2,'Module Master','Completed 5 modules','MODULE_MASTER',NULL,0),(8,2,'Assessment Pro','Completed all self-assessments','ASSESSMENT_PRO',NULL,0),(9,3,'First Steps','Completed your first module','FIRST_MODULE','2025-12-05 11:36:18',1),(10,3,'7-Day Streak','Logged in for 7 consecutive days','STREAK_7_DAYS','2025-12-05 11:36:18',1),(11,3,'Module Master','Completed 5 modules','MODULE_MASTER',NULL,0),(12,3,'Assessment Pro','Completed all self-assessments','ASSESSMENT_PRO',NULL,0),(13,3,'First Steps','Completed your first module','FIRST_MODULE','2025-12-05 11:42:53',1),(14,3,'7-Day Streak','Logged in for 7 consecutive days','STREAK_7_DAYS','2025-12-05 11:42:53',1),(15,3,'Module Master','Completed 5 modules','MODULE_MASTER',NULL,0),(16,3,'Assessment Pro','Completed all self-assessments','ASSESSMENT_PRO',NULL,0);
/*!40000 ALTER TABLE `student_achievements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_feedback`
--

DROP TABLE IF EXISTS `student_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_feedback` (
  `feedback_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `category` varchar(100) NOT NULL,
  `rating` int NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `status` enum('PENDING','REVIEWED','RESPONDED') NOT NULL DEFAULT 'PENDING',
  `response` longtext,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `student_feedback_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `student_feedback_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_feedback`
--

LOCK TABLES `student_feedback` WRITE;
/*!40000 ALTER TABLE `student_feedback` DISABLE KEYS */;
INSERT INTO `student_feedback` VALUES (1,3,'Learning Modules',5,'Excellent stress management module','The stress management module was incredibly helpful. The breathing exercises really work!','RESPONDED','Thank you for your positive feedback! We\'re glad the module was helpful.','2025-12-04 03:00:00','2025-12-05 02:30:00'),(2,3,'Platform Experience',4,'Great platform, minor suggestions','Love the interface! Would be great to have a mobile app version.','RESPONDED','Thank you','2025-12-03 19:00:00','2026-01-11 04:23:56'),(3,3,'Counseling Service',5,'Amazing counseling session','Dr. Williams was very professional and understanding. Highly recommend!','RESPONDED','ik ik','2025-11-28 06:30:00','2026-01-11 04:24:09'),(14,3,'Counseling Service',5,'Very nice website','I enjoyed using the website','RESPONDED','whaaat','2025-12-07 11:04:17','2026-01-11 04:27:10'),(15,3,'Counseling Service',5,'rgrg','grgr','RESPONDED','damn','2026-01-04 06:34:24','2026-01-11 04:27:02'),(16,3,'Counseling Service',4,'rsrser','rere','PENDING',NULL,'2026-01-11 04:28:30','2026-01-11 04:28:30'),(17,3,'Platform Experience',1,'rere','erer','PENDING',NULL,'2026-01-11 04:28:38','2026-01-11 04:28:38'),(18,3,'Learning Modules',1,'erre','rere','PENDING',NULL,'2026-01-11 04:28:43','2026-01-11 04:28:43');
/*!40000 ALTER TABLE `student_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_lesson_progress`
--

DROP TABLE IF EXISTS `student_lesson_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_lesson_progress` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `completed_at` datetime(6) DEFAULT NULL,
  `lesson_id` bigint DEFAULT NULL,
  `module_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_lesson_progress`
--

LOCK TABLES `student_lesson_progress` WRITE;
/*!40000 ALTER TABLE `student_lesson_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_lesson_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_progress`
--

DROP TABLE IF EXISTS `student_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_progress` (
  `progress_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `module_id` bigint NOT NULL,
  `completion_percentage` int NOT NULL DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'NOT_STARTED',
  `last_accessed` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`progress_id`),
  UNIQUE KEY `unique_user_module` (`user_id`,`module_id`),
  KEY `module_id` (`module_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_last_accessed` (`last_accessed`),
  CONSTRAINT `student_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `student_progress_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `learning_modules` (`module_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_progress`
--

LOCK TABLES `student_progress` WRITE;
/*!40000 ALTER TABLE `student_progress` DISABLE KEYS */;
INSERT INTO `student_progress` VALUES (1,2,1,75,'IN_PROGRESS','2025-12-05 11:05:52','2025-12-05 11:05:52','2025-12-05 11:05:52'),(2,2,2,30,'IN_PROGRESS','2025-12-04 11:05:52','2025-12-05 11:05:52','2025-12-05 11:05:52'),(7,3,1,75,'IN_PROGRESS','2025-12-05 11:36:18','2025-12-05 11:36:18','2025-12-05 11:36:18'),(8,3,2,30,'IN_PROGRESS','2025-12-04 11:36:18','2025-12-05 11:36:18','2025-12-05 11:36:18'),(13,2,3,100,'COMPLETED',NULL,'2026-01-04 21:24:36','2026-01-04 21:24:36'),(14,2,5,0,'NOT_STARTED',NULL,'2026-01-04 21:24:36','2026-01-04 21:24:36'),(15,3,3,100,'COMPLETED',NULL,'2026-01-04 21:24:36','2026-01-04 21:24:36'),(16,3,5,100,'COMPLETED',NULL,'2026-01-04 21:24:36','2026-01-04 21:24:36'),(17,2,6,0,'NOT_STARTED',NULL,'2026-01-04 21:24:36','2026-01-04 21:24:36');
/*!40000 ALTER TABLE `student_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (2,1),(3,1),(15,1),(14,3),(16,3);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `profile_image_url` varchar(255) DEFAULT NULL,
  `verified` bit(1) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'student@utm.my','$2a$10$gtAoo88GJ4GrpLBtESq3qeITRcqRT5ytlVJFih9PsFUJBQk6G3CSG','Student User',NULL,1,'2026-01-04 19:54:43',NULL,_binary ''),(3,'ammar@gmail.com','$2a$10$TwAZEDGd.Vc9/Ml/mBXCl.69RKlNK70tyZDMFtCEsUm61NDHPjSkS','Yossep','09111897',1,'2025-12-02 01:00:24',NULL,_binary ''),(14,'admin@nilecare.com','$2a$10$xrn0kP5gAeRLVQGtb/wsfezgRIWRJdFOZUpr9wEK6I8SM8iD5FK9K','Admin','4903287423',1,'2026-01-04 10:53:07',NULL,_binary ''),(15,'rgdrg@hun.c0om','$2a$10$.tO.6tYbQac3cg9pTH77Ne19hmYeGcYfUGMPZmCNs7VHBxiUsGZQW','rgdgdr',NULL,0,'2026-01-04 11:32:23',NULL,_binary '\0'),(16,'johndoey@gmail.com','$2a$10$UDi2PHgyiCsqh3BiOoTKuuwiFvd205R0hHt/pAI1TuiTT7WWT64ke','john doey',NULL,1,'2026-01-11 05:01:08',NULL,_binary '');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-12 14:04:21
