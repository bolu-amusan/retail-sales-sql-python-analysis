-- Normalized schema: customers, products, orders, order_items (fact table)

CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    region TEXT
);

CREATE TABLE products (
    product_id TEXT PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    sub_category TEXT
);

CREATE TABLE orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT REFERENCES customers(customer_id),
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id TEXT REFERENCES orders(order_id),
    product_id TEXT REFERENCES products(product_id),
    sales NUMERIC,
    quantity INTEGER,
    discount NUMERIC,
    profit NUMERIC
);