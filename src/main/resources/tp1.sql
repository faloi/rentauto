CREATE DATABASE `tpepers` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci */;
CREATE TABLE `usuario` (
  `username` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `passwd` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `apellido` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `nacimiento` date DEFAULT NULL,
  `cod_verif` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `validado` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`username`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  UNIQUE KEY `apellido_UNIQUE` (`apellido`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `validado_UNIQUE` (`validado`),
  UNIQUE KEY `cod_verif_UNIQUE` (`cod_verif`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;
