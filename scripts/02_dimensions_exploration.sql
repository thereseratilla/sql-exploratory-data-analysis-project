/*------------------------------------------------------------------------------------
2. DIMENSION EXPLORATION
--------------------------------------------------------------------------------------
Purpose:
	-To explore the structure of the dimensions table
--------------------------------------------------------------------------------------
*/

-- 2.1. Identify unique values in each dimension

------ Where do our customers come from?

SELECT DISTINCT country
FROM gold.dim_customers;

------ What are the product categories, subcategories and product name in the business?

SELECT	 
	DISTINCT category
	,subcategory
	,product_name
FROM gold.dim_products
ORDER BY 1,2,3;
