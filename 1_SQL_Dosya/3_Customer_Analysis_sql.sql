--total revenue  by customer
SELECT 
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.customer_id, c.company_name
ORDER BY 
    total_revenue DESC;

--customer order frequency and avg.order value
SELECT 
    c.customer_id,
    c.company_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS avg_order_value
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.customer_id, c.company_name
ORDER BY 
    total_orders DESC;

--customer sales by country
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.country
ORDER BY 
    total_revenue DESC;

--customer lifetime value 
SELECT 
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC / COUNT(o.order_id), 2) AS avg_order_value,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS customer_lifetime_value
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.customer_id, c.company_name
ORDER BY 
    customer_lifetime_value DESC;

--new and old customers 
WITH CustomerOrderTotals AS (
    SELECT 
        c.customer_id,
        c.company_name,
        o.order_id,
        SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC AS order_value
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    JOIN 
        order_details od ON o.order_id = od.order_id
    GROUP BY 
        1, 2, 3
)
SELECT 
    customer_id,
    company_name,
    ROUND(SUM(order_value), 2) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(order_value), 2) AS avg_order_value,
    ROUND(SUM(order_value), 2) AS customer_lifetime_value
FROM 
    CustomerOrderTotals
GROUP BY 
    1, 2
ORDER BY 
    customer_lifetime_value DESC;

--customer segmentation 
SELECT 
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue,
    CASE 
        WHEN SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) < 1000 THEN 'Low'
        WHEN SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'High'
    END AS revenue_tier
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.customer_id, c.company_name
ORDER BY 
    total_revenue DESC;



