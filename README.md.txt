# DataAnalytics-Assessment

This repository contains SQL queries for key financial and customer analytics tasks using Cowrywise dataset tables.

## 📊 Contents

1. **High-Value Customers**
A "funded" savings is identified by a positive amount in savings_savingsaccount.

A "funded" investment plan is a plans_plan with a positive amount and a plan_type_id (assuming different plan types distinguish savings and investments).
We'll assume:
plan_type_id = 1 → savings plan
plan_type_id = 2 → investment plan
   - File: `01_high_value_customers.sql`
   - Identifies customers with both savings and investment plans.


2. **Transaction Frequency Analysis**
   - File: `02_transaction_frequency_analysis.sql`
   - Segments customers based on monthly transaction activity.

Each row in savings_savingsaccount is a transaction.
The transaction date is stored in transaction_date.
We'll calculate the number of transactions per customer per month using the available timestamps.

Customers are categorized into:
High Frequency: ≥10 transactions/month

Medium Frequency: 3–9 transactions/month

Low Frequency: ≤2 transactions/month



3. **Account Inactivity Alert**
   - File: `03_account_inactivity_alert.sql`
   - Flags accounts with no inflow for over a year.

Savings transactions are in savings_savingsaccount.

Active plans are from plans_plan (filtered using appropriate status_id or flags like is_deleted, is_archived, etc.).
Inflow transactions are assumed to be amount > 0.
Plan type is identified via plan_type_id:

We'll assume:

1 = Savings

2 = Investment

The last transaction date is based on transaction_date from savings_savingsaccount.



4. **Customer Lifetime Value (CLV)**
   - File: `04_customer_lifetime_value.sql`
   - Estimates CLV using account tenure and transaction data.

To calculate Customer Lifetime Value (CLV) using a simplified model, we’ll compute:

CLV Formula:
Estimated CLV
=
(
Total Transactions
Tenure in Months
) × 12 × Avg Profit per Transaction
Estimated CLV=( Tenure in Months
Total Transactions) × 12 × Avg Profit per Transaction

With:
profit_per_transaction = 0.001 × transaction amount

tenure = months since signup (based on users_customuser.date_joined)

total_transactions = total number of inflow records per customer (from savings_savingsaccount where amount > 0)

Use average transaction amount to estimate profit.



## 📂 Tables Used

- `users_customuser`
- `plans_plan`
- `savings_savingsaccount`

