-- =================================================================
-- SCRIPT PARA EJERCICIO 2: ABM DE PAÍSES Y CIUDADES
-- =================================================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- CREACIÓN DE LA BASE DE DATOS Y USO DEL ESQUEMA
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `geography_db`;
CREATE DATABASE IF NOT EXISTS `geography_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `geography_db`;

-- -----------------------------------------------------
-- TABLA: `country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE IF NOT EXISTS `country` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `capital` VARCHAR(100) NULL,
    `language` VARCHAR(50) NULL,
    `surface` DECIMAL(15,2) NULL,
    `population` BIGINT UNSIGNED NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- TABLA: `city` 
-- -----------------------------------------------------
DROP TABLE IF EXISTS `city`;
CREATE TABLE IF NOT EXISTS `city` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, -- Clave primaria de la ciudad
    `id_country` INT UNSIGNED NOT NULL,        -- Clave foránea que relaciona con el país
    `name` VARCHAR(100) NOT NULL,
    `population` BIGINT UNSIGNED NOT NULL,        
    `surface` DECIMAL(10,2) NOT NULL,         
    `postal_code` VARCHAR(20) NULL,     
    `is_coastal` BOOLEAN NOT NULL,    
    PRIMARY KEY (`id`),
    UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
    INDEX `fk_city_country_idx` (`id_country` ASC) VISIBLE,
    CONSTRAINT `fk_city_country`
        FOREIGN KEY (`id_country`)
        REFERENCES `country` (`id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- DATOS DE PRUEBA
-- -----------------------------------------------------
INSERT INTO `country`(`name`, `capital`, `language`, `surface`, `population`) VALUES
("Argentina", "Buenos Aires", "Spanish", 2780400.00, 46000000),
("Brazil", "Brasília", "Portuguese", 8516000.00, 213000000),
("France", "Paris", "French", 551695.00, 68000000),
("Japan", "Tokyo", "Japanese", 377975.00, 125000000),
("Canada", "Ottawa", "English/French", 9984670.00, 39000000);

INSERT INTO `city`(`id_country`, `name`, `population`, `surface`, `postal_code`, `is_coastal`) VALUES
-- Argentina (id: 1)
(1, "Buenos Aires", 15000000, 203.00, "C1000", TRUE),
(1, "Córdoba", 1600000, 576.00, "X5000", FALSE),
(1, "Mar del Plata", 650000, 79.50, "B7600", TRUE),
-- Brazil (id: 2)
(2, "São Paulo", 22000000, 1521.00, "01000-000", FALSE),
(2, "Rio de Janeiro", 6700000, 1200.00, "20000-000", TRUE),
-- France (id: 3)
(3, "Paris", 11000000, 105.00, "75000", FALSE),
(3, "Marseille", 870000, 240.00, "13000", TRUE),
-- Japan (id: 4)
(4, "Tokyo", 37000000, 2194.00, "100-0001", TRUE),
(4, "Osaka", 2700000, 225.00, "530-0001", TRUE),
-- Canada (id: 5)
(5, "Toronto", 3000000, 630.00, "M5V 2T6", FALSE),
(5, "Vancouver", 675000, 115.00, "V6B 3H7", TRUE);

-- -----------------------------------------------------
-- ELIMINACIÓN DE PROCEDIMIENTOS SI EXISTEN (Para facilitar la re-ejecución)
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS country_create;
DROP PROCEDURE IF EXISTS country_read_by_id;
DROP PROCEDURE IF EXISTS country_read_by_name;
DROP PROCEDURE IF EXISTS country_update;

DROP PROCEDURE IF EXISTS delete_country;
DROP PROCEDURE IF EXISTS city_create;
DROP PROCEDURE IF EXISTS city_read_by_id;
DROP PROCEDURE IF EXISTS city_read_by_name;
DROP PROCEDURE IF EXISTS city_read_by_country;
DROP PROCEDURE IF EXISTS city_update;
DROP PROCEDURE IF EXISTS city_delete;
DROP PROCEDURE IF EXISTS get_country_of_most_populous_city;
DROP PROCEDURE IF EXISTS get_countries_with_coastal_cities_over_1m;
DROP PROCEDURE IF EXISTS get_city_with_highest_population_density;



-- -----------------------------------------------------
-- PROCEDIMIENTOS ALMACENADOS ABM PARA `country` (mejorados)
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE country_create(
    IN p_name VARCHAR(100),
    IN p_capital VARCHAR(100),
    IN p_language VARCHAR(50),
    IN p_surface DECIMAL(15,2),
    IN p_population BIGINT UNSIGNED
)
BEGIN
    INSERT INTO `country`(`name`, `capital`, `language`, `surface`, `population`)
    VALUES (p_name, p_capital, p_language, p_surface, p_population);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE country_read_by_id(
    IN p_id INT UNSIGNED
)
BEGIN
    SELECT * FROM `country` WHERE `id` = p_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE country_read_by_name(
    IN p_name VARCHAR(100)
)
BEGIN
    SELECT * FROM `country` WHERE `name` = p_name;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE country_update(
    IN p_id INT UNSIGNED,
    IN p_name VARCHAR(100),
    IN p_capital VARCHAR(100),
    IN p_language VARCHAR(50),
    IN p_surface DECIMAL(15,2),
    IN p_population BIGINT UNSIGNED
)
BEGIN
    UPDATE `country`
    SET `name` = p_name,
        `capital` = p_capital,
        `language` = p_language,
        `surface` = p_surface,
        `population` = p_population
    WHERE `id` = p_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE country_delete(
    IN p_id INT UNSIGNED
)
BEGIN
    DELETE FROM `country` WHERE `id` = p_id;
END $$
DELIMITER ;



-- -----------------------------------------------------
-- PROCEDIMIENTOS ALMACENADOS ABM PARA `city` (mejorados)
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE city_create(
    IN p_id_country INT UNSIGNED,
    IN p_name VARCHAR(100),
    IN p_population BIGINT UNSIGNED,
    IN p_surface DECIMAL(10,2),
    IN p_postal_code VARCHAR(20),
    IN p_is_coastal BOOLEAN
)
BEGIN
    INSERT INTO `city`(`id_country`, `name`, `population`, `surface`, `postal_code`, `is_coastal`)
    VALUES (p_id_country, p_name, p_population, p_surface, p_postal_code, p_is_coastal);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE city_read_by_id(
    IN p_id INT UNSIGNED
)
BEGIN
    SELECT ci.*, co.name AS country_name
    FROM `city` ci
    JOIN `country` co ON ci.id_country = co.id
    WHERE ci.id = p_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE city_read_by_name(
    IN p_name VARCHAR(100)
)
BEGIN
    SELECT ci.*, co.name AS country_name
    FROM `city` ci
    JOIN `country` co ON ci.id_country = co.id
    WHERE ci.name = p_name;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE city_read_by_country(
    IN p_id_country INT UNSIGNED
)
BEGIN
    SELECT ci.*, co.name AS country_name
    FROM `city` ci
    JOIN `country` co ON ci.id_country = co.id
    WHERE ci.id_country = p_id_country;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE city_update(
    IN p_id INT UNSIGNED,
    IN p_name VARCHAR(100),
    IN p_population BIGINT UNSIGNED,
    IN p_surface DECIMAL(10,2),
    IN p_postal_code VARCHAR(20),
    IN p_is_coastal BOOLEAN
)
BEGIN
    UPDATE `city`
    SET `name` = p_name,
        `population` = p_population,
        `surface` = p_surface,
        `postal_code` = p_postal_code,
        `is_coastal` = p_is_coastal
    WHERE `id` = p_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE city_delete(
    IN p_id INT UNSIGNED
)
BEGIN
    DELETE FROM `city` WHERE `id` = p_id;
END $$
DELIMITER ;



-- -----------------------------------------------------
-- PROCEDIMIENTOS ESPECIALES (REPORTES)
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE report_country_of_most_populous_city()
BEGIN
    SELECT co.name AS country_name
    FROM `country` co
    JOIN `city` ci ON co.id = ci.id_country
    ORDER BY ci.population DESC
    LIMIT 1;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE report_countries_with_large_coastal_cities()
BEGIN
    SELECT DISTINCT co.name AS country_name
    FROM `country` co
    JOIN `city` ci ON co.id = ci.id_country
    WHERE ci.is_coastal = TRUE AND ci.population > 1000000;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE report_city_with_highest_density()
BEGIN
    SELECT co.name AS country_name, ci.name AS city_name,
           (ci.population / ci.surface) AS population_density
    FROM `city` ci
    JOIN `country` co ON ci.id_country = co.id
    WHERE ci.surface > 0
    ORDER BY population_density DESC
    LIMIT 1;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- RESTAURAR CONFIGURACIONES
-- -----------------------------------------------------
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
