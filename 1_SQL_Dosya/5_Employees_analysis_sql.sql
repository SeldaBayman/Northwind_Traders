--Total Sales by Employees
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name, 
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::NUMERIC) AS total_sales  
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

--Total orders by employees
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    COUNT(o.order_id) AS total_orders
FROM 
    employees e
JOIN 
    orders o ON e.employee_id = o.employee_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    total_orders DESC;

--Average order value by employees
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount))::NUMERIC, 2) AS avg_order_value
FROM 
    employees e
JOIN 
    orders o ON e.employee_id = o.employee_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    avg_order_value DESC;

-- Top 5 employee by Month/Year
SELECT SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    EXTRACT(MONTH FROM o.order_date) AS month,
    EXTRACT(YEAR FROM o.order_date) AS year,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::NUMERIC) AS total_sales
FROM 
    employees e
JOIN 
    orders o ON e.employee_id = o.employee_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
   1,2,3,4
ORDER BY 
    total_sales DESC 
LIMIT 5;
