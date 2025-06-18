/* 
================================================
Logistics & Shipping Performance
================================================

Overview:
This section analyses shipping efficiency by evaluating delivery times, delays, and their correlation with geographic distance using the 'target_ecommerce' schema.
*/

-- ================================================
-- Question 9: What's the average delivery time across different states?
-- ================================================

SELECT
    c.customer_state,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400),
        2
    ) AS avg_delivery_days
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    avg_delivery_days;


-- ================================================
-- Question 10: Which regions experience the longest delivery delays?
-- ================================================

SELECT
    c.customer_state,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 86400),
        2
    ) AS avg_delay_days
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    avg_delay_days DESC;


-- ================================================
-- Question 11: Is there a relationship between shipping distance and delivery delay?
-- ================================================

-- Step 1: Get average coordinates per zip code prefix
WITH geo AS (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS lat,
        AVG(geolocation_lng) AS lng
    FROM
        target_ecommerce.geolocation
    GROUP BY
        geolocation_zip_code_prefix
),

-- Step 2: Map customer IDs to their coordinates
customer_locs AS (
    SELECT
        c.customer_id,
        g.lat AS customer_lat,
        g.lng AS customer_lng
    FROM
        target_ecommerce.customers AS c
    INNER JOIN
        geo AS g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
),

-- Step 3: Map seller IDs to their coordinates
seller_locs AS (
    SELECT
        s.seller_id,
        g.lat AS seller_lat,
        g.lng AS seller_lng
    FROM
        target_ecommerce.sellers AS s
    INNER JOIN
        geo AS g ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
),

-- Step 4: Get each order with customer and seller info
order_pairs AS (
    SELECT
        o.order_id,
        o.customer_id,
        oi.seller_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date
    FROM
        target_ecommerce.orders AS o
    INNER JOIN
        target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
    WHERE
        o.order_delivered_customer_date IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
),

-- Step 5: Join to get locations
order_with_locations AS (
    SELECT
        op.*,
        cl.customer_lat,
        cl.customer_lng,
        sl.seller_lat,
        sl.seller_lng
    FROM
        order_pairs AS op
    INNER JOIN
        customer_locs AS cl ON op.customer_id = cl.customer_id
    INNER JOIN
        seller_locs AS sl ON op.seller_id = sl.seller_id
),

-- Step 6: Compute distance and delay
order_with_distance AS (
    SELECT
        *,
        -- Haversine formula (distance in kilometers)
        6371 * 2 * ASIN(
            SQRT(
                POWER(SIN(RADIANS((customer_lat - seller_lat) / 2)), 2) +
                COS(RADIANS(seller_lat)) * COS(RADIANS(customer_lat)) *
                POWER(SIN(RADIANS((customer_lng - seller_lng) / 2)), 2)
            )
        ) AS distance_km,
        EXTRACT(EPOCH FROM (order_delivered_customer_date - order_estimated_delivery_date)) / 86400 AS delivery_delay_days
    FROM
        order_with_locations
)

-- Step 7: Group by rounded distance to analyze relationship
SELECT
    ROUND(distance_km) AS distance_bucket_km,
    AVG(delivery_delay_days) AS avg_delivery_delay_days,
    COUNT(*) AS num_orders
FROM
    order_with_distance
GROUP BY
    distance_bucket_km
ORDER BY
    distance_bucket_km;
