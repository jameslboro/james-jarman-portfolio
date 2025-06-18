/* 
================================================
Geospatial & Regional Insights
================================================

Overview:
This section analyses regional patterns in the data, including the geographic distribution of orders across Brazilian states and the impact of urban vs. rural location on delivery times.
*/

-- ================================================
-- Question 18: What is the distribution of orders across Brazilian states?
-- ================================================

SELECT
    c.customer_state,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percent_of_total
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
GROUP BY
    c.customer_state
ORDER BY
    order_count DESC;


-- ================================================
-- Question 19: Do rural or urban areas tend to have longer delivery times?
-- ================================================

-- Step 1: Classify zip code prefixes as urban or rural based on address density
WITH zip_density AS (
    SELECT
        geolocation_zip_code_prefix,
        COUNT(DISTINCT geolocation_lat || ',' || geolocation_lng) AS address_count
    FROM
        target_ecommerce.geolocation
    GROUP BY
        geolocation_zip_code_prefix
),
area_type AS (
    SELECT
        geolocation_zip_code_prefix,
        CASE
            WHEN address_count >= 20 THEN 'urban'
            ELSE 'rural'
        END AS area_type
    FROM
        zip_density
),

-- Step 2: Link area classification with customers and orders to calculate delivery times
customer_area AS (
    SELECT
        c.customer_id,
        a.area_type
    FROM
        target_ecommerce.customers AS c
    INNER JOIN
        area_type AS a ON c.customer_zip_code_prefix = a.geolocation_zip_code_prefix
)
SELECT
    ca.area_type,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400), 2) AS avg_delivery_days,
    COUNT(*) AS num_orders
FROM
    target_ecommerce.orders AS o
INNER JOIN
    customer_area AS ca ON o.customer_id = ca.customer_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    ca.area_type;
