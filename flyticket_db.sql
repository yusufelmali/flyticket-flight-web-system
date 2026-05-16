-- MySQL dump 10.13  Distrib 8.0.43, for macos15 (x86_64)
--
-- Host: localhost    Database: flyticket_db
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` VALUES ('admin','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `City`
--

DROP TABLE IF EXISTS `City`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `City` (
  `city_id` varchar(10) NOT NULL,
  `city_name` varchar(100) NOT NULL,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `City`
--

LOCK TABLES `City` WRITE;
/*!40000 ALTER TABLE `City` DISABLE KEYS */;
INSERT INTO `City` VALUES ('01','Adana'),('02','Adiyaman'),('03','Afyonkarahisar'),('04','Agri'),('05','Amasya'),('06','Ankara'),('07','Antalya'),('08','Artvin'),('09','Aydin'),('10','Balikesir'),('11','Bilecik'),('12','Bingol'),('13','Bitlis'),('14','Bolu'),('15','Burdur'),('16','Bursa'),('17','Canakkale'),('18','Cankiri'),('19','Corum'),('20','Denizli'),('21','Diyarbakir'),('22','Edirne'),('23','Elazig'),('24','Erzincan'),('25','Erzurum'),('26','Eskisehir'),('27','Gaziantep'),('28','Giresun'),('29','Gumushane'),('30','Hakkari'),('31','Hatay'),('32','Isparta'),('33','Mersin'),('34','Istanbul'),('35','Izmir'),('36','Kars'),('37','Kastamonu'),('38','Kayseri'),('39','Kirklareli'),('40','Kirsehir'),('41','Kocaeli'),('42','Konya'),('43','Kutahya'),('44','Malatya'),('45','Manisa'),('46','Kahramanmaras'),('47','Mardin'),('48','Mugla'),('49','Mus'),('50','Nevsehir'),('51','Nigde'),('52','Ordu'),('53','Rize'),('54','Sakarya'),('55','Samsun'),('56','Siirt'),('57','Sinop'),('58','Sivas'),('59','Tekirdag'),('60','Tokat'),('61','Trabzon'),('62','Tunceli'),('63','Sanliurfa'),('64','Usak'),('65','Van'),('66','Yozgat'),('67','Zonguldak'),('68','Aksaray'),('69','Bayburt'),('70','Karaman'),('71','Kirikkale'),('72','Batman'),('73','Sirnak'),('74','Bartin'),('75','Ardahan'),('76','Igdir'),('77','Yalova'),('78','Karabuk'),('79','Kilis'),('80','Osmaniye'),('81','Duzce');
/*!40000 ALTER TABLE `City` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Flight`
--

DROP TABLE IF EXISTS `Flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Flight` (
  `flight_id` varchar(20) NOT NULL,
  `from_city` varchar(10) DEFAULT NULL,
  `to_city` varchar(10) DEFAULT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `seats_total` int NOT NULL,
  `seats_available` int NOT NULL,
  PRIMARY KEY (`flight_id`),
  KEY `from_city` (`from_city`),
  KEY `to_city` (`to_city`),
  CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`from_city`) REFERENCES `City` (`city_id`),
  CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`to_city`) REFERENCES `City` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flight`
--

LOCK TABLES `Flight` WRITE;
/*!40000 ALTER TABLE `Flight` DISABLE KEYS */;
INSERT INTO `Flight` VALUES ('TK1408','48','34','2026-05-16 23:49:00','2026-05-17 01:48:00',1600.00,200,199);
/*!40000 ALTER TABLE `Flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ticket`
--

DROP TABLE IF EXISTS `Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ticket` (
  `ticket_id` varchar(20) NOT NULL,
  `passenger_name` varchar(50) NOT NULL,
  `passenger_surname` varchar(50) NOT NULL,
  `passenger_email` varchar(100) NOT NULL,
  `flight_id` varchar(20) DEFAULT NULL,
  `seat_number` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `flight_id` (`flight_id`),
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `Flight` (`flight_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket`
--

LOCK TABLES `Ticket` WRITE;
/*!40000 ALTER TABLE `Ticket` DISABLE KEYS */;
INSERT INTO `Ticket` VALUES ('TKT-34302','Yusuf Emre','Elmali','elmali.yusufemre@gmail.com','TK1408','15F');
/*!40000 ALTER TABLE `Ticket` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-16 23:54:34
