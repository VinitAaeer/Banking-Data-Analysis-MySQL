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


