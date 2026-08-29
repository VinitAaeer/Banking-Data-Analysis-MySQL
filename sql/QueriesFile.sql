SELECT * FROM customers;
SELECT * FROM branches;
SELECT * FROM credit_card_transactions;
SELECT * FROM credit_cards;
SELECT * FROM accounts;
SELECT * FROM customer_risk_metrics;
SELECT * FROM loans;
SELECT * FROM repayments;
SELECT * FROM transactions;



/*  1.  Behavioral Cash-Flow Analysis

	Problem:** Pinpoint customers with negative net cash flow (Withdrawals > Deposits).
	SQL Queries Included:** Q1, Q2
	Business Impact:** Flags deteriorating customer liquidity to restrict new credit issuance.
	   
*/

-- Q1. Find customers whose withdrawals exceed deposits.

    SELECT   
     c.customer_id,c.customer_name,
        SUM(
            CASE
                WHEN t.transaction_type = 'Deposit'
                THEN t.amount
                ELSE 0
            END
        ) AS deposits,
        SUM(
            CASE
                WHEN t.transaction_type = 'Withdrawal'
                THEN t.amount
                ELSE 0
            END
        ) AS withdrawals   from customers c  join transactions  t on  c.customer_id=t.customer_id
    -- FROM transactions  
    GROUP BY c.customer_id,c.customer_name
    HAVING withdrawals > deposits;

-- Q2. Find net cash flow for every customer.
    SELECT
        customer_id,
        SUM(
            CASE
                WHEN transaction_type = 'Deposit'
                    THEN amount
                WHEN transaction_type = 'Withdrawal'
                    THEN -amount
                ELSE 0
            END
        ) AS net_cash_flow
    FROM transactions
    GROUP BY customer_id;

-- Q3. Find customers with negative net cash flow.
    SELECT
        customer_id,
        SUM(
            CASE
                WHEN transaction_type = 'Deposit'
                    THEN amount
                WHEN transaction_type = 'Withdrawal'
                    THEN -amount
                ELSE 0
            END
        ) AS net_cash_flow
    FROM transactions
    GROUP BY customer_id
    
    HAVING net_cash_flow < 0;


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


/*
 3. Fraud & Anomaly Detection
	Problem:** Detect rapid back-to-back transactions (within 5 minutes) and cross-border location anomalies on the same day.
	SQL Queries Included:** Q28, Q51, Q52
	Business Impact:** Enables real-time account flagging to mitigate credit card fraud and unauthorized access.
*/

-- Q7. Find customers making multiple transactions within 5 minutes.
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
   
-- Q8. Find customers who make transactions from multiple countries within one day.
    SELECT
        customer_id,
        DATE(transaction_date) AS transaction_day
    FROM 
        transactions
    GROUP BY
        customer_id,
        DATE(transaction_date)
    HAVING 
        COUNT(DISTINCT country) > 1;


-- Q9. Find customers with unusual transaction amounts compared with their average.

    SELECT
         customer_id, AVG(amount) from transactions group by customer_id;
    
    SELECT
         customer_id,  transaction_id,amount
    FROM transactions t
    WHERE amount > (SELECT   AVG(amount) * 10  FROM transactions t2
        WHERE t2.customer_id = t.customer_id);





/*
 4.  Revenue Growth & Customer Value Segmentation
	Problem:** Calculate Month-over-Month (MoM) revenue growth and segment customers into Platinum, Gold, and Silver tiers.
	SQL Queries Included:** Q33, Q35
	Business Impact:** Provides executive management with growth trends and identifies VIP customers for dedicated Relationship Managers.
*/


-- Q10. Segment customers based on transaction value.
SELECT
    customer_id,
    SUM(amount) AS total_value,

    CASE
        WHEN SUM(amount) >= 10000000
            THEN 'Platinum'

        WHEN SUM(amount) >= 5000000
            THEN 'Gold'

        WHEN SUM(amount) >= 1000000
            THEN 'Silver'

        ELSE 'Regular'
    END AS customer_segment

FROM transactions

WHERE status = 'Success'

GROUP BY customer_id;



-- Q11. Calculate month-over-month growth.
WITH monthly AS (
    SELECT
        DATE_FORMAT(
            transaction_date,
            '%Y-%m'
        ) AS month,

        SUM(amount) AS revenue

    FROM transactions

    WHERE status = 'Success'

    GROUP BY month
),
x AS (
    SELECT
        *,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_revenue

    FROM monthly
)
SELECT
    month,
    revenue,
    previous_revenue,

    100.0 *
    (revenue - previous_revenue)
    / NULLIF(previous_revenue,0)
    AS growth_percentage

FROM x;



/*
 5. Customer Dormancy & Reactivation Analysis
	Problem:** Track dormant accounts (no activity for 180 days) and re-activated customer behavior.
	SQL Queries Included:** Q41, Q42
	Business Impact:** Drives targeted marketing campaigns to retain at-risk customers.
*/

-- — CUSTOMER RETENTION
-- Q12. Find customers who haven't transacted for 180 days.
SELECT
    customer_id,
    MAX(transaction_date) AS last_transaction
FROM transactions
WHERE status = 'Success'
GROUP BY customer_id
HAVING last_transaction <
       CURRENT_DATE - INTERVAL 180 DAY;
       
-- Q13. Find customers who became active again after 90 days.
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



/*
  6. Pareto Analysis (80/20 Revenue Rule)
	Problem:** Identify the top 20% of customer cohorts driving 80% of total transaction volume.
	SQL Queries Included:** Q55
	Business Impact:** Focuses retention efforts on the most profitable bank accounts.
*/

-- Q.13  Find customers contributing to first 80% of transaction value.
      WITH customer_value AS (
             SELECT
                  customer_id, SUM(amount) AS value
             FROM transactions
             WHERE status = 'Success'
             GROUP BY customer_id),
      x AS (
          SELECT  *,SUM(value) OVER (ORDER BY value DESC) AS cumulative_value ,
                            SUM(value) OVER () AS total_value
          FROM customer_value
              )
      SELECT
      	customer_id,    concat(round(value/100000,1),' L') value,
           CASE
              WHEN cumulative_value >= 10000000 THEN
                  CONCAT(ROUND(cumulative_value * 1.0 / 10000000, 2), ' Cr')
              WHEN cumulative_value >= 100000 THEN
                  CONCAT(ROUND(cumulative_value * 1.0 / 100000, 2), ' L')
              ELSE
                  CONCAT(ROUND(cumulative_value, 2), '')
          END AS sales_formatted,
          concat( round(100.0 *cumulative_value /   total_value ,2),' %') AS cumulative_percentage
      FROM x
      WHERE   cumulative_value / total_value <= 0.80;
