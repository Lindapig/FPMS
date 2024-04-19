DROP DATABASE fpms;
CREATE DATABASE IF NOT EXISTS fpms;
use fpms;

CREATE TABLE user (
user_id INT AUTO_INCREMENT PRIMARY KEY,
user_name VARCHAR(255) UNIQUE NOT NULL UNIQUE,
email VARCHAR(255) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,
date_created DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE watchlist (
    watchlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    watchlist_name VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE account (
account_id INT AUTO_INCREMENT PRIMARY KEY,
account_balance DECIMAL(15,2) NOT NULL,
user_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES user(user_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE portfolio_holding (
    portfolio_id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_name VARCHAR(255) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE security (
    security_id INT AUTO_INCREMENT PRIMARY KEY,
    security_name VARCHAR(255) NOT NULL,
    security_type VARCHAR(50) NOT NULL
);


CREATE TABLE market_data (
    data_id INT AUTO_INCREMENT PRIMARY KEY,
    security_id INT NOT NULL,
    date DATE NOT NULL,
    market_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (security_id) REFERENCES security(security_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE security_in_portfolio (
    security_id INT NOT NULL,
    portfolio_id INT NOT NULL,
    quantity INT NOT NULL,
    cost_base DECIMAL(15,2) NOT NULL,
    market_value DECIMAL(15,2) NOT NULL,
    gain_loss DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (security_id, portfolio_id),
    FOREIGN KEY (security_id) REFERENCES security(security_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (portfolio_id) REFERENCES portfolio_holding(portfolio_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    transaction_amount DECIMAL(15,2) NOT NULL,
    security_id INT default 0,
    FOREIGN KEY (security_id) REFERENCES security(security_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES account(account_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE notification (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    notification_message VARCHAR(255) NOT NULL,
    transaction_id INT NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE security
ADD COLUMN watchlist_id INT NULL,
ADD CONSTRAINT FK_security_watchlist
FOREIGN KEY (watchlist_id) REFERENCES watchlist(watchlist_id)
ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE user
ADD COLUMN watchlist_id INT UNIQUE,
ADD CONSTRAINT FK_user_watchlist
FOREIGN KEY (watchlist_id) REFERENCES watchlist(watchlist_id)
ON UPDATE CASCADE ON DELETE SET NULL;


-- Insert
-- Insert sample data into the user table
INSERT INTO user (user_name, email, password, date_created) 
VALUES 
('user1', 'user1@example.com', 'password1', NOW()),
('user2', 'user2@example.com', 'password2', NOW()),
('user3', 'user3@example.com', 'password3', NOW());

-- Insert sample data into the account table
INSERT INTO account (account_balance, user_id) 
VALUES 
(10000.00, 1),
(5000.00, 2),
(7500.00, 3);

-- Insert sample data into the portfolio_holding table
INSERT INTO portfolio_holding (portfolio_name, user_id) 
VALUES 
('Portfolio 1', 1),
('Portfolio 2', 2),
('Portfolio 3', 3);

-- Insert sample data into the watchlist table
INSERT INTO watchlist (user_id, watchlist_name) 
VALUES 
(1, 'Watchlist 1'),
(2, 'Watchlist 2'),
(3, 'Watchlist 3');

-- Insert sample data into the security table
INSERT INTO security (security_name, security_type, watchlist_id) 
VALUES 
('AAPL', 'Stock', 1),
('GOOGL', 'Stock', 2),
('MSFT', 'Stock', 3);

-- Insert sample data into the security_in_portfolio table
INSERT INTO security_in_portfolio (security_id, portfolio_id, quantity, cost_base, market_value, gain_loss) 
VALUES 
(1, 1, 100, 15000.00, 15000.00, 0),
(2, 2, 50, 100000.00, 100000.00, 0),
(3, 3, 200, 60000.00, 60000.00, 0);

-- Insert sample data into the market_data table
INSERT INTO market_data (security_id, date, market_price) 
VALUES 
(1, '2024-04-01', 150.00),
(2, '2024-04-01', 2000.00),
(3, '2024-04-01', 300.00);

-- Insert sample data into the transaction table
INSERT INTO transaction (account_id, transaction_date, transaction_type, transaction_amount, security_id) 
VALUES 
(1, '2024-04-01', 'Deposit', 5000.00, 1), 
(2, '2024-04-01', 'Withdraw', 2500.00, 2), 
(3, '2024-04-01', 'Deposit', 10000.00, 3); 

-- Insert sample data into the notification table
INSERT INTO notification (notification_message, transaction_id) 
VALUES 
('Notification message 1', 1),
('Notification message 2', 2),
('Notification message 3', 3);


-- Procedures/Triggers
-- login: return the password given the user_name
DELIMITER $$

CREATE PROCEDURE get_password(IN p_username VARCHAR(255))
BEGIN
    SELECT password
    FROM user
    WHERE user_name = p_username;
END$$

DELIMITER ;

-- Add a new user 
DELIMITER $$

CREATE PROCEDURE add_new_user(IN p_name VARCHAR(255), IN p_email VARCHAR(255), IN p_password VARCHAR(255))
BEGIN
    INSERT INTO user (user_name, email, password)
    VALUES (p_name, p_email, p_password);
END$$

DELIMITER ;

-- Select securities 
DELIMITER $$

CREATE PROCEDURE select_security(IN p_security_id INT)
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
END$$

DELIMITER ;


-- Historical Price for a security
DELIMITER $$

CREATE PROCEDURE historical_price(IN p_security_id INT)
BEGIN
    SELECT data_id, date, market_price
    FROM market_data
    WHERE security_id = p_security_id;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS buy;
-- Buy securities
DELIMITER $$

CREATE PROCEDURE buy(IN p_portfolio_id INT, IN p_security_id INT, IN p_quantity INT)
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
END$$

DELIMITER ;
CALL buy(1, 1, 10);

-- Check withholding security
DELIMITER $$
CREATE PROCEDURE check_withholding_security(IN p_security_id INT, IN p_portfolio_id INT)
BEGIN
    SELECT *
    FROM security_in_portfolio
    WHERE security_id = p_security_id AND portfolio_id = p_portfolio_id;
END$$
DELIMITER ;


-- Sell securities
DELIMITER $$

CREATE PROCEDURE sell(IN p_portfolio_id INT, IN p_security_id INT, IN p_quantity INT)
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
END$$

DELIMITER ;

-- Show watchlist
DELIMITER $$

CREATE PROCEDURE show_watchlist(IN p_user_name VARCHAR(255))
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
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS add_to_watchlist;
-- Add to watchlist
DELIMITER $$

CREATE PROCEDURE add_to_watchlist(IN p_user_name VARCHAR(255), IN p_security_id INT)
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
END$$

DELIMITER ;


-- Delete from watchlist
DELIMITER $$

CREATE PROCEDURE delete_from_watchlist(IN p_security_id INT)
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
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS all_portfolios;
-- Show all portfolios for specific user
DELIMITER $$

CREATE PROCEDURE all_portfolios(IN p_user_name VARCHAR(255))
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
END$$

DELIMITER ;
CALL all_portfolios('user1');

DROP PROCEDURE IF EXISTS select_portfolio;
-- Show All Securities in a Specific Portfolio for a user

DELIMITER $$

CREATE PROCEDURE select_portfolio(IN p_user_name VARCHAR(255))
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
END$$

DELIMITER ;
CALL select_portfolio('user1');

-- Check account balance
DELIMITER $$

CREATE PROCEDURE check_balance(IN p_user_name VARCHAR(255))
BEGIN
    SELECT a.account_id, a.account_balance
    FROM account a
    JOIN user u ON a.user_id = u.user_id
    WHERE u.user_name = p_user_name;
END$$

DELIMITER ;


-- Deposit Money into Account
DROP PROCEDURE IF EXISTS deposit;
DELIMITER $$

CREATE PROCEDURE deposit(IN p_user_name VARCHAR(255), IN p_amount DECIMAL(15,2))
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
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS withdraw;
-- Withdraw Money from Account
DELIMITER $$

CREATE PROCEDURE withdraw(IN p_user_name VARCHAR(255), IN p_amount DECIMAL(15,2))
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
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS all_transactions;
-- Return all transactions for specific user
DELIMITER $$

CREATE PROCEDURE all_transactions(IN p_user_name VARCHAR(255))
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
END$$

DELIMITER ;


-- Return Specific Transaction Details
DELIMITER $$

CREATE PROCEDURE select_transaction(IN p_transaction_id INT)
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
END$$

DELIMITER ;




