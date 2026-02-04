CREATE DATABASE IF NOT EXISTS walmart_sales;
#Renaming Table
RENAME TABLE `walmartsalesdata.csv` TO sales;

SELECT * 
FROM sales;

# Creating new column called time_of_day

SELECT time,
(CASE 
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

ALTER TABLE sales
DROP COLUMN time_of_date;

UPDATE sales
SET time_of_day = (
CASE 
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END
);

# Create a new column called day_name to determine which days were the busiest for sales
SELECT date,
dayname(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = dayname(date);

# Create a new column called month_name to determine which months were the busiest for sales
SELECT date,
monthname(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = monthname(date);

# How many unique cities does the data have? 
SELECT DISTINCT(city)
FROM sales;

# In which city is each branch?
SELECT DISTINCT(city), branch
FROM sales;

# How many unique product line does the data have?
SELECT DISTINCT(`Product line`)
FROM sales;

# What is most common payment method?
SELECT DISTINCT(Payment), COUNT(Payment) AS Total_Count
FROM sales
GROUP BY Payment
ORDER BY Total_Count DESC;

# What is the most selling product line?
SELECT DISTINCT(`Product line`), COUNT(`Product line`) AS Total_Products
FROM sales
GROUP BY `Product line`
ORDER BY Total_Products DESC;

# What is the total revenue by Month?
SELECT month_name as Month, SUM(Total) as Total_Revenue
FROM sales
GROUP BY month_name;

# What month had the largest Cost of Goods Solds (COGS)?
SELECT month_name as Month, SUM(cogs) as goods_sold
FROM sales
GROUP BY month_name;

# What product line had the largest revenue?
SELECT `Product line`, SUM(Total) as total_revenue
FROM sales
GROUP BY `Product line`
ORDER BY total_revenue DESC;

# What is the city with the largest revenue?
SELECT branch, city, SUM(Total) as total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

# What product line had the largest VAT?
SELECT `Product line`, AVG(`Tax 5%`) as avg_tax
FROM sales
GROUP BY `Product line`
ORDER BY avg_tax DESC;

# Which branch sold more products than average product sold?
SELECT branch,
SUM(Quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM sales);

# What is the most product line by gender?
SELECT gender, `Product Line`, COUNT(gender) as total_count
FROM sales
GROUP BY gender, `Product Line`
ORDER BY total_count DESC;

# What is the average rating of each product line?
SELECT `Product Line`, ROUND(AVG(Rating),2) as avg_rating
FROM sales
GROUP BY `Product Line`
ORDER BY avg_rating DESC;

# Sales Analysis
# Number of sales made in each time of the day per weekday
SELECT time_of_day,
COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

# Which of the customer types brings the most revenue?
SELECT `Customer type`, SUM(Total) as total_revenue
FROM sales
GROUP BY `Customer type`
ORDER BY total_revenue DESC;

# Which city has the largest tax percent/ VAT?
SELECT city, AVG(`Tax 5%`) as VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

# Which customer type pays the most in VAT?
SELECT `Customer type`, AVG(`Tax 5%`) as VAT
FROM sales
GROUP BY `Customer type`
ORDER BY VAT DESC;

# Customer Information
# How many unique customer types does the data have?
SELECT DISTINCT(`Customer type`), COUNT(`Customer type`) AS customer_count
FROM sales
GROUP BY `Customer type`
ORDER BY customer_count DESC;

# How many unique payment methods does the data have?
SELECT DISTINCT(Payment), COUNT(Payment) AS payment_count
FROM sales
GROUP BY Payment
ORDER BY payment_count DESC;

# Which customer type buys the most?
SELECT DISTINCT(`Customer type`), SUM(Quantity) AS products_bought
FROM sales
GROUP BY `Customer type`
ORDER BY products_bought DESC;

# What is the gender of most of the customers?
SELECT DISTINCT(Gender), COUNT(`Customer type`) AS customer_count
FROM sales
GROUP BY Gender
ORDER BY customer_count DESC;

# What is the gender distribution per branch?
SELECT DISTINCT(branch), COUNT(Gender) as gender_count
FROM sales
GROUP BY branch
ORDER BY gender_count DESC;

# Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(Rating) AS avg_ratings
FROM sales
GROUP BY time_of_day
ORDER BY avg_ratings DESC;

# Which time of the day do customers give most ratings per branch?
SELECT DISTINCT(branch) as Branch, time_of_day, AVG(Rating) AS avg_ratings
FROM sales
GROUP BY time_of_day, Branch
ORDER BY avg_ratings DESC;

# Which day of the week has the best avg ratings?
SELECT day_name, AVG(Rating) as avg_rating
FROM sales
GROUP by day_name
ORDER BY avg_rating DESC;

# Which day of the week has the best average ratings per branch?
SELECT day_name, AVG(Rating) as avg_rating
FROM sales
WHERE branch = "B"
GROUP by day_name
ORDER BY avg_rating DESC;
