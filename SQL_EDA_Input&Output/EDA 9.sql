-- What patterns exist in employee title and courtesy title distributions?

SELECT Title, COUNT(*) as No_of_Emp
FROM employees
GROUP BY Title
order by No_of_Emp;

SELECT TitleOfCourtesy, COUNT(*) as No_of_Emp
FROM employees
GROUP BY TitleOfCourtesy
order by No_of_Emp;

SELECT 
    Title,
    TitleOfCourtesy,
    COUNT(*) AS No_of_Emp,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Title),
        2
    ) AS Percent_within_Title
FROM employees
GROUP BY Title, TitleOfCourtesy
ORDER BY Title, Percent_within_Title DESC;
