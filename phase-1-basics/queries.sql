-- =============================================================
-- Phase 1: Student Management System
-- File: queries.sql
-- Description: Practice queries covering all Phase 1 concepts
-- Run this AFTER schema.sql and seed.sql
-- =============================================================

USE student_management;


-- =============================================================
-- SECTION 1: SELECT — Basic reads
-- =============================================================

-- 1.1 Get all students
SELECT * FROM students;

-- 1.2 Get only names and emails
SELECT first_name, last_name, email FROM students;

-- 1.3 Get all courses with their credits
SELECT course_name, instructor, credits FROM courses;


-- =============================================================
-- SECTION 2: WHERE — Filtering rows
-- =============================================================

-- 2.1 Find a student by email
SELECT * FROM students
WHERE email = 'priya.patel@email.com';

-- 2.2 Find all students born after 2001
SELECT first_name, last_name, date_of_birth FROM students
WHERE date_of_birth > '2001-12-31';

-- 2.3 Find courses with 4 credits
SELECT course_name, instructor FROM courses
WHERE credits = 4;

-- 2.4 Find enrollments with grade above 85
SELECT * FROM enrollments
WHERE grade > 85;

-- 2.5 Find enrollments where grade is between 70 and 90
SELECT * FROM enrollments
WHERE grade BETWEEN 70 AND 90;

-- 2.6 Find students whose first name starts with 'A'
SELECT * FROM students
WHERE first_name LIKE 'A%';

-- 2.7 Find students with no phone number
SELECT first_name, last_name FROM students
WHERE phone IS NULL;

-- 2.8 Find enrollments where grade is not yet assigned
SELECT * FROM enrollments
WHERE grade IS NULL;


-- =============================================================
-- SECTION 3: INSERT — Adding new records
-- =============================================================

-- 3.1 Add a new student
INSERT INTO students (first_name, last_name, email, date_of_birth, phone)
VALUES ('Rohan', 'Verma', 'rohan.verma@email.com', '2002-06-18', '9112233445');

-- 3.2 Add a new course
INSERT INTO courses (course_name, instructor, credits)
VALUES ('Machine Learning Basics', 'Prof. Aisha Khan', 4);

-- 3.3 Enroll the new student in DBMS (course_id = 1)
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES (9, 1, CURRENT_DATE);   -- student_id 9 = Rohan (just inserted)


-- =============================================================
-- SECTION 4: UPDATE — Modifying records
-- =============================================================

-- 4.1 Update a student's phone number
UPDATE students
SET phone = '9000011112'
WHERE student_id = 8;

-- 4.2 Assign a grade to an enrollment that had NULL
UPDATE enrollments
SET grade = 82.00
WHERE student_id = 4 AND course_id = 1;

-- 4.3 Give everyone in Computer Networks (course_id=5) a 5-point bonus
UPDATE enrollments
SET grade = grade + 5
WHERE course_id = 5 AND grade IS NOT NULL;

-- 4.4 Update a course instructor
UPDATE courses
SET instructor = 'Prof. Ramesh Gupta'
WHERE course_id = 3;


-- =============================================================
-- SECTION 5: DELETE — Removing records
-- =============================================================

-- 5.1 Remove a specific enrollment (unenroll student 7 from course 3)
DELETE FROM enrollments
WHERE student_id = 7 AND course_id = 3;

-- 5.2 Delete a student (ON DELETE CASCADE removes their enrollments too)
-- Uncomment carefully — this deletes Kiran Mehta and their enrollments
-- DELETE FROM students WHERE student_id = 7;


-- =============================================================
-- SECTION 6: JOIN — Combining tables
-- =============================================================

-- 6.1 INNER JOIN — List all enrolled students with course names
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses  c ON e.course_id  = c.course_id
ORDER BY s.last_name, c.course_name;

-- 6.2 LEFT JOIN — All students, even those not enrolled in anything
SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses     c ON e.course_id  = c.course_id
ORDER BY s.last_name;

-- 6.3 Find which courses have no enrollments
SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;


-- =============================================================
-- SECTION 7: ORDER BY & LIMIT
-- =============================================================

-- 7.1 Top 5 highest grades
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses  c ON e.course_id  = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY e.grade DESC
LIMIT 5;

-- 7.2 Youngest 3 students
SELECT first_name, last_name, date_of_birth FROM students
ORDER BY date_of_birth DESC
LIMIT 3;


-- =============================================================
-- SECTION 8: Aggregate Functions — COUNT, AVG, SUM, MIN, MAX
-- =============================================================

-- 8.1 Total number of students
SELECT COUNT(*) AS total_students FROM students;

-- 8.2 Total number of enrollments
SELECT COUNT(*) AS total_enrollments FROM enrollments;

-- 8.3 Average grade across all enrollments
SELECT ROUND(AVG(grade), 2) AS overall_average FROM enrollments
WHERE grade IS NOT NULL;

-- 8.4 Average grade per course
SELECT
    c.course_name,
    ROUND(AVG(e.grade), 2) AS avg_grade,
    COUNT(e.student_id)    AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY avg_grade DESC;

-- 8.5 Number of courses each student is enrolled in
SELECT
    s.first_name,
    s.last_name,
    COUNT(e.course_id) AS courses_enrolled
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_enrolled DESC;

-- 8.6 Students enrolled in more than 2 courses (HAVING)
SELECT
    s.first_name,
    s.last_name,
    COUNT(e.course_id) AS courses_enrolled
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > 2;

-- 8.7 Highest and lowest grade in each course
SELECT
    c.course_name,
    MAX(e.grade) AS highest_grade,
    MIN(e.grade) AS lowest_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.grade IS NOT NULL
GROUP BY c.course_id, c.course_name;
