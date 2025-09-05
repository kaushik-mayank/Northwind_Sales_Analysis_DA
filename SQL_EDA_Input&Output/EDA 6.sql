-- How frequently do different customer segments place orders?


WITH customer_orders AS (
    SELECT 
        customerid,
        COUNT(orderid) AS total_orders,
        MIN(orderdate) AS first_order,
        MAX(orderdate) AS last_order,
        DATEDIFF(MAX(orderdate), MIN(orderdate)) AS active_days,
        ShipCountry
    FROM orders 
    GROUP BY customerid, shipcountry
),
customer_segments AS (
    SELECT
        customerid,
        shipcountry,
        total_orders,
        active_days,
        CASE 
            WHEN total_orders > 10 THEN 'Frequent Buyer'
            ELSE 'Infrequent Buyer'
        END AS segment,
        CASE 
            WHEN active_days > 0 THEN total_orders * 30.0 / active_days -- approx orders per month
            ELSE total_orders
        END AS orders_per_month
    FROM customer_orders
)

SELECT 
    segment,
    shipcountry,
    COUNT(customerid) AS num_customers,
    ROUND(AVG(orders_per_month), 2) AS avg_orders_per_month
FROM customer_segments
GROUP BY segment, shipcountry
ORDER BY avg_orders_per_month DESC;
