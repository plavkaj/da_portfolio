/*
===============================================================================
Project:        Telco Customer Churn Analysis
Script:         telco_customers.sql
Author:         Juraj Plavka
Description:    Data cleaning, EDA, and View creation for Power BI Dashboard.
===============================================================================
*/
use telco_customer;
-- 1. Table Creation & Setup
CREATE TABLE telco_churn
        (
                customerID       VARCHAR(50)   ,
                gender           VARCHAR(20)   ,
                SeniorCitizen    INT           ,
                Partner          VARCHAR(5)    ,
                Dependents       VARCHAR(5)    ,
                tenure           INT           ,
                PhoneService     VARCHAR(5)    ,
                MultipleLines    VARCHAR(20)   ,
                InternetService  VARCHAR(20)   ,
                OnlineSecurity   VARCHAR(20)   ,
                OnlineBackup     VARCHAR(20)   ,
                DeviceProtection VARCHAR(20)   ,
                TechSupport      VARCHAR(20)   ,
                StreamingTV      VARCHAR(20)   ,
                StreamingMovies  VARCHAR(20)   ,
                Contract         VARCHAR(20)   ,
                PaperlessBilling VARCHAR(5)    ,
                PaymentMethod    VARCHAR(50)   ,
                MonthlyCharges   DECIMAL(10, 2),
                TotalCharges     VARCHAR(50)   ,
                Churn            VARCHAR(5)
        )
;
-- 2. Data Quality Checks
-- Check for duplicate CustomerIDs
SELECT
        customerID,
        COUNT(*) as duplicate_count
FROM
        telco_churn
GROUP BY
        customerID
HAVING
        COUNT(*) > 1;
-- Check for NULLs or structural errors in key columns
SELECT
        COUNT(*) as total_rows,
        SUM(
                CASE
                WHEN
                        TotalCharges IS NULL
                        OR TotalCharges = 0
                THEN
                        1
                ELSE
                        0
                END) as missing_total_charges,
        SUM(
                CASE
                WHEN
                        MonthlyCharges IS NULL
                THEN
                        1
                ELSE
                        0
                END) as missing_monthly_charges,
        SUM(
                CASE
                WHEN
                        InternetService IS NULL
                        OR InternetService = ''
                THEN
                        1
                ELSE
                        0
                END) as missing_internet_service,
        SUM(
                CASE
                WHEN
                        Contract IS NULL
                        OR Contract = ''
                THEN
                        1
                ELSE
                        0
                END) as missing_contract,
        SUM(
                CASE
                WHEN
                        Churn IS NULL
                        OR Churn = ''
                THEN
                        1
                ELSE
                        0
                END) as missing_churn_label
FROM
        telco_churn;
-- Validate categorical values
SELECT DISTINCT
        Churn
FROM
        telco_churn;
SELECT DISTINCT
        InternetService
FROM
        telco_churn;
SELECT DISTINCT
        PaymentMethod
FROM
        telco_churn;
-- 3. Data Cleaning
-- Handle formatting issues in TotalCharges
UPDATE
        telco_churn
SET
        TotalCharges = NULL
WHERE
        TotalCharges = ' ';
-- 3. Data Cleaning
-- Handle formatting issues in TotalCharges
ALTER TABLE telco_churn MODIFY COLUMN TotalCharges DECIMAL(10, 2);
-- Handle NULL TotalCharges for new customers (Tenure = 0)
UPDATE
        telco_churn
SET
        TotalCharges = '0'
WHERE
        TotalCharges IS NULL;
-- 4. Exploratory Data Analysis (EDA)
/* Analysis 1: Product Reliability
Objective: Compare Churn Rate % between Fiber Optic and DSL.
*/
SELECT
        InternetService            ,
        COUNT(*) as total_customers,
        SUM(
                CASE
                WHEN
                        Churn = 'Yes'
                THEN
                        1
                ELSE
                        0
                END) as churned_customers,
        ROUND( SUM(
                CASE
                WHEN
                        Churn = 'Yes'
                THEN
                        1
                ELSE
                        0
                END) / COUNT(*) * 100, 1) as churn_rate_percent
FROM
        telco_churn
GROUP BY
        InternetService
ORDER BY
        churn_rate_percent DESC;
