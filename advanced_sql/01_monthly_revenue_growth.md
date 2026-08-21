# Monthly Revenue Growth Using LAG()

## Business Question

**How does monthly revenue change compared with the previous month?**

I wanted to answer this question using the Olist e-commerce dataset and practice the `LAG()` window function.

Instead of directly writing the final query, I tried to break the problem into smaller steps and figure out what information I actually needed.

---

### 1. First: What do I need?

To answer the question, I need three things:

- Revenue for each month
- Revenue from the previous month
- The percentage change between the two

So ideally, my final output should look something like:

| Month | Revenue | Previous Month Revenue | Growth Rate |
|---|---:|---:|---:|
| Jan | 100 | NULL | NULL |
| Feb | 120 | 100 | 20% |
| Mar | 110 | 120 | -8.33% |

The first month will not have a previous month, so `NULL` is expected.

---

### 2. Finding the required tables

I first thought about where the required information was stored.

For the month, I needed the order purchase date. This is available in the `orders` table:

text
order_purchase_timestamp

For revenue, I needed payment_value, which is in order_payments.
The two tables can be connected through:
orders.order_id = order_payments.order_id
So the basic relationship is:
orders
   |
   | order_id
   ↓
order_payments


### 3. First attempt: Get the required data

I started with a simple join:

SELECT
    ord.order_id,
    ord_p.payment_value,
    ord.order_purchase_timestamp
FROM orders ord
JOIN order_payments ord_p
    ON ord.order_id = ord_p.order_id;

This gave me the order, payment value, and purchase timestamp.

But this was still at the transaction/order level. I needed to convert this into a monthly view.

### 4. Convert the timestamp into a month

I used DATE_TRUNC():

DATE_TRUNC('month', ord.order_purchase_timestamp) AS month

For example:

2017-06-15 14:32:10 becomes 2017-06-01 00:00:00
This means all transactions occurring in June can now belong to the same group.

At this point, I had something conceptually like:

month       payment_value
2018-06-01  100
2018-06-01  250
2018-06-01  80
2018-07-01  300
...

Now I needed one row per month.

### 5. Calculate monthly revenue

I used SUM() on payment_value and grouped by month:

SELECT
    DATE_TRUNC('month', ord.order_purchase_timestamp) AS month,
    SUM(ord_p.payment_value) AS revenue
FROM orders ord
JOIN order_payments ord_p
    ON ord.order_id = ord_p.order_id
GROUP BY month
ORDER BY month;

This gave me the monthly revenue table I needed:

month       revenue
2018-01     ...
2018-02     ...
2018-03     ...

At this point, I stopped thinking about the original transaction tables. I now had a much simpler dataset:

month | revenue

### 6. How do I get the previous month's revenue?

This was the main part of the problem.

I needed to look at the previous row while keeping the current row.

This is where LAG() comes in.

I thought about it as: LAG(revenue)

which means:

Give me the revenue from the previous row.

But I also needed to tell SQL what "previous" means.

For this problem, previous means the previous month chronologically.

So: LAG(revenue) OVER (ORDER BY month)
The ORDER BY month inside OVER() tells the window function how to determine the sequence.

### 7. Why did I use another CTE?
Initially, I tried to use the aliases month and revenue directly inside the same SELECT where I created them.

That caused a problem because those aliases were being created in that same query level.

So I changed my thinking:

First create the monthly revenue table. Then treat that result as a new table and apply LAG() to it.

This resulted in a second query layer.

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', ord.order_purchase_timestamp) AS month,
        SUM(ord_p.payment_value) AS revenue
    FROM orders ord
    JOIN order_payments ord_p
        ON ord.order_id = ord_p.order_id
    GROUP BY month
),

monthly_with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS revenue_previous_month
    FROM monthly_revenue
)

Now I had: month | revenue | revenue_previous_month

### 8. Calculate the revenue growth rate

Now I had both values needed for the calculation.

I used:

(current revenue - previous revenue)
------------------------------------- × 100
       previous revenue

So the final query became:

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', ord.order_purchase_timestamp) AS month,
        SUM(ord_p.payment_value) AS revenue
    FROM orders ord
    JOIN order_payments ord_p
        ON ord.order_id = ord_p.order_id
    GROUP BY month
),

monthly_with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS revenue_previous_month
    FROM monthly_revenue
)

SELECT
    month,
    revenue,
    revenue_previous_month,
    100.0 * (revenue - revenue_previous_month)
        / revenue_previous_month AS revenue_growth_rate_pct
FROM monthly_with_previous
ORDER BY month;

### 9. What I learned from this problem

The main thing I learned was not just LAG().

I had to think about the problem in layers:

Raw transaction data
        ↓
Monthly revenue
        ↓
Previous month's revenue
        ↓
Revenue growth rate

I also understood why OVER() is needed with LAG() and why ORDER BY month has to be inside OVER().

Another important lesson was that when one calculated result needs to be used in another calculation, a CTE or subquery can make the logic much easier to manage.

I used AI as a coaching tool during this exercise. I first tried to build each step myself and used hints when I got stuck, especially around LAG(), OVER(), column aliases, and the need for a second query layer.

