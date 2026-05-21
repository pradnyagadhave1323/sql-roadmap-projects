# 📘 Phase 8 — Advanced SQL Functions

## 🎯 Mini Project: Employee Reporting System

A polished HR reporting system built entirely around SQL's built-in functions.  
This phase is all about **transforming raw data into clean, formatted, meaningful reports** using string, numeric, date, and conditional functions.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `departments` | Department info with budget and location |
| `employees` | Employee records with salary, hire date, and contact info |
| `bonuses` | Quarterly bonus records per employee |
| `leaves` | Leave (time-off) records per employee |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all 4 tables |
| `seed.sql` | Inserts employees, bonus records, and leave data |
| `queries.sql` | 60+ queries — string, numeric, date, conditional functions |

---

## ✅ Concepts Practiced

**String Functions:**
- `UPPER()`, `LOWER()` — case formatting
- `CONCAT()`, `CONCAT_WS()` — build display names
- `LENGTH()`, `CHAR_LENGTH()` — string length
- `TRIM()`, `LTRIM()`, `RTRIM()` — remove whitespace
- `SUBSTRING()`, `LEFT()`, `RIGHT()` — extract parts
- `REPLACE()` — swap characters
- `INSTR()`, `LOCATE()` — find position
- `LPAD()`, `RPAD()` — pad strings (e.g. employee IDs)
- `REVERSE()` — reverse a string
- `FORMAT()` — number-to-string with commas

**Numeric Functions:**
- `ROUND()`, `CEIL()`, `FLOOR()` — rounding
- `ABS()` — absolute value
- `MOD()` — remainder
- `TRUNCATE()` — cut decimals without rounding
- `POWER()`, `SQRT()` — math operations
- `GREATEST()`, `LEAST()` — compare multiple values

**Date & Time Functions:**
- `NOW()`, `CURDATE()`, `CURTIME()` — current timestamps
- `YEAR()`, `MONTH()`, `DAY()`, `MONTHNAME()`, `DAYNAME()`
- `DATEDIFF()` — days between two dates
- `TIMESTAMPDIFF()` — difference in years/months/days
- `DATE_ADD()`, `DATE_SUB()` — add/subtract intervals
- `DATE_FORMAT()` — custom date display format
- `LAST_DAY()` — last day of a month
- `WEEKDAY()`, `WEEK()` — day/week numbers

**Conditional Logic:**
- `CASE WHEN` — multi-branch logic
- `IF()` — simple two-branch logic
- `IFNULL()` — handle NULL values
- `NULLIF()` — return NULL on condition
- `COALESCE()` — first non-NULL value

---

## 🧪 How to Run

1. Run `schema.sql` → creates all 4 tables
2. Run `seed.sql` → inserts sample data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
departments               bonuses
-----------               -------
dept_id (PK)              bonus_id (PK)
dept_name                 emp_id (FK → employees)
location                  quarter   ENUM Q1–Q4
budget                    year
                          amount
                          reason

employees                 leaves
---------                 ------
emp_id (PK)               leave_id (PK)
first_name                emp_id (FK → employees)
last_name                 leave_type  ENUM
email                     start_date
phone                     end_date
hire_date                 days_taken
job_title                 status  ENUM
dept_id (FK)
manager_id (FK → emp_id)
salary
gender
is_active
```
