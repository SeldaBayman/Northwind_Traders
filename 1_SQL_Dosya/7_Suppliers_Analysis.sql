--suppliers performance analysis 
WITH SupplierAnalysis AS (
    SELECT 
        s.supplier_id,
        s.company_name AS supplier_name,
        COUNT(DISTINCT p.product_id) AS total_products_supplied,
        COUNT(od.order_id) AS total_orders,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue,
        ROUND(AVG(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS avg_order_value,
        AVG(o.shipped_date - o.order_date)::NUMERIC AS avg_delivery_time_days 
    FROM 
        suppliers s
    LEFT JOIN 
        products p ON s.supplier_id = p.supplier_id
    LEFT JOIN 
        order_details od ON p.product_id = od.product_id
    LEFT JOIN 
        orders o ON od.order_id = o.order_id
    WHERE 
        o.shipped_date IS NOT NULL 
    GROUP BY 
        s.supplier_id, s.company_name
)
SELECT 
    supplier_id,
    supplier_name,
    total_products_supplied,
    total_orders,
    total_revenue,
    avg_order_value,
    ROUND(avg_delivery_time_days, 2) AS avg_delivery_time_days
FROM 
    SupplierAnalysis
ORDER BY 
    total_revenue DESC; 

--suppliers performance by category 
WITH SupplierCategoryPerformance AS (
    SELECT 
        s.supplier_id,
        s.company_name AS supplier_name,
        c.category_name,
        SUM(od.quantity) AS total_quantity_sold,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue,
        ROUND(AVG(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS avg_order_value
    FROM 
        suppliers s
    LEFT JOIN 
        products p ON s.supplier_id = p.supplier_id
    LEFT JOIN 
        categories c ON p.category_id = c.category_id
    LEFT JOIN 
        order_details od ON p.product_id = od.product_id
    LEFT JOIN 
        orders o ON od.order_id = o.order_id
    WHERE 
        o.order_date IS NOT NULL 
    GROUP BY 
        s.supplier_id, s.company_name, c.category_name
)
SELECT 
    supplier_id,
    supplier_name,
    category_name,
    total_quantity_sold,
    total_revenue,
    avg_order_value
FROM 
    SupplierCategoryPerformance
ORDER BY 
    total_revenue DESC;

--top 10 suppliers(month/year)
WITH SupplierPerformanceOverTime AS (
    SELECT 
        s.supplier_id,
        s.company_name AS supplier_name,
        EXTRACT(YEAR FROM  o.order_date)::NUMERIC AS year,
	    EXTRACT(MONTH FROM o.order_date)::NUMERIC AS month,
        SUM(od.quantity) AS total_quantity_sold,
        ROUND(SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_revenue,
        ROUND(AVG(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS avg_order_value
    FROM 
        suppliers s
    LEFT JOIN 
        products p ON s.supplier_id = p.supplier_id
    LEFT JOIN 
        order_details od ON p.product_id = od.product_id
    LEFT JOIN 
        orders o ON od.order_id = o.order_id
    WHERE 
        o.order_date IS NOT NULL
    GROUP BY 
        1,2,3,4
)
SELECT 
    supplier_id,
    supplier_name,
	year,
    month,
    total_quantity_sold,
    total_revenue,
    avg_order_value
FROM 
    SupplierPerformanceOverTime
ORDER BY 
    month, total_revenue DESC
LIMIT 10;
--most reliable suppliers
WITH SupplierDeliveryPerformance AS (
    SELECT 
        s.supplier_id,
        s.company_name AS supplier_name,
        o.order_id,
        (o.shipped_date - o.order_date) AS delivery_time_days 
    FROM 
        suppliers s
    LEFT JOIN 
        products p ON s.supplier_id = p.supplier_id
    LEFT JOIN 
        order_details od ON p.product_id = od.product_id
    LEFT JOIN 
        orders o ON od.order_id = o.order_id
    WHERE 
        o.shipped_date IS NOT NULL
)
SELECT 
    supplier_id,
    supplier_name,
    ROUND(AVG(delivery_time_days)) AS avg_delivery_days
FROM 
    SupplierDeliveryPerformance
GROUP BY 
    supplier_id, supplier_name
ORDER BY 
    avg_delivery_days ASC; 


