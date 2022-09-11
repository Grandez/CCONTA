/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE IF NOT EXISTS `CCONTA_TEST` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `CCONTA_TEST`;

CREATE TABLE IF NOT EXISTS `ACCOUNTS` (
  `IDGROUP` bigint(20) NOT NULL,
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`IDGROUP`,`ID`),
  UNIQUE KEY `IDGROUP` (`IDGROUP`,`ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `ACCOUNTS` DISABLE KEYS */;
/*!40000 ALTER TABLE `ACCOUNTS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `BANKS` (
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `BANKS` DISABLE KEYS */;
/*!40000 ALTER TABLE `BANKS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `BUDGET` (
  `ID` bigint(20) NOT NULL,
  `AMOUNT` decimal(7,3) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `ONCE` tinyint(4) DEFAULT 0,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `BUDGET` DISABLE KEYS */;
/*!40000 ALTER TABLE `BUDGET` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `CARDS` (
  `IDBANK` bigint(20) NOT NULL,
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `CLOSE` tinyint(4) DEFAULT 0,
  `CHARGE` tinyint(4) DEFAULT 0,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDBANK` (`IDBANK`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `CARDS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CARDS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `EXPENSES` (
  `ID` bigint(20) NOT NULL,
  `ACCOUNT` bigint(20) NOT NULL,
  `METHOD` bigint(20) NOT NULL,
  `AMOUNT` decimal(7,3) NOT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `TYPE` tinyint(4) DEFAULT 0,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `ACCOUNT` (`ACCOUNT`,`METHOD`),
  KEY `ACCOUNT_2` (`ACCOUNT`,`TYPE`),
  KEY `SYNC` (`SYNC`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `EXPENSES` DISABLE KEYS */;
/*!40000 ALTER TABLE `EXPENSES` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `GROUPS` (
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `GROUPS` DISABLE KEYS */;
/*!40000 ALTER TABLE `GROUPS` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `INCOMES` (
  `ID` bigint(20) NOT NULL,
  `IDBANK` bigint(20) NOT NULL,
  `IDCARD` bigint(20) NOT NULL,
  `AMOUNT` decimal(7,3) NOT NULL,
  `NOTE` varchar(255) DEFAULT NULL,
  `TYPE` tinyint(4) DEFAULT 0,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDBANK` (`IDBANK`,`IDCARD`,`ID`),
  KEY `SYNC` (`SYNC`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `INCOMES` DISABLE KEYS */;
/*!40000 ALTER TABLE `INCOMES` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `TAGS` (
  `ID` bigint(20) NOT NULL,
  `TAG` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`,`TAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `TAGS` DISABLE KEYS */;
/*!40000 ALTER TABLE `TAGS` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
