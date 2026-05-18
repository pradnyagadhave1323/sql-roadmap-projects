# 📘 Phase 6 — Advanced SQL Joins

## 🎯 Mini Project: Company HR Analytics System

A full HR intelligence database covering attendance, payroll, performance, and project allocation.  
This phase is all about **mastering every type of JOIN** — including self joins, multi-table joins, and hierarchical queries.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `departments` | Company departments with location and budget |
| `employees` | Full employee records with self-referencing manager hierarchy |
| `attendance` | Daily attendance logs per employee |
| `salaries` | Monthly salary records with deductions and bonuses |
| `projects` | Projects with assignments linking employees |
| `employee_projects` | Many-to-many: employees assigned to projects |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all 6 tables with constraints and relationships |
| `seed.sql` | Inserts departments, employees, attendance, salary, and project data |
| `queries.sql` | 60+ queries — every JOIN type, hierarchies, aggregations, HR reports |

---

## ✅ Concepts Practiced

**JOIN Types:**
- `INNER JOIN` — employees with departments, salary with employees
- `LEFT JOIN` — employees with no attendance, departments with no staff
- `RIGHT JOIN` — all departments even if no employees
- `SELF JOIN` — employee → manager hierarchy, org chart
- `CROSS JOIN` — all possible combinations concept
- Multi-table JOIN — 4 and 5 tables joined in one query

**Hierarchical Queries:**
- Manager → direct reports chain
- Full org chart (who reports to whom at every level)
- Team size per manager
- Average team salary per manager

**HR Analytics Reports:**
- 📋 Attendance summary (present, absent, late days per employee)
- 💰 Payroll report (gross pay, deductions, net pay per month)
- 🏆 Performance report (project hours + attendance + salary)
- 📊 Department headcount and total cost analysis
- 📅 Monthly salary trends across the year
- 🔍 Employees earning below department average

---

## 🧪 How to Run

1. Run `schema.sql` → creates all 6 tables
2. Run `seed.sql` → inserts sample HR data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
departments
-----------
dept_id (PK)
dept_name
location
budget
manager_id (FK → employees)

employees
---------
emp_id (PK)
first_name, last_name
email, phone
hire_date, job_title
dept_id    (FK → departments)
manager_id (FK → emp_id)  ← SELF-REFERENCING
salary
is_active

     ↓               ↓               ↓
attendance        salaries     employee_projects
----------        --------     -----------------
att_id (PK)       sal_id (PK)  ep_id (PK)
emp_id (FK)       emp_id (FK)  emp_id (FK → employees)
att_date          month        project_id (FK → projects)
status            year         role
check_in_time     basic_pay    hours_worked
check_out_time    bonus
                  deductions   projects
                  net_pay      --------
                               project_id (PK)
                               project_name
                               dept_id (FK)
                               start_date
                               end_date
                               status
                               budget
```
