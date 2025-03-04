# [Project 1:](https://github.com/AyaanS001/SQL/blob/main/E-CommerceScript.sql)
 ## [E-Commerce Sales Analysis](https://github.com/AyaanS001/SQL/blob/main/E-CommerceScript.sql) - SQL
 ### Overview: This project analyzes sales performance using an E-Commerce Sales Dataset with SQLite and DBeaver. The goal is to extract key business insights related to:
Total sales revenue & order trends,
Top-selling products,
Customer buying patterns,
Seasonal sales trends,
Best days of the week for sales.

#### Key Business Questions to Answer:
1) What are the total sales revenue and the number of orders?
2) Which products generate the most revenue?
3) What are the monthly sales trends?
4) Who are the top customers by total spending?
5) Which days of the week see the highest sales?
6) What is the average order value (AOV), and how does it vary by customer segment?
7) Which product categories contribute the most to total revenue, and how has their performance changed over time?
8) What is the customer retention rate based on repeat purchases?
9) What percentage of revenue comes from new vs. returning customers?
10) How do discounts and promotions impact sales volume and revenue?

# Key Insights & Findings

## Total Revenue & Orders

Total Sales Revenue: $16,395,599.19

Total Orders: 37,432

This confirms a strong revenue stream with a healthy number of transactions.

# Top-Selling Products

(Included Outputs in the actual SQL File)

October 2021 had the highest sales activity, indicating a peak demand period.

# Best Customers by Total Spending

Customer

Total Spending ($)

MULBERRIES BOUTIQUE

$2,094,070.50

AMANI CONCEPT TRADING LLC

$930,451.00

VAHARSHA BOUTIQUE

$527,214.00

 These customers contributed significantly to revenue and could be targeted for loyalty programs.

# Monthly Sales Trends

Month

Total Revenue ($)

April 2022

$1,186,090.75

May 2022

$224,483.44

April saw a major revenue spike, while May had a significant drop. Investigating this change can reveal insights into seasonality or promotions.

# Best Days of the Week for Sales

Day

Total Revenue ($)

Thursday

$1,446,323

Saturday

$1,286,592

Tuesday

$1,172,562

Sales are strongest on Thursdays and Saturdays, suggesting optimal days for promotions and marketing pushes.

# Customer Retention Rate

Retention Rate: 99.42%
Most customers make repeat purchases, indicating strong customer loyalty.

### ALL DATA USED FOR THIS PROJECT WAS THROUGH KAGGLE THE CSV FILE IS INCLUDED AND CALLED INTERNATIONAL SALE REPORT


=================================================================================================================================



# [Project 2](https://github.com/AyaanS001/SQL/blob/main/Data%20Wrangling%20Subscriptions%20Script.sql)
## SQL Data Wrangling Project: Customer Subscriptions Analysis

### Overview
This project showcases my **SQL data wrangling** skills using **DBeaver with SQLite**. The dataset contains **customer subscription and transaction details** from an e-commerce platform. I performed **data cleaning, normalization, aggregation, and visualization** to derive key business insights.

---

## Key Steps in Data Wrangling
### **Data Cleaning**
✅ Checked for missing values and inconsistencies.  
✅ Standardized **text columns** (lowercase/uppercase).  
✅ Converted **transaction dates** from TEXT to DATE format.  
✅ Removed **duplicate records** while preserving the earliest transaction.

###  Technologies & Tools Used
✅ **SQL (SQLite via DBeaver)** – Data wrangling, cleaning, querying, aggregation.  
✅ **Python (Matplotlib, Pandas)** – Data visualization and trend analysis.  
✅ **GitHub** – Documentation and portfolio showcase.  

### **Data Normalization**
The raw dataset was **split into three relational tables** for better structure:
- **`customers`**: Stores customer details (ID, gender, age group, country).
- **`subscriptions`**: Tracks subscription plans and pricing per customer.
- **`transactions`**: Records customer transactions (initial signups, reductions, cancellations).

### **Data Aggregation & Key Metrics**
✅ **Total Revenue**: The Sum of all subscription payments.  
✅ **Average Subscription Price**: Helps analyze customer spending trends.  
✅ **Customer Churn Rate**: % of users who downgraded or canceled subscriptions.  
✅ **Top High-Value Customers**: Identified based on total spending.  
✅ **Subscription Trends Over Time**: Tracked new signups per month.

### **Data Visualization (Matplotlib)**
- **Subscription Trends Over Time:** 📈 Created a **line chart** to visualize **monthly new subscriptions**.
- **Enhanced Trend Analysis:** 🔴 Added a **moving average trendline** and highlighted key **peak/low months**.

---

## Project Results
- ** Peak Subscription Month:** March 2022 (**318 new subscriptions**).  
- ** Lowest Subscription Month:** September 2022 (**255 new subscriptions**).  
- ** Average Monthly Subscriptions:** ~290-300 new customers.  
- ** Churn Rate Insights:** Customers tend to churn **after 6+ months** of subscription.

---
![output](https://github.com/user-attachments/assets/d023d29f-fc10-4cde-9afc-73210bbdcf10)

- **Key Insights from the Chart:**
  - Clear seasonal trends: Noticeable spikes at the start of each year (January - March).
  - Biggest spike in March 2022 (318 new subscriptions).
  - Lowest subscriptions in September 2022 (255 new subscriptions).
  - Consistent monthly fluctuations between 270-310 new subscriptions.






