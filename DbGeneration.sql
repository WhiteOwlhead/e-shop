DROP schema if exists `eshopdb`;

CREATE SCHEMA IF NOT EXISTS `eshopdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `eshopdb` ;

-- -----------------------------------------------------
-- Table `eshopdb`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`category` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`category` (
  `category_ID` TINYINT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NULL DEFAULT NULL,
  `category_description` VARCHAR(145) NULL DEFAULT NULL,
  PRIMARY KEY (`category_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`role` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`role` (
  `role_ID` TINYINT NOT NULL AUTO_INCREMENT, 
  `role_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(145) NULL DEFAULT NULL,
  PRIMARY KEY (`role_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`user` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`user` (
  `user_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(145) NOT NULL,
  `surname` VARCHAR(145) NOT NULL,
  `phone` VARCHAR(145) NULL DEFAULT NULL,
  `login` VARCHAR(145) NOT NULL,
  `password` VARCHAR(145) NOT NULL,
  `email` VARCHAR(145) NOT NULL,
  `user_role` TINYINT NULL,
  PRIMARY KEY (`user_ID`),
  CONSTRAINT `role`
    FOREIGN KEY (`user_role`)
    REFERENCES `eshopdb`.`role` (`role_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`address` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`address` (
  `address_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(145) NULL DEFAULT NULL,
  `city` VARCHAR(145) NULL DEFAULT NULL,
  `street` VARCHAR(145) NULL DEFAULT NULL,
  `state` VARCHAR(145) NULL DEFAULT NULL,
  `postal_code` VARCHAR(145) NULL DEFAULT NULL,
  `user` BIGINT NOT NULL,
  PRIMARY KEY (`address_ID`),
  CONSTRAINT `fk_User_Addresses`
    FOREIGN KEY (`user`)
    REFERENCES `eshopdb`.`user` (`user_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`producer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`producer` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`producer` (
  `producer_ID` INT NOT NULL AUTO_INCREMENT,
  `producer_name` VARCHAR(45) NULL DEFAULT NULL,
  `producer_country` VARCHAR(145) NULL DEFAULT NULL,
  PRIMARY KEY (`producer_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`item` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`item` (
  `item_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `item_name` VARCHAR(90) NOT NULL,
  `category` TINYINT NOT NULL,
  `in_stock` TINYINT NOT NULL,
  `producer` INT NULL,
  `item_price` DECIMAL NULL,
  PRIMARY KEY (`item_ID`),
  CONSTRAINT `producer`
    FOREIGN KEY (`producer`)
    REFERENCES `eshopdb`.`producer` (`producer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`delivery_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`delivery_type` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`delivery_type` (
  `delivery_ID` TINYINT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`delivery_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`cart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`cart` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`cart` (  
  `user` BIGINT NOT NULL,
  `item` BIGINT NOT NULL,
  `quantity` TINYINT NOT NULL,
  `price` DECIMAL NOT NULL,
  PRIMARY KEY (`user`, `item`),
  CONSTRAINT `user`
    FOREIGN KEY (`user`)
    REFERENCES `eshopdb`.`user` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `item`
    FOREIGN KEY (`item`)
    REFERENCES `eshopdb`.`item` (`item_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eshopdb`.`item_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`item_category` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`item_category` (
  `item` BIGINT NOT NULL,
  `category` TINYINT NOT NULL,
  PRIMARY KEY (`item`, `category`),
  CONSTRAINT `fk_Item`
    FOREIGN KEY (`item` )
    REFERENCES `eshopdb`.`item` (`item_ID`),
  CONSTRAINT `category`
    FOREIGN KEY (`category`)
    REFERENCES `eshopdb`.`category` (`category_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eshopdb`.`item_media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`item_media` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`item_media` (
  `item_media_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `item_media_path` VARCHAR(145) NOT NULL,
  `item` BIGINT NOT NULL,
  PRIMARY KEY (`item_media_ID`),
  CONSTRAINT `fk_Item_Media`
    FOREIGN KEY (`item`)
    REFERENCES `eshopdb`.`item` (`item_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`pay_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`pay_method` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`pay_method` (
  `paymethod_ID` TINYINT NOT NULL AUTO_INCREMENT,
  `pay_method_name` VARCHAR(20) NOT NULL,
  `pay_method_description` VARCHAR(145) NULL DEFAULT NULL,
  PRIMARY KEY (`paymethod_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`mail_notifications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`mail_notifications` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`mail_notifications` (
  `notification_ID` INT NOT NULL AUTO_INCREMENT,
  `body` VARCHAR(150) NOT NULL,
  `user_mail` VARCHAR(145) NOT NULL,
  `subject` VARCHAR(145) NULL DEFAULT NULL,
  `user` BIGINT NOT NULL,
  PRIMARY KEY (`notification_ID`),
  CONSTRAINT `fk_Mail_Notifications_Customer`
    FOREIGN KEY (`user`)
    REFERENCES `eshopdb`.`user` (`user_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eshopdb`.`status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`status` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`status` (
  `status_ID` TinyINT NOT NULL AUTO_INCREMENT,
  `status_description` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`status_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eshopdb`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`order` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`order` (
  `order_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL,
  `user` BIGINT NOT NULL,
  `delivery_type` TINYINT NOT NULL,
  `order_status` TINYINT NOT NULL,
  `payment` TINYINT NOT NULL,
  `total` DECIMAL NOT NULL,
  PRIMARY KEY (`order_ID`),
  CONSTRAINT `fk_Order_User`
    FOREIGN KEY (`user`)
    REFERENCES `eshopdb`.`user` (`user_ID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Order_Delivery_Types`
    FOREIGN KEY (`delivery_type`)
    REFERENCES `eshopdb`.`delivery_type` (`delivery_ID`),
  CONSTRAINT `fk_Order_Status`
    FOREIGN KEY (`order_status`)
    REFERENCES `eshopdb`.`status` (`status_ID`),
  CONSTRAINT `payment`
    FOREIGN KEY (`payment`)
    REFERENCES `eshopdb`.`pay_method` (`paymethod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eshopdb`.`order_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`order_item` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`order_item` (
  `order_ID` BIGINT NOT NULL UNIQUE,
  `item` BIGINT NOT NULL,
  `quantity` TINYINT NULL,
  `price` DECIMAL NULL,
  PRIMARY KEY (`order_ID`, `item`),
  CONSTRAINT `fk_Order_has_Item_Item`
    FOREIGN KEY (`item`)
    REFERENCES `eshopdb`.`item` (`item_ID`),
  CONSTRAINT `fk_Order_has_Item_Order`
    FOREIGN KEY (`order_ID`)
    REFERENCES `eshopdb`.`order` (`order_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eshopdb`.`order_messages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`order_messages` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`order_messages` (
  `order_message_ID` INT NOT NULL AUTO_INCREMENT,
  `order_message_text` VARCHAR(250) NOT NULL,
  `order_` BIGINT NOT NULL,
  `delivery_type` TINYINT NOT NULL,
  `customer` BIGINT NOT NULL,
  PRIMARY KEY (`order_message_ID`),
  CONSTRAINT `fk_Order_Messages_User`
    FOREIGN KEY (`customer`)
    REFERENCES `eshopdb`.`user` (`user_ID`),
  CONSTRAINT `fk_Order_Messages_Order`
    FOREIGN KEY (`order_` )
    REFERENCES `eshopdb`.`order` (`order_ID` ))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eshopdb`.`reviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `eshopdb`.`reviews` ;

CREATE TABLE IF NOT EXISTS `eshopdb`.`reviews` (
  `review_ID` INT NOT NULL AUTO_INCREMENT,
  `review_rating` SMALLINT NOT NULL,
  `review_description` VARCHAR(150) NULL DEFAULT NULL,
  `item` BIGINT NOT NULL,
  `user` BIGINT NOT NULL,
  PRIMARY KEY (`review_ID`),
  CONSTRAINT `fk_Reviews_Item1`
    FOREIGN KEY (`item`)
    REFERENCES `eshopdb`.`item` (`item_ID`),
  CONSTRAINT `user_review`
    FOREIGN KEY (`user`)
    REFERENCES `eshopdb`.`user` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;