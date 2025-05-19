-- Customer Lifetime Value (CLV) Estimation
WITH user_transactions AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        AVG(amount) AS avg_transaction_amount,
        SUM(amount) AS total_amount
    FROM savings_savingsaccount
    WHERE amount > 0
    GROUP BY owner_id
),
user_tenure AS (
    SELECT
        id AS customer_id,
        name,
        DATE_PART('month', AGE(CURRENT_DATE, date_joined)) AS tenure_months
    FROM users_customuser
),
clv_estimates AS (
    SELECT
        u.customer_id,
        u.name,
        u.tenure_months,
        COALESCE(t.total_transactions, 0) AS total_transactions,
        ROUND(
            (COALESCE(t.total_transactions, 0) / NULLIF(u.tenure_months, 0)) * 12 * (0.001 * COALESCE(t.avg_transaction_amount, 0)),
            2
        ) AS estimated_clv
    FROM user_tenure u
    LEFT JOIN user_transactions t ON u.customer_id = t.owner_id
)
SELECT *
FROM clv_estimates
ORDER BY estimated_clv DESC;