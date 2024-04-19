CREATE DATABASE  IF NOT EXISTS `fpms` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `fpms`;
-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (x86_64)
--
-- Host: 127.0.0.1    Database: fpms
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `account_balance` decimal(15,2) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,8500.00,1),(2,5000.00,2),(3,7500.00,3);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_data`
--

DROP TABLE IF EXISTS `market_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `market_data` (
  `data_id` int NOT NULL AUTO_INCREMENT,
  `security_id` int NOT NULL,
  `date` date NOT NULL,
  `market_price` decimal(15,2) NOT NULL,
  PRIMARY KEY (`data_id`),
  KEY `security_id` (`security_id`),
  CONSTRAINT `market_data_ibfk_1` FOREIGN KEY (`security_id`) REFERENCES `security` (`security_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_data`
--

LOCK TABLES `market_data` WRITE;
/*!40000 ALTER TABLE `market_data` DISABLE KEYS */;
INSERT INTO `market_data` VALUES (1,1,'2024-04-01',150.00),(2,2,'2024-04-01',2000.00),(3,3,'2024-04-01',300.00);
/*!40000 ALTER TABLE `market_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `notification_message` varchar(255) NOT NULL,
  `transaction_id` int NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `transaction_id` (`transaction_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`transaction_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,'Notification message 1',1),(2,'Notification message 2',2),(3,'Notification message 3',3);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_holding`
--

DROP TABLE IF EXISTS `portfolio_holding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_holding` (
  `portfolio_id` int NOT NULL AUTO_INCREMENT,
  `portfolio_name` varchar(255) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`portfolio_id`),
  UNIQUE KEY `portfolio_name` (`portfolio_name`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `portfolio_holding_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_holding`
--

LOCK TABLES `portfolio_holding` WRITE;
/*!40000 ALTER TABLE `portfolio_holding` DISABLE KEYS */;
INSERT INTO `portfolio_holding` VALUES (1,'Portfolio 1',1),(2,'Portfolio 2',2),(3,'Portfolio 3',3);
/*!40000 ALTER TABLE `portfolio_holding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security`
--

DROP TABLE IF EXISTS `security`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security` (
  `security_id` int NOT NULL AUTO_INCREMENT,
  `security_name` varchar(255) NOT NULL,
  `security_type` varchar(50) NOT NULL,
  `watchlist_id` int DEFAULT NULL,
  PRIMARY KEY (`security_id`),
  KEY `FK_security_watchlist` (`watchlist_id`),
  CONSTRAINT `FK_security_watchlist` FOREIGN KEY (`watchlist_id`) REFERENCES `watchlist` (`watchlist_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security`
--

LOCK TABLES `security` WRITE;
/*!40000 ALTER TABLE `security` DISABLE KEYS */;
INSERT INTO `security` VALUES (1,'AAPL','Stock',1),(2,'GOOGL','Stock',2),(3,'MSFT','Stock',3);
/*!40000 ALTER TABLE `security` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_in_portfolio`
--

DROP TABLE IF EXISTS `security_in_portfolio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_in_portfolio` (
  `security_id` int NOT NULL,
  `portfolio_id` int NOT NULL,
  `quantity` int NOT NULL,
  `cost_base` decimal(15,2) NOT NULL,
  `market_value` decimal(15,2) NOT NULL,
  `gain_loss` decimal(15,2) NOT NULL,
  PRIMARY KEY (`security_id`,`portfolio_id`),
  KEY `portfolio_id` (`portfolio_id`),
  CONSTRAINT `security_in_portfolio_ibfk_1` FOREIGN KEY (`security_id`) REFERENCES `security` (`security_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_in_portfolio_ibfk_2` FOREIGN KEY (`portfolio_id`) REFERENCES `portfolio_holding` (`portfolio_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_in_portfolio`
--

LOCK TABLES `security_in_portfolio` WRITE;
/*!40000 ALTER TABLE `security_in_portfolio` DISABLE KEYS */;
INSERT INTO `security_in_portfolio` VALUES (1,1,110,16500.00,18000.00,0.00),(2,2,50,100000.00,100000.00,0.00),(3,3,200,60000.00,60000.00,0.00);
/*!40000 ALTER TABLE `security_in_portfolio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `transaction_date` date NOT NULL,
  `transaction_type` varchar(50) NOT NULL,
  `transaction_amount` decimal(15,2) NOT NULL,
  `security_id` int DEFAULT '0',
  PRIMARY KEY (`transaction_id`),
  KEY `security_id` (`security_id`),
  KEY `account_id` (`account_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`security_id`) REFERENCES `security` (`security_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT INTO `transaction` VALUES (1,1,'2024-04-01','Deposit',5000.00,1),(2,2,'2024-04-01','Withdraw',2500.00,2),(3,3,'2024-04-01','Deposit',10000.00,3),(4,1,'2024-04-18','Buy',1500.00,1);
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `watchlist_id` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `watchlist_id` (`watchlist_id`),
  CONSTRAINT `FK_user_watchlist` FOREIGN KEY (`watchlist_id`) REFERENCES `watchlist` (`watchlist_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'user1','user1@example.com','password1','2024-04-18 23:37:56',NULL),(2,'user2','user2@example.com','password2','2024-04-18 23:37:56',NULL),(3,'user3','user3@example.com','password3','2024-04-18 23:37:56',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watchlist`
--

DROP TABLE IF EXISTS `watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watchlist` (
  `watchlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `watchlist_name` varchar(255) NOT NULL,
  PRIMARY KEY (`watchlist_id`),
  UNIQUE KEY `watchlist_name` (`watchlist_name`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `watchlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchlist`
--

LOCK TABLES `watchlist` WRITE;
/*!40000 ALTER TABLE `watchlist` DISABLE KEYS */;
INSERT INTO `watchlist` VALUES (1,1,'Watchlist 1'),(2,2,'Watchlist 2'),(3,3,'Watchlist 3');
/*!40000 ALTER TABLE `watchlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'fpms'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_new_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_user`(IN p_name VARCHAR(255), IN p_email VARCHAR(255), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO user (user_name, email, password)
    VALUES (p_name, p_email, p_password);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_to_watchlist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_to_watchlist`(IN p_user_name VARCHAR(255), IN p_security_id INT)
BEGIN
    DECLARE v_watchlist_id INT;

    -- Retrieve the user's watchlist_id
    SELECT watchlist_id INTO v_watchlist_id FROM user WHERE user_name = p_user_name;

    -- Check if the security is already in any watchlist
    IF (SELECT watchlist_id FROM security WHERE security_id = p_security_id) IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Security is already in a watchlist';
    ELSEIF v_watchlist_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not have a watchlist';
    ELSE
        -- Assign the security to the user's watchlist
        UPDATE security
        SET watchlist_id = v_watchlist_id
        WHERE security_id = p_security_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_portfolios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_portfolios`(IN p_user_name VARCHAR(255))
BEGIN
    DECLARE v_user_id INT;

    -- Get the user_id for the provided user_name
    SELECT user_id INTO v_user_id FROM user WHERE user_name = p_user_name;

    -- Select all portfolios for the specified user
    SELECT p.portfolio_id,
           p.portfolio_name,
           COALESCE(SUM(sp.quantity), 0) AS total_quantity,
           sp.gain_loss
    FROM portfolio_holding p
    LEFT JOIN security_in_portfolio sp ON p.portfolio_id = sp.portfolio_id
    WHERE p.user_id = v_user_id
    GROUP BY p.portfolio_id, p.portfolio_name, sp.gain_loss;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_transactions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_transactions`(IN p_user_name VARCHAR(255))
BEGIN
    DECLARE v_user_id INT;

    -- Retrieve the user's ID based on the user's name
    SELECT user_id INTO v_user_id FROM user WHERE user_name = p_user_name;

    -- Check if the user exists
    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    ELSE
        -- Return all transactions associated with the user
        SELECT t.transaction_id, t.transaction_date, t.transaction_type, t.transaction_amount
        FROM transaction t
        JOIN account a ON t.account_id = a.account_id
        WHERE a.user_id = v_user_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `buy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy`(IN p_portfolio_id INT, IN p_security_id INT, IN p_quantity INT)
BEGIN
    DECLARE v_total_cost DECIMAL(10, 2);
    DECLARE v_account_balance DECIMAL(10, 2);
    DECLARE v_account_id INT;
    DECLARE v_existing_quantity INT;
    DECLARE v_market_price DECIMAL(10, 2);
    DECLARE v_latest_cost DECIMAL(10, 2); -- Variable to store the latest buy cost

    -- Fetch the latest market price for the security
    SELECT market_price INTO v_market_price
    FROM market_data
    WHERE security_id = p_security_id
    ORDER BY date DESC
    LIMIT 1;

    -- Calculate the total cost based on the current market price
    SET v_total_cost = p_quantity * v_market_price;

    -- Get the user's account balance and account ID based on the provided portfolio
    SELECT a.account_balance, a.account_id
    INTO v_account_balance, v_account_id
    FROM account a
    JOIN portfolio_holding ph ON a.user_id = ph.user_id
    WHERE ph.portfolio_id = p_portfolio_id;

    IF v_total_cost <= v_account_balance THEN
        -- Deduct the total cost from the user's account
        UPDATE account SET account_balance = account_balance - v_total_cost WHERE user_id = (SELECT user_id FROM portfolio_holding WHERE portfolio_id = p_portfolio_id);

        -- Check if the security is already in the portfolio
        SELECT quantity INTO v_existing_quantity
        FROM security_in_portfolio
        WHERE security_id = p_security_id AND portfolio_id = p_portfolio_id;

        IF v_existing_quantity IS NOT NULL THEN
            -- Update the existing record
            UPDATE security_in_portfolio
            SET 
                quantity = quantity + p_quantity,  -- Add the new quantity to the existing quantity
                cost_base = cost_base + v_total_cost, -- Update the cost base
                market_value = (quantity + p_quantity) * v_market_price  -- Update the market value
            WHERE security_id = p_security_id AND portfolio_id = p_portfolio_id;
        ELSE
            -- Insert a new record if not present
            INSERT INTO security_in_portfolio(security_id, portfolio_id, quantity, cost_base, market_value, gain_loss)
            VALUES(p_security_id, p_portfolio_id, p_quantity, v_total_cost / p_quantity, p_quantity * v_market_price, 0);
        END IF;

        -- Record the buy transaction
        INSERT INTO transaction(account_id, transaction_date, transaction_type, transaction_amount, security_id)
        VALUES (v_account_id, CURDATE(), 'Buy', v_total_cost, p_security_id);
    ELSE
        -- Raise an error if funds are insufficient
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds to complete transaction';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_balance`(IN p_user_name VARCHAR(255))
BEGIN
    SELECT a.account_id, a.account_balance
    FROM account a
    JOIN user u ON a.user_id = u.user_id
    WHERE u.user_name = p_user_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_withholding_security` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_withholding_security`(IN p_security_id INT, IN p_portfolio_id INT)
BEGIN
    SELECT *
    FROM security_in_portfolio
    WHERE security_id = p_security_id AND portfolio_id = p_portfolio_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_from_watchlist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_from_watchlist`(IN p_security_id INT)
BEGIN
    -- Check if the security is currently in a watchlist
    DECLARE v_watchlist_id INT;
    SELECT watchlist_id INTO v_watchlist_id FROM security WHERE security_id = p_security_id;

    IF v_watchlist_id IS NULL THEN
        -- If the security is not in any watchlist, raise an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Security is not in any watchlist';
    ELSE
        -- If the security is in a watchlist, remove it
        UPDATE security
        SET watchlist_id = NULL
        WHERE security_id = p_security_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deposit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deposit`(IN p_user_name VARCHAR(255), IN p_amount DECIMAL(15,2))
BEGIN
    DECLARE v_user_id INT;

    -- Retrieve the user's ID based on the user's name
    SELECT user_id INTO v_user_id FROM user WHERE user_name = p_user_name;

    -- Check if the user exists
    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    ELSE
        -- Perform the deposit operation
        UPDATE account 
        SET account_balance = account_balance + p_amount WHERE user_id = v_user_id;

        -- Insert the transaction record
        INSERT INTO transaction(account_id, transaction_date, transaction_type, transaction_amount, security_id)
        VALUES ((SELECT account_id FROM account WHERE user_id = v_user_id), CURDATE(), 'Deposit', p_amount, NULL);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_password`(IN p_username VARCHAR(255))
BEGIN
    SELECT password
    FROM user
    WHERE user_name = p_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `historical_price` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `historical_price`(IN p_security_id INT)
BEGIN
    SELECT data_id, date, market_price
    FROM market_data
    WHERE security_id = p_security_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_portfolio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_portfolio`(IN p_user_name VARCHAR(255))
BEGIN
    DECLARE v_user_id INT;
    
    -- Retrieve the user's user_id
    SELECT user_id INTO v_user_id FROM user WHERE user_name = p_user_name;
    
    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    ELSE
        -- Select all portfolios associated with the user
        SELECT sp.security_id,
               s.security_name,
               s.security_type,
               sp.quantity,
               sp.portfolio_id,
               sp.cost_base,
               sp.market_value,
               sp.gain_loss
        FROM security_in_portfolio sp
        JOIN security s ON sp.security_id = s.security_id
        WHERE sp.portfolio_id IN (SELECT portfolio_id FROM portfolio_holding WHERE user_id = v_user_id);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_security` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_security`(IN p_security_id INT)
BEGIN
    -- Check if the security exists
    DECLARE security_count INT;
    SELECT COUNT(*) INTO security_count FROM security WHERE security_id = p_security_id;

    -- Handling based on the count of securities found
    IF security_count = 1 THEN
        -- Fetch and return details for the uniquely identified security
        SELECT 
            s.security_id,
            s.security_name,
            s.security_type,
            IFNULL(sp.quantity, 'NA') AS quantity,
            IFNULL(sp.portfolio_id, 'NA') AS portfolio_id,
            IFNULL(sp.cost_base, 'NA') AS cost_base,
            IFNULL(sp.market_value, (SELECT market_price FROM market_data WHERE security_id = s.security_id ORDER BY date DESC LIMIT 1)) AS market_value,
            IFNULL(sp.gain_loss, 'NA') AS gain_loss
        FROM 
            security s
            LEFT JOIN security_in_portfolio sp ON s.security_id = sp.security_id
        WHERE 
            s.security_id = p_security_id;
    ELSEIF security_count = 0 THEN
        -- No security found with the given ID
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No security found with the provided ID.';
    ELSE
        -- Multiple securities found with the same ID (should not happen)
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Multiple securities found with the provided ID, please specify a unique ID.';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_transaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_transaction`(IN p_transaction_id INT)
BEGIN
    SELECT 
        t.transaction_id, 
        t.transaction_date, 
        t.transaction_type, 
        t.transaction_amount,
        s.security_name, 
        s.security_id, 
        s.security_type
    FROM 
        transaction t
    LEFT JOIN 
        security s ON t.security_id = s.security_id
    WHERE 
        t.transaction_id = p_transaction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sell` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sell`(IN p_portfolio_id INT, IN p_security_id INT, IN p_quantity INT)
BEGIN
    DECLARE v_price DECIMAL(10, 2);
    DECLARE v_total_revenue DECIMAL(10, 2);
    DECLARE v_quantity INT;
    DECLARE v_account_id INT;
    DECLARE v_cost_base_price DECIMAL(10, 2);

    -- Fetch the latest market price for the security
    SELECT market_price INTO v_price
    FROM market_data
    WHERE security_id = p_security_id
    ORDER BY date DESC
    LIMIT 1;

    -- Calculate the total revenue from the sale
    SET v_total_revenue = p_quantity * v_price;

    -- Calculate the average cost basis per hare using FIFO
    SELECT AVG(cost_base / quantity) INTO v_cost_base_price
    FROM security_in_portfolio
    WHERE portfolio_id = p_portfolio_id AND security_id = p_security_id;

    -- Retrieve the current quantity held in the portfolio
    SELECT quantity INTO v_quantity
    FROM security_in_portfolio
    WHERE security_id = p_security_id AND portfolio_id = p_portfolio_id;

    -- Check if the portfolio holds enough securities to sell
    IF v_quantity >= p_quantity THEN
        -- Update the quantity and cost base in the portfolio
        UPDATE security_in_portfolio
        SET quantity = quantity - p_quantity,
            cost_base = cost_base - (v_cost_base_price * p_quantity),  -- Update the cost base based on FIFO
            market_value = (quantity - p_quantity) * v_price,  -- Update the market value
            gain_loss = gain_loss + (v_total_revenue - (v_cost_base_price * p_quantity))  -- Update the gain/loss
        WHERE security_id = p_security_id AND portfolio_id = p_portfolio_id;

        -- Get the user's account ID
        SELECT account_id INTO v_account_id
        FROM account
        WHERE user_id = (SELECT user_id FROM portfolio_holding WHERE portfolio_id = p_portfolio_id)
        LIMIT 1;

        -- Update the account balance
        UPDATE account
        SET account_balance = account_balance + v_total_revenue
        WHERE account_id = v_account_id;

        -- Record the transaction (optional, but recommended for auditing)
        INSERT INTO transaction(account_id, transaction_date, transaction_type, transaction_amount, security_id)
        VALUES (v_account_id, CURDATE(), 'Sell', v_total_revenue, p_security_id);
    ELSE
        -- Error if not enough securities to sell
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient securities to complete transaction';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_watchlist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_watchlist`(IN p_user_name VARCHAR(255))
BEGIN
    DECLARE v_user_id INT;
    
    -- Get the user_id based on the provided user_name
    SELECT user_id INTO v_user_id FROM user WHERE user_name = p_user_name;
    
    -- Select securities from the watchlist based on the user_id
    SELECT 
        s.security_id,
        s.security_name,
        s.security_type
    FROM 
        security s
        JOIN watchlist w ON s.watchlist_id = w.watchlist_id
    WHERE 
        w.user_id = v_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `withdraw` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `withdraw`(IN p_user_name VARCHAR(255), IN p_amount DECIMAL(15,2))
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_account_balance DECIMAL(15,2);

    -- Retrieve the user's ID based on the user's name
    SELECT user_id INTO v_user_id FROM user WHERE user_name = p_user_name;

    -- Check if the user exists
    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    ELSE
        -- Retrieve the user's account balance
        SELECT account_balance INTO v_account_balance FROM account WHERE user_id = v_user_id;

        -- Check if the account balance is sufficient for withdrawal
        IF v_account_balance >= p_amount THEN
            -- Perform the withdrawal operation
            UPDATE account 
            SET account_balance = account_balance - p_amount WHERE user_id = v_user_id;

            -- Insert the transaction record
            INSERT INTO transaction(account_id, transaction_date, transaction_type, transaction_amount, security_id)
            VALUES ((SELECT account_id FROM account WHERE user_id = v_user_id), CURDATE(), 'Withdraw', p_amount, NULL);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds for withdrawal';
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-18 23:41:06
