--ürün bazında toplam satış
SELECT 
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_sales
FROM 
    order_details od
JOIN 
    products p ON od.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    total_sales DESC;

--montlhy sales trend 
SELECT 
    EXTRACT(MONTH FROM o.order_date)::NUMERIC AS month,
    EXTRACT(YEAR FROM o.order_date)::NUMERIC AS year,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC,2) AS total_sales
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    month,year
ORDER BY 
    total_sales DESC;

--total_sales	
SELECT 
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC,2) AS total_sales
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
;

--top 5 customers
SELECT 
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC,2) AS total_sales
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.customer_id, c.company_name
ORDER BY 
    total_sales DESC
LIMIT 5;

--avg order value by country
SELECT 
    c.country,
    ROUND(AVG(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS average_order_value
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.country
ORDER BY 
    average_order_value DESC;

--order status by delivery (on_time, late)

WITH DeliveryPerformance AS (
    SELECT 
        o.order_id,
        c.country,
        CASE WHEN o.shipped_date <= o.required_date THEN 'On Time'
        ELSE 'Late'
        END AS delivery_status
    FROM 
        orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id
    WHERE 
        o.shipped_date IS NOT NULL
)
SELECT 
    country,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN delivery_status = 'On Time' THEN 1 ELSE 0 END) AS on_time_deliveries,
    SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_deliveries
FROM 
    DeliveryPerformance
GROUP BY 
    country
ORDER BY 
    on_time_deliveries DESC;

-- all employees sales performance
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC,2) AS total_sales
FROM 
    employees e
JOIN 
    orders o ON e.employee_id = o.employee_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    total_sales DESC;
