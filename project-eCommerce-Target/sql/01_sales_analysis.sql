/* 
================================================
Order & Sales Analysis
================================================

Overview:
This analysis investigates revenue patterns, order consistency across tables, and category-level and geographic performance, based on the 'target_ecommerce' schema.
*/

-- ================================================
-- Question 1: What is the total revenue generated per year? Per month?
-- ================================================

-- Revenue by Year using payments Table (chosen for consistency and completeness, exploratory investigation completed later)
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

-- Revenue by Year-Month using payments Table
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS order_year_month,
    SUM(COALESCE(p.payment_value, 0)) AS total_revenue
FROM
    target_ecommerce.orders AS o
INNER JOIN
    target_ecommerce.payments AS p ON o.order_id = p.order_id
WHERE
    o.order_status IN ('shipped', 'delivered')
GROUP BY
    order_year_month
ORDER BY
    order_year_month;

-- ================================================
-- Question 2: Which months show the highest and lowest sales performance?
-- ================================================

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS order_year_month,
        SUM(COALESCE(p.payment_value, 0)) AS total_revenue
    FROM
        target_ecommerce.orders AS o
    INNER JOIN
        target_ecommerce.payments AS p ON o.order_id = p.order_id
    WHERE
        o.order_status IN ('shipped', 'delivered')
    GROUP BY
        order_year_month
),
highest_month AS (
    SELECT 'Highest' AS performance_type, order_year_month, total_revenue
    FROM monthly_revenue
    ORDER BY total_revenue DESC
    LIMIT 1
),
lowest_month AS (
    SELECT 'Lowest' AS performance_type, order_year_month, total_revenue
    FROM monthly_revenue
    ORDER BY total_revenue ASC
    LIMIT 1
)
SELECT * FROM highest_month
UNION ALL
SELECT * FROM lowest_month;

-- ================================================
-- Question 3: Which product categories generate the most revenue?
-- ================================================

SELECT
    p.product_category,
    SUM(COALESCE(oi.price, 0) + COALESCE(oi.freight_value, 0)) AS total_revenue
FROM
    target_ecommerce.order_items AS oi
INNER JOIN
    target_ecommerce.orders AS o ON oi.order_id = o.order_id
INNER JOIN
    target_ecommerce.products AS p ON oi.product_id = p.product_id
WHERE
    o.order_status IN ('shipped', 'delivered')
GROUP BY
    p.product_category
ORDER BY
    total_revenue DESC;

-- ================================================
-- Question 4: What is the average order value (AOV) per state?
-- ================================================

SELECT
    c.customer_state,
    AVG(COALESCE(p.payment_value, 0)) AS average_order_value
FROM
    target_ecommerce.payments AS p
INNER JOIN
    target_ecommerce.orders AS o ON p.order_id = o.order_id
INNER JOIN
    target_ecommerce.customers AS c ON o.customer_id = c.customer_id
WHERE
    o.order_status IN ('shipped', 'delivered')
GROUP BY
    c.customer_state
ORDER BY
    average_order_value DESC;