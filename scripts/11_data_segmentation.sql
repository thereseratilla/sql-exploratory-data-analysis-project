/*------------------------------------------------------------------------------------
11. DATA SEGMENTATION: 
-------------------------------------------------------------------------------------
Purpose: 
  - To group certain measures to understand understand correlation between them

SQL FUNCTIONS:
  - Aggregate Functions
  - Window Functions
-------------------------------------------------------------------------------------

*/

----- Segment products into cost ranges and count how many products fall into each segment

SELECT
	cost_range 
	,COUNT(product_key) AS total_products
FROM 
	(
	SELECT 
		product_key
		,product_name 
		,cost
		,(CASE WHEN cost < 100 THEN 'Below 100'
				WHEN cost BETWEEN 100 AND 500 THEN '100-500'
				WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
				ELSE 'Above 1000'
				END) AS cost_range
	FROM gold.dim_products
	) AS product_segments
GROUP BY
	cost_range
ORDER BY total_products DESC

/*
----- Group customers into 3 segments based on their spending behavior
	- VIP: Customers with at least 12 months of history and spending more than 5,000
	- Regular: Customers with ate least 12 months of history but spending 5000 or less
	- New: Customers with a lifespan less than 12 months
And find the total number of customers by each group

*/


WITH customer_details AS (
SELECT 
	c.customer_key 
	,SUM(f.sales)                                          AS total_spending
	,MIN(f.order_date)                                     AS first_order_date
	,MAX(f.order_date)                                     AS last_order_date
	,DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY
	c.customer_key
)

SELECT 
	customer_segment
	,COUNT(DISTINCT customer_key) AS total_customers
FROM
	(
	SELECT 
		customer_key
		,( CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
				WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
				ELSE 'New'
				END) customer_segment
	FROM customer_details
	) AS t
GROUP BY customer_segment;

