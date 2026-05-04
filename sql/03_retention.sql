-- Step 1: First activity per user

SELECT 
    CustomerID,
    MIN(DATE(InvoiceDate)) AS first_activity_date
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;
