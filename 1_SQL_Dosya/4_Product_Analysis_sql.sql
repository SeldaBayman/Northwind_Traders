--product analysis 

WITH ProductPerformance AS (
    SELECT 
        p.product_id,
        p.product_name,
        c.category_name,
        s.company_name AS supplier_name,
        SUM(od.quantity) AS total_quantity_sold,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue,
        ROUND(AVG(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS avg_order_value,
        COUNT(od.order_id) AS total_orders
    FROM 
        products p
    LEFT JOIN 
        order_details od ON p.product_id = od.product_id
    LEFT JOIN 
        orders o ON od.order_id = o.order_id
    LEFT JOIN 
        categories c ON p.category_id = c.category_id
    LEFT JOIN 
        suppliers s ON p.supplier_id = s.supplier_id
    WHERE 
        o.order_date IS NOT NULL 
    GROUP BY 
        p.product_id, p.product_name, c.category_name, s.company_name
)
SELECT 
    product_id,
    product_name,
    category_name,
    supplier_name,
    total_quantity_sold,
    total_revenue,
    avg_order_value,
    total_orders
FROM 
    ProductPerformance
ORDER BY 
    total_revenue DESC; 

--product segmentation by month, quarter,year
WITH SalesByTimePeriod AS (
    SELECT 
        EXTRACT(MONTH FROM o.order_date) AS month, 
        EXTRACT(QUARTER FROM o.order_date) AS quarter, 
        EXTRACT(YEAR FROM o.order_date) AS year, 
        p.product_id,
        p.product_name,
        SUM(od.quantity) AS total_quantity_sold,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue
    FROM 
        orders o
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        products p ON od.product_id = p.product_id
    WHERE 
        o.order_date IS NOT NULL
    GROUP BY 
        EXTRACT(MONTH FROM o.order_date), 
        EXTRACT(QUARTER FROM o.order_date), 
        EXTRACT(YEAR FROM o.order_date), 
        p.product_id, 
        p.product_name
)
SELECT 
    month,
    quarter,
    year,
    product_id,
    product_name,
    total_quantity_sold,
    total_revenue
FROM 
    SalesByTimePeriod
ORDER BY 
    year, quarter, month;

--product segmentation by Region
WITH ProductPerformanceByCountry AS (
    SELECT 
        c.country,
        p.product_id,
        p.product_name,
        SUM(od.quantity) AS total_quantity_sold,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC) AS total_revenue
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        products p ON od.product_id = p.product_id
    WHERE 
        o.order_date IS NOT NULL
    GROUP BY 
        1,2,3
)
SELECT 
    country,
    product_id,
    product_name,
    total_quantity_sold,
    total_revenue
FROM 
    ProductPerformanceByCountry
ORDER BY 
    total_revenue DESC;

--product details
WITH ProductDetails AS (
    SELECT 
        p.product_id,
        p.product_name,
	c.category_name,
        SUM(od.quantity) AS total_sold,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC) AS total_revenue,
        COUNT(p.quantity_per_unit)  total_quantity_per_unit,
	SUM(p.unit_in_stock)  total_in_stock,
	SUM(p.unit_on_order) total_unit_on_order,
        SUM(p.reorder_level) total_reordered,
        SUM(p.discontinued) total_discontinued
    FROM categories c 
	JOIN products p ON c.category_id=p.category_id    
    JOIN order_details od ON p.product_id = od.product_id
    JOIN orders o ON od.order_id = o.order_id
    WHERE 
        o.order_date IS NOT NULL
    GROUP BY 
        1,2,3
)
SELECT 
    product_id,
    product_name,
	category_name,
    total_sold,
    total_revenue,
	total_quantity_per_unit,
	total_unit_on_order,
    total_in_stock,
    total_reordered,
    total_discontinued	
FROM 
    ProductDetails
ORDER BY 
    total_revenue DESC;



