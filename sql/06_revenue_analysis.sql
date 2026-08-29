/*
 4.  Revenue Growth & Customer Value Segmentation
	Problem:** Calculate Month-over-Month (MoM) revenue growth and segment customers into Platinum, Gold, and Silver tiers.
	Business Impact:** Provides executive management with growth trends and identifies VIP customers for dedicated Relationship Managers.
*/


-- Q1. Segment customers based on transaction value.
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



-- Q2. Calculate month-over-month growth.
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

