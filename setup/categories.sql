/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

DROP TABLE IF EXISTS `CATEGORIES`;
CREATE TABLE IF NOT EXISTS `CATEGORIES` (
  `IDGROUP` int(11) NOT NULL,
  `ID` int(10) unsigned NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCR` text DEFAULT NULL,
  `ACTIVE` tinyint(4) DEFAULT 1,
  `SYNC` tinyint(4) DEFAULT 0,
  `INCOME` tinyint(4) DEFAULT NULL,
  `EXPENSE` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`IDGROUP`,`ID`),
  UNIQUE KEY `IDGROUP` (`IDGROUP`,`ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `CATEGORIES` DISABLE KEYS */;
INSERT INTO `CATEGORIES` (`IDGROUP`, `ID`, `NAME`, `DESCR`, `ACTIVE`, `SYNC`, `INCOME`, `EXPENSE`) VALUES
	(1, 1001, 'Tabaco', NULL, 1, 0, 0, 1),
	(1, 2998, 'Otros', NULL, 1, 0, 0, 1),
	(1, 2999, 'Imprevistos', NULL, 1, 0, 0, 1),
	(2, 2001, 'Alquiler', NULL, 1, 0, 0, 1),
	(2, 2002, 'Gastos', NULL, 1, 0, 0, 1),
	(2, 2003, 'Comida', NULL, 1, 0, 0, 1),
	(2, 2004, 'Limpieza', NULL, 1, 0, 0, 1),
	(2, 2998, 'Otros', NULL, 1, 0, 0, 1),
	(2, 2999, 'Imprevistos', NULL, 1, 0, 0, 1),
	(3, 3001, 'Carburante', NULL, 1, 0, 0, 1),
	(3, 3002, 'Seguro', NULL, 1, 0, 0, 1),
	(3, 3003, 'Mantenimiento', NULL, 1, 0, 0, 1),
	(3, 3004, 'Taxis', NULL, 1, 0, 0, 1),
	(3, 3005, 'Publico', NULL, 1, 0, 0, 1),
	(3, 3998, 'Otros', NULL, 1, 0, 0, 1),
	(3, 3999, 'Imprevistos', NULL, 1, 0, 0, 1),
	(4, 4001, 'Copas', NULL, 1, 0, 0, 1),
	(4, 4002, 'Comidas', NULL, 1, 0, 0, 1),
	(4, 4003, 'Espectaculos', NULL, 1, 0, 0, 1),
	(4, 4998, 'Otros', NULL, 1, 0, 0, 1),
	(4, 4999, 'Imprevistos', NULL, 1, 0, 0, 1),
	(5, 5001, 'Medicinas', NULL, 1, 0, 0, 1),
	(5, 5002, 'Seguros', NULL, 1, 0, 0, 1),
	(5, 5003, 'Medicos', NULL, 1, 0, 0, 1),
	(5, 5998, 'Otros', NULL, 1, 0, 0, 1),
	(5, 5999, 'Imprevistos', NULL, 1, 0, 0, 1),
	(6, 6001, 'Matriculas', NULL, 1, 0, 0, 1),
	(6, 6002, 'Libros', NULL, 1, 0, 0, 1),
	(6, 6003, 'Cursos', NULL, 1, 0, 0, 1),
	(6, 6998, 'Otros', NULL, 1, 0, 0, 1),
	(6, 6999, 'Imprevistos', NULL, 1, 0, 0, 1),
	(101, 1001, 'Nomina', NULL, 1, 0, 1, 0),
	(101, 1002, 'Dietas', NULL, 1, 0, 1, 0),
	(101, 1003, 'Bonos', NULL, 1, 0, 1, 0),
	(101, 1998, 'Otros', NULL, 1, 0, 1, 0),
	(101, 1999, 'Imprevistos', NULL, 1, 0, 1, 0),
	(102, 2001, 'Intereses', NULL, 1, 0, 1, 0),
	(102, 2998, 'Otros', NULL, 1, 0, 1, 0),
	(102, 2999, 'Imprevistos', NULL, 1, 0, 1, 0);
/*!40000 ALTER TABLE `CATEGORIES` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
