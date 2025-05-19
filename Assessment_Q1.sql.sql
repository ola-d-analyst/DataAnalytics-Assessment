-- High-Value Customers with Multiple Products
SELECT
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT s.plan_id) AS savings_count,
    COUNT(DISTINCT i.id) AS investment_count,
    COALESCE(SUM(s.amount), 0) + COALESCE(SUM(i.amount), 0) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id AND s.amount > 0
LEFT JOIN plans_plan i ON u.id = i.owner_id AND i.amount > 0 AND i.plan_type_id = 2
WHERE
    EXISTS (
        SELECT 1 FROM savings_savingsaccount ss
        WHERE ss.owner_id = u.id AND ss.amount > 0
    )
    AND EXISTS (
        SELECT 1 FROM plans_plan pp
        WHERE pp.owner_id = u.id AND pp.amount > 0 AND pp.plan_type_id = 2
    )
GROUP BY u.id, u.name
ORDER BY total_deposits DESC;