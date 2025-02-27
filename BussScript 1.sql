-- Checking Data Integrity

SELECT * 
FROM International_sale_Report LIMIT 10;

-- Step 1: Checking Total Sales Revenue and Orders

SELECT 
    SUM("GROSS AMT") AS Total_Revenue,
    COUNT(*) AS Total_Orders
FROM International_sale_Report;

-- Output: Total Revenue: $16,395,599.19 Total Orders: 37,432

-- Top-Selling Products by Revenue

SELECT 
    SKU, 
    SUM("GROSS AMT") AS Total_Revenue
FROM International_sale_Report
GROUP BY SKU
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Output: Top Product: SET268-KR-NP-L → $54,772 in revenue. 
-- Other high-revenue products: J0277-SKD-S: $43,676 J0277-SKD-M: $38,585 SET268-KR-NP-M: $37,566 SET268-KR-NP-XL: $34,102

-- Monthly Sales Trends

SELECT 
    Months, 
    SUM("GROSS AMT") AS Monthly_Revenue
FROM International_sale_Report
GROUP BY Months
ORDER BY Monthly_Revenue DESC;

-- Output: Top Performing Month: October 2021 → $2,865,134
-- Other high-revenue months:
-- February 2022: $2,412,848
-- March 2022: $1,706,862
-- November 2021: $1,378,104
-- September 2021: $1,294,808


-- Top Customers by Total Spending

SELECT 
    CUSTOMER, 
    SUM("GROSS AMT") AS Total_Spending
FROM International_sale_Report
GROUP BY CUSTOMER
ORDER BY Total_Spending DESC
LIMIT 10;

-- OUPUT: MULBERRIES BOUTIQUE → $2,094,070.50
 -- AMANI CONCEPT TRADING LLC (KAPDA) → $930,451.00
  -- VAHARSHA BOUTIQUE → $527,214.00
   -- GALAXY GROUP OF COMPANIES PVT. LTD → $445,058.00
    -- RIVAAN LLC → $443,042.00


-- Customer Segments & Average Order Value (AOV)

SELECT 
    CUSTOMER, 
    AVG("GROSS AMT") AS Average_Order_Value
FROM International_sale_Report
GROUP BY CUSTOMER
ORDER BY Average_Order_Value DESC
LIMIT 10;

-- OUTPUT: AANCHOL → $2,863 per order
  -- BHANU SALEINE NAUNITHAM → $2,773 per order
	-- SYEDA MORSHED → $2,735 per order
	-- AMANI CONCEPT TRADING LLC (KAPDA) → $2,720 per order
	-- Natheliya → $2,548 per order


--  Revenue Split: New vs. Returning Customers

SELECT 
    CUSTOMER, 
    COUNT(*) AS Order_Count, 
    SUM("GROSS AMT") AS Total_Spending
FROM International_sale_Report
GROUP BY CUSTOMER
HAVING Order_Count > 1
ORDER BY Order_Count DESC;

-- OUTPUT: Key Findings:
	-- Top Repeat Customer: MULBERRIES BOUTIQUE
	-- Orders: 2,121
	-- Total Spending: $2,094,070.50
	-- Insight: This boutique is your most valuable client and may benefit from a VIP loyalty program or exclusive offers.

		-- Other High-Value Repeat Customers:
		--COTTON CLOSET LTD → 657 orders, $345,265.00
		--VAHARSHA BOUTIQUE → 616 orders, $527,214.00
		--RIVAAN LLC → 508 orders, $443,042.00
		--GALAXY GROUP OF COMPANIES PVT. LTD → 452 orders, $445,058.00



-- Customer Retention Rate Calculation

SELECT 
    COUNT(DISTINCT CUSTOMER) AS Total_Customers,
    COUNT(DISTINCT CASE WHEN Order_Count > 1 THEN CUSTOMER END) AS Returning_Customers,
    ROUND((COUNT(DISTINCT CASE WHEN Order_Count > 1 THEN CUSTOMER END) * 100.0) / COUNT(DISTINCT CUSTOMER), 2) AS Retention_Rate
FROM (
    SELECT CUSTOMER, COUNT(*) AS Order_Count
    FROM International_sale_Report
    GROUP BY CUSTOMER
) AS Subquery;

-- OUTPUT: Total Unique Customers: 173
 -- Returning Customers: 172
 -- Customer Retention Rate: 99.42% 


-- Sales Trend by Product

SELECT 
    SKU, 
    Months,
    SUM("GROSS AMT") AS Total_Revenue
FROM International_sale_Report
GROUP BY SKU, Months
ORDER BY Total_Revenue DESC;

-- OUTPUT: 

--  Best Days of the Week for Sales

	-- Checking formatinng of date
