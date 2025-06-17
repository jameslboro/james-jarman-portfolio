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
-- Alter "product category" to product_category
ALTER TABLE target_ecommerce.products RENAME COLUMN "product category" TO product_category;

-- Create sellers table
CREATE TABLE target_ecommerce.sellers (
    seller_id CHAR(32),
    seller_zip_code_prefix TEXT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);