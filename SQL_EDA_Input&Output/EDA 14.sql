-- How are suppliers distributed across different product categories?

SELECT 
    c.CategoryName,
    COUNT(DISTINCT p.SupplierID) AS SupplierCount,
    GROUP_CONCAT(DISTINCT s.CompanyName ORDER BY s.CompanyName SEPARATOR ', ') AS Suppliers
FROM products p
JOIN categories c ON p.CategoryID = c.CategoryID
JOIN suppliers s ON p.SupplierID = s.SupplierID
GROUP BY c.CategoryName
ORDER BY SupplierCount DESC;
