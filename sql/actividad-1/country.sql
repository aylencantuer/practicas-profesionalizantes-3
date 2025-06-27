SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- CREACIÓN DE LA BASE DE DATOS Y TABLA
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `actividad-1`;
CREATE DATABASE IF NOT EXISTS `actividad-1` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `actividad-1`;

DROP TABLE IF EXISTS `country`;
CREATE TABLE IF NOT EXISTS `country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `capital` VARCHAR(45),
  `language` VARCHAR(45),
  `surface` FLOAT,
  `population` INT(15),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- DATOS DE PRUEBA
-- -----------------------------------------------------
INSERT INTO country(id, name, capital, language, surface, population) VALUES 
(1, "Argentina", "Buenos Aires", "Spanish", 2780400, 46000000),
(2, "Brazil", "Brasília", "Portuguese", 8516000, 213000000),
(3, "France", "Paris", "French", 551695, 68000000),
(4, "Japan", "Tokyo", "Japanese", 377975, 125000000),
(5, "Canada", "Ottawa", "English/French", 9984670, 39000000);

-- -----------------------------------------------------
-- ELIMINACIÓN DE PROCEDIMIENTOS SI EXISTEN
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS create_country;
DROP PROCEDURE IF EXISTS read_country;
DROP PROCEDURE IF EXISTS update_country;
DROP PROCEDURE IF EXISTS delete_country;

-- -----------------------------------------------------
-- PROCEDIMIENTO: CREAR PAÍS
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
    INSERT INTO country(name, capital, language, surface, population)
    VALUES (p_name, p_capital, p_language, p_surface, p_population);
END $$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO: LEER PAÍS
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE read_country(
    IN p_name VARCHAR(45)
)
BEGIN
    SELECT * FROM country WHERE name = p_name;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO: ACTUALIZAR PAÍS
-- -----------------------------------------------------
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
    UPDATE country
    SET name = p_name,
        capital = p_capital,
        language = p_language,
        surface = p_surface,
        population = p_population
    WHERE id = p_id;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDIMIENTO: ELIMINAR PAÍS
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE delete_country(
    IN p_id INT
)
BEGIN
    DELETE FROM country WHERE id = p_id;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- RESTAURAR CONFIGURACIONES
-- -----------------------------------------------------
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
