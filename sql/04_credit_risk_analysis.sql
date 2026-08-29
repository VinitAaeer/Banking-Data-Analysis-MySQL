/*
  2.Credit Risk & Loan Default Analysis
		Problem:** Identify high-value customers with large outstanding loans and frequent EMI delays to prevent NPA.
		SQL Queries Included:** Q4, Q5, Q6
		Business Impact:** Helps the collection team prioritize high-exposure risk accounts before default occurs.
*/
--  Q4. Find customers who have active loans but no successful repayment.
SELECT DISTINCT
    l.customer_id
FROM loans l
LEFT JOIN repayments r
    ON l.loan_id = r.loan_id
   AND r.status = 'Success'
WHERE l.status = 'Active'
  AND r.repayment_id IS NULL;


-- Q5. Find loan types with default rate above 5%.

SELECT
    loan_type,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN status = 'Defaulted' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS default_rate
FROM loans
GROUP BY loan_type
HAVING default_rate > 5;

-- Q6. Identify high-value customers who are at risk of becoming bad borrowers.
WITH customer_value AS (
    SELECT
        customer_id,
        SUM(amount) AS transaction_value
    FROM transactions
    WHERE status = 'Success'
    GROUP BY customer_id
),
repayment AS (
    SELECT   customer_id,
        COUNT(
            CASE
                WHEN status = 'Missed'
                THEN 1
            END
        ) AS missed_payments,
      
        AVG(
			CASE
				WHEN payment_date > due_date
				THEN DATEDIFF(payment_date, due_date)
				ELSE 0
			END
) AS avg_delay
        
    FROM repayments
    GROUP BY customer_id
),
loan_data AS (
    SELECT
          customer_id,
          SUM(outstanding_amount) AS outstanding
    FROM loans
    WHERE status = 'Active'
    GROUP BY customer_id
)
SELECT
    v.customer_id,
    v.transaction_value,
    r.missed_payments,
    r.avg_delay,
    l.outstanding,
CASE
  WHEN r.missed_payments >= 3  AND r.avg_delay > 10 AND l.outstanding > 500000  THEN 'High RISK'
  WHEN r.missed_payments >= 1   THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
   END AS risk_category

FROM    customer_value  v 
 JOIN repayment r
                         ON    v.customer_id = r.customer_id
 JOIN loan_data l
                         ON v.customer_id = l.customer_id
WHERE 
    v.transaction_value > 1000000;


