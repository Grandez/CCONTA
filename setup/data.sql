-- MariaDB dump 10.19  Distrib 10.6.7-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: CCONTA
-- ------------------------------------------------------
-- Server version	10.6.7-MariaDB-2ubuntu1.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `MOVEMENTS`
--

LOCK TABLES `MOVEMENTS` WRITE;
/*!40000 ALTER TABLE `MOVEMENTS` DISABLE KEYS */;
INSERT INTO `MOVEMENTS` (`ID`, `CDATE`, `IDMETHOD`, `IDGROUP`, `IDCATEGORY`, `AMOUNT`, `NOTE`, `TYPE`, `MODE`, `ACTIVE`, `SYNC`, `DATEY`, `DATEM`, `DATED`) VALUES (56749121,'2022-09-17',1,2,2005,7.000,'Cervezas super',1,1,1,0,2022,9,17),(56749891,'2022-09-17',1,2,2005,7.000,'cervezas super',1,1,1,0,2022,9,17),(57571781,'2022-09-08',1,2,2001,275.000,'',1,1,1,0,2022,9,8),(57571912,'2022-09-08',1,2,2002,35.000,'',1,1,1,0,2022,9,8),(57572123,'2022-09-18',1,2,2006,12.000,'Baloncesto',1,1,1,0,2022,9,18),(57572404,'2022-09-18',1,4,4001,5.000,'Con arturo',1,1,1,0,2022,9,18),(57572595,'2022-09-18',1,4,4001,5.000,'Mediodia',1,1,1,0,2022,9,18),(57572856,'2022-09-17',1,2,2007,12.000,'Menu hostal',1,1,1,0,2022,9,17),(57684997,'2022-09-12',1,2,2003,22.000,'',1,1,1,0,2022,9,12),(57685138,'2022-09-12',1,2,2005,10.000,'Cervezas y vino',1,1,1,0,2022,9,12),(57685439,'2022-09-10',1,2,2005,15.000,'',1,1,1,0,2022,9,10),(57685790,'2022-09-08',1,3,3001,50.000,'',1,1,1,0,2022,9,8),(57686201,'2022-09-05',1,2,2005,10.000,'Cervezas y vino',1,1,1,0,2022,9,5),(57686312,'2022-09-05',1,2,2003,10.000,'',1,1,1,0,2022,9,5),(57686773,'2022-08-30',1,2,2003,8.000,'',1,1,1,0,2022,8,30),(57686864,'2022-08-30',1,2,2005,15.000,'',1,1,1,0,2022,8,30),(57889655,'2022-09-19',1,2,2005,12.000,'',1,1,1,0,2022,9,19),(57889656,'2022-09-19',1,2,2005,12.000,'',1,1,1,0,2022,9,19),(57889817,'2022-09-19',1,4,4001,5.000,'Cervezas Arturo',1,1,1,0,2022,9,19),(57889818,'2022-09-19',1,4,4001,5.000,'Cervezas Arturo',1,1,1,0,2022,9,19),(57889990,'2022-09-19',1,1,1001,6.000,'Caja tabaco con Arturo',1,1,1,0,2022,9,19),(57889999,'2022-09-19',1,1,1001,6.000,'Caja tabaco con Arturo',1,1,1,0,2022,9,19),(59595171,'2022-09-21',1,1,1001,10.000,'Dos paquetes',1,1,1,0,2022,9,21),(59595492,'2022-09-21',1,2,2005,4.000,'Chino',1,1,1,0,2022,9,21),(59595893,'2022-09-21',1,4,4001,10.000,'Cervezas barrio (Andrea/Paco)',1,1,1,0,2022,9,21),(60928661,'2022-09-22',1,2,2005,8.000,'Chinos dos veces',1,1,1,0,2022,9,22),(67329801,'2022-09-18',1,1,1001,5.000,'Paquete',1,1,1,0,2022,9,18);
/*!40000 ALTER TABLE `MOVEMENTS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-23 12:56:48