-- Insight: Fiber Optic Churn (41.9%) is double that of DSL (19%).
/* Follow-up: Price Sensitivity Check
Objective: Determine if churners are leaving due to high prices.
Compare Average Monthly Charges of Churned vs Retained users.
*/
SELECT
        InternetService            ,
        COUNT(*) as total_customers,
        ROUND(AVG(
                CASE
                WHEN
                        Churn = 'Yes'
                THEN
                        MonthlyCharges
                END), 2) as avg_price_churned,
        ROUND(AVG(
                CASE
                WHEN
                        Churn = 'No'
                THEN
                        MonthlyCharges
                END), 2) as avg_price_retained,
        ROUND( AVG(
                CASE
                WHEN
                        Churn = 'Yes'
                THEN
                        MonthlyCharges
                END) - AVG(
                CASE
                WHEN
                        Churn = 'No'
                THEN
                        MonthlyCharges
                END), 2) as price_difference
FROM
        telco_churn
WHERE
        InternetService != 'No'
GROUP BY
        InternetService;
-- Insight: Retained customers actually pay slightly MORE than churners. Price is likely not the primary driver.
/* Analysis 2: Service Support Impact
Objective: Determine if Tech Support reduces churn for Fiber Optic users.
*/
SELECT
        TechSupport                ,
        COUNT(*) as total_customers,
        -- Column 1: Churned customers
        SUM(
                CASE
                WHEN
                        Churn = 'Yes'
                THEN
                        1
                ELSE
                        0
                END) as churned_customers,
        -- Column 2: Retained customers
        ROUND( SUM(
                CASE
                WHEN
                        Churn = 'Yes'
                THEN
                        1
                ELSE
                        0
                END) / COUNT(*) * 100, 1) as churn_rate_percent
FROM
        telco_churn
WHERE
        InternetService = 'Fiber Optic'
GROUP BY
        TechSupport;
-- Insight: Tech Support reduces Fiber churn from 49.4% to 22.6%.
/* Analysis 3: Financial Risk & Payment Methods
Objective: Identify revenue loss from High-Value Customers (>$70/mo).
*/
SELECT
        tc.PaymentMethod                             ,
        COUNT(*)              as high_value_customers,
        SUM(tc.TotalCharges ) as total_revenue_lost
FROM
        telco_churn tc
WHERE
        tc.MonthlyCharges > 70
AND     tc.Churn          = 'Yes'
group BY
        PaymentMethod
order BY
        total_revenue_lost DESC;
-- Insight: Electronic Check is the highest loss segment (£1.6M+).
-- 5. Final View Creation
/* Objective: Create a clean Master View for Power BI import.
Includes 'High_Value_User' flag and numeric 'Churn_Count' for easier DAX calculations.
*/
CREATE VIEW vw_churn_data
AS
SELECT
        customerID   ,
        Gender       ,
        SeniorCitizen,
        Partner      ,
        Dependents   ,
        Tenure       ,
        -- 1. Create Tenure Groups (for easier charts)
        CASE
        WHEN
                Tenure <= 12
        THEN
                '< 1 Year'
        WHEN
                Tenure     > 12
                AND Tenure <= 24
        THEN
                '1-2 Years'
        WHEN
                Tenure     > 24
                AND Tenure <= 48
        THEN
                '2-4 Years'
        WHEN
                Tenure > 48
        THEN
                '> 4 Years'
        END AS Tenure_Group,
        PhoneService       ,
        MultipleLines      ,
        InternetService    ,
        OnlineSecurity     ,
        OnlineBackup       ,
        DeviceProtection   ,
        TechSupport        ,
        StreamingTV        ,
        StreamingMovies    ,
        Contract           ,
        PaperlessBilling   ,
        PaymentMethod      ,
        MonthlyCharges     ,
        TotalCharges       ,
        Churn              ,
        -- Binary Churn for math
        CASE
        WHEN
                Churn = 'Yes'
        THEN
                1
        ELSE
                0
        END AS Churn_Count,
        -- High Value Flag (> $70)
        CASE
        WHEN
                MonthlyCharges > 70
        THEN
                'Yes'
        ELSE
                'No'
        END AS High_Value_User
FROM
        telco_churn;