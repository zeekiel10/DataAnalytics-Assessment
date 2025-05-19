SELECT 
    p.plan_id, 
    p.owner_id, 
    p.Type, 
    s.Last_trans_date, 
    DATEDIFF(CURDATE(), COALESCE(s.Last_trans_date, p.start_date)) AS inactivity_days
FROM (
-- select relevant plans (either Savings or Investment), with their start dates
    SELECT     
        p.id AS plan_id,
        p.owner_id,
        p.start_date,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'None'
        END AS Type
    FROM plans_plan p
    WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
) p

-- Join the plans with inflow transaction records to get last transaction date
LEFT JOIN (
    SELECT 
        s.owner_id,
        s.plan_id,
        MAX(s.transaction_date) AS Last_trans_date
    FROM savings_savingsaccount s
    WHERE 
        s.transaction_status IN ('success', 'successful') 
        AND s.confirmed_amount > 0
    GROUP BY s.owner_id, s.plan_id
) s ON p.plan_id = s.plan_id
-- Only show plans with over 365 days of inactivity
WHERE DATEDIFF(CURDATE(), COALESCE(s.Last_trans_date, p.start_date)) > 365
-- Order by most inactive plans first
ORDER BY inactivity_days DESC;
