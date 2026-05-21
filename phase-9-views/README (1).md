# 📘 Phase 9 — SQL Views

## 🎯 Mini Project: Employee Reporting & Analytics System

A production-style reporting system built entirely on **SQL Views** — the foundation of how real companies build dashboards, secure data access layers, and reusable analytics pipelines.  
This phase is all about **creating virtual tables that hide complexity, protect sensitive data, and power reports.**

---

## 🗃️ Tables (Base Tables)

| Table | Description |
|-------|-------------|
| `departments` | Department info with budget and location |
| `employees` | Full employee records — salary, hierarchy, dates |
| `salaries_log` | Every salary change ever made (audit trail) |
| `performance_reviews` | Quarterly scores per employee |
| `projects` | Projects with status and budget |
| `employee_projects` | Employees assigned to projects |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all 6 base tables |
| `seed.sql` | Inserts realistic HR data |
| `views.sql` | 20+ views — simple, aggregated, secure, joined, nested |
| `queries.sql` | 40+ queries that USE the views for reports and analysis |

---

## ✅ Concepts Practiced

**View Types Built:**
- **Simple views** — single table, column renaming, basic filters
- **Joined views** — combine multiple tables into one clean virtual table
- **Aggregated views** — GROUP BY inside a view for instant summaries
- **Filtered views** — WHERE clause baked into the view
- **Nested views** — a view built on top of another view
- **Secure views** — hides sensitive columns (salary, phone) from end users

**View Operations:**
- `CREATE VIEW` — define the view
- `CREATE OR REPLACE VIEW` — update an existing view safely
- `ALTER VIEW` — rename/modify a view (MySQL syntax)
- `DROP VIEW` — remove a view
- `SHOW FULL TABLES WHERE Table_type = 'VIEW'` — list all views
- `DESCRIBE view_name` — inspect view structure
- `WITH CHECK OPTION` — enforce view filters on INSERT/UPDATE

**Reports Built via Views:**
- 📋 Department summary dashboard
- 💰 Salary analytics (bands, averages, comparisons)
- 🔒 Secure employee directory (no sensitive fields)
- 🏆 Performance leaderboard
- 📊 Project analytics view
- 📅 Tenure and joining year analysis
- 🔍 Manager hierarchy view

---

## 🧪 How to Run

```
1. schema.sql  → creates base tables
2. seed.sql    → inserts data
3. views.sql   → creates all 20+ views
4. queries.sql → queries that USE the views
```

> 💡 Always run `views.sql` before `queries.sql` — the queries depend on the views existing.

---

## 🗺️ Schema + Views Architecture

```
BASE TABLES (schema.sql)              VIEWS (views.sql)
═════════════════════════             ══════════════════════════════════

departments  ──────────────────────→  v_department_summary
employees    ──┬───────────────────→  v_employee_full_profile
               ├───────────────────→  v_employee_secure          ← no salary/phone
               ├───────────────────→  v_salary_bands
               └───────────────────→  v_manager_hierarchy
salaries_log ──────────────────────→  v_latest_salary
performance_reviews ───────────────→  v_performance_summary
projects ──────────────────────────→  v_project_status
employee_projects ─────────────────→  v_project_team

NESTED VIEWS (views built on views):
v_employee_full_profile ───────────→  v_high_earners
v_performance_summary   ───────────→  v_top_performers
v_department_summary    ───────────→  v_dept_over_budget
```
