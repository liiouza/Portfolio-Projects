PRAGMA foreign_keys = ON; 
 
DROP VIEW IF EXISTS account_balances; 
DROP TABLE IF EXISTS transactions; 
DROP TABLE IF EXISTS accounts; 
DROP TABLE IF EXISTS customers; 
 
CREATE TABLE customers ( 
    customer_id INTEGER PRIMARY KEY, 
    full_name   TEXT NOT NULL, 
    email       TEXT NOT NULL UNIQUE, 
    city        TEXT NOT NULL, 
    joined_on   TEXT NOT NULL CHECK (date(joined_on) IS NOT NULL) 
); 
 
CREATE TABLE accounts ( 
    account_id   INTEGER PRIMARY KEY, 
    customer_id  INTEGER NOT NULL REFERENCES customers(customer_id), 
    account_type TEXT NOT NULL CHECK (account_type IN ('checking', 'savings')), 
    opened_on    TEXT NOT NULL CHECK (date(opened_on) IS NOT NULL), 
    status       TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'closed')) 
); 
  
CREATE TABLE transactions ( 
    transaction_id INTEGER PRIMARY KEY, 
    account_id     INTEGER NOT NULL REFERENCES accounts(account_id), 
    transaction_date TEXT NOT NULL CHECK (date(transaction_date) IS NOT NULL), 
    description    TEXT NOT NULL, 
    amount         NUMERIC NOT NULL CHECK (amount <> 0), 
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal', 'fee')), 
    CHECK ( 
        (transaction_type = 'deposit' AND amount > 0) 
        OR (transaction_type IN ('withdrawal', 'fee') AND amount < 0) 
    ) 
); 
 
CREATE INDEX idx_accounts_customer ON accounts(customer_id); 
CREATE INDEX idx_transactions_account_date ON transactions(account_id, transaction_date); 
 
CREATE VIEW account_balances AS 
SELECT 
    a.account_id, 
    a.customer_id, 
    c.full_name, 
    a.account_type, 
    a.status, 
    COALESCE(SUM(t.amount), 0) AS current_balance 
FROM accounts AS a 
JOIN customers AS c ON c.customer_id = a.customer_id 
LEFT JOIN transactions AS t ON t.account_id = a.account_id 
GROUP BY a.account_id, a.customer_id, c.full_name, a.account_type, a.status; 
