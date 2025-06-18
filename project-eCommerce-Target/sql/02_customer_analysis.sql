/* 
================================================
Customer Behavior
================================================

Overview:
This analysis explores customer distribution by geography, repeat purchase behaviour, and high-value customer segmentation using the 'target_ecommerce' schema.
*/

-- ================================================
-- Question 5: Which states or cities have the highest number of unique customers?
-- ================================================

-- Unique Customers by State
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS unique_customers_count
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
GROUP BY
    c.customer_state
ORDER BY
    unique_customers_count DESC;

-- Unique Customers by City (Top City Only)
SELECT
    c.customer_city,
    COUNT(DISTINCT c.customer_id) AS unique_customers_count
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
GROUP BY
    c.customer_city
ORDER BY
    unique_customers_count DESC
LIMIT 1;

-- ================================================
-- Question 6: What is the repeat purchase rate of customers?
-- ================================================

-- Calculate percentage of customers with more than one order
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM
        target_ecommerce.orders AS o
    LEFT JOIN
        target_ecommerce.customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    ROUND(
        100.0 * COUNT(CASE WHEN num_orders > 1 THEN 1 END) / COUNT(*),
        2
    ) AS repeat_purchase_rate_percent
FROM
    customer_orders;

-- ================================================
-- Question 7: How many customers place multiple orders and how often?
-- ================================================

-- Count of repeat customers
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM
        target_ecommerce.orders AS o
    LEFT JOIN
        target_ecommerce.customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id
) AS customer_orders
WHERE
    num_orders > 1;

-- Frequency distribution of repeat customers
SELECT
    num_orders AS purchase_count,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM
        target_ecommerce.orders AS o
    LEFT JOIN
        target_ecommerce.customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id
) AS customer_orders
GROUP BY
    num_orders
ORDER BY
    num_orders;

-- ================================================
-- Question 8: Do high-value customers (top 10%) behave differently from others?
-- ================================================

-- Segment customers by spend percentile and compare behavior
WITH customer_spend AS (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS total_spent,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM
        target_ecommerce.orders AS o
    INNER JOIN
        target_ecommerce.payments AS p ON o.order_id = p.order_id
    LEFT JOIN
        target_ecommerce.customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id
),
spend_threshold AS (
    SELECT
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_spent) AS threshold
    FROM
        customer_spend
),
segmented_customers AS (
    SELECT
        cs.*,
        CASE
            WHEN cs.total_spent >= st.threshold THEN 'high_value'
            ELSE 'other'
        END AS segment
    FROM
        customer_spend AS cs
    CROSS JOIN
        spend_threshold AS st
)
SELECT
    segment,
    COUNT(*) AS customer_count,
    AVG(num_orders) AS avg_orders,
    AVG(total_spent) AS avg_spent
FROM
    segmented_customers
GROUP BY
    segment;