/*
==========================================================
EXPLORATORY DATA ANALYSIS (EDA)
==========================================================

Purpose:
The objective of this exploratory data analysis (EDA) is to
understand the structure, quality, and characteristics of
the Olist Brazilian E-commerce dataset before performing
business analysis.

This section includes:
1. Dataset overview
2. Table statistics: identify Grain, primary key and foreign key
3. 
4. Data quality assessment
5. Missing value analysis
6. Temporal distribution of orders
7. Customer and product distributions
8. Review score analysis

The insights obtained during EDA help ensure data integrity
and provide a foundation for subsequent business analytics.
==========================================================
*/

/*
----------------------------------------------------------
1. DATASET OVERVIEW
----------------------------------------------------------
The following queries provide a high-level summary of the
dataset by reporting the number of records in each table.
This helps verify successful data import and understand
the relative size of each table.
----------------------------------------------------------
*/

-- Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total number of order items
SELECT COUNT(*) AS total_order_items
FROM order_items;

-- Total number of order payments
SELECT COUNT(*) AS total_order_payments
FROM order_payments;

-- Total number of order reviews
SELECT COUNT(*) AS total_order_reviews
FROM order_reviews;

-- Total number of products
SELECT COUNT(*) AS total_products
FROM products;

-- Total number of product categories
SELECT COUNT(*) AS total_product_categories
FROM product_category_translation;

-- Total number of sellers
SELECT COUNT(*) AS total_sellers
FROM sellers;

-- Total number of geolocation records
SELECT COUNT(*) AS total_geolocations
FROM geolocation;


/*
==========================================================
2. TABLE STATISTICS: PRIMARY KEY VALIDATION AND GRAIN
==========================================================

Purpose:
This section identifies the grain of each table and validates
candidate primary keys.

A primary key should:
1. Uniquely identify each row.
2. Never contain NULL values.
3. Remain consistent across the dataset.

Understanding the grain helps determine how tables should be
joined and prevents incorrect aggregations during analysis.
==========================================================
*/

/*
---------------------------------------------------
              Customers Table
---------------------------------------------------

- Grain: One row represents one customer account.
- Candidate primary key: customer_id

*/

-- Validating primary key

-- Check total rows
SELECT COUNT(*) AS total_rows
FROM customers;

-- Check unique customer IDs
SELECT COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customers;

-- Check NULL values
SELECT COUNT(*) AS null_customer_ids
FROM customers
WHERE customer_id IS NULL;

-- Evaluation results showed that customer_id is the primary key for this table

/*
---------------------------------------------------
              Orders Table
---------------------------------------------------

- Grain: One row represents one order transaction.
- Candidate primary key: order_id

*/

-- Validating primary key

SELECT COUNT(*) AS total_rows
FROM orders;

SELECT COUNT(DISTINCT order_id) AS unique_order_ids
FROM orders;

SELECT COUNT(*) AS null_order_ids
FROM orders
WHERE order_id IS NULL;

-- total_rows = unique_order_ids
-- Primary Key: order_id

/*
---------------------------------------------------
              Order Items Table
---------------------------------------------------

- Grain: A single order can contain multiple products. One row represents one order in a transaction.
- Candidate primary key:(order_id, order_item_id)

*/
-- validation:
SELECT COUNT(*) AS total_rows
FROM order_items;


SELECT COUNT(*) AS unique_combinations
FROM (
    SELECT DISTINCT
        order_id,
        order_item_id
    FROM order_items
) t;

--if total_rows = unique_combinations
-- primary key= (order_id, order_item_id)


/*
---------------------------------------------------
              Order Payments Table
---------------------------------------------------

- Grain: An order can have multiple payment records. One payment record associated with an order.
- Candidate primary key:((order_id, payment_sequential)

*/
-- validation:

SELECT COUNT(*) AS total_rows
FROM order_payments;


SELECT COUNT(*) AS unique_combinations
FROM (
    SELECT DISTINCT
        order_id,
        payment_sequential
    FROM order_payments
) t;

/*
---------------------------------------------------
              Order Reviews Table
---------------------------------------------------

- Grain: One row = one review associated with one order
- Detected duplicates both in review_id and order_id. 
- Candidate primary key:One row = review_id, order_id
*/
-- validation: Check duplicate in review_id
SELECT 
review_id,
COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- validation: Check duplicate in order_id
SELECT 
    order_id,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Validation: Candidate primary key

SELECT COUNT(*) AS total_rows
FROM order_reviews;


SELECT COUNT(*) AS unique_review_order_pairs
FROM (
    SELECT DISTINCT
        review_id,
        order_id
    FROM order_reviews
) t;

/*
---------------------------------------------------
              Products Table
---------------------------------------------------

- Grain: One row = One unique product. 
- Candidate primary key:product_id
*/

-- Validation
SELECT COUNT(*) AS total_rows
FROM products;


SELECT COUNT(DISTINCT product_id)
FROM products;

-- total_rows = distinct product_id

/*
---------------------------------------------------
              Products Table
---------------------------------------------------

- Grain: One row = One seller 
- Candidate primary key:seller_id
*/

-- Validation
SELECT COUNT(*) AS total_rows
FROM sellers;

SELECT COUNT(DISTINCT seller_id)
FROM sellers;

-- total_rows =  distinct seller_id

/*
---------------------------------------------------
          Product Category Translation
---------------------------------------------------

- Grain: One row = One product category translation.
- Candidate primary key:product_category_name
*/

-- Validation

SELECT COUNT(*) AS total_rows
FROM product_category_translation;


SELECT COUNT(DISTINCT product_category_name)
FROM product_category_translation;

-- total_rows = distinct product_category_name

/*
==========================================================
          ORDER DISTRIBUTION OVER TIME ANALYSIS
==========================================================

Purpose:
Analyze how customer orders are distributed across different
time periods. Understanding temporal trends helps identify
seasonality, peak shopping periods, and customer purchasing
patterns.

The analysis includes:
1. Orders by Year
2. Orders by Month
3. Orders by Weekday
4. Orders by Hour
==========================================================
*/

-- Number of orders placed each year

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY year
ORDER BY year;

-- Number of orders placed each month

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- Number of orders placed on each day of the week

SELECT
    TO_CHAR(order_purchase_timestamp, 'Day') AS weekday,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_orders;

-- Number of orders placed during each hour of the day

SELECT
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY hour
ORDER BY hour;
