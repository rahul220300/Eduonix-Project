-- Create database if not exists
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Use the database
USE walmartSales;

-- Create table for sales data
CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    time TIMESTAMP NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT(11, 9),
    gross_income DECIMAL(10, 2),
    rating FLOAT(2, 1)
);

-- Add time_of_day column
ALTER TABLE sales
ADD time_of_day VARCHAR(10);

UPDATE sales
SET time_of_day = CASE
    WHEN HOUR(time) >= 0 AND HOUR(time) < 12 THEN 'Morning'
    WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
    ELSE 'Evening'
END;

-- Add day_name column
ALTER TABLE sales
ADD day_name VARCHAR(10);

UPDATE sales
SET day_name = UPPER(DATE_FORMAT(date, '%a'));

-- Add month_name column
ALTER TABLE sales
ADD month_name VARCHAR(10);

UPDATE sales
SET month_name = UPPER(DATE_FORMAT(date, '%b'));

-- Generic Questions
-- How many unique cities does the data have?
SELECT COUNT(DISTINCT city) AS unique_cities
FROM sales;

-- In which city is each branch?
SELECT branch, city
FROM sales
GROUP BY branch, city;

-- Product Questions
-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) AS unique_product_lines
FROM sales;

-- What is the most common payment method?
SELECT payment_method, COUNT(*) AS count
FROM sales
GROUP BY payment_method
ORDER BY count DESC
LIMIT 1;

-- What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- What product line had the largest VAT?
SELECT product_line, SUM(VAT) AS total_VAT
FROM sales
GROUP BY product_line
ORDER BY total_VAT DESC
LIMIT 1;

-- Which branch sold more products than average product sold?
SELECT branch
FROM (
    SELECT branch, AVG(quantity) AS avg_quantity
    FROM sales
    GROUP BY branch
) AS avg_sales
WHERE quantity > avg_quantity;

-- Sales Questions
-- Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(*) AS sales_count
FROM sales
GROUP BY day_name, time_of_day;

-- Which customer type brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- Which city has the largest VAT (Value Added Tax)?
SELECT city, AVG(VAT) AS avg_VAT
FROM sales
GROUP BY city
ORDER BY avg_VAT DESC
LIMIT 1;

-- Which customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS total_VAT
FROM sales
GROUP BY customer_type
ORDER BY total_VAT DESC
LIMIT 1;
