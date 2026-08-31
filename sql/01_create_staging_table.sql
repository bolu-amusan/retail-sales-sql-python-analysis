-- Staging table: mirrors raw CSV structure exactly, all columns as TEXT
-- to avoid failures from inconsistent formatting (e.g. mixed date formats)
CREATE TABLE staging_sales (
    row_id TEXT,
    order_id TEXT,
    order_date TEXT,
    ship_date TEXT,
    ship_mode TEXT,
    customer_id TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales TEXT,
    quantity TEXT,
    discount TEXT,
    profit TEXT
);