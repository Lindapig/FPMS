
CREATE TABLE user (
user_id INT AUTO_INCREMENT PRIMARY KEY,
user_name VARCHAR(255) UNIQUE NOT NULL UNIQUE,
email VARCHAR(255) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,
date_created DATETIME DEFAULT CURRENT_TIMESTAMP
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

CREATE TABLE watchlist (
    watchlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    watchlist_name VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE security
ADD COLUMN watchlist_id INT NULL,
ADD CONSTRAINT FK_security_watchlist
FOREIGN KEY (watchlist_id) REFERENCES watchlist(watchlist_id)
ON UPDATE CASCADE ON DELETE SET NULL;



