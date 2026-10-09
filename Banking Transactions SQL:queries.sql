-- 1. Current balance by account, including accounts without transactions.
SELECT account_id, full_name, account_type, status, ROUND(current_balance, 2) AS current_balance
FROM account_balances
ORDER BY customer_id, account_id;

-- 2. Monthly deposits, withdrawals, net cash flow, and transaction count.
SELECT
    strftime('%Y-%m', transaction_date) AS month,
    ROUND(SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END), 2) AS deposits,
    ROUND(SUM(CASE WHEN amount < 0 THEN -amount ELSE 0 END), 2) AS withdrawals,
    ROUND(SUM(amount), 2) AS net_flow,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY strftime('%Y-%m', transaction_date)
ORDER BY month;

-- 3. Customers ranked by total transaction volume (absolute value).
SELECT
    c.customer_id,
    c.full_name,
    ROUND(SUM(ABS(t.amount)), 2) AS transaction_volume,
    COUNT(t.transaction_id) AS transaction_count
FROM customers AS c
JOIN accounts AS a ON a.customer_id = c.customer_id
JOIN transactions AS t ON t.account_id = a.account_id
GROUP BY c.customer_id, c.full_name
ORDER BY transaction_volume DESC;

-- 4. Accounts with no transaction in June 2025.
SELECT a.account_id, c.full_name, a.account_type
FROM accounts AS a
JOIN customers AS c ON c.customer_id = a.customer_id
LEFT JOIN transactions AS t
    ON t.account_id = a.account_id
   AND t.transaction_date >= '2025-06-01'
   AND t.transaction_date < '2025-07-01'
WHERE t.transaction_id IS NULL
ORDER BY a.account_id;

-- 5. Account transaction volume ranking within each account type.
WITH account_volume AS (
    SELECT
        a.account_id,
        c.full_name,
        a.account_type,
        ROUND(COALESCE(SUM(ABS(t.amount)), 0), 2) AS transaction_volume
    FROM accounts AS a
    JOIN customers AS c ON c.customer_id = a.customer_id
    LEFT JOIN transactions AS t ON t.account_id = a.account_id
    GROUP BY a.account_id, c.full_name, a.account_type
)
SELECT
    account_id,
    full_name,
    account_type,
    transaction_volume,
    DENSE_RANK() OVER (PARTITION BY account_type ORDER BY transaction_volume DESC) AS type_rank
FROM account_volume
ORDER BY account_type, type_rank, account_id;
