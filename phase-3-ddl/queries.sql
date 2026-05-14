USE college_management;
GO

-- =============================================================
-- ALTER TABLE — Add New Columns
-- =============================================================

-- 1 Add blood_group column to students
ALTER TABLE students
ADD blood_group VARCHAR(5);

-- 2 Add office_number column to teachers
ALTER TABLE teachers
ADD office_number VARCHAR(20);

-- 3 Add fee column to courses
ALTER TABLE courses
ADD fee DECIMAL(8,2)
CONSTRAINT DF_courses_fee DEFAULT 5000.00;

-- 4 Add remarks column to enrollments
ALTER TABLE enrollments
ADD remarks VARCHAR(255);

-- Verify
SELECT * FROM students;
SELECT * FROM courses;

-- =============================================================
-- ALTER TABLE — Modify Existing Columns
-- =============================================================

-- 1 Increase size of address column
ALTER TABLE students
ALTER COLUMN address VARCHAR(500);

-- 2 Increase size of phone column
ALTER TABLE teachers
ALTER COLUMN phone VARCHAR(25);

-- 3 Change max_students default value to 50

DECLARE @ConstraintName NVARCHAR(200);

SELECT @ConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
ON dc.parent_object_id = c.object_id
AND dc.parent_column_id = c.column_id
WHERE OBJECT_NAME(dc.parent_object_id) = 'courses'
AND c.name = 'max_students';

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE courses DROP CONSTRAINT ' + @ConstraintName);
END;

-- Add new default constraint
ALTER TABLE courses
ADD CONSTRAINT DF_courses_max_students
DEFAULT 50 FOR max_students;

-- Verify
EXEC sp_help courses;

-- =============================================================
-- ALTER TABLE — Drop Columns
-- =============================================================

-- 1 Drop remarks column
ALTER TABLE enrollments
DROP COLUMN remarks;

-- 2 Drop blood_group column
ALTER TABLE students
DROP COLUMN blood_group;

-- Verify
EXEC sp_help enrollments;
EXEC sp_help students;

-- =============================================================
-- ALTER TABLE — Add Constraints
-- =============================================================

-- 1 Enrollment year must be 2015 or later
ALTER TABLE students
ADD CONSTRAINT chk_enrollment_year
CHECK (enrollment_year >= 2015);

-- 2 Course fee must be positive
ALTER TABLE courses
ADD CONSTRAINT chk_fee
CHECK (fee > 0);

-- 3 Make office_number NOT NULL

-- Update existing NULL values first
UPDATE teachers
SET office_number = 'TBD'
WHERE office_number IS NULL;

-- Alter column
ALTER TABLE teachers
ALTER COLUMN office_number VARCHAR(20) NOT NULL;

-- =============================================================
-- UNIQUE Constraint
-- =============================================================
ALTER TABLE courses
ADD CONSTRAINT uq_code_semester
UNIQUE (course_code, semester);

-- =============================================================
-- Rename Table
-- =============================================================

-- Rename enrollments table
EXEC sp_rename 'enrollments', 'student_enrollments';

-- Rename back
EXEC sp_rename 'student_enrollments', 'enrollments';

-- Verify tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- =============================================================
-- Data Queries
-- =============================================================

-- 1 Students with enrolled courses and grades
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    c.course_code,
    e.grade,
    e.status
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_name;

-- 2 Courses with teacher names
SELECT
    c.course_code,
    c.course_name,
    CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
    t.department
FROM courses c
LEFT JOIN teachers t
ON c.teacher_id = t.teacher_id
ORDER BY c.course_name;

-- 3 Student count per course
SELECT
    c.course_name,
    c.course_code,
    COUNT(e.student_id) AS enrolled_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
AND e.status = 'Active'
GROUP BY
    c.course_id,
    c.course_name,
    c.course_code
    ORDER BY enrolled_students DESC;

-- 4 Teacher teaching most courses
SELECT
    CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
    t.department,
    COUNT(c.course_id) AS courses_teaching
FROM teachers t
LEFT JOIN courses c
ON t.teacher_id = c.teacher_id
GROUP BY
    t.teacher_id,
    t.first_name,
    t.last_name,
    t.department
ORDER BY courses_teaching DESC;

-- 5 Average grade per course
SELECT
    c.course_name,
    ROUND(AVG(e.grade), 2) AS avg_grade,
    COUNT(e.enrollment_id) AS total_students
FROM courses c
JOIN enrollments e
ON c.course_id = e.course_id
WHERE
    e.status = 'Completed'
    AND e.grade IS NOT NULL
GROUP BY
    c.course_id,
    c.course_name
ORDER BY avg_grade DESC;

-- 6 Students enrolled in more than 2 courses
SELECT
    s.first_name,
    s.last_name,
    COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY
    s.student_id,
    s.first_name,
    s.last_name
HAVING COUNT(e.course_id) > 2
ORDER BY total_courses DESC;