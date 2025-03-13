/*------------------------------------------------------------------------------------
10. PART-TO-WHOLE ANALYSIS (PROPORTIONAL ANALYSIS)
--------------------------------------------------------------------------------------
Purpose: 
  - To analyze contribution of certain measures to overall performance

SQL FUNCTIONS:
  - Aggregate Functions
  - Window Functions
--------------------------------------------------------------------------------------
*/

----- What categories contribute most to the overall sales

WITH category_sales AS(
SELECT 
	p.category 
	,SUM(f.sales) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY
	p.category 
) 
SELECT 
	category
	,total_sales
	,SUM(total_sales) OVER () AS overall_sales
	,CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) *100, 2),'%') AS percent_total
FROM category_sales
ORDER BY total_sales DESC

-- Insights: You are overrelying on one category of the business, and if this fails, then the whole business will fail.
-- Either remove both categories not performing well, or focus on bringing revenue on these 2 categories

----- What categories has the most number of customers
WITH category_performance AS(
SELECT 
	p.category 
	,SUM(f.sales) AS total_sales
	,COUNT(DISTINCT customer_key) AS total_customers
	,COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY
	p.category 
) 
SELECT 
	category
	,total_customers 
	,SUM(total_customers) OVER () AS overall_customers
	,CONCAT(ROUND((CAST(total_customers AS float)/SUM(total_customers) OVER () *100), 2),'%') AS percent_total
FROM category_performance
ORDER BY total_customers  DESC

----- What categories has the most number of orders

WITH category_performance AS(
SELECT 
	p.category 
	,SUM(f.sales) AS total_sales
	,COUNT(DISTINCT customer_key) AS total_customers
	,COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY
	p.category 
) 
SELECT 
	category
	,total_orders 
	,SUM(total_orders) OVER () AS overall_orders
	,CONCAT(ROUND((CAST(total_orders AS FLOAT) / SUM(total_orders) OVER ())*100, 2), '%') AS percent_total
FROM category_performance
ORDER BY total_orders DESC
