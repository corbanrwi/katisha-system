-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: katisha_system_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admins` (
  `adminID` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `agencieid` int(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`adminID`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'john@gmail.com','$2b$10$Nalv4t8ixK1M4ti7O6H7Qet/hdF3.Lm6sjbMeIz4bB3b4m7KP8RVO',1,'John Doe'),(2,'jane@gmail.com','$2b$10$Nalv4t8ixK1M4ti7O6H7Qet/hdF3.Lm6sjbMeIz4bB3b4m7KP8RVO',2,'Jane Doe');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agencies`
--

DROP TABLE IF EXISTS `agencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agencies` (
  `AgencyID` int(11) NOT NULL,
  `AgencyName` varchar(100) DEFAULT NULL,
  `number_of_buses` int(11) NOT NULL,
  PRIMARY KEY (`AgencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agencies`
--

LOCK TABLES `agencies` WRITE;
/*!40000 ALTER TABLE `agencies` DISABLE KEYS */;
INSERT INTO `agencies` VALUES (1,'Virunga',50),(2,'Kigali Coach',50),(3,'Ritco',45),(4,'Horizon',55),(5,'Fidelity',40);
/*!40000 ALTER TABLE `agencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agencydestination`
--

DROP TABLE IF EXISTS `agencydestination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agencydestination` (
  `realtionshipid` int(11) DEFAULT NULL,
  `AgencyID` int(11) NOT NULL,
  `DestinationID` int(11) NOT NULL,
  PRIMARY KEY (`AgencyID`,`DestinationID`),
  KEY `DestinationID` (`DestinationID`),
  CONSTRAINT `agencydestination_ibfk_1` FOREIGN KEY (`AgencyID`) REFERENCES `agencies` (`AgencyID`),
  CONSTRAINT `agencydestination_ibfk_2` FOREIGN KEY (`DestinationID`) REFERENCES `destinations` (`DestinationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agencydestination`
--

LOCK TABLES `agencydestination` WRITE;
/*!40000 ALTER TABLE `agencydestination` DISABLE KEYS */;
INSERT INTO `agencydestination` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,2,1),(8,2,2),(9,4,7),(10,4,8);
/*!40000 ALTER TABLE `agencydestination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buses`
--

DROP TABLE IF EXISTS `buses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Plate` varchar(20) DEFAULT NULL,
  `AvailableSeats` int(11) DEFAULT NULL,
  `TotalSeats` int(11) DEFAULT NULL,
  `BookedSeats` int(11) DEFAULT NULL,
  `DeptTime` datetime DEFAULT NULL,
  `AgencyID` int(11) DEFAULT NULL,
  `DestinationID` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `AgencyID` (`AgencyID`),
  KEY `DestinationID` (`DestinationID`),
  CONSTRAINT `buses_ibfk_1` FOREIGN KEY (`AgencyID`) REFERENCES `agencies` (`AgencyID`),
  CONSTRAINT `buses_ibfk_2` FOREIGN KEY (`DestinationID`) REFERENCES `destinations` (`DestinationID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buses`
--

LOCK TABLES `buses` WRITE;
/*!40000 ALTER TABLE `buses` DISABLE KEYS */;
INSERT INTO `buses` VALUES (1,'RAB123',30,40,10,'2024-04-21 08:00:00',1,1),(2,'RAB456',20,30,10,'2024-04-21 09:00:00',2,2),(3,'RAB789',35,45,10,'2024-04-21 10:00:00',3,3),(4,'RAB987',25,35,10,'2024-04-21 11:00:00',4,4),(5,'RAB654',40,50,10,'2024-04-21 12:00:00',5,5),(6,'RAB321',30,40,10,'2024-04-21 13:00:00',1,6),(7,'RAB258',20,30,10,'2024-04-21 14:00:00',2,7),(8,'RAB369',35,45,10,'2024-04-21 15:00:00',3,8),(9,'RAB741',25,35,10,'2024-04-21 16:00:00',4,9),(10,'RAB852',40,50,10,'2024-04-21 17:00:00',5,10),(11,'RAB111',30,40,10,'2024-04-22 08:00:00',1,1),(12,'RAB222',30,40,10,'2024-04-22 09:00:00',1,1),(13,'RAB333',30,40,10,'2024-04-22 10:00:00',1,1),(14,'RAB444',30,40,10,'2024-04-22 11:00:00',1,1),(15,'RAB555',30,40,10,'2024-04-22 12:00:00',1,1);
/*!40000 ALTER TABLE `buses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `destinations`
--

DROP TABLE IF EXISTS `destinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `destinations` (
  `DestinationID` int(11) NOT NULL,
  `DestinationName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`DestinationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `destinations`
--

LOCK TABLES `destinations` WRITE;
/*!40000 ALTER TABLE `destinations` DISABLE KEYS */;
INSERT INTO `destinations` VALUES (1,'Kigali-Musanze'),(2,'Musanze-Kigali'),(3,'Rubavu-Musanze'),(4,'Musanze-Rubavu'),(5,'Kigali-Rubavu'),(6,'Rubavu-Kigali'),(7,'Kigali-Muhanga'),(8,'Muhanga-Kigali'),(9,'Kigali-Ruhango'),(10,'Ruhango-Kigali');
/*!40000 ALTER TABLE `destinations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `location_id` int(255) DEFAULT NULL,
  `location_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Musanze'),(2,'Kigali'),(3,'Rubavu'),(4,'Muhanga'),(5,'Ruhango'),(6,'Nyanza'),(7,'Huye'),(8,'Nyaruguru'),(9,'Rwamagana'),(10,'Kayonza');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(255) DEFAULT NULL,
  `busName` varchar(255) DEFAULT NULL,
  `destinationName` varchar(255) DEFAULT NULL,
  `deptTime` datetime DEFAULT NULL,
  `agencyName` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `qrCode` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transactionId` (`transactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-22 20:17:08
