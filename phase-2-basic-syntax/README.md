# 📘 Phase 2 — Basic SQL Syntax

## 🎯 Mini Project: Employee Management System

A database to manage employees and departments in a company.  
This project deepens your SQL syntax skills with real-world HR data scenarios.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `departments` | Stores company departments |
| `employees` | Stores employee info linked to departments |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates both tables with constraints |
| `seed.sql` | Inserts sample departments and employees |
| `queries.sql` | Practice queries covering all Phase 2 concepts |

---

## ✅ Concepts Practiced

- `CREATE TABLE` with `FOREIGN KEY`
- `INSERT INTO` — adding employees and departments
- `UPDATE` — updating salaries, job titles, departments
- `DELETE` — removing employees and departments
- `SELECT` with `WHERE` filters
- `ORDER BY` salary (ASC and DESC)
- `BETWEEN`, `LIKE`, `IN`, `IS NULL`
- `LIMIT` — top earners
- `GROUP BY` + `AVG`, `COUNT`, `SUM`

---

## 🧪 How to Run

1. Run `schema.sql` → creates tables
2. Run `seed.sql` → inserts sample data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
departments                 employees
-----------                 ---------
dept_id (PK)   ←———        emp_id (PK)
dept_name           |       first_name
location            |       last_name
                    |       email
                    |       phone
                    |       hire_date
                    |       job_title
                    └———    dept_id (FK)
                            salary
                            is_active
```
