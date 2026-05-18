-- =============================================================
-- BASIC AGGREGATES
-- =============================================================

-- 1 Total number of sales transactions
SELECT COUNT(*) AS total_transactions FROM sales;

-- 2 Total revenue generated (all time)
SELECT
    ROUND(SUM(quantity * unit_price * (1 - discount_pct / 100)), 2) AS total_revenue
FROM sales;

-- 3 Overall average order value
SELECT
    ROUND(AVG(quantity * unit_price * (1 - discount_pct / 100)), 2) AS avg_order_value
FROM sales;

-- 4 Largest and smallest single transaction value
SELECT
    ROUND(MAX(quantity * unit_price * (1 - discount_pct / 100)), 2) AS biggest_sale,
    ROUND(MIN(quantity * unit_price * (1 - discount_pct / 100)), 2) AS smallest_sale
FROM sales;

-- 5 Total units sold across all products
SELECT SUM(quantity) AS total_units_sold FROM sales;

-- 6 Date range of sales data
SELECT
    MIN(sale_date) AS first_sale,
    MAX(sale_date) AS last_sale
FROM sales;


-- =============================================================
-- REVENUE REPORTS
-- =============================================================

-- 1 Total revenue per product (with product name)
SELECT
    p.product_name,
    p.category,
    COUNT(s.sale_id)                                                  AS times_sold,
    SUM(s.quantity)                                                   AS units_sold,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

-- 2 Total revenue per customer
SELECT
    c.full_name,
    COUNT(s.sale_id)                                                  AS orders,
    SUM(s.quantity)                                                   AS units_bought,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- 3 Revenue by customer segment
SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id)                                     AS customers,
    COUNT(s.sale_id)                                                  AS transactions,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_revenue,
    ROUND(AVG(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS avg_order_value
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC;

-- 4 Revenue by payment mode
SELECT
    payment_mode,
    COUNT(*)                                                          AS transactions,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2)   AS total_revenue,
    ROUND(AVG(quantity * unit_price * (1 - discount_pct/100)), 2)   AS avg_transaction
FROM sales
GROUP BY payment_mode
ORDER BY total_revenue DESC;

-- 5 Profit report per product
SELECT
    p.product_name,
    p.category,
    SUM(s.quantity)                                                     AS units_sold,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS revenue,
    ROUND(SUM(s.quantity * p.cost_price), 2)                           AS total_cost,
    ROUND(
        SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100))
        - SUM(s.quantity * p.cost_price), 2)                           AS profit,
    ROUND(
        (SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100))
        - SUM(s.quantity * p.cost_price))
        / SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)) * 100, 1) AS profit_margin_pct
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY profit DESC;

-- =============================================================
-- CATEGORY ANALYSIS
-- =============================================================

-- 1 Total revenue per category
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)                                        AS products_in_category,
    COUNT(s.sale_id)                                                    AS transactions,
    SUM(s.quantity)                                                     AS units_sold,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_revenue,
    ROUND(AVG(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS avg_order_value
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 2 Best-selling product in each category (most units sold)
SELECT
    category,
    product_name,
    units_sold
FROM (
    SELECT
        p.category,
        p.product_name,
        SUM(s.quantity) AS units_sold,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) AS rnk
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY p.category, p.product_id, p.product_name
) ranked
WHERE rnk = 1
ORDER BY units_sold DESC;

-- 3 Average discount offered per category
SELECT
    p.category,
    ROUND(AVG(s.discount_pct), 2) AS avg_discount_pct,
    MAX(s.discount_pct)           AS max_discount_given
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_discount_pct DESC;

-- =============================================================
-- CITY-WISE ANALYTICS
-- =============================================================

-- 1 Total revenue per city
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id)                                       AS customers,
    COUNT(s.sale_id)                                                    AS transactions,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- 2 Average order value per city
