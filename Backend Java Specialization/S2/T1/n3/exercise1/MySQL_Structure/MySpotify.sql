-- MySQL Script generated by MySQL Workbench
-- Thu Feb 22 23:14:48 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema MySpotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema MySpotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `MySpotify` DEFAULT CHARACTER SET utf8 ;
USE `MySpotify` ;

-- -----------------------------------------------------
-- Table `MySpotify`.`countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`countries` (
  `idcountries` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcountries`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`postalcodes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`postalcodes` (
  `idpostalcodes` INT NOT NULL AUTO_INCREMENT,
  `postalcode` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idpostalcodes`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`users` (
  `idusers` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `birthdate` DATE NOT NULL,
  `gender` ENUM("M", "F", "O") NOT NULL COMMENT 'O = other.',
  `country_id` INT NOT NULL,
  `postalcode_id` INT NOT NULL,
  `subscription_id` INT NULL,
  PRIMARY KEY (`idusers`),
  INDEX `country_id_idx` (`country_id` ASC) VISIBLE,
  INDEX `postalcode_id_idx` (`postalcode_id` ASC) VISIBLE,
  CONSTRAINT `country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `MySpotify`.`countries` (`idcountries`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `postalcode_id`
    FOREIGN KEY (`postalcode_id`)
    REFERENCES `MySpotify`.`postalcodes` (`idpostalcodes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`payments` (
  `idpayments` INT NOT NULL AUTO_INCREMENT,
  `type` ENUM("paypal", "credit") NOT NULL,
  `card_number_hash` VARCHAR(45) NULL,
  `card_expiry_date` DATE NULL,
  `paypal_username` VARCHAR(45) NULL,
  PRIMARY KEY (`idpayments`),
  UNIQUE INDEX `idpayments_UNIQUE` (`idpayments` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`subscriptions` (
  `idsubscriptions` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `renewal_date` DATE NOT NULL,
  `payment_information_id` INT NOT NULL,
  PRIMARY KEY (`idsubscriptions`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  INDEX `paymentinformation_id_idx` (`payment_information_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `MySpotify`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `paymentinformation_id`
    FOREIGN KEY (`payment_information_id`)
    REFERENCES `MySpotify`.`payments` (`idpayments`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`payment_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`payment_records` (
  `idpayment_records` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `price_total` DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (`idpayment_records`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `idpayment_records_UNIQUE` (`idpayment_records` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `MySpotify`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `payment_id`
    FOREIGN KEY (`idpayment_records`)
    REFERENCES `MySpotify`.`payments` (`idpayments`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`playlists` (
  `idplaylists` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `song_number` SMALLINT UNSIGNED NOT NULL,
  `creation_date` DATE NOT NULL,
  `playlistscol` VARCHAR(45) NOT NULL,
  `state` ENUM("active", "deleted") NOT NULL,
  `deleted_date` DATE NULL,
  `owner_id` INT NOT NULL,
  PRIMARY KEY (`idplaylists`),
  INDEX `owner_id_idx` (`owner_id` ASC) VISIBLE,
  CONSTRAINT `owner_id`
    FOREIGN KEY (`owner_id`)
    REFERENCES `MySpotify`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`shared_playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`shared_playlists` (
  `idshared_playlists` INT NOT NULL AUTO_INCREMENT,
  `song_id` INT NOT NULL,
  `adder_id` INT NOT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`idshared_playlists`),
  INDEX `adder_id_idx` (`adder_id` ASC) VISIBLE,
  CONSTRAINT `sharedlist_id`
    FOREIGN KEY (`idshared_playlists`)
    REFERENCES `MySpotify`.`playlists` (`idplaylists`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `adder_id`
    FOREIGN KEY (`adder_id`)
    REFERENCES `MySpotify`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`artists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`artists` (
  `idartists` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `image` VARCHAR(45) NOT NULL COMMENT 'Paste the link here.',
  `theme` VARCHAR(45) NOT NULL COMMENT 'Index to relate artists who make similar music',
  PRIMARY KEY (`idartists`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`albums`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`albums` (
  `idalbums` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `artist_id` INT NOT NULL,
  `publication_date` DATE NOT NULL,
  PRIMARY KEY (`idalbums`),
  UNIQUE INDEX `name_UNIQUE` (`title` ASC) VISIBLE,
  UNIQUE INDEX `album_artists_idx` () VISIBLE,
  INDEX `artist_id_idx` (`artist_id` ASC) VISIBLE,
  CONSTRAINT `artist_id`
    FOREIGN KEY (`artist_id`)
    REFERENCES `MySpotify`.`artists` (`idartists`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`songs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`songs` (
  `idsongs` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `album_id` INT NOT NULL,
  `duration` TIME NOT NULL,
  `reproductions` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idsongs`),
  UNIQUE INDEX `name_UNIQUE` (`title` ASC) VISIBLE,
  UNIQUE INDEX `song_album_limiter` (`title` ASC, `album_id` ASC) VISIBLE,
  INDEX `album_id_idx` (`album_id` ASC) VISIBLE,
  CONSTRAINT `album_id`
    FOREIGN KEY (`album_id`)
    REFERENCES `MySpotify`.`albums` (`idalbums`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`follows`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`follows` (
  `idfollows` INT NOT NULL AUTO_INCREMENT,
  `follower_id` INT NOT NULL,
  `followed_id` INT NOT NULL,
  PRIMARY KEY (`idfollows`),
  INDEX `follower_id_idx` (`follower_id` ASC) VISIBLE,
  INDEX `followed_id_idx` (`followed_id` ASC) VISIBLE,
  CONSTRAINT `follower_id`
    FOREIGN KEY (`follower_id`)
    REFERENCES `MySpotify`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `followed_id`
    FOREIGN KEY (`followed_id`)
    REFERENCES `MySpotify`.`artists` (`idartists`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MySpotify`.`favorites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MySpotify`.`favorites` (
  `idfavorites` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `media_id` INT NOT NULL,
  PRIMARY KEY (`idfavorites`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `media_id_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `MySpotify`.`users` (`idusers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `media_id`
    FOREIGN KEY (`media_id`)
    REFERENCES `MySpotify`.`songs` (`idsongs`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `media_id2`
    FOREIGN KEY (`media_id`)
    REFERENCES `MySpotify`.`albums` (`idalbums`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
