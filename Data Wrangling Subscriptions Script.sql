-- =====================================
-- CHECK IMPORTED DATA
-- =====================================

-- View the structure of the table (Check column names & data types)
PRAGMA table_info(raw_customer_transactions);

-- View the first few rows of the table
SELECT * 
FROM raw_customer_transactions
LIMIT 10;

PRAGMA table_info(raw_customer_transactions);


-- =====================================
-- STEP 2: FIX DATA TYPES (CONVERT TRANSACTION_DATE TO DATE FORMAT)
-- =====================================

-- 1. Convert and store transaction_date as a proper DATE format

UPDATE raw_customer_transactions
SET transaction_date_clean = DATE(transaction_date);

-- 2. Verify that the new column has proper date values

SELECT transaction_date, transaction_date_clean 
FROM raw_customer_transactions 
LIMIT 10;


-- =====================================
-- STEP 3: STANDARDIZE TEXT COLUMNS
-- =====================================

-- Convert text columns to consistent case formatting
UPDATE raw_customer_transactions
SET referral_type = LOWER(referral_type),   -- Convert referral type to lowercase
    transaction_type = UPPER(transaction_type),  -- Convert transaction type to uppercase
    customer_gender = UPPER(customer_gender);   -- Convert gender values to uppercase

-- Verify the changes
SELECT DISTINCT referral_type, transaction_type, customer_gender
FROM raw_customer_transactions;


-- =====================================
-- STEP 4: CHECK & REMOVE DUPLICATES
-- =====================================

-- 1. Identify duplicates based on customer ID and transaction date
SELECT cust_id, transaction_date_clean, COUNT(*) AS duplicate_count
FROM raw_customer_transactions
GROUP BY cust_id, transaction_date_clean
HAVING COUNT(*) > 1;

-- 2. Remove duplicates while keeping the earliest record
DELETE FROM raw_customer_transactions
WHERE rowid NOT IN (
    SELECT MIN(rowid) 
    FROM raw_customer_transactions 
    GROUP BY cust_id, transaction_date_clean
);

-- 3. Verify that duplicates are removed
SELECT cust_id, transaction_date_clean, COUNT(*) AS remaining_duplicates
FROM raw_customer_transactions
GROUP BY cust_id, transaction_date_clean
HAVING COUNT(*) > 1;


-- ====================================================
-- DATA NORMALIZATION
-- GOAL: Break down raw_customer_transactions into 
-- separate tables (customers, subscriptions, transactions)
-- ====================================================

-- ==========================================
--  STEP 1: CREATE CUSTOMERS TABLE
-- ==========================================
-- This table stores unique customer details
CREATE TABLE customers (
    cust_id INTEGER PRIMARY KEY,  -- Unique Customer ID
    customer_gender TEXT,          -- Gender (Male/Female)
    age_group TEXT,                -- Age Range (e.g., 18-24, 25-34)
    customer_country TEXT          -- Country of the customer
);

-- Insert unique customers from raw data into the customers table
INSERT INTO customers (cust_id, customer_gender, age_group, customer_country)
SELECT DISTINCT cust_id, customer_gender, age_group, customer_country
FROM raw_customer_transactions;

-- Verify the customer data was inserted correctly
SELECT * 
FROM customers 
LIMIT 10;


-- ==========================================
-- STEP 2: CREATE SUBSCRIPTIONS TABLE
-- ==========================================
-- This table stores subscription details for each customer
CREATE TABLE subscriptions (
    subscription_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique Subscription ID
    cust_id INTEGER,                -- Links to customers table
    subscription_type TEXT,          -- Subscription Plan (e.g., BASIC, PRO, MAX)
    subscription_price INTEGER,      -- Price of the subscription
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id) -- Maintain relational integrity
);

-- Insert unique subscription details from raw data into subscriptions table
INSERT INTO subscriptions (cust_id, subscription_type, subscription_price)
SELECT DISTINCT cust_id, subscription_type, subscription_price
FROM raw_customer_transactions;

-- Verify the subscription data was inserted correctly
SELECT * 
FROM subscriptions 
LIMIT 10;


-- ==========================================
-- STEP 3: CREATE TRANSACTIONS TABLE
-- ==========================================
-- This table stores all transaction history
CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique Transaction ID
    cust_id INTEGER,                 -- Customer ID (Foreign Key)
    transaction_type TEXT,            -- Type of transaction (INITIAL, REDUCTION, etc.)
    transaction_date DATE,            -- Date of the transaction
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id) -- Maintain relational integrity
);

-- Insert transaction records from raw data into transactions table
INSERT INTO transactions (cust_id, transaction_type, transaction_date)
SELECT cust_id, transaction_type, transaction_date_clean
FROM raw_customer_transactions;

-- Verify the transaction data was inserted correctly
SELECT * 
FROM transactions
LIMIT 10;


-- ==========================================
-- STEP 4: FINAL CHECKS - VERIFY DATA INTEGRITY
-- ==========================================

-- Count unique customers to confirm records were inserted properly
SELECT COUNT(*) AS total_customers 
FROM customers;

-- Count unique subscriptions to confirm records were inserted properly
SELECT COUNT(*) AS total_subscriptions 
FROM subscriptions;

-- Count total transactions to confirm records were inserted properly
SELECT COUNT(*) 
AS total_transactions FROM transactions;


-- ================================
-- Data Aggregation & Key Metrics
-- ================================

-- Calculate the total revenue from all subscriptions
SELECT SUM(subscription_price) AS total_revenue
FROM subscriptions;

-- Output $1,257,292

-- Calculate the average price of a subscription
SELECT ROUND(AVG(subscription_price), 2) AS avg_subscription_price
FROM subscriptions;

-- Output: $73.63

-- Calculate churn rate (percentage of customers who downgraded/canceled)
WITH churned_customers AS (
    SELECT COUNT(DISTINCT cust_id) AS churned_count
    FROM transactions
    WHERE transaction_type IN ('REDUCTION', 'CANCEL')
),
total_customers AS (
    SELECT COUNT(*) AS total_count FROM customers
)
SELECT 
    ROUND((churned_customers.churned_count * 100.0) / total_customers.total_count, 2) AS churn_rate_percentage
FROM churned_customers, total_customers;

-- Output 24.49%

-- Identify the top 5 highest spending customers

SELECT s.cust_id, SUM(s.subscription_price) AS total_spent
FROM subscriptions s
GROUP BY s.cust_id
ORDER BY total_spent DESC
LIMIT 5;

-- Output
-- Cust Id	Total Spent 
-- 9956		368
-- 8299		368
-- 7043		368
-- 7022		368
-- 991		368

-- Count the number of new subscriptions per month
SELECT 
    strftime('%Y-%m', t.transaction_date) AS month,
    COUNT(DISTINCT t.cust_id) AS new_subscriptions
FROM transactions t
WHERE t.transaction_type = 'INITIAL'
GROUP BY month
ORDER BY month;

--  Output:
-- - Highest new subscriptions recorded in March 2022 (318 new customers).
-- - Lowest new subscriptions recorded in September 2022 (255 new customers).
-- - Consistent trends across months, with an average monthly subscription rate of around 290-300 new customers.
-- - Growth spikes in early Q1 (January - March) each year, possibly due to seasonal demand or marketing campaigns.





