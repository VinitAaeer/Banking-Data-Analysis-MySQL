/*
  6. Pareto Analysis (80/20 Revenue Rule)
	Problem:** Identify the top 20% of customer cohorts driving 80% of total transaction volume.
	Business Impact:** Focuses retention efforts on the most profitable bank accounts.
*/

-- Q.1  Find customers contributing to first 80% of transaction value.
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

