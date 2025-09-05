-- What is the average number of orders per customer? Are there high-value repeat customers?

USE northwind_sales;
WITH cust_info AS (SELECT customerid, COUNT(orderid) AS ordersbycust FROM orders
GROUP BY customerid)

SELECT ROUND(Avg(c.ordersbycust)) FROM cust_info c; 




USE northwind_sales;

WITH customer_orders AS (
    SELECT 
        o.customerid,
        COUNT(DISTINCT o.orderid) AS order_count,
        SUM(od.revenue_after_discount) AS total_spend
    FROM orders o
    JOIN `order details` od ON o.orderid = od.orderid
    GROUP BY o.customerid
)

SELECT 
    customerid,
    order_count,
    total_spend,
    CASE 
        WHEN order_count > 5 AND total_spend > 1000 THEN 'High-Value Repeat'
        WHEN order_count > 5 THEN 'Repeat Customer'
        WHEN total_spend > 1000 THEN 'High-Value One-Timer'
        ELSE 'Regular Customer'
    END AS customer_segment
FROM customer_orders;
