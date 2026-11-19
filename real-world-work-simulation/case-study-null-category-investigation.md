# Case Study: Investigating Null Product Categories in the Olist Dataset

## Context

While checking the `products` table for data quality issues, I found 610 products (out of 32,951 total) with a null `product_category_name`. What stood out was that these weren't obviously broken or incomplete rows — they still had real weight and dimension data populated, just missing name, description, category, and photo count. That made it worth digging into rather than just dropping or ignoring them.

## Step 1: Ruling Out "These Are Just Bad Rows"

First thing I checked: were the nulls isolated to category, or were these products generally low-quality/incomplete records?

```sql
SELECT 
    COUNT(*) AS total,
    COUNT(product_weight_g) AS has_weight,
    COUNT(product_length_cm) AS has_length,
    COUNT(product_photos_qty) AS has_photos
FROM products
WHERE product_category_name IS NULL;
```

Weight and dimensions were populated for all but one of the 610. Photos and name/description were missing across all of them. So this wasn't general data decay — it was specifically the descriptive/listing fields that were missing, while the physical/logistics fields were fine. That's a meaningfully different (and more specific) problem than "this data is just messy."

## Step 2: Checking for a Seller Pattern

Next question: is this spread randomly across sellers, or is it coming from somewhere specific?

```sql
SELECT seller_id, COUNT(*) AS null_category_count
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL
GROUP BY seller_id
ORDER BY null_category_count DESC;
```

At first glance, the nulls were spread across 257 different sellers, which looked like it might just be background noise. But looking closer at the distribution, one seller alone accounted for 372 of the 610 nulls. I went back and checked that seller's total catalog size — and found they only have 373 products total. 372 of 373 — basically their entire listing — was missing this data. That's not noise, that's a seller whose listings never had this information captured in the first place.

The remaining ~238 nulls were thinly spread across the other 256 sellers — a few each, consistent with normal, occasional data entry gaps rather than a systemic issue.

## Step 3: Checking for a Time Pattern

I also checked whether the nulls clustered around a specific period:

```sql
SELECT DATE_TRUNC('month', shipping_limit_date) AS month, COUNT(*)
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL
GROUP BY 1
ORDER BY 1;
```

2017 didn't show a clear pattern, but late 2017 through early 2018 showed a noticeable rise, roughly tracking the platform's higher sales volume in that window. Read together with the seller finding, this looks like two separate contributing factors rather than one single cause — a data-entry gap from one seller, plus a mild increase in data quality slips during higher-volume periods across the board.

## Step 4: Checking Whether It Actually Matters

Before recommending anything, I checked the business impact rather than treating this as purely a data cleanliness issue:

```sql
SELECT COUNT(DISTINCT oi.order_id) AS orders_affected, SUM(oi.price) AS revenue_affected
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL;
```

1,451 orders and about 179,535 in revenue were tied to these products over the two-year span — roughly 1.32% of total revenue in that period. Small relative to the whole, but not trivial, and concentrated enough (mostly in one seller) that it's worth acting on rather than ignoring.

## Conclusion and Recommendation

What looked at first like 610 scattered null values turned out to be two distinct stories:

1. **One seller with a near-complete data gap** — 372 of their 373 products are missing listing information. This looks like an onboarding or process issue specific to that seller, and is worth flagging directly to whoever manages seller relationships, rather than treating it as a general data quality sweep.
2. **A small, likely-normal background rate** — the remaining nulls spread thinly across 256 other sellers, consistent with occasional one-off misses rather than a systemic problem.

My recommendation was to flag the specific product IDs tied to that one seller for direct follow-up, rather than launching a broad investigation across all sellers for a problem that's really concentrated in one place.

## Why This Mattered

The easy version of this task would've been to just drop the 610 rows or bucket them as "uncategorized" and move on. The useful version was tracing the nulls back to a cause, separating a real systemic issue from normal background noise, and tying it to an actual revenue number before deciding what to recommend. That's the difference between patching a symptom in SQL and actually finding out what's going on.
