# Dataset Schema Documentation

This document outlines the structure of the tables used in this SQL project. Each section describes the columns available in each `.csv` file along with a brief explanation. This serves as a data dictionary for easier understanding, querying, and analysis.

## Table of Contents

- [Entity Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
- [customers.csv](#customerscsv)
- [geolocations.csv](#geolocationscsv)
- [order_items.csv](#order_itemscsv)
- [orders.csv](#orderscsv)
- [payments.csv](#paymentscsv)
- [products.csv](#productscsv)
- [sellers.csv](#sellerscsv)

---

## Entity Relationship Diagram (ERD)

Below is the ERD that describes the relationships between the tables in the dataset:

![ERD](./erd/erd.png)

---

## 📁 customers.csv

| Column                     | Description                                                |
|----------------------------|------------------------------------------------------------|
| `customer_id`              | Unique ID of the customer who made the purchase           |
| `customer_unique_id`       | Unique identifier across all orders by a customer         |
| `customer_zip_code_prefix` | Zip code prefix of the customer’s location                |
| `customer_city`            | City from which the order was made                        |
| `customer_state`           | State code of the customer’s location (e.g., SP for São Paulo) |

---

## 📁 geolocations.csv

| Column                      | Description                          |
|-----------------------------|--------------------------------------|
| `geolocation_zip_code_prefix` | First 5 digits of the zip code     |
| `geolocation_lat`           | Latitude                             |
| `geolocation_lng`           | Longitude                            |
| `geolocation_city`          | City                                 |
| `geolocation_state`         | State                                |

---

## 📁 order_items.csv

| Column                | Description                                                               |
|------------------------|---------------------------------------------------------------------------|
| `order_id`            | Unique ID of the customer order                                           |
| `order_item_id`       | Sequential ID for each item in the order                                  |
| `product_id`          | Unique ID of the product                                                  |
| `seller_id`           | Unique ID of the seller                                                   |
| `shipping_limit_date` | Deadline by which the seller must ship the product                        |
| `price`               | Price of the product                                                      |
| `freight_value`       | Shipping fee charged for the item                                         |

---

## 📁 orders.csv

| Column                         | Description                                                     |
|--------------------------------|-----------------------------------------------------------------|
| `order_id`                     | Unique ID for the order                                         |
| `customer_id`                  | ID of the customer who placed the order                         |
| `order_status`                 | Status of the order (e.g., delivered, shipped)                  |
| `order_purchase_timestamp`     | Timestamp when the order was placed                             |
| `order_approved_at`            | Timestamp when the order was approved                           |
| `order_delivered_carrier_date` | Date the order was handed over to the carrier                   |
| `order_delivered_customer_date` | Date the customer received the order                          |
| `order_estimated_delivery_date` | Estimated delivery date for the order                          |

---

## 📁 payments.csv

| Column               | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| `order_id`           | Unique ID of the order                                             |
| `payment_sequential` | Sequence number for payment attempts (useful in installment plans) |
| `payment_type`       | Type of payment method (e.g., credit_card, boleto)                |
| `payment_installments` | Number of installments (in case of EMI)                         |
| `payment_value`      | Total amount paid for the order                                   |

---

## 📁 products.csv

| Column                     | Description                                                    |
|----------------------------|----------------------------------------------------------------|
| `product_id`               | Unique identifier for the product                              |
| `product_category_name`    | Name of the product category                                   |
| `product_name_length`      | Character length of the product name                           |
| `product_description_length` | Character length of the product description                  |
| `product_photos_qty`       | Number of photos available for the product                     |
| `product_weight_g`         | Weight of the product (in grams)                               |
| `product_length_cm`        | Length of the product (in centimeters)                         |
| `product_height_cm`        | Height of the product (in centimeters)                         |
| `product_width_cm`         | Width of the product (in centimeters)                          |

---

## 📁 sellers.csv

| Column                   | Description                                     |
|--------------------------|-------------------------------------------------|
| `seller_id`              | Unique ID of the seller                         |
| `seller_zip_code_prefix` | Zip code prefix of the seller’s location        |
| `seller_city`            | City where the seller is based                  |
| `seller_state`           | State code (e.g., SP for São Paulo)             |
