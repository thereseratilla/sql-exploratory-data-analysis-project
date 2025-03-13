/*------------------------------------------------------------------------------------
1. DATABASE EXPLORATION
-------------------------------------------------------------------------------------*/

-- 1.1 Explore Objects in the Database: Check the metadata

SELECT *
FROM INFORMATION_SCHEMA.TABLES ;

-- 1.2 Explore All Columns in the Database: the structure, naming, type, etc.

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';
