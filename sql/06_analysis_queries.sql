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