/*
 5. Customer Dormancy & Reactivation Analysis
	Problem:** Track dormant accounts (no activity for 180 days) and re-activated customer behavior.
	Business Impact:** Drives targeted marketing campaigns to retain at-risk customers.
*/

-- — CUSTOMER RETENTION
-- Q1. Find customers who haven't transacted for 180 days.
SELECT
    customer_id,
    MAX(transaction_date) AS last_transaction
FROM transactions
WHERE status = 'Success'
GROUP BY customer_id
HAVING last_transaction <
       CURRENT_DATE - INTERVAL 180 DAY;
       
-- Q2. Find customers who became active again after 90 days.
WITH x AS (
    SELECT
        customer_id,
        transaction_date,

        LAG(transaction_date) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS previous_transaction

    FROM transactions

    WHERE status = 'Success'
)
SELECT *
FROM x
WHERE DATEDIFF(
          transaction_date,
          previous_transaction
      ) >= 90;

