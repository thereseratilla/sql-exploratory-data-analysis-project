
/*
=============================================================================================================
CUSTOMER REPORT
=============================================================================================================

Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details
	2. Segments customers into categories (VIP, Regular, New) and age groups
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPI:
		- recency (months since last order)
		- average order value
		- average monthly spend

Usage:
  - This can be used by BI analysts to append data to existing dataset for data visualizations
  - Can be used by data analysts for further querying
  - Can be used for further analysis and modelling

=============================================================================================================
*/

CREATE VIEW gold.customer_report 
AS
SELECT 
	customer_id
	,customer_name
	,age
	,(CASE WHEN age < 18 THEN 'Below 18'
			WHEN age BETWEEN 18 AND 25 THEN '18 - 25'
			WHEN age BETWEEN 25 AND 35 THEN '25 - 35'
			WHEN age BETWEEN 35 AND 45 THEN '35 - 45'
			WHEN age BETWEEN 45 AND 55 THEN '45 - 55'
			ELSE 'Above 55'
			END) AS age_group
	,total_orders
	,total_spending
	,total_quantity_purchased
	,total_products
	,first_order_date
	,last_order_date
	,lifespan_months
	,(CASE WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
			END) AS customer_segment
	, DATEDIFF(month, last_order_date, GETDATE())	AS recency
	, (CASE WHEN total_spending = 0 THEN 0
			ELSE total_spending/total_orders
			END) AS avg_order_value
	, (CASE WHEN lifespan_months = 0 THEN total_spending
			ELSE total_spending/lifespan_months
			END) AS avg_monthly_spend
FROM
	(
	SELECT 
		c.customer_id											AS customer_id
		, CONCAT(c.first_name, ' ', c.last_name)				AS customer_name
		, DATEDIFF(year, c.birth_date, GETDATE())				AS age
		, COUNT(DISTINCT f.order_number)						AS total_orders
		, SUM(f.sales)											AS total_spending
		, SUM(f.quantity)										AS total_quantity_purchased
		, COUNT(DISTINCT f.product_key)							AS total_products
		, MIN(f.order_date)										AS first_order_date
		, MAX(f.order_date)										AS last_order_date
		, DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS lifespan_months
	FROM gold.dim_customers c
	LEFT JOIN gold.fact_sales f
	ON c.customer_key = f.customer_key
	GROUP BY 
		c.customer_id
		,CONCAT(c.first_name, ' ', c.last_name)
		,DATEDIFF(year, birth_date, GETDATE())
	) AS customer_details





