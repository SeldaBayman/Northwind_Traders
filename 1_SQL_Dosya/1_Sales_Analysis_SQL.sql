--Top 5 ülke satışları:

SELECT 
    c.country,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS total_sales
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.country
ORDER BY 
    total_sales DESC
LIMIT 5;

--TOP 5 category
SELECT 
    cat.category_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS total_sales
FROM 
    categories cat
JOIN 
    products p ON cat.category_id = p.category_id
JOIN 
    order_details od ON p.product_id = od.product_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    cat.category_name
ORDER BY 
    total_sales DESC
LIMIT 5;

--Top 5 Company
SELECT 
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS total_sales
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.company_name
ORDER BY 
    total_sales DESC
LIMIT 5;

--Top 5 Product Sales
SELECT 
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS total_sales
FROM 
    products p
JOIN 
    order_details od ON p.product_id = od.product_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    p.product_name
ORDER BY 
    total_sales DESC
LIMIT 5;

--Shipping Cost By Companies	

SELECT 
    s.company_name AS shipper_name,
    ROUND(SUM(o.freight)) AS total_shipping_cost
FROM 
    shippers s
JOIN 
    orders o ON s.shipper_id = o.ship_via
GROUP BY 
    s.company_name
ORDER BY 
    total_shipping_cost DESC;

--Total Revenue-Net Revenue-Gross Revenue
SELECT 
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity)) AS gross_revenue,  
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS net_revenue,  
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)) + o.freight)) AS total_revenue  
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    c.company_name
ORDER BY 
    total_revenue DESC;
	
--Sales By Month
SELECT 
    EXTRACT(MONTH FROM o.order_date)::NUMERIC AS sales_month,  
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS total_sales 
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
WHERE 
    o.order_date IS NOT NULL 
GROUP BY 
    EXTRACT(MONTH FROM o.order_date)::NUMERIC
ORDER BY 
    sales_month;

--Sales By Employee(Net Revenue)

SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,  
    ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) AS net_revenue 
FROM 
    employees e
JOIN 
    orders o ON e.employee_id = o.employee_id
JOIN 
    order_details od ON o.order_id = od.order_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    net_revenue DESC;

KPI:
--GROSS REVENUE:(iskontasız)
SELECT  
    ROUND(SUM(unit_price * quantity)::NUMERIC,2) AS gross_revenue 
FROM order_details    
;

--NET REVENUE (+iskonta)
SELECT 
    ROUND(SUM(unit_price * quantity * (1-COALESCE(discount)))::NUMERIC,2) net_revenue
FROM order_details od;

--TOTAL REVENUE (iskonta + nakliye_ücreti) 
SELECT 
    ROUND(SUM(od.unit_price * od.quantity * (1 -(od.discount)) + (o.freight))::NUMERIC,2) AS total_revenue
FROM 
    order_details od 
JOIN 
    orders o ON o.order_id = od.order_id
;
-- TOTAL_ORDERS
SELECT 
COUNT(*) AS total_orders
FROM orders;

-- TOTAL_CUSTOMERS
SELECT COUNT(*) AS total_customers
FROM customers;



