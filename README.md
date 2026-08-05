# E-Commerce Sales & Customer Analysis Using SQL

## Project Overview

This project performs end-to-end exploratory data analysis and business analysis on a Brazilian e-commerce dataset using PostgreSQL.

The objective of this project is to analyze customer behavior, sales performance, seller performance, product trends, and customer satisfaction by transforming raw transactional data into meaningful business insights.

The analysis focuses on answering key business questions such as:
- Which regions contribute the most customers and sellers?
- What are the major revenue drivers?
- Which product categories and sellers perform best?
- How do customers interact with the platform?
---

## Dataset

The project uses the **Brazilian E-Commerce Public Dataset by Olist**, containing real-world transactional data from an online marketplace.

The dataset consists of multiple relational tables, including:

- Customers
- Orders
- Order Items
- Order Payments
- Order Reviews
- Products
- Sellers
- Product Category Translation
- Geolocation

The dataset contains more than **1 million records**, providing information about customer orders, payments, products, sellers, and reviews.

---

## Tools & Technologies

- **PostgreSQL 18** - Database management and SQL analysis
- **pgAdmin** - Database administration and query execution
- **SQL** - Data exploration, transformation, aggregation, and business analysis

---

## Project Workflow

The project follows a structured analytics workflow:

### 1. Data Preparation
- Created relational database tables
- Defined appropriate data types and constraints
- Imported raw CSV files into PostgreSQL

### 2. Exploratory Data Analysis (EDA)
Performed data exploration to understand:
- Dataset size and structure
- Table relationships and grain
- Primary key uniqueness
- Duplicate records
- Data quality issues
- Order trends over time

### 3. Business Analysis

Analyzed key business metrics:

**Customer & Seller Analysis**
- Customer distribution by state
- Seller distribution by state
- Customer retention patterns

**Revenue Analysis**
- Total revenue
- Monthly revenue trends
- Revenue by state
- Revenue contribution by sellers
- Average order value

**Product Analysis**
- Top categories by revenue
- Top categories by units sold

**Customer Satisfaction Analysis**
- Review score distribution
- Positive review percentage
- Average rating by state
- Category-level customer satisfaction

---

## Repository Structure

```
E-Commerce-Sales-Customer-Analysis
├── data_exploration
│   ├── 01_dataset_overview.md
│   └── 02_PrimaryKey_Grain.md
│
├── business_analysis
│   └── business_analysis.md
│
├── sql
│   ├── 01_database_creation.sql
│   ├── 02_exploratory_data_analysis.sql
│   └── 03_business_analysis.sql
│
└── README.md
```


