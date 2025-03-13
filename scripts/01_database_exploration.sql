/*------------------------------------------------------------------------------------
1. DATABASE EXPLORATION
-------------------------------------------------------------------------------------
Purpose: 
  - To explore the structure of the database, i.e., tables and schemas
  - To inspect the columns within specific tables
*/

-- 1.1 Explore Objects in the Database: Check the metadata

SELECT *
FROM INFORMATION_SCHEMA.TABLES ;

-- 1.2 Explore All columns in the database for the products table

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';
