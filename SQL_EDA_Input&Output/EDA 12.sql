-- Can we identify anomalies in product sales or revenue performance?

WITH monthly_sales AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        DATE_FORMAT(o.OrderDate, '%Y-%m-01') AS month,
        SUM(od.Quantity * od.UnitPrice) AS revenue
    FROM `order details` od
    JOIN orders o 
        ON od.OrderID = o.OrderID
    JOIN products p 
        ON od.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName, DATE_FORMAT(o.OrderDate, '%Y-%m-01')
), stats AS (
    SELECT 
        ProductID,
        AVG(revenue) AS avg_revenue,
        STDDEV(revenue) AS std_revenue
    FROM monthly_sales
    GROUP BY ProductID
), anomalies AS (
    SELECT 
        m.ProductID,
        m.ProductName,
        m.month,
        m.revenue,
        s.avg_revenue,
        s.std_revenue,
        CASE 
            WHEN m.revenue > s.avg_revenue + 2*s.std_revenue THEN 'High Anomaly'
            WHEN m.revenue < s.avg_revenue - 2*s.std_revenue THEN 'Low Anomaly'
        END AS stat_anomaly
    FROM monthly_sales m
    JOIN stats s 
        ON m.ProductID = s.ProductID
), yoy AS (
    SELECT 
        a.ProductID,
        a.ProductName,
        a.month,
        a.revenue,
        a.stat_anomaly,
        LAG(a.revenue, 12) OVER (PARTITION BY a.ProductID ORDER BY a.month) AS prev_year_revenue
    FROM anomalies a
)
SELECT 
    ProductID,
    ProductName,
    month,
    revenue,
    COALESCE(stat_anomaly, 'No Anomaly') AS stat_anomaly,
    prev_year_revenue,
    CASE 
        WHEN prev_year_revenue IS NOT NULL 
             AND ABS((revenue - prev_year_revenue) / prev_year_revenue) > 0.5
        THEN 'YoY Anomaly (>50% change)'
        ELSE 'No Anomaly'
    END AS yoy_anomaly
FROM yoy
WHERE stat_anomaly IS NOT NULL 
   OR (prev_year_revenue IS NOT NULL 
       AND ABS((revenue - prev_year_revenue) / prev_year_revenue) > 0.5)
ORDER BY ProductID, month;


