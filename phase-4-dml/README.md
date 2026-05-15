# 📘 Phase 4 — Data Manipulation Language (DML)

## 🎯 Mini Project: Employee Analytics System

A company analytics database to extract meaningful insights from employee, department, and project data.  
This phase is all about **mastering how to read and manipulate data** — the heart of real-world SQL work.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `departments` | Company departments with budget info |
| `employees` | Employee details linked to departments and managers |
| `projects` | Projects assigned to departments |
| `employee_projects` | Which employees work on which projects (many-to-many) |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all 4 tables with constraints |
| `seed.sql` | Inserts realistic company data |
| `queries.sql` | 50+ DML queries — JOINs, aggregations, sorting, filtering, reports |

---

## ✅ Concepts Practiced

**JOINs:**
- `INNER JOIN` — matching rows only
- `LEFT JOIN` — all left rows, NULLs for unmatched right
- `RIGHT JOIN` — all right rows
- Self JOIN — employee-manager relationship
- Multi-table JOIN — 3 and 4 table joins

**Aggregations:**
- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` + `HAVING`
- Aggregate with JOINs

**Filtering & Sorting:**
- `WHERE` with multiple conditions
- `BETWEEN`, `IN`, `LIKE`, `IS NULL`
- `ORDER BY` single and multiple columns
- `LIMIT` + `OFFSET` (pagination)

**Reports:**
- Salary reports per department
- Project workload per employee
- Top performers
- Budget vs actual headcount
- Department summary dashboard

---

## 🧪 How to Run

1. Run `schema.sql` → creates tables
2. Run `seed.sql` → inserts sample data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
departments                         projects
-----------                         --------
dept_id (PK)                        project_id (PK)
dept_name                           project_name
location             ←——————        dept_id (FK)
budget                    |         start_date
manager_id (FK→employees) |         end_date
                          |         status
                          |         budget
employees                 |
---------                 |    employee_projects
emp_id (PK)               |    ------------------
first_name                |    emp_project_id (PK)
last_name                 |    emp_id (FK → employees)
email                     |    project_id (FK → projects)
dept_id (FK) ————————————         role
manager_id (FK → emp_id)          hours_worked
job_title
salary
hire_date
is_active
```
