-- Query 1: Find transactions with unusual spikes compared to user average.

WITH UserAvg AS (
    SELECT 
        "Transaction_ID",
        "User_ID",
        "Transaction_Amount",
        "Fraudulent",
        AVG("Transaction_Amount") OVER(PARTITION BY "User_ID") AS avg_user_amount
    FROM fraud_transactions
)
SELECT 
    "Transaction_ID",
    "User_ID",
    "Transaction_Amount",
    ROUND(avg_user_amount::numeric, 2) AS avg_user_amount,
    "Fraudulent",
    CASE 
        WHEN "Transaction_Amount" > (2 * avg_user_amount) THEN 'High Anomaly'
        ELSE 'Normal'
    END AS anomaly_status
FROM UserAvg
WHERE "Fraudulent" = 1
ORDER BY "Transaction_Amount" DESC;

-- Query 2: Identify top repeat-offender users ranked by fraud volume.

WITH UserFraudCount AS (
    SELECT 
        "User_ID",
        COUNT(*) AS total_transactions,
        SUM("Fraudulent") AS fraud_cases,
        ROUND(SUM("Fraudulent")::numeric / COUNT(*) * 100, 2) AS fraud_rate
    FROM fraud_transactions
    GROUP BY "User_ID"
    HAVING SUM("Fraudulent") > 0
)
SELECT 
    "User_ID",
    total_transactions,
    fraud_cases,
    fraud_rate,
    DENSE_RANK() OVER (ORDER BY fraud_cases DESC, fraud_rate DESC) as risk_rank
FROM UserFraudCount
LIMIT 10;

-- Query 3: Calculate cumulative running total of frauds across locations.

WITH LocationStats AS (
    SELECT 
        "Location",
        COUNT(*) AS total_txns,
        SUM("Fraudulent") AS fraud_txns
    FROM fraud_transactions
    GROUP BY "Location"
)
SELECT 
    "Location",
    total_txns,
    fraud_txns,
    SUM(fraud_txns) OVER (ORDER BY total_txns DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_frauds
FROM LocationStats
ORDER BY total_txns DESC;

-- Query 4: Analyze fraud percentage in new accounts with high transaction velocity.

WITH RiskSegment AS (
    SELECT 
        "Transaction_ID",
        "User_ID",
        "Account_Age",
        "Number_of_Transactions_Last_24H",
        "Fraudulent",
        CASE 
            WHEN "Account_Age" <= 30 AND "Number_of_Transactions_Last_24H" > 10 THEN 'Critical Risk'
            WHEN "Account_Age" <= 30 THEN 'New Account Risk'
            WHEN "Number_of_Transactions_Last_24H" > 10 THEN 'High Velocity Risk'
            ELSE 'Low Risk'
        END AS risk_category
    FROM fraud_transactions
)
SELECT 
    risk_category,
    COUNT(*) AS total_transactions,
    SUM("Fraudulent") AS confirmed_frauds,
    ROUND(SUM("Fraudulent")::numeric / COUNT(*) * 100, 2) AS fraud_percentage
FROM RiskSegment
GROUP BY risk_category
ORDER BY fraud_percentage DESC;

-- Query 5: Track transaction velocity spikes between consecutive user actions.

WITH OrderedTransactions AS (
    SELECT 
        "User_ID",
        "Transaction_ID",
        "Number_of_Transactions_Last_24H",
        "Fraudulent",
        LAG("Number_of_Transactions_Last_24H", 1) OVER (PARTITION BY "User_ID" ORDER BY "Transaction_ID") AS prev_24h_txns
    FROM fraud_transactions
)
SELECT 
    "User_ID",
    "Transaction_ID",
    prev_24h_txns,
    "Number_of_Transactions_Last_24H",
    ("Number_of_Transactions_Last_24H" - COALESCE(prev_24h_txns, 0)) AS velocity_spike,
    "Fraudulent"
FROM OrderedTransactions
WHERE "Fraudulent" = 1
ORDER BY velocity_spike DESC
LIMIT 10;

-- Query 6: Find the most vulnerable device and payment method combinations.

WITH DevicePaymentRisk AS (
    SELECT 
        "Device_Used",
        "Payment_Method",
        COUNT(*) AS total_txns,
        SUM("Fraudulent") AS fraud_txns
    FROM fraud_transactions
    GROUP BY "Device_Used", "Payment_Method"
)
SELECT 
    "Device_Used",
    "Payment_Method",
    total_txns,
    fraud_txns,
    ROUND(fraud_txns::numeric / total_txns * 100, 2) AS fraud_rate_pct,
    RANK() OVER (ORDER BY (fraud_txns::numeric / total_txns) DESC) as vulnerability_rank
FROM DevicePaymentRisk
WHERE total_txns > 5;

-- Query 7: Compare fraud rates across account age quartiles.

WITH AccountQuartiles AS (
    SELECT 
        "Transaction_ID",
        "Account_Age",
        "Fraudulent",
        NTILE(4) OVER (ORDER BY "Account_Age" ASC) AS age_quartile
    FROM fraud_transactions
)
SELECT 
    age_quartile,
    MIN("Account_Age") AS min_days,
    MAX("Account_Age") AS max_days,
    COUNT(*) AS total_transactions,
    SUM("Fraudulent") AS fraud_cases,
    ROUND(SUM("Fraudulent")::numeric / COUNT(*) * 100, 2) AS fraud_rate
FROM AccountQuartiles
GROUP BY age_quartile
ORDER BY age_quartile ASC;

-- Query 8: Generate high-level executive financial summary of fraud losses.

WITH OverallStats AS (
    SELECT 
        COUNT(*) as total, 
        SUM("Fraudulent") as total_frauds, 
        SUM("Transaction_Amount") as total_vol 
    FROM fraud_transactions
),
FraudStats AS (
    SELECT 
        SUM("Transaction_Amount") as fraud_vol 
    FROM fraud_transactions 
    WHERE "Fraudulent" = 1
)
SELECT 
    o.total AS total_transactions,
    o.total_frauds AS total_fraud_cases,
    ROUND((o.total_frauds::numeric / o.total) * 100, 2) AS overall_fraud_rate_pct,
    ROUND(o.total_vol::numeric, 2) AS total_transaction_volume,
    ROUND(f.fraud_vol::numeric, 2) AS total_fraud_financial_loss,
    ROUND((f.fraud_vol::numeric / NULLIF(o.total_vol, 0))::numeric * 100, 2) AS financial_loss_pct
FROM OverallStats o, FraudStats f;