SELECT DISTINCT DATE FROM International_sale_Report LIMIT 10;

-- USING LLM (chat gpt) TO FIX DATE FORMATTING

SELECT 
    DATE,
    SUBSTR(DATE, 7, 2) || '-'
    || SUBSTR(DATE, 4, 2) || '-'
    || SUBSTR(DATE, 1, 2) AS Reformatted_Date
FROM International_sale_Report
LIMIT 10;

SELECT 
    DATE,
    CASE 
        WHEN CAST(SUBSTR(DATE, 7, 2) AS INTEGER) < 50 
        THEN '20' || SUBSTR(DATE, 7, 2) || '-' || SUBSTR(DATE, 4, 2) || '-' || SUBSTR(DATE, 1, 2)
        ELSE '19' || SUBSTR(DATE, 7, 2) || '-' || SUBSTR(DATE, 4, 2) || '-' || SUBSTR(DATE, 1, 2)
    END AS Corrected_Date
FROM International_sale_Report
LIMIT 10;

SELECT 
    CASE 
        WHEN strftime('%w', Corrected_Date) = '0' THEN 'Sunday'
        WHEN strftime('%w', Corrected_Date) = '1' THEN 'Monday'
        WHEN strftime('%w', Corrected_Date) = '2' THEN 'Tuesday'
        WHEN strftime('%w', Corrected_Date) = '3' THEN 'Wednesday'
        WHEN strftime('%w', Corrected_Date) = '4' THEN 'Thursday'
        WHEN strftime('%w', Corrected_Date) = '5' THEN 'Friday'
        WHEN strftime('%w', Corrected_Date) = '6' THEN 'Saturday'
    END AS DayOfWeek,
    COUNT(*) AS Order_Count,
    SUM("GROSS AMT") AS Total_Revenue
FROM (
    SELECT 
        DATE,
        CASE 
            WHEN CAST(SUBSTR(DATE, 7, 2) AS INTEGER) < 50 
            THEN '20' || SUBSTR(DATE, 7, 2) || '-' || SUBSTR(DATE, 4, 2) || '-' || SUBSTR(DATE, 1, 2)
            ELSE '19' || SUBSTR(DATE, 7, 2) || '-' || SUBSTR(DATE, 4, 2) || '-' || SUBSTR(DATE, 1, 2)
        END AS Corrected_Date
    FROM International_sale_Report
) AS Fixed_Dates
GROUP BY DayOfWeek
ORDER BY Total_Revenue DESC;

SELECT 
    SUM("GROSS AMT") AS Total_Revenue,
    AVG("GROSS AMT") AS Avg_Revenue
FROM International_sale_Report;

SELECT 
    SUM(CAST("GROSS AMT" AS REAL)) AS Total_Revenue,
    AVG(CAST("GROSS AMT" AS REAL)) AS Avg_Revenue
FROM International_sale_Report;

SELECT 
    CASE 
        WHEN strftime('%w', Corrected_Date) = '0' THEN 'Sunday'
        WHEN strftime('%w', Corrected_Date) = '1' THEN 'Monday'
        WHEN strftime('%w', Corrected_Date) = '2' THEN 'Tuesday'
        WHEN strftime('%w', Corrected_Date) = '3' THEN 'Wednesday'
        WHEN strftime('%w', Corrected_Date) = '4' THEN 'Thursday'
        WHEN strftime('%w', Corrected_Date) = '5' THEN 'Friday'
        WHEN strftime('%w', Corrected_Date) = '6' THEN 'Saturday'
    END AS DayOfWeek,
    COUNT(*) AS Order_Count,
    SUM(CAST("GROSS AMT" AS REAL)) AS Total_Revenue
FROM (
    SELECT 
        DATE,
        CASE 
            WHEN CAST(SUBSTR(DATE, 7, 2) AS INTEGER) < 50 
            THEN '20' || SUBSTR(DATE, 7, 2) || '-' || SUBSTR(DATE, 4, 2) || '-' || SUBSTR(DATE, 1, 2)
            ELSE '19' || SUBSTR(DATE, 7, 2) || '-' || SUBSTR(DATE, 4, 2) || '-' || SUBSTR(DATE, 1, 2)
        END AS Corrected_Date,
        "GROSS AMT"
    FROM International_sale_Report
) AS Fixed_Dates
GROUP BY DayOfWeek
ORDER BY Total_Revenue DESC;

-- OUTPUT:
	-- Best Days for Sales (High Revenue & Orders)
	-- Thursday → $1,446,323 (Highest Revenue)
	-- Saturday → $1,286,592
	-- Tuesday → $1,172,562.45
-- Worst-Performing Days
	-- Sunday → $385,420.6 (Lowest Revenue)
	-- Friday → $568,703.0 

