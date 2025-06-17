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