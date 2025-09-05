-- Can we cluster customers based on total spend, order count, and preferred categories?

USE northwind_sales;

WITH customer_category_counts AS (
    SELECT 
        o.customerid,
        c.categoryname,
        COUNT(*) AS order_count
    FROM `order details` od
    JOIN orders o ON od.orderid = o.orderid
    JOIN products p ON od.productid = p.productid
    JOIN categories c ON p.categoryid = c.categoryid  -- updated table name
    GROUP BY o.customerid, c.categoryname
),
ranked_categories AS (
    SELECT 
        customerid,
        categoryname,
        order_count,
        ROW_NUMBER() OVER (PARTITION BY customerid ORDER BY order_count DESC) AS rn
    FROM customer_category_counts
),
pc AS (
    SELECT 
        customerid, 
        categoryname AS top_category
    FROM ranked_categories
    WHERE rn = 1
)

SELECT 
    o.customerid,
    SUM(od.revenue_after_discount) AS total_spend,
    COUNT(DISTINCT o.orderid) AS order_count, 
    pc.top_category
FROM `order details` od
JOIN orders o ON od.orderid = o.orderid
JOIN pc ON o.customerid = pc.customerid
GROUP BY o.customerid, pc.top_category;
