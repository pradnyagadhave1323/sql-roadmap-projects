# 📘 Phase 5 — Aggregate Queries

## 🎯 Mini Project: Sales Analytics System

A sales intelligence database to generate real business reports from customer, product, and sales data.  
This phase is all about **GROUP BY, HAVING, aggregate functions, and multi-dimensional analysis**.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `customers` | Customer details with city and segment info |
| `products` | Product catalogue with categories and pricing |
| `sales` | Every sales transaction — links customers and products |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all 3 tables with constraints |
| `seed.sql` | Inserts customers, products, and 60+ sales transactions |
| `queries.sql` | 50+ aggregate queries — revenue, categories, city, monthly trends |

---

## ✅ Concepts Practiced

**Aggregate Functions:**
- `COUNT()` — number of transactions, customers
- `SUM()` — total revenue, quantity sold
- `AVG()` — average order value, avg price
- `MIN()` / `MAX()` — cheapest/most expensive, first/last sale
- `ROUND()` — clean decimal output

**Grouping & Filtering:**
- `GROUP BY` — single and multiple columns
- `HAVING` — filter after aggregation
- `WHERE` + `GROUP BY` — filter before aggregation

**Date-Based Analysis:**
- `MONTH()`, `YEAR()` — extract date parts
- `MONTHNAME()` — readable month names
- Monthly and yearly trend reports

**Reports Built:**
- 💰 Revenue reports (total, by product, by customer)
- 📦 Category analysis (best category, units sold)
- 🏙️ City-wise analytics (top cities, avg order value)
- 📅 Monthly trends (growth, best/worst months)
- 🏆 Top N analysis (top customers, top products)

---

## 🧪 How to Run

1. Run `schema.sql` → creates tables
2. Run `seed.sql` → inserts sample data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
customers                 products
---------                 --------
customer_id (PK)          product_id (PK)
full_name                 product_name
email (UNIQUE)            category
phone                     unit_price
city                      cost_price
state                     stock_qty
segment
                sales
                -----
                sale_id (PK)
                customer_id (FK → customers)
                product_id  (FK → products)
                quantity
                unit_price   ← price at time of sale
                discount_pct
                sale_date
                payment_mode
```
