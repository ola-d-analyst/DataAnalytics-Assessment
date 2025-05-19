-- Transaction Frequency Analysis
WITH transaction_counts AS (
    SELECT
        owner_id,
        DATE_TRUNC('month', transaction_date) AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM savings_savingsaccount
    GROUP BY owner_id, DATE_TRUNC('month', transaction_date)
),
avg_txn_per_customer AS (
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month
    FROM transaction_counts
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT
        owner_id,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM avg_txn_per_customer
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;