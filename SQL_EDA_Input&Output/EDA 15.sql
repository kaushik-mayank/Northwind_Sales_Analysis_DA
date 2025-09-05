-- How do supplier pricing and categories relate across different regions?

SELECT 
    s.Country AS Region,
    c.CategoryName,
    COUNT(DISTINCT p.SupplierID) AS SupplierCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice,
    ROUND(MIN(p.UnitPrice), 2) AS MinPrice,
    ROUND(MAX(p.UnitPrice), 2) AS MaxPrice
FROM products p
JOIN suppliers s ON p.SupplierID = s.SupplierID
JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY s.Country, c.CategoryName
ORDER BY s.Country, c.CategoryName;
