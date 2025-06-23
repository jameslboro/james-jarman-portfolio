
-- ================================================
-- Exploratory: Investigating Revenue Discrepancies
-- ================================================

-- Revenue using order_items Table (for comparison)
SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp)::INT AS order_year,
    SUM(COALESCE(oi.price, 0) + COALESCE(oi.freight_value, 0)) AS total_revenue
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
WHERE
    o.order_status IN ('shipped', 'delivered')
GROUP BY
    order_year
ORDER BY
    order_year;

-- Revenue using payments (again, for comparison)
SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp)::INT AS order_year,
    SUM(COALESCE(p.payment_value, 0)) AS total_revenue
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.payments AS p ON o.order_id = p.order_id
WHERE
    o.order_status IN ('shipped', 'delivered')
GROUP BY
    order_year
ORDER BY
    order_year;

-- Result: The two queries above do not match. A deeper investigation is required.

-- ================================================
-- Data Consistency Checks
-- ================================================

-- Count of distinct order IDs in key tables
SELECT COUNT(DISTINCT order_id) AS payments_count FROM target_ecommerce.payments;
SELECT COUNT(DISTINCT order_id) AS orders_count FROM target_ecommerce.orders;
SELECT COUNT(DISTINCT order_id) AS order_items_count FROM target_ecommerce.order_items;

-- Identify orders with no payment record
SELECT
    o.order_id
FROM
    target_ecommerce.orders AS o
LEFT JOIN
    target_ecommerce.payments AS p ON o.order_id = p.order_id
WHERE
    p.order_id IS NULL;

-- Example: Check specific missing order_id
SELECT * FROM target_ecommerce.orders WHERE order_id = 'bfbd0f9bdef84302105ad712db648a6c';
SELECT * FROM target_ecommerce.order_items WHERE order_id = 'bfbd0f9bdef84302105ad712db648a6c';

-- Identify orders with no order_items
SELECT o.order_id
    FROM target_ecommerce.orders AS o
    LEFT JOIN target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
    WHERE oi.order_id IS NULL;
-- Identify order statuses of missing orders
WITH orders_missing_items AS (
    SELECT o.order_id
    FROM target_ecommerce.orders AS o
    LEFT JOIN target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
    WHERE oi.order_id IS NULL
)
SELECT DISTINCT o.order_status
FROM target_ecommerce.orders o
INNER JOIN orders_missing_items omi ON o.order_id = omi.order_id;

-- ================================================
-- Cleaned Revenue Calculation Using Only Valid Orders
-- ================================================

-- Create CTE to filter consistent orders
WITH relevant_order_id AS (
    SELECT o.order_id
    FROM target_ecommerce.orders AS o
    INNER JOIN target_ecommerce.payments AS p ON o.order_id = p.order_id
    INNER JOIN target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status IN ('shipped', 'delivered')
)

-- Revenue from Order Items (validated set)
SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp)::INT AS order_year,
    SUM(COALESCE(oi.price, 0) + COALESCE(oi.freight_value, 0)) AS total_revenue
FROM target_ecommerce.orders AS o
INNER JOIN target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
WHERE o.order_id IN (SELECT order_id FROM relevant_order_id)
GROUP BY order_year
ORDER BY order_year;

WITH relevant_order_id AS (
    SELECT o.order_id
    FROM target_ecommerce.orders AS o
    INNER JOIN target_ecommerce.payments AS p ON o.order_id = p.order_id
    INNER JOIN target_ecommerce.order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status IN ('shipped', 'delivered')
)
-- Revenue from Payments (validated set)
SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp)::INT AS order_year,
    SUM(COALESCE(p.payment_value, 0)) AS total_revenue
FROM target_ecommerce.orders AS o
INNER JOIN target_ecommerce.payments AS p ON o.order_id = p.order_id
WHERE o.order_id IN (SELECT order_id FROM relevant_order_id)
GROUP BY order_year
ORDER BY order_year;

-- Conclusion: Still mismatched. Therefore, we'll proceed using the **payments** table as the authoritative source for revenue analysis.