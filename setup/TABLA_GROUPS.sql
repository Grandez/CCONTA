/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE IF NOT EXISTS `CCONTA` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `CCONTA`;

DROP TABLE IF EXISTS `GROUPS`;
CREATE TABLE IF NOT EXISTS `GROUPS` (
  `ID` int(11) NOT NULL COMMENT 'Convencion: Neg = Ingreso / Pos = Gasto',
  `NAME` varchar(255) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `TYPE` tinyint(4) DEFAULT 0 COMMENT '-1 Ingresos / 1 Gastos',
  `SYNC` tinyint(4) DEFAULT 0,
  `INCOME` tinyint(4) DEFAULT NULL,
  `EXPENSE` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `TYPE` (`TYPE`,`NAME`),
  KEY `TYPE_2` (`TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `GROUPS` DISABLE KEYS */;
INSERT INTO `GROUPS` (`ID`, `NAME`, `DESCR`, `ACTIVE`, `TYPE`, `SYNC`, `INCOME`, `EXPENSE`) VALUES
	(1, 'Personal', NULL, 1, 1, 0, 0, 1),
	(2, 'Hogar', NULL, 1, 1, 0, 0, 1),
	(3, 'Transporte', NULL, 1, 1, 0, 0, 1),
	(4, 'Ocio', NULL, 1, 1, 0, 0, 1),
	(5, 'Salud', NULL, 1, 1, 0, 0, 1),
	(6, 'Formacion', NULL, 1, 1, 0, 0, 1),
	(101, 'Trabajo', NULL, 1, -1, 0, 1, 0),
	(102, 'Bancos', NULL, 1, -1, 0, 1, 0);
/*!40000 ALTER TABLE `GROUPS` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
