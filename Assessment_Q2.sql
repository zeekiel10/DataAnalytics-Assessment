-- Categorize customers based on their average number of monthly transactions
SELECT
  -- Create a frequency category based on average transactions per month
  CASE
    WHEN cus.Avg_Trans >= 10 THEN 'High Frequency'
    WHEN cus.Avg_Trans >= 3 AND cus.Avg_Trans <= 9 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS Frequency,

  -- Count the number of customers in each frequency category
  COUNT(*) AS Customer_count,

  -- Calculate the average of average transactions (across customers in the same frequency category)
  ROUND(AVG(cus.Avg_Trans), 2) AS Avg_Trans

FROM (
  -- Subquery: Compute average monthly transactions for each customer
  SELECT 
    t.owner_id, 
    ROUND(AVG(t.total_transactions), 2) AS Avg_Trans  -- Average number of transactions per month for each customer
  FROM (
    -- Sub-subquery: Count monthly transactions per customer
    SELECT
      owner_id,
      DATE_FORMAT(transaction_date, '%Y-%m') AS mnth_yr,  -- Group by year and month
      COUNT(*) AS total_transactions  -- Count transactions in each month
    FROM savings_savingsaccount s
    JOIN users_customuser u ON u.id = s.owner_id  -- Join with user table (optional here unless filtering by user attributes)
    WHERE transaction_status IN ('success', 'successful')  -- Only successful transactions
    GROUP BY owner_id, mnth_yr  -- Group by customer and month
  ) t
  GROUP BY t.owner_id  -- Get average monthly transactions per customer
) cus
GROUP BY Frequency;  -- Final grouping by frequency category
