/*
===============================================================================
Project:        Sales Performance & Commission Simulator
Script:         01_Data_Cleaning.sql
Author:         Juraj Plavka
Description:    This script sets up the database, creates the schema for raw
and clean data, and executes the ETL pipeline.
===============================================================================
*/
-- 1. Database setup. Creates database if does not exist
CREATE DATABASE
IF
        NOT EXISTS portfolio_retail CHARACTER
        SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- 2. use Database
USE portfolio_retail;
DROP TABLE IF EXISTS retail_sales;
-- 3 Create staging table for CSV import
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
        (
                Invoice     VARCHAR(50) ,
                StockCode   VARCHAR(50) ,
                Description VARCHAR(255),
                Quantity    VARCHAR(20) , -- Load as text to handle format errors
                InvoiceDate VARCHAR(50) , -- Load as text to handle format errors
                Price       VARCHAR(20) , -- Load as text to handle format errors
                CustomerID  VARCHAR(50) ,
                Country     VARCHAR(50)
        )
;
-- 4. Create production table structure to ensure optimal data types and performance
DROP TABLE IF EXISTS retail_clean;
CREATE TABLE retail_clean
        (
                Invoice     VARCHAR(50)   ,
                StockCode   VARCHAR(50)   ,
                Description VARCHAR(255)  ,
                Quantity    INT           ,
                InvoiceDate DATETIME      ,
                Price       DECIMAL(10, 2), -- Currency format
                CustomerID  VARCHAR(20)   ,
                Country     VARCHAR(50)   ,
                Revenue     DECIMAL (10,2) -- Calculated Measure
        )
;
-- 5. ETL Pipeline
TRUNCATE TABLE retail_clean; -- Clear the table before loading to prevent duplicates
INSERT INTO retail_clean
        (
                Invoice    ,
                StockCode  ,
                Description,
                Quantity   ,
                InvoiceDate,
                Price      ,
                CustomerID ,
                Country    ,
                Revenue
        )
SELECT
        Invoice                                         ,
        StockCode                                       ,
        Description                                     ,
        CAST(Quantity AS SIGNED)          AS Quantity   , -- Quantity: Convert to integer
        CAST(InvoiceDate AS DATETIME)     AS InvoiceDate, -- Date: Convert to DateTime
        CAST(Price AS DECIMAL(10,2))      AS Price      , -- Convert text to Decimal
        CAST(CustomerID AS DECIMAL(10,0)) AS CustomerID , -- CustomerID: Strip the ".0" artifact
        Country                                         ,
        (CAST(Quantity AS SIGNED) * CAST(Price AS DECIMAL(10,2))) AS Revenue -- Revenue Calculation
FROM
        retail_sales
WHERE
        -- Rule 1: Remove Cancellations (Invoice starts with 'C')
        Invoice NOT LIKE 'C%'
        -- Rule 2: Remove System Errors (Negative quantity without 'C')
AND     Quantity > 0
        -- Rule 3: Valid Price
AND     Price > 0
        -- Rule 4: Valid Customer
AND     CustomerID IS NOT NULL
AND     CustomerID <> '';
/* FINAL CHECK
Expected Row Count: ~805,549
*/
SELECT
        COUNT(*)
FROM
        retail_clean;
