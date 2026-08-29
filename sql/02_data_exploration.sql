-- ============================================
-- 02_data_exploration.sql
-- Purpose: Basic exploration of all tables before deep analysis
-- ============================================

-- --------------------------------------------
-- 1. ROW COUNTS — how many records exist in each table
-- --------------------------------------------
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'branches', COUNT(*) FROM branches
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'repayments', COUNT(*) FROM repayments
UNION ALL
SELECT 'credit_cards', COUNT(*) FROM credit_cards
UNION ALL
SELECT 'credit_card_transactions', COUNT(*) FROM credit_card_transactions
UNION ALL
SELECT 'customer_risk_metrics', COUNT(*) FROM customer_risk_metrics;


-- --------------------------------------------
-- 2. SAMPLE DATA — preview first 5 rows of each table
-- --------------------------------------------
SELECT * FROM customers LIMIT 5;
SELECT * FROM branches LIMIT 5;
SELECT * FROM accounts LIMIT 5;
SELECT * FROM transactions LIMIT 5;
SELECT * FROM loans LIMIT 5;
SELECT * FROM repayments LIMIT 5;
SELECT * FROM credit_cards LIMIT 5;
SELECT * FROM credit_card_transactions LIMIT 5;
SELECT * FROM customer_risk_metrics LIMIT 5;


-- --------------------------------------------
-- 3. DISTINCT VALUES — check what values exist in categorical columns
-- (helps catch typos like 'Deposite' instead of 'Deposit')
-- --------------------------------------------
SELECT DISTINCT account_type FROM accounts;
SELECT DISTINCT status FROM accounts;

SELECT DISTINCT transaction_type FROM transactions;
SELECT DISTINCT status FROM transactions;
SELECT DISTINCT city FROM transactions;
SELECT DISTINCT country FROM transactions;

SELECT DISTINCT loan_type FROM loans;
SELECT DISTINCT status FROM loans;

SELECT DISTINCT status FROM repayments;

SELECT DISTINCT status FROM credit_cards;


-- --------------------------------------------
-- 4. NULL / MISSING VALUE CHECK — assess data quality
-- --------------------------------------------
SELECT
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS null_names,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS null_email
FROM customers;

SELECT
    SUM(CASE WHEN payment_date IS NULL THEN 1 ELSE 0 END) AS null_payment_dates,
    SUM(CASE WHEN status = 'Missed' THEN 1 ELSE 0 END) AS missed_count,
    SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_count
FROM repayments;


-- --------------------------------------------
-- 5. MIN / MAX / RANGE CHECK — sanity-check numeric columns
-- --------------------------------------------
SELECT
    MIN(balance) AS min_balance,
    MAX(balance) AS max_balance,
    AVG(balance) AS avg_balance
FROM accounts;

SELECT
    MIN(amount) AS min_txn,
    MAX(amount) AS max_txn,
    AVG(amount) AS avg_txn
FROM transactions;

SELECT
    MIN(transaction_date) AS earliest_txn,
    MAX(transaction_date) AS latest_txn
FROM transactions;

SELECT
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan,
    AVG(loan_amount) AS avg_loan
FROM loans;


-- --------------------------------------------
-- 6. DUPLICATE CHECK — customers with multiple accounts/cards
-- --------------------------------------------
SELECT customer_id, COUNT(*) AS account_count
FROM accounts
GROUP BY customer_id
HAVING account_count > 1
ORDER BY account_count DESC;

SELECT customer_id, COUNT(*) AS card_count
FROM credit_cards
GROUP BY customer_id
HAVING card_count > 1;


-- --------------------------------------------
-- 7. REFERENTIAL INTEGRITY CHECK — look for orphan records
-- (e.g. a transaction referencing a customer_id that doesn't exist in customers)
-- --------------------------------------------
SELECT t.customer_id
FROM transactions t
LEFT JOIN customers c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT l.customer_id
FROM loans l
LEFT JOIN customers c ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
