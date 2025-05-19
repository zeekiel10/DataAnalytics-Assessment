# DataAnalytics-Assessment
**Question 1 : Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.**
Solution: 
First, I had to break down the requirement of identifying funded savings and funded investment plans separately checking for confirmed deposits under each. I used my savings experience on Piggyvest to approach this part logically.
Then, using the hint given, I aggregated the data per customer: counting how many of each plan type they funded and summing up their total confirmed deposits.
Finally, I filtered for customers who had at least one of each funded plan and sorted them by total deposits to spotlight the most valuable users.

**Question 2: Calculate the average number of transactions per customer per month and categorize them**:
Solution : 
I had to get my month_yr first using DATE_FORMAT to group each customer's transactions by month.
Then I calculated their average number of monthly transactions, which helped in classifying them into frequency buckets (Low, Medium, or High).
Finally, I grouped the customers by these frequency categories, counted how many fall into each, and computed the average transaction rate for each group.

Question 3: **Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)** 
I started by looking at all the savings and investment plans from the plans table — only the ones marked as either a regular savings or an investment plan. For each plan, I wanted to find the most recent transaction where money was successfully added to that plan. So, I checked the transactions table for successful deposits linked to each plan and picked the latest date for each.
Next, I compared today’s date with that most recent transaction date to see how long it’s been since the user last put money into their plan. If a plan never had a successful transaction, I used the plan’s start date as the reference point instead.
Finally, I filtered the results to show only those plans where it’s been more than 365 days (a year) since the last deposit or the plan started. This way, I could highlight accounts that have been inactive for a long time.The output includes each plan’s ID, the owner, the type (Savings or Investment), the date of the last transaction, and the number of inactive days.

**Question 4: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:**
I started by calculating the tenure of each customer in months using the TIMESTAMPDIFF function between their signup date (date_joined) and today (CURDATE()). This helps normalize transaction activity across users who've been active for different durations.

Then, I counted the total number of successful transactions for each user and computed the average profit per transaction using AVG(confirmed_amount) * 0.001, since 0.1% is the assumed profit margin.

Finally, I applied the CLV formula:
(total_transactions ÷ tenure) × 12 × avg_profit_per_transaction,which estimates annualized CLV based on average transaction frequency and profit.

To make the results meaningful, I filtered only successful transactions, grouped everything by customer, and sorted by CLV to highlight the most valuable users.


