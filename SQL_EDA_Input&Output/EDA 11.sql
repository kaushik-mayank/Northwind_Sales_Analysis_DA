-- How does product demand change over months or seasons?

WITH monthly_sales AS (
    SELECT
        od.ProductID,
        DATE_FORMAT(o.OrderDate, '%Y-%m-01') AS month_start,
        EXTRACT(YEAR FROM o.OrderDate) AS order_year,
        EXTRACT(MONTH FROM o.OrderDate) AS order_month,
        CASE 
            WHEN EXTRACT(MONTH FROM o.OrderDate) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM o.OrderDate) IN (3,4,5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM o.OrderDate) IN (6,7,8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM o.OrderDate) IN (9,10,11) THEN 'Autumn'
        END AS season,
        SUM(od.Quantity) AS monthly_units,
        ROUND(SUM(od.Quantity * od.UnitPrice * (1 - COALESCE(od.Discount, 0))), 2) AS monthly_revenue
    FROM `order details` od
    JOIN orders o ON o.OrderID = od.OrderID
    GROUP BY od.ProductID, month_start, order_year, order_month, season
),

mom_changes AS (
    SELECT
        ProductID,
        month_start,
        monthly_units,
        LAG(monthly_units) OVER (PARTITION BY ProductID ORDER BY month_start) AS prev_month_units,
        CASE 
            WHEN LAG(monthly_units) OVER (PARTITION BY ProductID ORDER BY month_start) IS NULL THEN NULL
            WHEN LAG(monthly_units) OVER (PARTITION BY ProductID ORDER BY month_start) = 0 THEN NULL
            ELSE ROUND(
                100.0 * (monthly_units - LAG(monthly_units) OVER (PARTITION BY ProductID ORDER BY month_start))
                / LAG(monthly_units) OVER (PARTITION BY ProductID ORDER BY month_start), 2)
        END AS mom_pct_change
    FROM monthly_sales
),

seasonal_agg AS (
    SELECT
        ProductID,
        order_year,
        season,
        SUM(monthly_units) AS seasonal_units,
        SUM(monthly_revenue) AS seasonal_revenue
    FROM monthly_sales
    GROUP BY ProductID, order_year, season
),

seasonal_index AS (
    SELECT
        ms.ProductID,
        ms.month_start,
        ms.monthly_units,
        AVG(ms.monthly_units) OVER (PARTITION BY ms.ProductID) AS avg_units,
        ROUND(ms.monthly_units / NULLIF(AVG(ms.monthly_units) OVER (PARTITION BY ms.ProductID), 0), 2) AS seasonal_index
    FROM monthly_sales ms
)

SELECT
    ms.ProductID,
    ms.order_year,
    ms.order_month,
    ms.month_start,
    ms.season,
    ms.monthly_units,
    ms.monthly_revenue,
    sa.seasonal_units,
    sa.seasonal_revenue,
    mc.mom_pct_change,
    si.seasonal_index
FROM monthly_sales ms
LEFT JOIN seasonal_agg sa 
    ON ms.ProductID = sa.ProductID 
    AND ms.order_year = sa.order_year 
    AND ms.season = sa.season
LEFT JOIN mom_changes mc 
    ON ms.ProductID = mc.ProductID 
    AND ms.month_start = mc.month_start
LEFT JOIN seasonal_index si 
    ON ms.ProductID = si.ProductID 
    AND ms.month_start = si.month_start
ORDER BY ms.ProductID, ms.order_year, ms.order_month;
