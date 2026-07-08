### Determine primary keys
A primary key is a specific column or a set of columns in a database table that uniquely identifies each record (row).
Two key indications to determine if a particular column is a primary key
*Is there any NULL value?*
*Is there any duplicate value?*

First, I take the table  *orders* and find out its primary key. The initial assumption is *order_id* as the primary key of *orders* table

*Test 1:* Check for duplicate values

<img src="images/orders_duplicate_test.png" width="250">

This gives 99441 for both counts. It reveals that every row has a unique order_id (no duplicate!)

*Test 2:* Check for NULL values

<img src="images/orders_NULL_test.png" width="250">

This gives 0, meaning no NULL. it means that *order_id is the primary key*


#### Determining the primary key for the table *order_items*
Candidate columns for primary key: *order_id*, *order_item_id*

*Test 1:* Check duplicate for *order_id*

<img src="images/order_items_order_id_duplicate_test.png" width="250">

*Output:* total rows are 112650, and distinct_order_id is 98666
*Result* shows that there are more rows than orders than the number of unique order_id. This reveals that *order_id* is *not* unique (chance of duplicate order_ids). I want to make sure there are duplicate order_ids with the following queries:

<img src="images/order_id_duplicate_confirmation.png" width="250">

This gives those order_ids that have more than 1 entries (rows) in the table (many orders have multiple rows). Most likely interpretation is that *there are multiple items in many orders*.

*Concluding remark*: one row != one order.

Since order_id is not unique, I no longer test for NULL for it.

*Test 2:* Check duplicate for *order_item_id*

<img src="images/order_item_id_duplicate_test.png" width="250">

*Output:* 112650, 21
It reveals there are only few types of items compared to the orders (21 items compared to 112650 rows). This means that order_item_id repeats across orders. *order_item_id* itself cannot be a primary key.

*Test 3:* Check if *order_id* and *order_item_id* combinedly are unique

<img src="images/distinct_order_id_order_item_id_test.png" width="250">

*Result:* 112650 (equal to the number of rows in the table)
*Decision*: (order_id, order_item_id) is unique identifier
*Conclusion*: one row = one item within an order (this is the Grain, meaning what each row mean)




