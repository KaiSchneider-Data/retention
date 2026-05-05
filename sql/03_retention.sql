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

-- Step 3: Calculate Day 1 retention rate

WITH first_activity AS (
    SELECT 
        CustomerID,
        MIN(DATE(InvoiceDate)) AS first_activity_date
    FROM online_retail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),

day_1_retained_users AS (
    SELECT DISTINCT
        a.CustomerID
    FROM first_activity a
    JOIN online_retail b
        ON a.CustomerID = b.CustomerID
    WHERE DATE(b.InvoiceDate) = a.first_activity_date + INTERVAL '1 day'
)

SELECT
    COUNT(DISTINCT f.CustomerID) AS total_users,
    COUNT(DISTINCT d.CustomerID) AS day_1_retained_users,
    ROUND(
        COUNT(DISTINCT d.CustomerID) * 100.0 / COUNT(DISTINCT f.CustomerID),
        2
    ) AS day_1_retention_rate_percent
FROM first_activity f
LEFT JOIN day_1_retained_users d
    ON f.CustomerID = d.CustomerID;

-- Step 4: Calculate Day 7 retention rate

WITH first_activity AS (
    SELECT 
        CustomerID,
        MIN(DATE(InvoiceDate)) AS first_activity_date
    FROM online_retail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),

day_7_retained_users AS (
    SELECT DISTINCT
        a.CustomerID
    FROM first_activity a
    JOIN online_retail b
        ON a.CustomerID = b.CustomerID
    WHERE DATE(b.InvoiceDate) = a.first_activity_date + INTERVAL '7 day'
)

SELECT
    COUNT(DISTINCT f.CustomerID) AS total_users,
    COUNT(DISTINCT d.CustomerID) AS day_7_retained_users,
    ROUND(
        COUNT(DISTINCT d.CustomerID) * 100.0 / COUNT(DISTINCT f.CustomerID),
        2
    ) AS day_7_retention_rate_percent
FROM first_activity f
LEFT JOIN day_7_retained_users d
    ON f.CustomerID = d.CustomerID;
