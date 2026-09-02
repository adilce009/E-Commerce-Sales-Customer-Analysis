## Top 3 Sellers by State

### Business Question

**Which three sellers generate the highest sales in each state?**

The goal was not to find the three highest-selling sellers overall. The sellers needed to be **ranked independently within each state**, so that each state had its own top three sellers.

---

### 1. Understanding the Data

I first identified where the required information lives:

- `order_items` contains `seller_id` and `price` for each item sold.
- `sellers` contains `seller_id` and `seller_state`.

Since seller state is not available in `order_items`, the two tables need to be joined using `seller_id`.

I also considered the **grain of the data**. `order_items` is at the order-item level, while the business question is at the **seller-within-state level**.

Therefore, the first step was to aggregate item-level sales into total sales for each seller.

---

### 2. Building the Solution Step by Step

#### Step 1 — Connect Sales to Seller State

I joined `order_items` with `sellers` and kept the fields needed for the analysis:

- `seller_id`
- `seller_state`
- `price`

At this point, the data was still at the **order-item level**. This was intentional because I had not yet calculated total sales for each seller.

```sql
SELECT
    o.seller_id,
    o.price,
    s.seller_state
FROM order_items AS o
INNER JOIN sellers AS s
    ON o.seller_id = s.seller_id;
```

#### Step 2 — Calculate Total Sales for Each Seller

The business question requires comparing sellers based on their total sales.

I therefore grouped the data by:

*seller_state,  seller_id*

This changes the grain to **one row per seller per state**.

I then used SUM(price) to calculate each seller's total sales.

```sql
SELECT
    ss.seller_id,
    ss.seller_state,
    SUM(ss.price) AS seller_sale_total
FROM Seller_sale AS ss
GROUP BY ss.seller_id, ss.seller_state;
```
At this stage, I had a seller-level sales table that could be ranked.

#### Step 3 — Rank Sellers Within Each State

The next challenge was that I did not want one ranking across the entire dataset.

For example, if the state SP had 1,849 sellers and PA had 349 sellers, each state needed its own ranking.

The key idea was:

```sql

PARTITION BY seller_state

```
This tells the window function to restart the ranking for every state.

I used ROW_NUMBER() and ordered sellers by total sales in descending order.

```sql
ROW_NUMBER() OVER (
    PARTITION BY seller_state
    ORDER BY SUM(ss.price) DESC
) AS seller_rank
```

#### Step 4 — Filter to the Top Three

Once the ranking was created, I needed to keep only sellers with a rank of 1, 2, or 3.

I placed the ranking logic inside a CTE and then filtered it in the outer query:

```sql

WHERE seller_rank <= 3

```
This separation was necessary because the window-function result is calculated at the query level where it is defined. Filtering the resulting rank is therefore handled in the outer query.

### 3. Choosing ROW_NUMBER() vs RANK()

An important design decision was choosing the appropriate ranking function.

At first glance, both ROW_NUMBER() and RANK() could be used for a top-three analysis. However, they handle ties differently. The function RANK() ranks all the entries that have tie and places them in the same rank.
This will create problem when we use WHERE filter with a maximum number of sellers = 3. Using RANK() may be appropriate if the business requirement is:

**Return everyone who falls within the top three positions, including ties.**

However, the requirement here is:

**"Return the top three sellers per state."**

Therefore, I chose ROW_NUMBER() because it guarantees a maximum of three sellers per state.

This was an important distinction because the choice of a window function should be based on the business definition of the result, rather than simply choosing the most familiar ranking function.

