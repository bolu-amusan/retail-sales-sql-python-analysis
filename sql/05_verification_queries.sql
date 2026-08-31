-- Sanity checks: confirm row counts match between staging and normalized tables

SELECT COUNT(*) FROM staging_sales;

SELECT COUNT(*) FROM customers;
SELECT COUNT(DISTINCT customer_id) FROM staging_sales;

SELECT COUNT(*) FROM products;
SELECT COUNT(DISTINCT product_id) FROM staging_sales;

SELECT COUNT(*) FROM orders;
SELECT COUNT(DISTINCT order_id) FROM staging_sales;

SELECT COUNT(*) FROM order_items;