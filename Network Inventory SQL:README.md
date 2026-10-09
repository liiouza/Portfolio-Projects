# Network Inventory Database

A SQLite database for tracking network devices, locations, health checks, and support incidents. It models a simplified environment that could be used for reporting.

## What is included

- A normalized schema with primary keys, foreign keys, `CHECK` constraints, a view, and a trigger
- Sample device and incident data
- Four operational queries: device health, open incidents, resolution metrics, and stale health checks

## Run the demo

Requires the `sqlite3` command-line tool.

```bash
sqlite3 inventory.db < schema.sql
sqlite3 inventory.db < sample_data.sql
sqlite3 -header -column inventory.db < queries.sql
```

## Design choices

- A device belongs to one location; incidents belong to one device.
- IP and MAC addresses are unique to prevent duplicate inventory entries.
- A `device_health` view gives a reusable dashboard without duplications.
- A trigger that prevents mistakes such as opening a new incident against a retired device.

## Skills demonstrated

SQL · relational database design · constraints · joins · aggregation · IT asset inventory · incident reporting
