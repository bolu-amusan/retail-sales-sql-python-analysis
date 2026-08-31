-- Transform staging data into normalized tables
-- Dates are parsed with a CASE statement handling two mixed formats found
-- in the raw data: DD-MM-YYYY and M/D/YYYY (assumed US convention)

INSERT INTO customers (customer_id, segment, country, city, state, region)
SELECT DISTINCT ON (customer_id)
    customer_id,
    segment,
    country,
    city,
    state,
    region
FROM staging_sales
ORDER BY customer_id, row_id;

INSERT INTO products (product_id, product_name, category, sub_category)
SELECT DISTINCT ON (product_id)
    product_id,
    product_name,
    category,
    sub_category
FROM staging_sales
ORDER BY product_id, row_id;

INSERT INTO orders (order_id, customer_id, order_date, ship_date, ship_mode)
SELECT DISTINCT ON (order_id)
    order_id,
    customer_id,
    CASE
        WHEN order_date ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(order_date, 'DD-MM-YYYY')
        ELSE TO_DATE(order_date, 'MM/DD/YYYY')
    END AS order_date,
    CASE
        WHEN ship_date ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(ship_date, 'DD-MM-YYYY')
        ELSE TO_DATE(ship_date, 'MM/DD/YYYY')
    END AS ship_date,
    ship_mode
FROM staging_sales
ORDER BY order_id, row_id;

INSERT INTO order_items (order_id, product_id, sales, quantity, discount, profit)
SELECT
    order_id,
    product_id,
    sales::NUMERIC,
    quantity::INTEGER,
    discount::NUMERIC,
    profit::NUMERIC
FROM staging_sales;