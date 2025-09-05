-- 8. What trends can we observe in hire dates across employee titles?


USE northwind_sales;

SELECT 
    Title,
    YEAR(HireDate) AS HireYear,
    COUNT(*) AS HiresThisYear,
    SUM(COUNT(*)) OVER (
        PARTITION BY Title 
        ORDER BY YEAR(HireDate)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeHires
FROM employees
GROUP BY Title, YEAR(HireDate)
ORDER BY Title, HireYear;
