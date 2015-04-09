DROP DATABASE IF EXISTS `tpepers`;
CREATE DATABASE `tpepers`;
CREATE TABLE `tpepers`.`usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `apellido` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nacimiento` date DEFAULT NULL,
  `codigo_validacion` varchar(255) DEFAULT NULL,
  `is_validado` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;
