-- How do customer order patterns vary by city or country?

WITH 
Order_Aggregates AS (
  SELECT 
    o.ShipCountry,
    SUM(od.revenue_after_discount) AS Total_Revenue,
    SUM(od.Quantity) AS Total_Quantity,
    AVG(od.revenue_after_discount) AS Avg_Order_Value,
    AVG(od.Quantity) AS Avg_Order_Quantity
  FROM `order details` od
  JOIN orders o ON od.OrderID = o.OrderID
  GROUP BY o.ShipCountry
),
Order_Frequency_Per_Customer AS (
  SELECT CustomerID, COUNT(OrderID) AS Order_Frequency
  FROM orders
  GROUP BY CustomerID
),
Customer_Countries AS (
  SELECT DISTINCT CustomerID, ShipCountry
  FROM orders
),
Frequency_By_Country AS (
  SELECT
    cc.ShipCountry,
    AVG(ofpc.Order_Frequency) AS Avg_Order_Frequency
  FROM Customer_Countries cc
  JOIN Order_Frequency_Per_Customer ofpc ON cc.CustomerID = ofpc.CustomerID
  GROUP BY cc.ShipCountry
)

SELECT 
  oa.ShipCountry,
  oa.Total_Revenue,
  oa.Total_Quantity,
  oa.Avg_Order_Value,
  oa.Avg_Order_Quantity,
  fbc.Avg_Order_Frequency
FROM Order_Aggregates oa
LEFT JOIN Frequency_By_Country fbc ON oa.ShipCountry = fbc.ShipCountry;
