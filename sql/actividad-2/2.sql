SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- CREACIÓN DE LA BASE DE DATOS Y USO DEL ESQUEMA
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `actividad-1`;
CREATE DATABASE IF NOT EXISTS `actividad-1` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `actividad-1`;

-- -----------------------------------------------------
-- TABLA: `country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE IF NOT EXISTS `country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `capital` VARCHAR(45) NULL,
  `language` VARCHAR(45) NULL,
  `surface` FLOAT NULL,
  `population` INT(15) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- TABLA: `city` 
-- -----------------------------------------------------
DROP TABLE IF EXISTS `city`;
CREATE TABLE IF NOT EXISTS `city` (
  `id` INT NOT NULL AUTO_INCREMENT, -- Clave primaria de la ciudad
  `country_id` INT NOT NULL,        -- Clave foránea que relaciona con el país
  `name` VARCHAR(45) NOT NULL,
  `population` INT NOT NULL,        
  `surface` FLOAT NOT NULL,         
  `zip_code` VARCHAR(10) NULL,     
  `is_coastal` BOOLEAN NOT NULL,    
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_city_country_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_city_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- DATOS DE PRUEBA PARA `country`
-- -----------------------------------------------------
INSERT INTO `country`(`id`, `name`, `capital`, `language`, `surface`, `population`) VALUES
(1, "Argentina", "Buenos Aires", "Spanish", 2780400, 46000000),
(2, "Brazil", "Brasília", "Portuguese", 8516000, 213000000),
(3, "France", "Paris", "French", 551695, 68000000),
(4, "Japan", "Tokyo", "Japanese", 377975, 125000000),
(5, "Canada", "Ottawa", "English/French", 9984670, 39000000);

-- -----------------------------------------------------
-- DATOS DE PRUEBA PARA `city`
-- Incluye ciudades costeras con más de 1 millón de habitantes para probar los procedimientos
-- -----------------------------------------------------
INSERT INTO `city`(`country_id`, `name`, `population`, `surface`, `zip_code`, `is_coastal`) VALUES
-- Argentina
(1, "Buenos Aires", 15000000, 203, "C1000", TRUE),   -- Coastal, >1M
(1, "Córdoba", 1600000, 576, "X5000", FALSE),      -- Not coastal, >1M
(1, "Mar del Plata", 650000, 79.5, "B7600", TRUE),  -- Coastal, <1M
-- Brazil
(2, "São Paulo", 22000000, 1521, "01000-000", FALSE), -- Not coastal, >1M
(2, "Rio de Janeiro", 6700000, 1200, "20000-000", TRUE), -- Coastal, >1M
-- France
(3, "Paris", 11000000, 105, "75000", FALSE),       -- Not coastal, >1M
(3, "Marseille", 870000, 240, "13000", TRUE),      -- Coastal, <1M
-- Japan
(4, "Tokyo", 14000000, 2194, "100-0001", TRUE),    -- Coastal, >1M
(4, "Osaka", 2700000, 225, "530-0001", TRUE),      -- Coastal, >1M
-- Canada
(5, "Toronto", 3000000, 630, "M5V 2T6", FALSE),    -- Not coastal, >1M
(5, "Vancouver", 675000, 115, "V6B 3H7", TRUE);    -- Coastal, <1M

-- -----------------------------------------------------
-- ELIMINACIÓN DE PROCEDIMIENTOS SI EXISTEN (Para facilitar la re-ejecución)
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS country_create;
DROP PROCEDURE IF EXISTS country_read;
DROP PROCEDURE IF EXISTS country_update;
DROP PROCEDURE IF EXISTS country_delete;

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
-- PROCEDIMIENTOS ALMACENADOS PARA `country` (del ejercicio 1)
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE create_country(
    IN p_name VARCHAR(45),
    IN p_capital VARCHAR(45),
    IN p_language VARCHAR(45),
    IN p_surface FLOAT,
    IN p_population INT
)
BEGIN
    INSERT INTO `country`(`name`, `capital`, `language`, `surface`, `population`)
    VALUES (p_name, p_capital, p_language, p_surface, p_population);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE read_country(
    IN p_name VARCHAR(45)
)
BEGIN
    SELECT * FROM `country` WHERE `name` = p_name;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_country(
    IN p_id INT,
    IN p_name VARCHAR(45),
    IN p_capital VARCHAR(45),
    IN p_language VARCHAR(45),
    IN p_surface FLOAT,
    IN p_population INT
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
CREATE PROCEDURE delete_country(
    IN p_id INT
)
BEGIN
    DELETE FROM `country` WHERE `id` = p_id;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTOS ALMACENADOS ABM PARA `city`
-- -----------------------------------------------------

-- PROCEDIMIENTO: CREAR CIUDAD
DELIMITER $$
CREATE PROCEDURE city_create(
    IN p_country_id INT,
    IN p_name VARCHAR(45),
    IN p_population INT,
    IN p_surface FLOAT,
    IN p_zip_code VARCHAR(10),
    IN p_is_coastal BOOLEAN
)
BEGIN
    INSERT INTO `city`(`country_id`, `name`, `population`, `surface`, `zip_code`, `is_coastal`)
    VALUES (p_country_id, p_name, p_population, p_surface, p_zip_code, p_is_coastal);
END $$
DELIMITER ;

-- PROCEDIMIENTO: LEER CIUDAD POR ID
DELIMITER $$
CREATE PROCEDURE city_read_by_id(
    IN p_id INT
)
BEGIN
    SELECT c.*, co.name AS country_name
    FROM `city` c
    JOIN `country` co ON c.country_id = co.id
    WHERE c.id = p_id;
END $$
DELIMITER ;

-- PROCEDIMIENTO: LEER CIUDAD POR NOMBRE
DELIMITER $$
CREATE PROCEDURE city_read_by_name(
    IN p_name VARCHAR(45)
)
BEGIN
    SELECT c.*, co.name AS country_name
    FROM `city` c
    JOIN `country` co ON c.country_id = co.id
    WHERE c.name = p_name;
END $$
DELIMITER ;

-- PROCEDIMIENTO: LEER CIUDADES POR PAÍS
DELIMITER $$
CREATE PROCEDURE city_read_by_country(
    IN p_country_id INT
)
BEGIN
    SELECT c.*, co.name AS country_name
    FROM `city` c
    JOIN `country` co ON c.country_id = co.id
    WHERE c.country_id = p_country_id;
END $$
DELIMITER ;

-- PROCEDIMIENTO: ACTUALIZAR CIUDAD
DELIMITER $$
CREATE PROCEDURE city_update(
    IN p_id INT,
    IN p_name VARCHAR(45),
    IN p_population INT,
    IN p_surface FLOAT,
    IN p_zip_code VARCHAR(10),
    IN p_is_coastal BOOLEAN
)
BEGIN
    UPDATE `city`
    SET `name` = p_name,
        `population` = p_population,
        `surface` = p_surface,
        `zip_code` = p_zip_code,
        `is_coastal` = p_is_coastal
    WHERE `id` = p_id;
END $$
DELIMITER ;

-- PROCEDIMIENTO: ELIMINAR CIUDAD
DELIMITER $$
CREATE PROCEDURE city_delete(
    IN p_id INT
)
BEGIN
    DELETE FROM `city` WHERE `id` = p_id;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTOS NUEVOS
-- -----------------------------------------------------

-- PROCEDIMIENTO: Mostrar el nombre del país que tiene la ciudad más poblada registrada en la base de datos.
-- Si hay varias ciudades con la misma población máxima, mostrará el país de cada una de ellas.
DELIMITER $$
CREATE PROCEDURE get_country_of_most_populous_city()
BEGIN
    SELECT DISTINCT co.name AS country_name, c.name AS city_name, c.population
    FROM `city` c
    JOIN `country` co ON c.country_id = co.id
    WHERE c.population = (SELECT MAX(population) FROM `city`);
END $$
DELIMITER ;

-- PROCEDIMIENTO: Obtener el conjunto de países que poseen ciudades costeras con más de 1 millón de habitantes.
DELIMITER $$
CREATE PROCEDURE get_countries_with_coastal_cities_over_1m()
BEGIN
    SELECT DISTINCT co.name AS country_name
    FROM `country` co
    JOIN `city` c ON co.id = c.country_id
    WHERE c.is_coastal = TRUE AND c.population > 1000000;
END $$
DELIMITER ;

-- PROCEDIMIENTO: Obtener el país y el nombre de la ciudad que posee la ciudad con la densidad de población más alta.
-- (Densidad de población: Habitantes/Km^2)
DELIMITER $$
CREATE PROCEDURE get_city_with_highest_population_density()
BEGIN
    SELECT co.name AS country_name, c.name AS city_name,
           (c.population / c.surface) AS population_density
    FROM `city` c
    JOIN `country` co ON c.country_id = co.id
    WHERE c.surface > 0 -- Evitar división por cero
    ORDER BY (c.population / c.surface) DESC
    LIMIT 1; -- Limitar a la ciudad con la densidad más alta. Si existe mas de una, solo una se mostrará.
END $$
DELIMITER ;

-- -----------------------------------------------------
-- RESTAURAR CONFIGURACIONES
-- -----------------------------------------------------
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
