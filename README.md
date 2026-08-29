# Banking Data Analysis using MySQL

## Project Overview

This project analyzes banking data using MySQL to understand customer transactions, loan risk, repayment behavior, fraud patterns, customer activity, revenue growth, and customer value.

The main goal of this project is to use SQL to solve real-world banking business problems and generate useful insights that can support business decisions.

---

## Business Objectives

- Identify customers with negative cash flow.
- Analyze loan repayment and default risk.
- Identify unusual transaction patterns.
- Analyze customer transaction behavior.
- Track customer dormancy and reactivation.
- Measure month-over-month revenue growth.
- Segment customers based on transaction value.
- Identify high-value customers using Pareto analysis.

---

## Tools Used

- MySQL
- SQL
- GitHub

---

## Database Tables

The project uses the following banking-related tables:

| Table | Description |
|---|---|
| `customers` | Customer information |
| `branches` | Bank branch information |
| `accounts` | Customer account information |
| `credit_cards` | Credit card details |
| `credit_card_transactions` | Credit card transaction details |
| `customer_risk_metrics` | Customer risk-related information |
| `loans` | Loan details |
| `repayments` | Loan repayment details |
| `transactions` | Deposit, withdrawal and transaction information |

---

# SQL Concepts Used

The project covers the following SQL concepts:

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- CASE WHEN
- Aggregate Functions
- INNER JOIN
- LEFT JOIN
- Conditional Aggregation
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- `LAG()`
- Date Functions
- `DATEDIFF()`
- `DATE()`
- `DATE_FORMAT()`
- `HOUR()`
- `SUM()`
- `AVG()`
- `COUNT()`
- `COUNT(DISTINCT)`
- `TIMESTAMPDIFF()`

---

# Business Case Analysis

## 1. Behavioral Cash-Flow Analysis

### Business Problem

Identify customers whose withdrawals are higher than their deposits and calculate their net cash flow.

### SQL Questions

  Q1.Find customers whose withdrawals exceed deposits.
  
  Q2.Find the net cash flow for every customer.
  
  Q3.Find customers with negative net cash flow.

### SQL Concepts Used

- JOIN
- GROUP BY
- HAVING
- CASE WHEN
- SUM()
- Conditional Aggregation

### Key Finding

The analysis identifies customers whose withdrawals are higher than their deposits and customers with negative net cash flow.

### Business Impact

Helps the bank identify customers whose cash flow may need further review before making additional credit decisions.

---

# 2. Credit Risk & Loan Default Analysis

### Business Problem

Identify customers with loan repayment problems and understand loan default patterns.

### SQL Questions

  Q4.Find customers who have active loans but no successful repayment.
  
  Q5.Find loan types with a default rate above 5%.
  
  Q6.Identify high-value customers who may be at higher borrowing risk based on transaction value, missed payments, repayment delays, and outstanding loan amount.

### SQL Concepts Used

- INNER JOIN
- LEFT JOIN
- CTEs
- CASE WHEN
- GROUP BY
- HAVING
- Aggregate Functions
- DATEDIFF()

### Key Finding

The analysis identifies customers with active loans, repayment problems, missed payments, and high outstanding loan amounts.

### Business Impact

Helps the collection and risk teams focus on customers who may need early follow-up.

-----

# 3. Fraud & Anomaly Detection

### Business Problem

Identify unusual transaction patterns that may require further investigation.

### SQL Questions

  Q7.Find customers making multiple transactions within 5 minutes.
  
  Q8.Find customers making transactions from multiple countries on the same day.
  
  Q9.Find transactions that are significantly higher than the customer's normal transaction value.

### Additional Fraud Checks

- Transactions outside normal banking hours.
- Customers transacting from multiple cities on the same day.

### SQL Concepts Used

- Self JOIN
- Subqueries
- GROUP BY
- HAVING
- COUNT(DISTINCT)
- Date and Time Functions

### Key Finding

The analysis identifies unusual transaction patterns such as rapid transactions, multiple locations, and unusually large transaction amounts.

### Business Impact

Helps the bank identify suspicious activity that may need further investigation and monitoring.

> Note: These patterns indicate potential anomalies and do not automatically confirm fraud.

---

# 4. Revenue Growth & Customer Value Segmentation

### Business Problem

Understand monthly revenue growth and identify customers based on their total transaction value.

### SQL Questions

  10.Segment customers into Platinum, Gold, Silver, and Regular based on transaction value.
  
  11.Calculate month-over-month revenue growth.

### Customer Segments

| Segment | Transaction Value |
|---|---:|
| Platinum | >= 10,000,000 |
| Gold | >= 5,000,000 |
| Silver | >= 1,000,000 |
| Regular | < 1,000,000 |

### SQL Concepts Used

- CASE WHEN
- GROUP BY
- CTEs
- Window Functions
- `LAG()`
- `DATE_FORMAT()`
- Aggregate Functions

### Key Finding

The analysis shows monthly revenue changes and identifies customers who contribute higher transaction value.

### Business Impact

Helps the bank understand revenue trends and focus more attention on high-value customers.

---

# 5. Customer Dormancy & Reactivation Analysis

### Business Problem

Identify customers who have been inactive for a long period and customers who return after a long transaction gap.

### SQL Questions
  
  12.Find customers who have not made a successful transaction for 180 days.
  
  13.Find customers with a transaction gap of 90 days or more.

### SQL Concepts Used

- CTE
- Window Functions
- `LAG()`
- `DATEDIFF()`
- GROUP BY
- HAVING

### Key Finding

The analysis identifies dormant customers and customers who become active again after a long transaction gap.

### Business Impact

Helps the bank identify inactive customers and plan suitable customer engagement or retention activities.

---

# 6. Pareto Analysis – 80/20 Customer Value

### Business Problem

Identify customers who contribute a large share of the total transaction value.

### SQL Question

    Q14.Find customers contributing to the first 80% of total transaction value.

### SQL Concepts Used

- CTEs
- Window Functions
- `SUM() OVER()`
- Cumulative Sum
- Ranking
- Percentage Calculation

### Key Finding

The analysis identifies customers who contribute the largest share of the bank's total transaction value.

### Business Impact

Helps the bank focus retention and relationship efforts on high-value customers.

---

# Project Structure


banking-data-analysis-sql/
│
├── README.md
│
├── sql/
  ├── 01_database_setup.sql
  ├── 02_data_exploration.sql
  ├── 03_cash_flow_analysis.sql
  ├── 04_credit_risk.sql
  ├── 05_fraud_analysis.sql
  ├── 06_revenue_analysis.sql
  ├── 07_customer_retention.sql
  └── 08_pareto_analysis.sql

