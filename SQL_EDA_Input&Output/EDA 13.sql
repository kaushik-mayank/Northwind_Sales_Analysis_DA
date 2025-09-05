-- Are there any regional trends in supplier distribution and pricing?

SELECT 
    s.Country,
    COUNT(DISTINCT s.SupplierID) AS supplier_count,
    ROUND(AVG(p.UnitPrice), 2) AS avg_price,
    ROUND(MIN(p.UnitPrice), 2) AS min_price,
    ROUND(MAX(p.UnitPrice), 2) AS max_price,
    ROUND(STDDEV(p.UnitPrice), 2) AS price_variability
FROM suppliers s
JOIN products p
    ON s.SupplierID = p.SupplierID
GROUP BY s.Country
ORDER BY supplier_count DESC, avg_price ASC;
