/*
=============================================================================================================
PRELIMINARY DATA EXPLORATION
=============================================================================================================

Purpose:
	- This script explores the structure of the following:
      - the database (i.e., the tables and schemas)
      - the dimensions table
      - date and time spans

Note: The measures table is in a separate script, #04

=============================================================================================================
*/


/*------------------------------------------------------------------------------------
1. DATABASE EXPLORATION
-------------------------------------------------------------------------------------
Purpose: 
  - To explore the structure of the database, i.e., tables and schemas
  - To inspect the columns within specific tables
-------------------------------------------------------------------------------------
*/

-- 1.1 Explore Objects in the Database: Check the metadata

SELECT *
FROM INFORMATION_SCHEMA.TABLES ;

-- 1.2 Explore All columns in the database for the products table

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';


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

/*------------------------------------------------------------------------------------
3. DATE EXPLORATION
-------------------------------------------------------------------------------------
Purpose:
	- To explore the boundaries, scope and time span of the data.
-------------------------------------------------------------------------------------
*/


------ Find the date of the first and last order
------ How many years of sales are available

SELECT	
	MIN(order_date)                                   	AS first_order_date
	,MAX(order_date)                                   	AS last_order_date
	,DATEDIFF(year, MIN(order_date), MAX(order_date)) 	AS number_sales_years
FROM gold.fact_sales;

------ Find the youngest and oldest customer

SELECT	 
    MIN(birth_date)						AS oldest_birthdate
	,DATEDIFF(year,MIN(birth_date), GETDATE())	      	AS oldest_age
	,MAX(birth_date)					AS youngest_birthdate
	,DATEDIFF(year,MAX(birth_date), GETDATE())	      	AS youngest_age
FROM gold.dim_customers;
