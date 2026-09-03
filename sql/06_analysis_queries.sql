-- ============================================
-- Analysis Queries
-- Business questions answered using the normalized schema
-- ============================================

-- 1. Overview: total orders, sales, profit, avg discount
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS total_line_items,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    ROUND(AVG(discount)::NUMERIC, 3) AS avg_discount
FROM order_items;

-- 2. Top 10 best-selling products by revenue
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(oi.sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2) AS total_profit,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_sales DESC
LIMIT 10;

-- 3. Discount analysis: do high discounts explain low/negative profit
--    on our top-revenue products?
SELECT
    p.product_name,
    p.category,
    ROUND(AVG(oi.discount)::NUMERIC, 3) AS avg_discount,
    ROUND(SUM(oi.sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2) AS total_profit,
    ROUND((SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100)::NUMERIC, 1) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_sales DESC
LIMIT 10;

-- 3b. Discount bands vs. average profit margin, across all order items
SELECT
    CASE
        WHEN discount = 0 THEN '0% (no discount)'
        WHEN discount <= 0.2 THEN '1-20%'
        WHEN discount <= 0.4 THEN '21-40%'
        WHEN discount <= 0.6 THEN '41-60%'
        ELSE '60%+'
    END AS discount_band,
    COUNT(*) AS line_items,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    ROUND((SUM(profit) / NULLIF(SUM(sales), 0) * 100)::NUMERIC, 1) AS profit_margin_pct
FROM order_items
GROUP BY discount_band
ORDER BY MIN(discount);

-- 4. Sales and profit performance by category and sub-category
SELECT
    p.category,
    p.sub_category,
    ROUND(SUM(oi.sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2) AS total_profit,
    ROUND((SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100)::NUMERIC, 1) AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY total_sales DESC;

-- 5. Sales and profit performance by region
SELECT
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2) AS total_profit,
    ROUND((SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100)::NUMERIC, 1) AS profit_margin_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_sales DESC;

-- 6. Month-over-month sales and profit trend
SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2) AS total_profit
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;

-- 7. Top 10 customers by total spend
SELECT
    c.customer_id,
    c.segment,
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2) AS total_profit
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.segment, c.region
ORDER BY total_sales DESC
LIMIT 10;

-- 8. Investigate the April 2017 loss anomaly
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    p.category,
    oi.sales,
    oi.discount,
    oi.profit
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= '2017-04-01' AND o.order_date < '2017-05-01'
ORDER BY oi.profit ASC
LIMIT 10;

-- 9. Investigate SM-20320's orders and discount levels
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    p.category,
    oi.sales,
    oi.discount,
    oi.profit
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.customer_id = 'SM-20320'
ORDER BY o.order_date;