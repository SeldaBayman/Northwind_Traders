--delivery performance 
WITH DeliveryPerformance AS (
    SELECT 
        o.order_id,
        c.country,
        o.order_date,
        o.required_date,
        o.shipped_date,
        CASE 
            WHEN o.shipped_date <= o.required_date THEN 'On Time'
            ELSE 'Late'
        END AS delivery_status,
        (o.shipped_date - o.order_date) AS delivery_interval,
        (o.required_date - o.order_date) AS required_delivery_interval
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
    SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_deliveries,
    ROUND(AVG(delivery_interval),0) AS avg_delivery_days,
    ROUND(AVG(required_delivery_interval),0)  AS avg_required_delivery_days,
    ROUND(AVG(delivery_interval) - AVG(required_delivery_interval),0) AS avg_days_difference 
FROM 
    DeliveryPerformance
GROUP BY 
    country
ORDER BY 
    on_time_deliveries DESC;

--total shipping cost by company
SELECT 
    s.shipper_id,
    s.company_name,
    ROUND(SUM(o.freight)::NUMERIC, 2) AS total_shipping_cost
FROM 
    shippers s
JOIN 
    orders o ON s.shipper_id = o.ship_via
GROUP BY 
    s.shipper_id, s.company_name
ORDER BY 
    total_shipping_cost DESC;

--total delivered orders by shippers
SELECT 
    s.shipper_id,
    s.company_name,
    COUNT(o.order_id) AS total_delivered_orders
FROM 
    shippers s
JOIN 
    orders o ON s.shipper_id = o.ship_via
WHERE 
    o.shipped_date IS NOT NULL 
GROUP BY 
    s.shipper_id, s.company_name
ORDER BY 
    total_delivered_orders DESC;

-- top 5 longest delivery time by country
WITH DeliveryTimes AS (
    SELECT 
        c.country,
        (o.shipped_date - o.order_date)::NUMERIC AS delivery_time_days
    FROM 
        orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id
    WHERE 
        o.shipped_date IS NOT NULL 
),
AverageDeliveryTime AS (
    SELECT 
        country,
        ROUND(AVG(delivery_time_days)::NUMERIC, 2) AS avg_delivery_time_days
    FROM 
        DeliveryTimes
    GROUP BY 
        country
)
SELECT 
    country,
    avg_delivery_time_days
FROM 
    AverageDeliveryTime
ORDER BY 
    avg_delivery_time_days DESC
LIMIT 5;

--top shortest delivery time by country 
WITH DeliveryTimes AS (
    SELECT 
        c.country,
        (o.shipped_date - o.order_date)::NUMERIC AS delivery_time_days
    FROM 
        orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id
    WHERE 
        o.shipped_date IS NOT NULL 
),
AverageDeliveryTime AS (
    SELECT 
        country,
        ROUND(AVG(delivery_time_days)::NUMERIC, 2) AS avg_delivery_time_days
    FROM 
        DeliveryTimes
    GROUP BY 
        country
)
SELECT 
    country,
    avg_delivery_time_days
FROM 
    AverageDeliveryTime
ORDER BY 
    avg_delivery_time_days ASC
LIMIT 5;

--average shippings days by country
WITH ShippingDays AS (
    SELECT 
        s.shipper_id,
        s.company_name,
        (o.shipped_date - o.order_date) AS shipping_days 
    FROM 
        shippers s
    JOIN 
        orders o ON s.shipper_id = o.ship_via
    WHERE 
        o.shipped_date IS NOT NULL
)
SELECT 
    company_name,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days
FROM 
    ShippingDays
GROUP BY 
    company_name
ORDER BY 
    avg_shipping_days;

--average delivery time by shippers
WITH DeliveryTime AS (
    SELECT 
        s.shipper_id,
        s.company_name,
        o.order_id,
        o.order_date,
        o.shipped_date,
        (o.shipped_date - o.order_date)::NUMERIC AS delivery_time_days
    FROM 
        shippers s
    JOIN 
        orders o ON s.shipper_id = o.ship_via
    WHERE 
        o.shipped_date IS NOT NULL 
)
SELECT 
    company_name,
    ROUND(AVG(delivery_time_days), 2) AS avg_delivery_time_days
FROM 
    DeliveryTime
GROUP BY 
    company_name
ORDER BY 
    avg_delivery_time_days ASC 
LIMIT 5; 

--delivery performance 2
WITH DeliveryPerformance AS (
    SELECT 
        s.shipper_id,
        s.company_name,
        o.order_id,
        o.shipped_date,
        o.required_date,
        o.order_date,
        (o.shipped_date - o.order_date)::NUMERIC AS delivery_time_days,
        CASE 
            WHEN o.shipped_date <= o.required_date THEN 1 
            ELSE 0 
        END AS on_time_delivery,
        o.freight::NUMERIC AS shipping_cost
    FROM 
        shippers s
    JOIN 
        orders o ON s.shipper_id = o.ship_via
    WHERE 
        o.shipped_date IS NOT NULL 
)
SELECT 
    company_name,
    COUNT(order_id) AS total_shipments,
    ROUND(SUM(shipping_cost), 2) AS total_shipping_cost,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(AVG(delivery_time_days), 2) AS avg_delivery_time_days,
    ROUND((SUM(on_time_delivery) * 100.0) / COUNT(order_id), 2) AS on_time_delivery_rate
FROM 
    DeliveryPerformance
GROUP BY 
    company_name
ORDER BY 
    on_time_delivery_rate DESC;