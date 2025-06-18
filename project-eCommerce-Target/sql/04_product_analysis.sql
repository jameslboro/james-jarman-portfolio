/* 
================================================
Product Insights
================================================

Overview:
This section explores product-level performance, including return rates, shipping costs, and physical characteristics like weight and volume, using data from the 'target_ecommerce' schema.
*/

-- ================================================
-- Question 12: Which products/categories have the highest return rate (undelivered or canceled)?
-- ================================================

-- Return rate by product
SELECT
    oi.product_id,
    COUNT(*) FILTER (WHERE o.order_status IN ('canceled', 'unavailable'))::float / COUNT(*) AS return_rate,
    COUNT(*) AS total_orders
FROM
    target_ecommerce.order_items AS oi
INNER JOIN
    target_ecommerce.orders AS o ON oi.order_id = o.order_id
GROUP BY
    oi.product_id
HAVING
    COUNT(*) > 10 -- Only include products with more than 10 orders
    AND COUNT(*) FILTER (WHERE o.order_status IN ('canceled', 'unavailable'))::float / COUNT(*) > 0
ORDER BY
    return_rate DESC;

-- Return rate by product category
SELECT
    p.product_category,
    COUNT(*) FILTER (WHERE o.order_status IN ('canceled', 'unavailable'))::float / COUNT(*) AS return_rate,
    COUNT(*) AS total_orders
FROM
    target_ecommerce.order_items AS oi
INNER JOIN
    target_ecommerce.orders AS o ON oi.order_id = o.order_id
INNER JOIN
    target_ecommerce.products AS p ON oi.product_id = p.product_id
GROUP BY
    p.product_category
HAVING
    COUNT(*) > 10
    AND COUNT(*) FILTER (WHERE o.order_status IN ('canceled', 'unavailable'))::float / COUNT(*) > 0
ORDER BY
    return_rate DESC;


-- ================================================
-- Question 13: Are certain product categories more associated with high freight costs?
-- ================================================

SELECT
    p.product_category,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost,
    COUNT(*) AS num_orders
FROM
    target_ecommerce.order_items AS oi
INNER JOIN
    target_ecommerce.products AS p ON oi.product_id = p.product_id
GROUP BY
    p.product_category
ORDER BY
    avg_freight_cost DESC;


-- ================================================
-- Question 14: Which products have the highest weight or dimensional volume?
-- ================================================

-- Top 10 heaviest products (by weight in grams)
SELECT
    product_id,
    product_category,
    product_weight_g
FROM
    target_ecommerce.products
WHERE
    product_weight_g IS NOT NULL
ORDER BY
    product_weight_g DESC
LIMIT 10;

-- Top 10 largest products (by volume in cm³)
SELECT
    product_id,
    product_category,
    product_length_cm * product_height_cm * product_width_cm AS product_volume_cm3
FROM
    target_ecommerce.products
WHERE
    product_length_cm IS NOT NULL
    AND product_height_cm IS NOT NULL
    AND product_width_cm IS NOT NULL
ORDER BY
    product_volume_cm3 DESC
LIMIT 10;
