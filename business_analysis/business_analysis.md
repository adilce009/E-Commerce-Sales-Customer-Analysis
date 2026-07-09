#### Question: Which states contribute most customers?

<img src="ba_images/customers_states.png" width="250">

Most customers are in state SP (41746). States RJ and MG also have more than 10K customers. Total nunmber of states are 27

#### Question: States vs sellers: Which states contribute the most sellers?

<img src="ba_images/sellers_states.png" width="250">

State SP has the heights number of sellers (1849). PR and MG have 349 and 244 sellers consecutively. 

#### What payment methods are popular?

<img src="ba_images/payment_method.png" width="250">

*Result* shows that the most popular payment type is credit card. There are 3 more payment methods. 

#### How are review scores distributed?

<img src="ba_images/review_score_dist.png" width="250">

The reviews are quite positive; most of the reviewers rated it the best.

#### Average review score

<img src="ba_images/avg_review.png" width="250">

*Result:* The average review score is 4.086 which demonstrates a high satisfaction among the customers.

### Revenue analysis

#### Find total revenue

<img src="ba_images/total_rev.png" width="250">

Total revenue was 16 million for the entire duration given in the dataset.

#### Find revenue by month.

<img src="ba_images/rev_by_month.png" width="250">

The revenue by does not show a specific trend like a hike on a particular month or a group of months (as we usually see during the month of November due to black friday or during the month of December due to the Christmas). However, during the months of the year 2018 is much higher compared to the months of the other years.

#### Find revenue by states
This is a complex situation where three tables should be involved. 

<img src="ba_images/rev_by_states.png" width="250">

States SP, RJ, and MG contribute to the most amount of revenue. This also alighs with the number of customers and sellers in those states that was shown during dataset analysis. 

#### Find revenue by seller
This is a tricky question. One way to solve it as following:

<img src="ba_images/rev_by_seller_1.png" width="250">

But since there may be orders that contain multiple items, an order might be counted multiple times, which will lead to a wrong answer. Instead of the above query, the following is much simpler and accuratly represent the actual revenue.

<img src="ba_images/rev_by_seller_2.png" width="250">

### Top product category
Finding the top category product can be with respect to revenue or with respect to the number of products sold. 
#### Top product category with respect to revenue earned

<img src="ba_images/top_cat_revenue.png" width="250">

There are 71 categories of products. The product names are translated into their respective english names with the help of *product_category_translation* table. The *result* of the above query shows that *health_beauty* category generates the most revenue, whereas the *watches_gifts*, *bed_bath_table*, *sports_leisure*, and *computer_accessories* categories are not much behind as well. 

#### Top category with respect to the unit sold

<img src="ba_images/top_cat_unit_sold.png" width="250">

*bed_bath_table* category products are sold the most whereas the *health_beauty* category places second. It reveals that the *health_beauty* category products produces higher profit margin.  

### Top sellers
#### Top seller by revenue (which seller generated the most revenue?)

<img src="ba_images/top_sellers_by_revenue.png" width="250">

There are three sellers who made more than 220K revenue.

#### Top sellers by item sold

<img src="ba_images/top_sellers_by_unit_sold.png" width="250">

One of the sellers sold more than 2K units whereas there are two more sellers who sold more than 1900 units.

### Top customers
#### Average order value: how much money a customer spent per order?
To find this, I need to use *subquery*. I should consider: some orders may have *multiple payment records* (e.g., split across credit card + voucher) as there is a feature called *payment installment*. So, we may have multiple payments for the same *order_id*.

<img src="ba_images/avg_order_value.png" width="250">

*Result:* The average order value is 160.99

#### How many customer purchased more than once? 
Count order per customer

<img src="ba_images/count_order_per_customer.png" width="250">

The above query gives the number of times the customers purchased. But if we want to only see the customers who purchased repeatedly (more than once), then the following query can be used.

<img src="ba_images/repeat_customer.png" width="250">

#### Count how many repeat customer exist.

<img src="ba_images/count_repeat_customers.png" width="250">

#### New vs Repeat customers: how many customers visited one time and how many customers are loyal and repeat coming?
This is a complex query that involves multiple steps:
First subquery: calculate orders per customer.
Second subquery: classify customer as One-time or Repeat.
Outer query: count how many customers fall into each category.

<img src="ba_images/new_vs_old_customers.png" width="250">

*Result* shows that most of the customers (93099) purchased one time and there are close to 3K customers who are loyal and purchased multiple times. From business perspective, a the company might want to attract the big chunk of visiting customers. 

### Review score analysis
#### Distribution of review score: How many 1-star, 2-star, 3-star, 4-star, and 5-star reviews are there?

<img src="ba_images/review_score.png" width="250">

####  What is the percentage of review_score for 3, 4 and 5 in combined (positive review percentage)

<img src="ba_images/percent_high_review_score.png" width="250">

The percentage of positive reviews is 85.31% which shows a high satisfaction for the product. 








