# Banking Transactions Database

A small SQLite portfolio project for modeling retail banking activity and answering finance-oriented questions with SQL. All names, accounts, and transactions are fictional sample data.

## Skills demonstrated

- Relational schema design with primary keys, foreign keys, constraints, and indexes
- SQL joins, grouping, date filtering, conditional aggregation, and window functions
- Transaction volume, monthly cash flow, account activity, and customer-level analysis
- Reproducible setup from plain SQL files

## Project files

- `schema.sql` creates the tables and a reusable account balance view.
- `seed.sql` inserts a small fictional dataset.
- `queries.sql` contains five analysis queries.
- `run_demo.py` builds a fresh database and prints the query results using Python's standard library.
- [`BEGINNER_GUIDE.md`](./BEGINNER_GUIDE.md) explains the project files line by line in beginner-friendly language.

## Run the project

Requires Python 3.9 or later. No third-party packages are needed.

```bash
python3 run_demo.py
```

The script creates `banking_demo.db` in this folder. To rebuild it, run the command again; the demo database is recreated from the SQL files.

You can also use SQLite directly:

```bash
sqlite3 banking_demo.db < schema.sql
sqlite3 banking_demo.db < seed.sql
sqlite3 -header -column banking_demo.db < queries.sql
```

## Questions answered

1. What is each account's current balance?
2. How much money moved in and out each month?
3. Which customers have the highest total transaction volume?
4. Which accounts had no activity during the final month in the sample?
5. How does each account's transaction volume rank within its account type?

## Data model

Each customer can own one or more accounts. Every account belongs to an account type, and each transaction records a signed amount and a transaction date. Deposits are positive and withdrawals are negative, so balances and net cash flow can be calculated with `SUM(amount)`.

The sample period is January through June 2025. The data is intentionally compact so the queries and schema are easy to inspect and explain in an interview.

## CV description (after you review and run it)

**Banking Transactions Database | SQLite, SQL** — Designed a relational database for customers, accounts, and transactions; added integrity constraints and an account-balance view; queried transaction activity and monthly net flows with joins, aggregations, and window functions.

## Possible extensions

- Add a transfer table that links the debit and credit sides of an internal transfer.
- Add a transaction category dimension and compare spending by category.
- Extend the sample dataset and add a query that flags unusual transaction patterns.

This is a learning project using fictional data, not a banking system.
