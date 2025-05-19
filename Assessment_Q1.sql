#Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
SELECT
    txt.owner_id,
    txt.name,
    txt.savings_count,
    txt.investment_count,
    txt.total_deposits
FROM (
    -- Aggregating customer data: count of savings plans, investment plans, and summation of total deposits
   SELECT 
        uc.id AS owner_id,
        CONCAT(uc.first_name, ' ', uc.last_name) AS name,
        
        -- Count of distinct funded savings plans per customer
        COUNT(DISTINCT CASE 
            WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 THEN p.id 
        END) AS savings_count,
        
        -- Count of distinct funded investment plans per customer
        COUNT(DISTINCT CASE    
            WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN p.id 
        END) AS investment_count,
        
        -- Total confirmed deposit amount across all plans, scaled and rounded
        ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
    FROM
        users_customuser AS uc
    JOIN
        plans_plan AS p ON uc.id = p.owner_id
    JOIN
        savings_savingsaccount AS s ON p.id = s.plan_id
    GROUP BY
        uc.id, uc.first_name, uc.last_name
) AS txt
-- Filter to include only customers having at least one funded savings AND one funded investment plan
WHERE
    txt.savings_count >= 1
    AND txt.investment_count >= 1
-- Sort results by total deposits in descending order to identify high-value customers first
ORDER BY
    txt.total_deposits DESC;