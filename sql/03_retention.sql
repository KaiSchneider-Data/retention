-- Step 1: First activity per user

SELECT 
    CustomerID,
    MIN(DATE(InvoiceDate)) AS first_activity_date
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;

-- Step 2: Check if users return on Day 1

SELECT 
    a.CustomerID,
    a.first_activity_date,
    b.InvoiceDate
FROM (
    SELECT 
        CustomerID,
        MIN(DATE(InvoiceDate)) AS first_activity_date
    FROM online_retail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) a
JOIN online_retail b
    ON a.CustomerID = b.CustomerID
WHERE DATE(b.InvoiceDate) = a.first_activity_date + INTERVAL '1 day';
