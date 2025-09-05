-- What is the geographic and title-wise distribution of employees?

SELECT country, title, COUNT(EmployeeID) AS No_of_employee
FROM employees 
GROUP BY country, title

