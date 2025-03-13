/*------------------------------------------------------------------------------------
9. PERFORMANCE ANALYSIS
-------------------------------------------------------------------------------------
Purpose
  - To compare current and target values (e.g., previous year, average, etc.) of 
  business performance

SQL FUNCTIONS:
  - Aggregate Functions
  - Window Functions
-------------------------------------------------------------------------------------
*/

----- Analyze the yearly performance of products by comparing each product's sales to both 
----- its average sales performance and the previous year's sales performance


----------- Year-over-year analysis
SELECT 
	order_year 
	,product_name
	,current_sales
	,AVG(current_sales) OVER (PARTITION BY product_name) AS average_sales
	,(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) AS diff_avg_sales
	,(CASE	WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) > 0 THEN 'Above'
			WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below'
			ELSE 'Average'
			END) AS average_change
	,LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_sales
	,(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) AS diff_py_sales
	,( CASE WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Increase'
			WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Decrease'
			ELSE 'No Change'
			END) py_change
FROM
(
SELECT 
	YEAR(f.order_date) AS order_year
	,p.product_name 
	,SUM(sales) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY
	YEAR(f.order_date)
	,p.product_name 
) AS t


----------- Month-over-month analysis 
SELECT 
	order_month 
	,product_name
	,current_sales
	,AVG(current_sales) OVER (PARTITION BY product_name) AS average_sales
	,(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) AS diff_avg_sales
	,(CASE	WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) > 0 THEN 'Above'
			WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below'
			ELSE 'Average'
			END) AS average_change
	,LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month ) AS previous_month
	,(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month )) AS diff_pm_sales
	,( CASE WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month)) > 0 THEN 'Increase'
			WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month)) < 0 THEN 'Decrease'
			ELSE 'No Change'
			END) my_change
FROM
(
SELECT 
	MONTH(f.order_date) AS order_month
	,p.product_name 
	,SUM(sales) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY
	MONTH(f.order_date)
	,p.product_name 
) AS t


----- Month-over-month analysis for total quantity sold

SELECT 
	order_year
	,order_month 
	,product_name
	,current_quantity_sold
	,LAG(current_quantity_sold) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) AS previous_quantity
	,current_quantity_sold - LAG(current_quantity_sold) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) AS diff_quantity
	, (CASE WHEN current_quantity_sold - LAG(current_quantity_sold) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) > 0 THEN 'Increase'
			WHEN current_quantity_sold - LAG(current_quantity_sold) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) < 0 THEN 'Decrease'
			ELSE 'No change'
			END) AS diff_previous_quantity
FROM
	(
	SELECT 
		YEAR(f.order_date)				AS order_year
		,MONTH(f.order_date)			AS order_month
		,p.product_name
		,COUNT(DISTINCT f.customer_key)	AS current_customers
		,COUNT(DISTINCT f.order_number)	AS current_orders
		,SUM(f.quantity)				AS current_quantity_sold
		,SUM(f.sales)					AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY
		YEAR(f.order_date)	
		,MONTH(f.order_date)
		,p.product_name
	) AS current_vals

-----Month-over-month analysis for total customers

SELECT 
	order_year
	,order_month 
	,product_name
	,current_customers
	,LAG(current_customers) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) AS previous_customers
	,current_customers - LAG(current_customers) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) AS diff_customers
	, (CASE WHEN current_customers - LAG(current_customers) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) > 0 THEN 'Increase'
			WHEN current_customers - LAG(current_customers) OVER (PARTITION BY product_name, order_year ORDER BY order_year,order_month) < 0 THEN 'Decrease'
			ELSE 'No change'
			END) AS diff_previous_customers
FROM
	(
	SELECT 
		YEAR(f.order_date)				AS order_year
		,MONTH(f.order_date)			AS order_month
		,p.product_name
		,COUNT(DISTINCT f.customer_key)	AS current_customers
		,COUNT(DISTINCT f.order_number)	AS current_orders
		,SUM(f.quantity)				AS current_quantity_sold
		,SUM(f.sales)					AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY
		YEAR(f.order_date)	
		,MONTH(f.order_date)
		,p.product_name
	) AS current_vals
