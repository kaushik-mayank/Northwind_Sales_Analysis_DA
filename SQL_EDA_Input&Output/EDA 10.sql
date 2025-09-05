-- Are there correlations between product pricing, stock levels, and sales performance?

SELECT 
    p.ProductName,
    p.UnitPrice AS Unit_Price,
    p.UnitsInStock AS Units_In_Stock_Left,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(revenue_after_discount), 2) AS Total_Revenue
FROM products p
JOIN `order details` o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
ORDER BY Total_Revenue DESC;

