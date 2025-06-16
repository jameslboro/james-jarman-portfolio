-- Create the database schema for the eCommerce Target project

CREATE SCHEMA IF NOT EXISTS target_ecommerce;

-- Create tables in the target_ecommerce schema

-- Create customers table
CREATE TABLE target_ecommerce.customers (
    customer_id CHAR(32),
    customer_unique_id CHAR(32),
    customer_zip_code_prefix TEXT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);
-- Create geolocation table
CREATE TABLE target_ecommerce.geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
-- Create order_items table
CREATE TABLE target_ecommerce.order_items (
    order_id CHAR(32),
    order_item_id INTEGER,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10, 2),
    freight_value NUMERIC(10, 2)
);
-- Create orders table
CREATE TABLE target_ecommerce.orders (
    order_id CHAR(32),
    customer_id CHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
-- Create payments table
CREATE TABLE target_ecommerce.payments (
    order_id CHAR(32),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value NUMERIC(10, 2)
);
-- Create products table
CREATE TABLE target_ecommerce.products (
    product_id CHAR(32),
    "product category" VARCHAR(100),
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);
-- Create sellers table
CREATE TABLE target_ecommerce.sellers (
    seller_id CHAR(32),
    seller_zip_code_prefix TEXT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);


-- Load data into tables from a CSV file using PostgreSQL's \COPY command
-- These commands should be run in the psql command line interface.
-- -- customers table
-- \COPY target_ecommerce.customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/customers.csv' DELIMITER ',' CSV HEADER
-- -- geolocation table
-- \COPY target_ecommerce.geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/geolocation.csv' DELIMITER ',' CSV HEADER 
-- -- order_items table
-- \COPY target_ecommerce.order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/order_items.csv' DELIMITER ',' CSV HEADER
-- -- orders table
-- \COPY target_ecommerce.orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/orders.csv' DELIMITER ',' CSV HEADER
-- -- payments table
-- \COPY target_ecommerce.payments (order_id, payment_sequential, payment_type, payment_installments, payment_value) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/payments.csv' DELIMITER ',' CSV HEADER
-- -- products table
-- \COPY target_ecommerce.products (product_id, "product category", product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/products.csv' DELIMITER ',' CSV HEADER
-- -- sellers table
-- \COPY target_ecommerce.sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state) FROM 'C:/Users/james/james-jarman-portfolio/project-eCommerce-Target/data/sellers.csv' DELIMITER ',' CSV HEADER