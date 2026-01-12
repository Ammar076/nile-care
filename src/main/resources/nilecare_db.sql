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

/*Learning_module table*/ 
INSERT INTO learning_modules (module_id, title, description, content_url, category, difficulty_level, created_at, updated_at) VALUES
(1, 'Understanding Mental Health Fundamentals', 'Learn the basics of mental health, common disorders, and the importance of mental wellness in everyday life.', '/static/images/module-mental-health.jpg', 'Mental Wellness', 'Beginner', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(2, 'Emotional Intelligence and Self-Awareness', 'Develop your emotional intelligence through self-reflection exercises and practical techniques to understand your emotions better.', '/static/images/module-emotional-intelligence.jpg', 'Self-Awareness', 'Intermediate', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(3, 'Understanding and Managing Stress', 'Comprehensive strategies for identifying stress triggers, understanding physiological effects, and developing effective coping mechanisms.', '/static/images/module-stress-managment.jpg', 'Mental Wellness', 'Intermediate', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(4, 'Anxiety Management Techniques', 'Learn evidence-based techniques to manage anxiety, including breathing exercises, cognitive behavioral therapy principles, and mindfulness practices.', '/static/images/module-anxiety.jpg', 'Anxiety', 'Beginner', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(5, 'Building Healthy Relationships', 'Explore communication skills, boundaries, conflict resolution, and the foundations of healthy interpersonal relationships.', '/static/images/module-relationships.jpg', 'Relationships', 'Intermediate', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(6, 'Sleep Hygiene and Better Rest', 'Master the science of sleep, create better sleep habits, and learn techniques to improve sleep quality and overall wellness.', '/static/images/module-sleep.jpg', 'Wellness', 'Beginner', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(7, 'Mindfulness and Meditation Basics', 'Introduction to mindfulness practices, meditation techniques, and how to incorporate these into your daily routine for mental clarity.', '/static/images/module-mindfulness.jpg', 'Mindfulness', 'Beginner', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(8, 'Cognitive Behavioral Therapy Principles', 'Understand the core principles of CBT and learn how to identify and challenge negative thinking patterns.', '/static/images/module-cbt.jpg', 'Mental Wellness', 'Advanced', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(9, 'Resilience and Coping with Change', 'Develop resilience skills to navigate life changes, setbacks, and challenges with greater confidence and emotional strength.', '/static/images/module-resilience.jpg', 'Personal Growth', 'Intermediate', '2025-12-08 00:32:10', '2025-12-08 03:47:46'),
(10, 'Depression: Recognition and Support', 'Learn to recognize signs of depression, understand the condition better, and discover available support resources and treatment options.', '/static/images/module-depression.jpg', 'Mental Health', 'Beginner', '2025-12-08 00:32:10', '2025-12-08 03:47:46');

/*Lessons table:*/
INSERT INTO lessons (lesson_id, module_id, title, description, content, video_url, lesson_order, duration_minutes, created_at, updated_at, lessonId) VALUES
(1, 3, 'Introduction to Stress', 'Understanding what stress is and its impact on mental health.', NULL, 'https://www.youtube.com/embed/mFrMxGyBeSU', 1, 20, '2025-12-08 00:32:20', '2026-01-06 05:14:14', 0),
(2, 3, 'Identifying Stressors', 'Learn to identify personal stress triggers and patterns.', NULL, 'https://www.youtube.com/embed/t39pAFp-QqY', 2, 25, '2025-12-08 00:32:20', '2026-01-06 05:14:14', 0),
(3, 3, 'Coping Strategies', 'Effective coping mechanisms for managing stress.', NULL, 'https://www.youtube.com/embed/0fL-pn80s-c', 3, 25, '2025-12-08 00:32:20', '2026-01-06 05:14:14', 0),
(4, 3, 'Practical Exercises', 'Hands-on exercises to practice stress management techniques.', NULL, 'https://www.youtube.com/embed/inpok4MKVLM', 4, 30, '2025-12-08 00:32:20', '2026-01-06 01:37:20', 0),
(5, 3, 'Knowledge Check', 'Course Summary & Knowledge Check', '<h3>Congratulations on reaching the end of this module!</h3><p>We have covered the definition of stress, how to identify your personal triggers, and various coping strategies to manage them.</p><p>Below, you will find a knowledge check to test your understanding. Good luck!</p>', NULL, 5, 15, '2025-12-08 00:32:20', '2026-01-06 05:14:20', 0),
(6, 2, 'Introduction to Emotional Intelligence', 'Discover the importance of EQ and how it differs from IQ.', '<p>Emotional Intelligence (EQ) is the ability to understand, use, and manage your own emotions in positive ways to relieve stress, communicate effectively, empathize with others, overcome challenges and defuse conflict.</p>', 'https://www.youtube.com/embed/LgUCyWhJf6s', 1, 15, '2026-01-06 05:26:36', '2026-01-06 05:26:36', 0),
(7, 2, 'The Power of Self-Awareness', 'Learn how to recognize your emotions as they happen and understand your personal triggers.', '<p>Self-awareness is the foundation of EQ. It involves recognizing your own emotions and how they affect your thoughts and behavior. You know your strengths and weaknesses, and have self-confidence.</p>', 'https://www.youtube.com/embed/R9qVa4LoJx8', 2, 20, '2026-01-06 05:26:36', '2026-01-06 05:26:36', 0),
(8, 2, 'Mastering Self-Regulation', 'Techniques to manage impulsive feelings and behaviors.', '<p>Self-regulation doesn''t mean blocking emotions. It means waiting for the right time and place to express them. It involves controlling impulsive feelings, taking initiative, and adapting to changing circumstances.</p>', 'https://www.youtube.com/embed/wxX8RdpN5M8', 3, 25, '2026-01-06 05:26:36', '2026-01-06 05:26:36', 0),
(9, 2, 'Empathy & Social Skills', 'Developing the ability to understand the emotions and needs of other people.', '<p>Social awareness enables you to recognize and interpret the nonverbal cues others use to communicate. These cues let you know how others are really feeling and what is truly important to them.</p>', 'https://www.youtube.com/embed/UzPMMSKfKZQ', 4, 20, '2026-01-06 05:26:36', '2026-01-06 05:26:36', 0),
(10, 2, 'EQ Knowledge Check', 'Review key concepts and test your understanding of Emotional Intelligence.', '<h3>Module Complete!</h3><p>You have learned the basics of recognizing and managing your own emotions, as well as understanding the emotions of others.</p><p>Take a moment to reflect on a recent situation where you could have applied better EQ.</p>', NULL, 5, 10, '2026-01-06 05:26:36', '2026-01-06 05:26:36', 0),
(11, 1, 'Introduction to Mental Health', 'An introduction to what mental health really is and why it matters.', NULL, 'https://www.youtube.com/embed/G0zJGDokyWQ', 1, 15, '2026-01-06 05:59:34', '2026-01-06 05:59:34', 0),
(12, 1, 'Breaking the Stigma', 'Understanding the stigma surrounding mental health and how to overcome it.', NULL, 'https://www.youtube.com/embed/IaSpas9hWNQ', 2, 15, '2026-01-06 05:59:34', '2026-01-06 05:59:34', 0),
(13, 1, 'Mental Health vs. Mental Illness', 'Distinguishing between mental wellness and specific mental health conditions.', NULL, 'https://www.youtube.com/embed/7JAhnEINmRM', 3, 15, '2026-01-06 05:59:34', '2026-01-06 05:59:34', 0),
(14, 1, 'Module 1 Wrap-Up', 'Summary of mental health fundamentals.', '<h3>You have completed Module 1!</h3><p>You now have a solid foundation in understanding mental health concepts.</p>', NULL, 4, 10, '2026-01-06 05:59:34', '2026-01-06 05:59:34', 0),
(15, 4, 'Immediate Relief: Breathing Techniques', 'Learn the Box Breathing and 4-7-8 techniques to physically calm your nervous system.', NULL, 'https://www.youtube.com/embed/odADwWzHR24', 1, 10, '2026-01-06 06:00:56', '2026-01-06 06:00:56', 0),
(16, 4, 'The 5-4-3-2-1 Grounding Method', 'A powerful sensory exercise to stop panic attacks and racing thoughts in their tracks.', NULL, 'https://www.youtube.com/embed/pjRMg6KALiw', 2, 10, '2026-01-06 06:00:56', '2026-01-06 06:00:56', 0),
(17, 4, 'CBT Exercises for Anxiety', 'How to use Cognitive Behavioral Therapy tools to challenge anxious thoughts.', NULL, 'https://www.youtube.com/embed/RFuYcIy6Vxc', 3, 15, '2026-01-06 06:00:56', '2026-01-06 06:00:56', 0),
(18, 4, 'Anxiety Toolkit Summary', 'Reviewing your new toolkit for managing anxiety.', '<h3>You have completed Module 4!</h3><p>Remember: <strong>Breathe</strong> to calm the body, <strong>Ground</strong> to calm the senses, and <strong>Challenge</strong> to calm the mind.</p>', NULL, 4, 5, '2026-01-06 06:00:56', '2026-01-06 06:00:56', 0),
(19, 5, 'Effective Communication Skills', 'Improving how we speak and listen to build stronger connections.', NULL, 'https://www.youtube.com/embed/Xk8NlNXoEug', 1, 12, '2026-01-06 06:02:35', '2026-01-06 06:02:35', 0),
(20, 5, 'Boundaries 101', 'A guide to setting healthy boundaries while maintaining respect and love.', NULL, 'https://www.youtube.com/embed/9roFI1cOHxk', 2, 15, '2026-01-06 06:02:35', '2026-01-06 06:02:35', 0),
(21, 5, 'Conflict Resolution 101', '5 quick tips for resolving conflict successfully in any relationship.', NULL, 'https://www.youtube.com/embed/zHXYWMnm7Yg', 3, 10, '2026-01-06 06:02:35', '2026-01-06 06:02:35', 0),
(22, 5, 'Relationships Summary', 'Recap of the keys to healthy interpersonal dynamics.', '<h3>You have completed Module 5!</h3><p>Healthy relationships require three things: <strong>Clear Communication</strong>, <strong>Firm Boundaries</strong>, and <strong>Fair Conflict</strong>.</p>', NULL, 4, 5, '2026-01-06 06:02:35', '2026-01-06 06:02:35', 0),
(23, 7, 'What is Mindfulness?', 'Demystifying mindfulness: It is not about clearing your mind, but observing it.', NULL, 'https://www.youtube.com/embed/w6T02g5hnT4', 1, 10, '2026-01-06 06:05:18', '2026-01-06 06:05:18', 0),
(24, 7, 'Guided Meditation for Beginners', 'A short, 10-minute guided session to practice the "Body Scan" technique.', NULL, 'https://www.youtube.com/embed/O-6f5wQXSu8', 2, 15, '2026-01-06 06:05:18', '2026-01-06 06:05:18', 0),
(25, 7, 'Mindfulness in Daily Life', 'How to be mindful while eating, walking, or doing chores (no cushion required).', NULL, 'https://www.youtube.com/embed/QtMq1tX0zj0', 3, 12, '2026-01-06 06:05:18', '2026-01-06 06:05:18', 0),
(26, 7, 'Mindfulness Summary', 'Reflecting on the power of the present moment.', '<h3>You have completed Module 7!</h3><p>Mindfulness is a muscle. The more you practice bringing your attention back to the present, the stronger it gets.</p>', NULL, 4, 5, '2026-01-06 06:05:18', '2026-01-06 06:05:18', 0),
(27, 8, 'The Cognitive Triangle', 'Understanding how Thoughts, Feelings, and Behaviors interact to create our reality.', NULL, 'https://www.youtube.com/embed/qIGQE4QlC68', 1, 15, '2026-01-06 06:05:29', '2026-01-06 06:05:29', 0),
(28, 8, 'Identifying Cognitive Distortions', 'Learn to spot common "Thinking Errors" like Catastrophizing and All-or-Nothing thinking.', NULL, 'https://www.youtube.com/embed/ot1F7d5_aEA', 2, 20, '2026-01-06 06:05:29', '2026-01-06 06:05:29', 0),
(29, 8, 'Reframing & The ABC Model', 'Practical techniques to challenge negative thoughts and rewrite your internal narrative.', NULL, 'https://www.youtube.com/embed/NoO9j6O6Hlg', 3, 20, '2026-01-06 06:05:29', '2026-01-06 06:05:29', 0),
(30, 8, 'CBT Toolkit Summary', 'Reviewing the tools for cognitive restructuring.', '<h3>You have completed Module 8!</h3><p>You now have the tools to be a "scientist of your own mind"-observing thoughts rather than automatically believing them.</p>', NULL, 4, 10, '2026-01-06 06:05:29', '2026-01-06 06:05:29', 0); 

/* Assessments Table */
CREATE TABLE IF NOT EXISTS `assessments` (
  `assessment_id` bigint NOT NULL AUTO_INCREMENT,
  `description` text,
  `due_date` datetime(6) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `total_points` int DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `module_id` bigint NOT NULL,
  PRIMARY KEY (`assessment_id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `assessments_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `learning_modules` (`module_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* Assessment Submissions Table */
CREATE TABLE IF NOT EXISTS `assessment_submissions` (
  `submission_id` bigint NOT NULL AUTO_INCREMENT,
  `content` text,
  `score` int DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `submission_date` datetime(6) DEFAULT NULL,
  `assessment_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `max_score` int DEFAULT NULL,
  PRIMARY KEY (`submission_id`),
  KEY `assessment_id` (`assessment_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `assessment_submissions_ibfk_1` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`assessment_id`) ON DELETE CASCADE,
  CONSTRAINT `assessment_submissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 