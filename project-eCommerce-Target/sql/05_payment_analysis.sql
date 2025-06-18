/* 
================================================
Payment Behaviour
================================================

Overview:
This section analyses customer payment behaviour, including preferred payment types, average instalment durations, and revenue contribution from different payment methods using data from the 'target_ecommerce' schema.
*/

-- ================================================
-- Question 15: What are the most commonly used payment types by state or customer segment?
-- ================================================

-- Most commonly used payment types by state
SELECT
    c.customer_state,
    p.payment_type,
    COUNT(*) AS payment_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY c.customer_state), 2) AS percent_of_state
FROM
    target_ecommerce.payments AS p
INNER JOIN
    target_ecommerce.orders AS o ON p.order_id = o.order_id
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
GROUP BY
    c.customer_state, p.payment_type
ORDER BY
    c.customer_state, payment_count DESC;

-- Most commonly used payment types by customer segment
WITH customer_segments AS (
    SELECT
        c.customer_unique_id,
        CASE 
            WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'repeat'
            ELSE 'one_time'
        END AS segment
    FROM
        target_ecommerce.orders AS o
    INNER JOIN
        target_ecommerce.customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    cs.segment,
    p.payment_type,
    COUNT(*) AS payment_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY cs.segment), 2) AS percent_of_segment
FROM
    target_ecommerce.payments AS p
INNER JOIN
    target_ecommerce.orders AS o ON p.order_id = o.order_id
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
INNER JOIN
    customer_segments AS cs ON c.customer_unique_id = cs.customer_unique_id
GROUP BY
    cs.segment, p.payment_type
ORDER BY
    cs.segment, payment_count DESC;


-- ================================================
-- Question 16: What’s the average instalment plan length for orders by value or category?
-- ================================================

-- Average instalments by order value segment
SELECT
    CASE
        WHEN o.total_value < 100 THEN 'Low (<$100)'
        WHEN o.total_value < 500 THEN 'Medium ($100-$499)'
        ELSE 'High ($500+)'
    END AS value_segment,
    ROUND(AVG(p.payment_installments), 2) AS avg_installments,
    COUNT(*) AS num_orders
FROM (
    SELECT
        o.order_id,
        SUM(oi.price) AS total_value
    FROM
        target_ecommerce.orders AS o
    INNER JOIN
        target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
    GROUP BY
        o.order_id
) AS o
INNER JOIN
    target_ecommerce.payments AS p ON o.order_id = p.order_id
GROUP BY
    value_segment
ORDER BY
    avg_installments;

-- Average installments by product category
SELECT
    pr.product_category,
    ROUND(AVG(p.payment_installments), 2) AS avg_installments,
    COUNT(*) AS num_orders
FROM
    target_ecommerce.payments AS p
INNER JOIN
    target_ecommerce.order_items AS oi ON p.order_id = oi.order_id
INNER JOIN
    target_ecommerce.products AS pr ON oi.product_id = pr.product_id
GROUP BY
    pr.product_category
HAVING
    COUNT(*) > 10 -- Only include categories with more than 10 orders
ORDER BY
    avg_installments DESC;


-- ================================================
-- Question 17: How much revenue is coming from instalment payments vs upfront?
-- ================================================

SELECT
    CASE
        WHEN p.payment_installments = 1 THEN 'upfront'
        ELSE 'instalment'
    END AS payment_type,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    COUNT(*) AS num_payments
FROM
    target_ecommerce.payments AS p
GROUP BY
    CASE
        WHEN p.payment_installments = 1 THEN 'upfront'
        ELSE 'instalment'
    END;