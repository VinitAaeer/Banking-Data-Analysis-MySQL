-- ============================================-- CUSTOMERS TABLE -- ============================================

CREATE TABLE IF NOT EXISTS customers (  
      customer_id     INT PRIMARY KEY AUTO_INCREMENT,   
      customer_name   VARCHAR(100) NOT NULL, 
      city            VARCHAR(50),   
      country         VARCHAR(50),   
      email           VARCHAR(100),   
      phone           VARCHAR(15),  
      created_at      DATETIME DEFAULT CURRENT_TIMESTAMP);


-- ============================================-- BRANCHES TABLE -- ============================================
CREATE TABLE IF NOT EXISTS branches (   
      branch_id       INT PRIMARY KEY AUTO_INCREMENT,  
      branch_name     VARCHAR(100),   
      city            VARCHAR(50),    
      ifsc_code       VARCHAR(15));

-- ============================================-- ACCOUNTS TABLE -- ============================================ 
CREATE TABLE IF NOT EXISTS accounts (    
      account_id      INT PRIMARY KEY AUTO_INCREMENT,   
      customer_id     INT NOT NULL,   
      branch_id       INT,   
      account_type    ENUM('Savings','Current') NOT NULL,    
      balance         DECIMAL(15,2) DEFAULT 0,   
      status          ENUM('Active','Inactive','Closed') DEFAULT 'Active',  
      opened_date     DATE,   
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id), 
      FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
      );

-- ============================================-- TRANSACTIONS TABLE-- ============================================ 
CREATE TABLE IF NOT EXISTS transactions (   
      transaction_id      INT PRIMARY KEY AUTO_INCREMENT,    
      customer_id         INT NOT NULL,   
      account_id          INT,   
      branch_id           INT,   
      transaction_type    ENUM('Deposit','Withdrawal','Transfer') NOT NULL,  
      amount              DECIMAL(15,2) NOT NULL, 
      status              ENUM('Success','Failed','Pending') DEFAULT 'Success',   
      city                VARCHAR(50),    
      country             VARCHAR(50),    
      transaction_date    DATETIME NOT NULL,   
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
      FOREIGN KEY (account_id) REFERENCES accounts(account_id),   
      FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
      );

-- ============================================-- LOANS TABLE-- ============================================
CREATE TABLE IF NOT EXISTS loans (    
      loan_id             INT PRIMARY KEY AUTO_INCREMENT,   
      customer_id         INT NOT NULL,  
      loan_type           VARCHAR(50),   
      loan_amount         DECIMAL(15,2), 
      outstanding_amount  DECIMAL(15,2),    
      status              ENUM('Active','Closed','Defaulted') DEFAULT 'Active', 
      issue_date          DATE,    
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      );


-- ===========================================-- REPAYMENTS TABLE -- ============================================
CREATE TABLE IF NOT EXISTS repayments (  
      repayment_id    INT PRIMARY KEY AUTO_INCREMENT,   
      loan_id         INT NOT NULL,  
      customer_id     INT NOT NULL,
      amount          DECIMAL(15,2),  
      due_date        DATE,
      payment_date    DATE,
      status          ENUM('Success','Missed','Pending') DEFAULT 'Success',    
      FOREIGN KEY (loan_id) REFERENCES loans(loan_id),  
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      );

-- ============================================-- CREDIT_CARDS TABLE-- ============================================ 
CREATE TABLE IF NOT EXISTS credit_cards (  
      card_id         INT PRIMARY KEY AUTO_INCREMENT, 
      customer_id     INT NOT NULL, 
      card_number     VARCHAR(20),    
      credit_limit    DECIMAL(15,2),  
      issued_date     DATE,  
      status          ENUM('Active','Blocked','Closed') DEFAULT 'Active',   
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      );

-- ============================================-- CREDIT_CARD_TRANSACTIONS TABLE-- ============================================ 
CREATE TABLE IF NOT EXISTS credit_card_transactions (    
      cc_transaction_id   INT PRIMARY KEY AUTO_INCREMENT,   
      card_id             INT NOT NULL,  
      customer_id         INT NOT NULL,   
      amount              DECIMAL(15,2),  
      status              ENUM('Success','Failed','Pending') DEFAULT 'Success',  
      transaction_date    DATETIME,  
      FOREIGN KEY (card_id) REFERENCES credit_cards(card_id),  
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      );


-- ============================================-- CUSTOMER_RISK_METRICS TABLE -- ============================================ 
CREATE TABLE IF NOT EXISTS customer_risk_metrics (   
      customer_risk_id               INT PRIMARY KEY,
      customer_id                    INT NOT NULL,  
      missed_payments                INT DEFAULT 0, 
      credit_utilization             DECIMAL(5,2) DEFAULT 0,   
      days_since_last_transaction    INT DEFAULT 0,  
      loan_default                   INT DEFAULT 0, 
      risk_score                     INT DEFAULT 0, 
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      );
