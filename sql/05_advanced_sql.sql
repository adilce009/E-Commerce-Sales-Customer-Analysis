-- Find the top 3 sellers by revenue within each state

WITH Seller_sale AS(
SELECT
	o.seller_id,
	o.price,
	s.seller_state
FROM order_items AS o
INNER JOIN sellers AS s
ON o.seller_id = s.seller_id
),

Ranked_sellers AS(
SELECT
	ss.seller_id,
	ss.seller_state,
	SUM(ss.price) AS seller_sale_total,
	ROW_NUMBER() OVER(PARTITION BY ss.seller_state ORDER BY SUM(ss.price) DESC) AS seller_rank
FROM Seller_sale ss 
GROUP BY ss.seller_id, ss.seller_state
)

SELECT 
	 seller_state, seller_id, seller_sale_total, seller_rank
FROM Ranked_sellers
WHERE seller_rank <=3
