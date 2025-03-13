/*
=============================================================================================================
PRODUCT REPORT
=============================================================================================================

Purpose:
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gather essential fields such as product name, category, subcategory, and cost
	2. Segment products by revenue to identify High Performers, Mid-Range, or Low-Performers
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers
		- lifespan (in months)
	4. Calculates valuable KPI:
		- recency (months since last sale)
		- average order revenue
		- average monthly revenue

Usage:
  - This can be used by BI analysts to append data to existing dataset for data visualizations
  - Can be used by data analysts for further querying
  - Can be used for further analysis and modelling

=============================================================================================================
*/

CREATE VIEW gold.products_report
AS
WITH product_details AS (
	SELECT 
		p.product_id
		,p.category
		,p.subcategory
		,p.product_name
		,p.cost
		,COUNT(DISTINCT order_number)						AS total_orders
		,SUM(sales)											AS total_sales
		,SUM(quantity)										AS total_quantity_sold
		,COUNT(DISTINCT customer_key)						AS total_customers
		,MIN(order_date)									AS first_order_date
		,MAX(order_date)									AS last_order_date
		,DATEDIFF(month, MIN(order_date), MAX(order_date))	AS lifespan
	FROM gold.dim_products p
	LEFT JOIN gold.fact_sales f
	ON p.product_key = f.product_key
	WHERE order_date IS NOT NULL
	GROUP BY
		p.product_id
		,p.category
		,p.subcategory
		,p.product_name
		,p.cost
)

SELECT 
	product_id
	,category
	,subcategory 
	,product_name 
	,cost
	,total_orders
	,total_sales 
	,total_quantity_sold 
	,total_customers 
	,first_order_date
	,last_order_date
	,lifespan
	, DATEDIFF(month, lifespan, GETDATE()) AS recency_in_months
	,(CASE WHEN total_sales > 50000 THEN 'High Performer'
			WHEN total_sales BETWEEN 10000 AND 50000 THEN 'Mid-range Performer'
			ELSE'Low Range Performer'
			END) AS product_segments
	,(CASE WHEN total_orders = 0 THEN 0
			ELSE total_sales / total_orders
			END) AS avg_order_revenue
	,(CASE WHEN lifespan = 0 then total_sales
			ELSE total_sales/lifespan
			END) As avg_monthly_revenue
FROM product_details
GROUP BY
	product_id
	,category
	,subcategory 
	,product_name 
	,cost
	,total_orders
	,total_sales 
	,total_quantity_sold 
	,total_customers 
	,first_order_date
	,last_order_date
	,lifespan
	, DATEDIFF(month, lifespan, GETDATE()) 





