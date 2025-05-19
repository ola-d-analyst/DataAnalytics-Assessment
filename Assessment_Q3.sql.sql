-- Account Inactivity Alert
WITH latest_transactions AS (
    SELECT
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE amount > 0
    GROUP BY plan_id
),
plan_activity AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.plan_type_id = 1 THEN 'Savings'
            WHEN p.plan_type_id = 2 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        lt.last_transaction_date,
        -- MySQL specific date difference
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN latest_transactions lt ON p.id = lt.plan_id
    WHERE
        (p.is_deleted = FALSE OR p.is_deleted IS NULL)
        AND (p.is_archived = FALSE OR p.is_archived IS NULL)
)
SELECT *
FROM plan_activity
WHERE
    (last_transaction_date IS NULL OR inactivity_days > 365)
ORDER BY inactivity_days DESC;
