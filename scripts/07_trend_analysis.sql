/*------------------------------------------------------------------------------------
7. TREND ANALYSIS
--------------------------------------------------------------------------------------
Purpose
    - To analyze change-over-time or trends for long-term or short-term decision-making

SQL Functions:
  - Aggregate functions
  - Window functions
--------------------------------------------------------------------------------------
*/

--- Analyse sales performance over time

----- Aggregate by year: Long-term (helpful for strategic decisions)

SELECT 
	YEAR(order_date)				AS order_year
	,SUM(sales)						AS total_sales
	,SUM(quantity)					AS total_quantity
	,COUNT(DISTINCT order_number)	AS number_orders
	,COUNT(DISTINCT customer_key)	AS number_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date) 

----- Aggregate by month: analyze seasonality

SELECT 
	MONTH(order_date)				AS order_month
	,SUM(sales)						AS total_sales
	,SUM(quantity)					AS total_quantity
	,COUNT(DISTINCT order_number)	AS number_orders
	,COUNT(DISTINCT customer_key)	AS number_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

----- Aggregate by year and month

SELECT 
	YEAR(order_date)				AS order_year
	,MONTH(order_date)				AS order_month
	,SUM(sales)						AS total_sales
	,SUM(quantity)					AS total_quantity
	,COUNT(DISTINCT order_number)	AS number_orders
	,COUNT(DISTINCT customer_key)	AS number_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date)
	,MONTH(order_date)
ORDER BY 
	YEAR(order_date)
	,MONTH(order_date)

----- Aggregate by year and month`: Using DATETRUNC() function

SELECT 
	DATETRUNC(month, order_date)	AS order_date
	,SUM(sales)						AS total_sales
	,SUM(quantity)					AS total_quantity
	,COUNT(DISTINCT order_number)	AS number_orders
	,COUNT(DISTINCT customer_key)	AS number_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	DATETRUNC(month, order_date)
ORDER BY 
	DATETRUNC(month, order_date)

----- Aggregate by year and month`: Using FORMAT() function
SELECT 
	FORMAT(order_date, 'yyyy-MMM')	AS order_date -- stored as string, order_date is ordered by year but alphabetically on the month
	,SUM(sales)						AS total_sales
	,SUM(quantity)					AS total_quantity
	,COUNT(DISTINCT order_number)	AS number_orders
	,COUNT(DISTINCT customer_key)	AS number_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	FORMAT(order_date, 'yyyy-MMM')
ORDER BY 
	FORMAT(order_date, 'yyyy-MMM')
