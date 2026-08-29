-- ============================================
-- 1. CUSTOMERS
-- ============================================
CREATE TABLE customers (
    customer_id     INT PRIMARY KEY AUTO_INCREMENT,
    customer_name   VARCHAR(100) NOT NULL,
    city            VARCHAR(50),
    country         VARCHAR(50),
    email           VARCHAR(100),
    phone           VARCHAR(15),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. BRANCHES
-- ============================================
CREATE TABLE branches (
    branch_id       INT PRIMARY KEY AUTO_INCREMENT,
    branch_name     VARCHAR(100),
    city            VARCHAR(50),
    ifsc_code       VARCHAR(15)
);

-- ============================================
-- 3. ACCOUNTS
-- ============================================
CREATE TABLE accounts (
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

-- ============================================
-- 4. TRANSACTIONS
-- ============================================
CREATE TABLE transactions (
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

-- ============================================
-- 5. LOANS
-- ============================================
CREATE TABLE loans (
    loan_id             INT PRIMARY KEY AUTO_INCREMENT,
    customer_id         INT NOT NULL,
    loan_type           VARCHAR(50),  -- e.g. Home, Personal, Auto, Education
    loan_amount         DECIMAL(15,2),
    outstanding_amount  DECIMAL(15,2),
    status              ENUM('Active','Closed','Defaulted') DEFAULT 'Active',
    issue_date          DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================
-- 6. REPAYMENTS (Loan EMI repayments)
-- ============================================
CREATE TABLE repayments (
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

-- ============================================
-- 7. CREDIT_CARDS
-- ============================================
CREATE TABLE credit_cards (
    card_id         INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT NOT NULL,
    card_number     VARCHAR(20),
    credit_limit    DECIMAL(15,2),
    issued_date     DATE,
    status          ENUM('Active','Blocked','Closed') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================
-- 8. CREDIT_CARD_TRANSACTIONS
-- ============================================
CREATE TABLE credit_card_transactions (
    cc_transaction_id   INT PRIMARY KEY AUTO_INCREMENT,
    card_id             INT NOT NULL,
    customer_id         INT NOT NULL,
    amount              DECIMAL(15,2),
    status              ENUM('Success','Failed','Pending') DEFAULT 'Success',
    transaction_date    DATETIME,
    FOREIGN KEY (card_id) REFERENCES credit_cards(card_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================
-- 9. customer_risk_metrics
-- ============================================
CREATE TABLE customer_risk_metrics (
    customer_risk_id               INT PRIMARY KEY.  
    customer_id                    INT ,
    missed_payments                INT DEFAULT 0,
    credit_utilization             DECIMAL(5,2) DEFAULT 0,
    days_since_last_transaction    INT DEFAULT 0,
    loan_default                   TINYINT(1) DEFAULT 0,
    risk_score                     INT DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


