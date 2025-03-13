/*------------------------------------------------------------------------------------
4. MEASURES EXPLORATION
--------------------------------------------------------------------------------------
Purpose: 
  - To calculate overall key business metrics for quick insights

--------------------------------------------------------------------------------------
*/

------ Find the total sales

SELECT SUM(sales) AS total_sales
FROM gold.fact_sales

------ Find how many items sold

SELECT SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales

------ Find the average selling price
SELECT AVG(price) AS average_price
FROM gold.fact_sales;

------ Find the total number of orders

SELECT COUNT(DISTINCT order_number) AS number_orders
FROM gold.fact_sales

------ Find the total number of products

SELECT COUNT(DISTINCT product_id) AS number_products
FROM gold.dim_products

SELECT COUNT(DISTINCT product_key) AS number_products_sold
FROM gold.dim_products

------ Find the total number of customers

SELECT COUNT(DISTINCT customer_id) AS number_customers
FROM gold.dim_customers

------ Find the total number of customers that has placed an order

SELECT COUNT(DISTINCT customer_key) AS number_customers_with_orders
FROM gold.fact_sales

---------------------------------------------------------------------------------------------------------------------
------ Report of Key Business Metrics
---------------------------------------------------------------------------------------------------------------------

SELECT 'Total Sales' AS measure_name, SUM(sales) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Products' AS measure_name, COUNT(DISTINCT product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Number of Customers' AS measure_name, COUNT(DISTINCT customer_id) AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Number of Customers with Orders' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales
