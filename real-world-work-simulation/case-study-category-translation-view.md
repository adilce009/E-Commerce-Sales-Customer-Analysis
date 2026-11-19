# Case Study: Cleaning Up Product Categories in the Olist Dataset

## Context

While loading the Olist e-commerce dataset into PostgreSQL, I noticed the `products` table stores category names in Portuguese (`product_category_name`), and there's a separate lookup table, `product_category_name_translation`, meant to map those to English. Before using categories in any analysis or dashboard, I wanted to confirm this translation actually covers everything — rather than assume it and find out later that half my reporting was quietly broken.

## Step 1: Checking Coverage

I ran a left join from `products` to the translation table to see if any Portuguese category names didn't have a match:

```sql
SELECT DISTINCT p.product_category_name
FROM products p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_translation IS NULL;
```

This came back with two categories with no translation: `pc_gamer` and `portateis_cozinha_e_preparadores_de_alimentos`. Small gap, but a real one — if I'd joined blindly, these two categories would've shown up as blank/null in any report broken down by category, which is exactly the kind of thing that looks like a bug three weeks later when nobody remembers why.

## Step 2: Deciding How to Handle It

I had a few options — drop them, bucket them as "uncategorized," or just manually translate the two myself since it's a small, fixed list. I went with manually mapping them, since it's cheap to do and keeps the data complete. The alternative (bucketing as "other") felt like it was trading away information for no real reason when the fix was this easy.

## Step 3: Building It as a Reusable View

Instead of writing this translation logic into every query that needed category names, I turned it into a view — so the fix lives in one place and everything downstream just references the clean version:

```sql
CREATE VIEW products_enriched AS
SELECT 
    p.*,
    CASE 
        WHEN p.product_category_name = 'pc_gamer' THEN 'gaming_pc'
        WHEN p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'kitchen_portables'
        ELSE t.product_category_name_translation
    END AS product_category_english
FROM products p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name;
```

Any report that needs category names now pulls from `products_enriched` instead of re-deriving this logic every time. If Olist ever adds an official translation for those two categories later, I only need to update it in one place.

## Why This Mattered

This wasn't a hard technical problem — the SQL itself is simple. The value was in not skipping the verification step before building on top of the data. A missing translation for 2 out of ~70 categories is easy to miss if you don't explicitly check for it, and it's exactly the kind of gap that causes confusing, hard-to-trace issues downstream (a dashboard with a mystery "null" category, a report that silently excludes a chunk of products). Catching it at the source, documenting the decision, and wrapping the fix in a reusable view meant the problem got solved once instead of becoming a recurring confusion for anyone else working with this table.

## Files
- `sql/views/products_enriched.sql` — the view definition
- Logged in the project's data dictionary under `products.product_category_name`
