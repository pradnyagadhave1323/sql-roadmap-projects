# 📘 Phase 7 — Subqueries & Nested Queries

## 🎯 Mini Project: Advanced Employee Analytics System

A deep-dive analytics system that uses subqueries, derived tables, and nested logic to answer complex business questions that simple joins can't solve alone.  
This phase is all about **thinking in layers** — a query inside a query inside a query.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `departments` | Company departments with budget and location |
| `employees` | Employee records with salary and manager hierarchy |
| `performance_reviews` | Quarterly performance scores per employee |
| `salaries_history` | Full salary revision history per employee |
| `projects` | Projects with status and assigned department |
| `employee_projects` | Many-to-many: employees assigned to projects |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all 6 tables |
| `seed.sql` | Inserts employees, reviews, salary history, project data |
| `queries.sql` | 60+ queries — subqueries, derived tables, EXISTS, ANY, ALL |

---

## ✅ Concepts Practiced

**Subquery Types:**
- **Scalar subquery** — returns single value, used in SELECT or WHERE
- **Row subquery** — returns one row
- **Column subquery** — returns one column of values
- **Table subquery (derived table)** — used in FROM as a virtual table

**Subquery Positions:**
- Subquery in `WHERE` — filter using computed results
- Subquery in `SELECT` — compute per-row derived values
- Subquery in `FROM` — treat a query result as a table
- Subquery in `HAVING` — filter groups using nested aggregates

**Operators:**
- `IN` / `NOT IN` — match against a list from subquery
- `EXISTS` / `NOT EXISTS` — check if subquery returns any rows
- `ANY` — true if condition matches at least one subquery result
- `ALL` — true if condition matches every subquery result
- Correlated subqueries — inner query references outer query row

**Reports Built:**
- 💰 Salary analysis (above avg, top earners, salary growth)
- 🏢 Department analytics (budget efficiency, team strength)
- 🏆 Performance reports (top performers, consistent high scorers)
- 📊 Comparative analytics (vs dept avg, vs company avg)
- 🔍 Anomaly detection (overpaid, underpaid, no reviews)

---

## 🧪 How to Run

1. Run `schema.sql` → creates all 6 tables
2. Run `seed.sql` → inserts sample data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
departments                    projects
-----------                    --------
dept_id (PK)                   project_id (PK)
dept_name                      project_name
location                       dept_id (FK)
budget                         status
manager_id (FK → employees)    budget

employees                      employee_projects
---------                      -----------------
emp_id (PK)                    ep_id (PK)
first_name, last_name          emp_id (FK)
email, phone                   project_id (FK)
hire_date, job_title           role
dept_id (FK → departments)     hours_worked
manager_id (FK → emp_id)
salary
is_active

performance_reviews            salaries_history
-------------------            ----------------
review_id (PK)                 hist_id (PK)
emp_id (FK → employees)        emp_id (FK → employees)
review_quarter  (Q1–Q4)        effective_date
review_year                    salary_amount
score (1.00–10.00)             revision_reason
reviewer_id (FK → employees)
comments
```
