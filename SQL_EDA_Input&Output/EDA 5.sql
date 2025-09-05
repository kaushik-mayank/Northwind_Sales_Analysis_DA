-- Are there any correlations between orders and customer location or product category?

SELECT 
    c.Country AS CustomerCountry,
    cat.CategoryName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN `order details` od ON o.OrderID = od.OrderID
JOIN products p ON od.ProductID = p.ProductID
JOIN categories cat ON p.CategoryID = cat.CategoryID
GROUP BY c.Country, cat.CategoryName
ORDER BY c.Country, TotalRevenue DESC;
