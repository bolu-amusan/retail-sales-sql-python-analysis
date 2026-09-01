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