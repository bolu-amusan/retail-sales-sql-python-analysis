-- Load raw CSV into staging table
-- Run via psql (\copy is client-side, avoids server file-permission issues)
-- Note: pgAdmin's Import wizard generated an incorrect ESCAPE clause that
-- broke on embedded apostrophes; written manually here instead.
\copy staging_sales(row_id, order_id, order_date, ship_date, ship_mode, customer_id, segment, country, city, state, region, product_id, category, sub_category, product_name, sales, quantity, discount, profit) FROM 'data/superstore.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');