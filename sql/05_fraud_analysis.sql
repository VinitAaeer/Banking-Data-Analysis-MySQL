/*
 3. Fraud & Anomaly Detection
	Problem:** Detect rapid back-to-back transactions (within 5 minutes) and cross-border location anomalies on the same day.
	Business Impact:** Enables real-time account flagging to mitigate credit card fraud and unauthorized access.
*/


-- Q1. Find customers making multiple transactions within 5 minutes.
SELECT
    t1.customer_id,
    t1.transaction_id,
    t1.transaction_date,
    t2.transaction_id AS related_transaction,
    t2.transaction_date AS related_transaction_date
FROM transactions t1
JOIN transactions t2
    ON t1.customer_id = t2.customer_id
   AND t1.transaction_id < t2.transaction_id
   AND t2.transaction_date > t1.transaction_date
   AND t2.transaction_date <=
       t1.transaction_date + INTERVAL 5 MINUTE;


 
-- FRAUD PATTERN
-- Q2. Find customers who make transactions from multiple countries within one day.
SELECT
    customer_id,
    DATE(transaction_date) AS transaction_day

FROM transactions

GROUP BY
    customer_id,
    DATE(transaction_date)

HAVING COUNT(DISTINCT country) > 1;




-- Q3. Find customers with unusual transaction amounts compared with their average.

SELECT
     customer_id, AVG(amount) from transactions group by customer_id;

SELECT
     customer_id,  transaction_id,amount
FROM transactions t
WHERE amount > (SELECT      AVG(amount) * 10  FROM transactions t2
    WHERE t2.customer_id = t.customer_id);

-- 🔥 Fraud detection scenario.

