USE retail_sales_analytics;
SHOW TABLES;

CREATE TABLE superstore_sales_final (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,4),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,4)
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Superstore_Import.csv'
INTO TABLE retail_sales_analytics.superstore_sales_final
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @row_id, @order_id, @order_date, @ship_date,
    @ship_mode, @customer_id, @customer_name, @segment,
    @country, @city, @state, @postal_code, @region,
    @product_id, @category, @sub_category, @product_name,
    @sales, @quantity, @discount, @profit
)
SET
    row_id = NULLIF(@row_id, ''),
    order_id = @order_id,
    order_date = STR_TO_DATE(@order_date, '%m/%d/%Y'),
    ship_date = STR_TO_DATE(@ship_date, '%m/%d/%Y'),
    ship_mode = @ship_mode,
    customer_id = @customer_id,
    customer_name = @customer_name,
    segment = @segment,
    country = @country,
    city = @city,
    state = @state,
    postal_code = NULLIF(@postal_code, ''),
    region = @region,
    product_id = @product_id,
    category = @category,
    sub_category = @sub_category,
    product_name = @product_name,
    sales = NULLIF(@sales, ''),
    quantity = NULLIF(@quantity, ''),
    discount = NULLIF(@discount, ''),
    profit = NULLIF(@profit, '');
    
SELECT COUNT(*) AS total_records
FROM retail_sales_analytics.superstore_sales_final;

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS units_sold,
    ROUND(
        SUM(profit) / SUM(sales) * 100, 2
    ) AS profit_margin_percentage
FROM superstore_sales_final;

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales) * 100, 2
    ) AS profit_margin_percentage
FROM superstore_sales_final
GROUP BY category
ORDER BY total_profit DESC;		

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / SUM(sales) * 100, 2
    ) AS profit_margin_percentage
FROM superstore_sales_final
GROUP BY region
ORDER BY total_profit DESC;

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales) * 100, 2
    ) AS profit_margin_percentage
FROM superstore_sales_final
GROUP BY sub_category
ORDER BY total_profit DESC;

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM superstore_sales_final
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

SELECT
    discount,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit), 2) AS avg_profit_per_line
FROM superstore_sales_final
GROUP BY discount
ORDER BY discount;

SELECT
    product_name,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM superstore_sales_final
GROUP BY product_name, sub_category
ORDER BY total_profit ASC
LIMIT 10;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales_final
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

