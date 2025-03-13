/*------------------------------------------------------------------------------------
6. RANKING ANALYSIS
-------------------------------------------------------------------------------------
  - To rank performance of different metrics, such as products, customers, etc.
  - To identify top and worse performers

SQL FUNCTIONS:
  - Aggregate functions 
  - Window fuctions

-------------------------------------------------------------------------------------
*/

------ What are the top 5 products that generates most of the revenue?

SELECT TOP 5
	p.product_name 
	,SUM(f.sales) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC;

------ What are the top 5 products that generates most of the revenue in each product category?
SELECT *
FROM
	(
	SELECT 
		p.category
		,p.product_name 
		,SUM(f.sales) AS total_sales
		,ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(f.sales) DESC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	GROUP BY 
		p.category
		,p.product_name 
	) AS t
WHERE rank_products <= 5;


------ What are the 5 worst-performing products in terms of sales?

SELECT TOP 5
	p.product_name 
	,SUM(f.sales) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales ASC;

------ What are the 5 worst-performing products in terms of sales per category?

SELECT *
FROM
	(
	SELECT 
		p.category
		,p.product_name 
		,SUM(f.sales) AS total_sales
		,ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(f.sales) ASC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	GROUP BY 
		p.category
		,p.product_name 
	) AS t
WHERE rank_products <= 5;

------ Who are the top 10 customers who have generated the highest revenue?

SELECT TOP 10
	c.customer_id
	,c.first_name
	,c.last_name
	,SUM(f.sales) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY
	c.customer_id
	,c.first_name
	,c.last_name
ORDER BY total_sales DESC;

------ Who are the 3 customers with the fewest orders placed?

SELECT TOP 3
	c.customer_id
	,c.first_name
	,c.last_name
	,COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY
	c.customer_id
	,c.first_name
	,c.last_name
ORDER BY total_orders ASC;

