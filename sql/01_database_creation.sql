```sql
/*
==========================================================
TABLE CREATION
==========================================================

The table schemas were designed to match the structure and
data types of the Olist Brazilian E-commerce dataset while
following relational database best practices.

Data Type Selection:
- VARCHAR was used for IDs (e.g., customer_id, order_id,
  product_id, seller_id) because these values are
  alphanumeric identifiers rather than numeric quantities.
  Arithmetic operations are never performed on these fields.

- INT was used for whole-number attributes such as
  ZIP code prefixes, quantities, installments, and product
  dimensions where decimal precision is unnecessary.

- NUMERIC(10,2) was chosen for monetary values (price,
  freight_value, payment_value) to ensure exact decimal
  precision and avoid floating-point rounding errors.

- TIMESTAMP was used for all date and time fields to
  preserve both the calendar date and time of each event,
  enabling accurate time-series analysis.

- TEXT was used for review comments because comment lengths
  vary considerably and should not be artificially limited.

- CHAR(2) was used for Brazilian state abbreviations since
  every state code consists of exactly two characters.

Primary keys were defined where appropriate to uniquely
identify records. Composite primary keys were used for
tables where a single column does not uniquely identify
each row (e.g., order_items, order_payments, and
order_reviews). The geolocation table intentionally has no
primary key because the dataset contains multiple records
for the same ZIP code prefix.
==========================================================
*/
```


-- ==========================================
-- CUSTOMERS
-- ==========================================
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- ==========================================
-- ORDERS
-- ==========================================
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- ==========================================
-- ORDER_ITEMS
-- ==========================================
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- ==========================================
-- ORDER_PAYMENTS
-- ==========================================
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- ==========================================
-- ORDER_REVIEWS
-- ==========================================
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);

-- ==========================================
-- PRODUCTS
-- ==========================================
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- ==========================================
-- PRODUCT_CATEGORY_TRANSLATION
-- ==========================================
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- ==========================================
-- SELLERS
-- ==========================================
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- ==========================================
-- GEOLOCATION
-- ==========================================
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC(10,8),
    geolocation_lng NUMERIC(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
