/*------------------------------------------------------------------------------------
8. CUMULATIVE ANALYSIS
-------------------------------------------------------------------------------------
Purpose:
  - To aggregate measures over time to analyze business performance progressively 

SQL FUNCTIONS:
  - Aggregate functions
  - Window functions
-------------------------------------------------------------------------------------
*/

----- Calculate the total sales per category per month and the running total of sales over time

SELECT
	order_year
	,order_month
	,category
	,total_sales
	,SUM(total_sales) OVER (PARTITION BY category,order_year ORDER BY order_year, order_month) AS running_yearly_total_sales
FROM
	(
	SELECT 
		YEAR(f.order_date)	  AS order_year
		,MONTH(f.order_date)	AS order_month
		,p.category
		,SUM(f.sales)			    AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		YEAR(order_date)
		,MONTH(order_date)
		,p.category
	) AS t

----- Calculate the running total sales per year
SELECT 
	order_year
	,total_sales 
	,SUM(total_sales) OVER (ORDER BY order_year) AS running_yearly_sales
FROM
	(
	SELECT 
		YEAR(order_date)  AS order_year
		,SUM(sales)       AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY
		YEAR(order_date) 
	) AS t

----- Calculate the moving average of the price and cost 
----- and the commulative total quantity sold and sales over time

SELECT 
	order_date
	,category
	,average_cost 
	,AVG(average_cost) OVER (PARTITION BY category ORDER BY order_date) AS moving_avg_cost
	,average_price
	,AVG(average_price) OVER (PARTITION BY category ORDER BY order_date) AS moving_avg_price
	,quantity_sold
	,SUM(quantity_sold) OVER (PARTITION BY category ORDER BY order_date) AS commulative_quantity_sold
	,total_sales 
	,SUM(total_sales) OVER (PARTITION BY category ORDER BY order_date) AS commulate_total_sales
FROM
(
SELECT 
	DATETRUNC(month, f.order_date) AS order_date
	,p.category
	,AVG(p.cost)                   AS average_cost
	,AVG(f.price)                  AS average_price
	,SUM(f.quantity)               AS quantity_sold
	,SUM(f.sales)                  AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY
	DATETRUNC(month, order_date)
	,p.category
) AS t