SELECT
    c.city,
    COUNT(s.sale_id)                                                    AS orders,
    ROUND(AVG(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS avg_order_value,
    ROUND(MIN(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS min_order,
    ROUND(MAX(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS max_order
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY avg_order_value DESC;

-- 3 Most popular product category per city
SELECT
    city,
    category,
    units_sold
FROM (
    SELECT
        c.city,
        p.category,
        SUM(s.quantity) AS units_sold,
        RANK() OVER (PARTITION BY c.city ORDER BY SUM(s.quantity) DESC) AS rnk
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN products  p ON s.product_id  = p.product_id
    GROUP BY c.city, p.category
) ranked
WHERE rnk = 1
ORDER BY city;

-- 4 State-wise revenue summary
SELECT
    c.state,
    COUNT(DISTINCT c.city)                                              AS cities,
    COUNT(DISTINCT c.customer_id)                                       AS customers,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_revenue DESC;


USE sales_analytics;
GO

-- =============================================================
-- MONTHLY TRENDS
-- =============================================================

-- 1 Monthly revenue for all time
SELECT
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    DATENAME(MONTH, sale_date) AS month_name,
    COUNT(sale_id) AS transactions,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2) AS monthly_revenue
FROM sales
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date),
    DATENAME(MONTH, sale_date)
ORDER BY sale_year, sale_month;
GO

-- 2 Best month by revenue
SELECT TOP 1
    YEAR(sale_date) AS sale_year,
    DATENAME(MONTH, sale_date) AS best_month,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2) AS revenue
FROM sales
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date),
    DATENAME(MONTH, sale_date)
ORDER BY revenue DESC;
GO

-- 3 Year-wise revenue comparison
SELECT
    YEAR(sale_date) AS sale_year,
    COUNT(sale_id) AS transactions,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2) AS annual_revenue
FROM sales
GROUP BY YEAR(sale_date)
ORDER BY sale_year;
GO

-- 4 Monthly average order value trend
SELECT
    YEAR(sale_date) AS sale_year,
    DATENAME(MONTH, sale_date) AS month_name,
    MONTH(sale_date) AS month_num,
    ROUND(AVG(quantity * unit_price * (1 - discount_pct/100)), 2) AS avg_order_value
FROM sales
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date),
    DATENAME(MONTH, sale_date)
ORDER BY sale_year, month_num;
GO

-- =============================================================
-- TOP-N REPORTS
-- =============================================================

-- 1 Top 5 customers by total spend
SELECT TOP 5
    c.full_name,
    c.city,
    c.segment,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_spent
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.full_name,
    c.city,
    c.segment
ORDER BY total_spent DESC;
GO

-- 2 Top 5 products by revenue
SELECT TOP 5
    p.product_name,
    p.category,
    ROUND(SUM(s.quantity * s.unit_price * (1 - s.discount_pct/100)), 2) AS total_revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC;
GO

-- 3 Top 3 cities by number of transactions
SELECT TOP 3
    c.city,
    COUNT(s.sale_id) AS transaction_count
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY transaction_count DESC;
GO

-- =============================================================
-- PAYMENT MODE ANALYSIS
-- =============================================================

-- 1 Revenue and transaction count by payment mode
SELECT
    payment_mode,
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2) AS revenue,
    ROUND(AVG(quantity * unit_price * (1 - discount_pct/100)), 2) AS avg_order
FROM sales
GROUP BY payment_mode
ORDER BY revenue DESC;
GO

-- 2 Payment mode preference per city
SELECT
    c.city,
    s.payment_mode,
    COUNT(*) AS usage_count
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.city,
    s.payment_mode
ORDER BY c.city, usage_count DESC;
GO

-- 3 Most used payment mode overall
SELECT TOP 1
    payment_mode,
    COUNT(*) AS times_used
FROM sales
GROUP BY payment_mode
ORDER BY times_used DESC;
GO


-- =============================================================
-- DISCOUNT ANALYSIS
-- =============================================================

-- 1 Total revenue lost due to discounts
SELECT
    ROUND(SUM(quantity * unit_price * discount_pct / 100), 2) AS total_discount_given,
    ROUND(SUM(quantity * unit_price), 2) AS gross_revenue,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2) AS net_revenue
FROM sales;
GO

-- 2 Average discount by product category
SELECT
    p.category,
    ROUND(AVG(s.discount_pct), 2) AS avg_discount_pct,
    COUNT(s.sale_id) AS sales_with_discount
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.discount_pct > 0
GROUP BY p.category
ORDER BY avg_discount_pct DESC;
GO

-- 3 Transactions with no discount vs with discount
SELECT
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        ELSE 'Discounted'
    END AS discount_type,
    COUNT(*) AS transactions,
    ROUND(SUM(quantity * unit_price * (1 - discount_pct/100)), 2) AS revenue
FROM sales
GROUP BY
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        ELSE 'Discounted'
    END;
GO

-- =============================================================
-- EXECUTIVE DASHBOARD QUERIES
-- =============================================================
xxxxx