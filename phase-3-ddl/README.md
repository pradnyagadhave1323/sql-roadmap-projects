# 📘 Phase 3 — Data Definition Language (DDL)

## 🎯 Mini Project: College Management System

A fully structured college database with proper constraints, relationships, and schema modifications.  
This project focuses on **how to define and modify database structure** — not just querying data.

---

## 🗃️ Tables

| Table | Description |
|-------|-------------|
| `students` | Stores student personal and academic info |
| `teachers` | Stores teacher/faculty details |
| `courses` | Stores courses offered, linked to a teacher |
| `enrollments` | Links students to courses (many-to-many) |

---

## 📂 Files

| File | Purpose |
|------|---------|
| `schema.sql` | Creates all tables with full constraints and relationships |
| `seed.sql` | Inserts sample students, teachers, courses, and enrollments |
| `queries.sql` | DDL practice — ALTER, DROP, RENAME, constraints, plus data queries |

---

## ✅ Concepts Practiced

**DDL Commands:**
- `CREATE TABLE` with full constraints
- `ALTER TABLE` — add/drop/modify columns
- `DROP TABLE` / `DROP DATABASE`
- `TRUNCATE` — clear data without dropping table
- `RENAME TABLE`

**Constraints:**
- `PRIMARY KEY` — unique row identifier
- `FOREIGN KEY` — enforce relationships between tables
- `NOT NULL` — field must have a value
- `UNIQUE` — no duplicate values
- `CHECK` — validate data on insert/update
- `DEFAULT` — fallback value if none provided

**Relationships:**
- One-to-Many: one teacher → many courses
- Many-to-Many: students ↔ courses via enrollments

---

## 🧪 How to Run

1. Run `schema.sql` → creates the database and all tables
2. Run `seed.sql` → populates with sample data
3. Open `queries.sql` → run section by section

---

## 🗺️ Schema Diagram

```
teachers                  students
--------                  --------
teacher_id (PK)           student_id (PK)
first_name                first_name
last_name                 last_name
email (UNIQUE)            email (UNIQUE)
phone                     phone
department                date_of_birth
qualification             gender
salary                    address
joined_date               enrollment_year
                          gpa

     ↓ (one teacher → many courses)

courses                           enrollments
-------                           -----------
course_id (PK)                    enrollment_id (PK)
course_name                       student_id (FK → students)
course_code (UNIQUE)              course_id  (FK → courses)
credits (CHECK 1–6)               enrollment_date
teacher_id (FK → teachers)        grade
max_students (DEFAULT 60)         status
semester
```
