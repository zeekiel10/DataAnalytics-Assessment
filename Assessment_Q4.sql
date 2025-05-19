-- This query calculates an estimated Customer Lifetime Value (CLV)
-- for each user based on transaction history and account tenure.

SELECT 
    u.id AS customer_id,  -- Unique ID of the customer
    CONCAT(u.first_name, ' ', u.last_name) AS Cus_name,  -- Full name of the customer

    -- Calculate how long the user has been active (in months)
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Count the total number of successful transactions the customer has made
    COUNT(*) AS total_transactions,

    -- Average profit per transaction is 0.1% of confirmed amount
    ROUND(AVG(s.confirmed_amount) * 0.001, 2) AS avg_profit_per_transaction,

    -- Estimate CLV using the formula:
    -- (total_transactions / tenure) * 12 months * avg profit per transaction
    ROUND((
        (COUNT(*) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0))  -- Avoid division by zero
        * 12 
        * AVG(s.confirmed_amount * 0.001)  -- Profit per transaction
    ), 2) AS estimated_clv

FROM 
    users_customuser u

-- Join user data with their savings transactions
LEFT JOIN 
    savings_savingsaccount s 
    ON u.id = s.owner_id

-- Consider only successful transactions for CLV calculation
WHERE 
    s.transaction_status IN ('success', 'successful') 

-- Group the results per customer
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined

-- Sort customers from highest to lowest estimated CLV
ORDER BY estimated_clv DESC;
