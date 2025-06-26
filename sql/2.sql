-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema actividad-1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema actividad-1
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `actividad-1` ;
CREATE SCHEMA IF NOT EXISTS `actividad-1` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `actividad-1` ;

-- -----------------------------------------------------
-- Table `actividad-1`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `actividad-1`.`country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `capital` VARCHAR(45) NULL,
  `language` VARCHAR(45) NULL,
  `surface` FLOAT NULL,
  `population` INT(15) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;

USE `actividad-1`;

INSERT INTO country(id, name, capital, language, surface, population) VALUES 
(1, "Argentina", "Buenos Aires", "Spanish", 2780400, 46000000),
(2, "Brazil", "Brasília", "Portuguese", 8516000, 213000000),
(3, "France", "Paris", "French", 551695, 68000000),
(4, "Japan", "Tokyo", "Japanese", 377975, 125000000),
(5, "Canada", "Ottawa", "English/French", 9984670, 39000000);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
