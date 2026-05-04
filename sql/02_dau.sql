-- Daily Active Users (DAU)
-- Counts unique active users per day

SELECT 
    DATE(InvoiceDate) AS activity_date,
    COUNT(DISTINCT CustomerID) AS dau
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY DATE(InvoiceDate)
ORDER BY activity_date;
