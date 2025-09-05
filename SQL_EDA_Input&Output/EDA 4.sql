-- Which product categories or products contribute most to order revenue?

USE northwind_sales;

SELECT 
    c.categoryname,
    p.productname,
    ROUND(SUM(od.revenue_after_discount), 2) AS total_revenue
FROM `order details` od
JOIN products p ON od.productid = p.productid
JOIN categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname, p.productname
ORDER BY c.categoryname, total_revenue DESC;
