-- =============================================================
-- College Management System Database Project
-- =============================================================
CREATE DATABASE college_management;
GO

USE college_management;
GO

-- =============================================================
-- Table 1: Teachers
-- =============================================================
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY IDENTITY(1,1),

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),

    department VARCHAR(100) NOT NULL,
    qualification VARCHAR(100) NOT NULL,

    salary DECIMAL(10,2)
        NOT NULL CHECK (salary >= 20000),

    joined_date DATE NOT NULL,

    is_active BIT DEFAULT 1
);

-- =============================================================
-- Table 2: Students
-- =============================================================
CREATE TABLE students (
    student_id INT PRIMARY KEY IDENTITY(1,1),

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),

    date_of_birth DATE NOT NULL,

    gender VARCHAR(10)
        NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),

    address VARCHAR(255),

    enrollment_year INT NOT NULL,

    gpa DECIMAL(3,2)
        CHECK (gpa BETWEEN 0.00 AND 10.00),

    is_active BIT DEFAULT 1
);

-- =============================================================
-- Table 3: Courses
-- =============================================================
CREATE TABLE courses (
    course_id INT PRIMARY KEY IDENTITY(1,1),

    course_name VARCHAR(100) NOT NULL,

    course_code VARCHAR(20)
        NOT NULL UNIQUE,

    credits INT
        NOT NULL CHECK (credits BETWEEN 1 AND 6),

    teacher_id INT,

    max_students INT DEFAULT 60,

    semester VARCHAR(20)
        NOT NULL CHECK (
            semester IN ('Semester 1', 'Semester 2', 'Summer')
        ),

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (teacher_id)
        REFERENCES teachers(teacher_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- =============================================================
-- Table 4: Enrollments
-- =============================================================
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY IDENTITY(1,1),

    student_id INT NOT NULL,
    course_id INT NOT NULL,

    enrollment_date DATE
        NOT NULL DEFAULT GETDATE(),

    grade DECIMAL(5,2)
        CHECK (grade BETWEEN 0 AND 100),

    status VARCHAR(20)
        DEFAULT 'Active'
        CHECK (status IN ('Active', 'Completed', 'Dropped')),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE,

    UNIQUE (student_id, course_id)
);

-- =============================================================
-- Insert Teachers
-- =============================================================
INSERT INTO teachers (
    first_name,
    last_name,
    email,
    phone,
    department,
    qualification,
    salary,
    joined_date
)
VALUES
('Rajesh', 'Kumar', 'rajesh.kumar@college.edu', '9876543210',
 'Computer Science', 'PhD Computer Science', 85000.00, '2015-07-01'),

('Meena', 'Iyer', 'meena.iyer@college.edu', '9123456789',
 'Mathematics', 'MSc Mathematics', 72000.00, '2017-03-15'),

('Anil', 'Sharma', 'anil.sharma@college.edu', '9988776655',
 'Physics', 'PhD Physics', 90000.00, '2012-08-20'),

('Sunita', 'Rao', 'sunita.rao@college.edu', '9001122334',
 'Computer Science', 'MTech Software Engg', 78000.00, '2019-01-10'),

('Deepak', 'Joshi', 'deepak.joshi@college.edu', '9871234560',
 'Electronics', 'PhD Electronics', 82000.00, '2014-06-05'),

('Kavita', 'Singh', 'kavita.singh@college.edu', NULL,
 'Mathematics', 'PhD Applied Mathematics', 76000.00, '2018-09-01');

-- =============================================================
-- Insert Students
-- =============================================================
INSERT INTO students (
    first_name,
    last_name,
    email,
    phone,
    date_of_birth,
    gender,
    address,
    enrollment_year,
    gpa
)
VALUES
('Arjun', 'Sharma', 'arjun.sharma@student.edu',
 '9876501234', '2003-03-15', 'Male',
 'Pune, Maharashtra', 2022, 8.50),

('Priya', 'Patel', 'priya.patel@student.edu',
 '9123498765', '2004-07-22', 'Female',
 'Mumbai, Maharashtra', 2023, 9.10),

('Rahul', 'Desai', 'rahul.desai@student.edu',
 '9988001122', '2002-11-08', 'Male',
 'Nagpur, Maharashtra', 2021, 7.80),

('Sneha', 'Kulkarni', 'sneha.kulkarni@student.edu',
 '9001234567', '2003-05-30', 'Female',
 'Nashik, Maharashtra', 2022, 8.90),

('Vikram', 'Nair', 'vikram.nair@student.edu',
 '9871230001', '2004-01-17', 'Male',
 'Kolhapur, Maharashtra', 2023, 7.20),

('Ananya', 'Iyer', 'ananya.iyer@student.edu',
 '9765400001', '2003-09-03', 'Female',
 'Sangli, Maharashtra', 2022, 9.40),

('Kiran', 'Mehta', 'kiran.mehta@student.edu',
 '9090001234', '2002-12-25', 'Male',
 'Solapur, Maharashtra', 2021, 6.90),

('Divya', 'Joshi', 'divya.joshi@student.edu',
 NULL, '2004-04-14', 'Female',
 'Aurangabad, Maharashtra', 2023, 8.20),

('Rohan', 'Verma', 'rohan.verma@student.edu',
 '9112200001', '2003-06-18', 'Male',
 'Pune, Maharashtra', 2022, 7.50),

('Meera', 'Singh', 'meera.singh@student.edu',
 '9654300001', '2002-02-28', 'Female',
 'Mumbai, Maharashtra', 2021, 9.00);

-- =============================================================
-- Insert Courses
-- =============================================================
INSERT INTO courses (
    course_name,
    course_code,
    credits,
    teacher_id,
    max_students,
    semester
)
VALUES
('Database Management Systems', 'CS301', 4, 1, 60, 'Semester 1'),
('Data Structures & Algorithms', 'CS201', 4, 1, 55, 'Semester 1'),
('Calculus', 'MATH101', 3, 2, 70, 'Semester 1'),
('Linear Algebra', 'MATH201', 3, 2, 65, 'Semester 2'),
('Mechanics', 'PHY101', 4, 3, 60, 'Semester 1'),
('Web Development', 'CS401', 3, 4, 50, 'Semester 2'),
('Digital Electronics', 'EC201', 4, 5, 55, 'Semester 2'),
('Discrete Mathematics', 'MATH301', 3, 6, 60, 'Semester 1'),
('Operating Systems', 'CS302', 4, 1, 55, 'Semester 2'),
('Python Programming', 'CS101', 3, 4, 70, 'Semester 1');

-- =============================================================
-- Insert Enrollments
-- =============================================================
INSERT INTO enrollments (
    student_id,
    course_id,
    enrollment_date,
    grade,
    status
)
VALUES
(1, 1, '2022-07-15', 88.50, 'Completed'),
(1, 2, '2022-07-15', 91.00, 'Completed'),
(1,10, '2022-07-15', 85.00, 'Completed'),

(2, 1, '2023-07-10', 95.00, 'Active'),
(2, 3, '2023-07-10', 89.50, 'Active'),
(2,10, '2023-07-10', 92.00, 'Active'),

(3, 2, '2021-07-20', 72.00, 'Completed'),
(3, 5, '2021-07-20', 68.50, 'Completed'),
(3, 9, '2022-01-15', 75.00, 'Completed'),

(4, 1, '2022-07-15', 93.00, 'Active'),
(4, 6, '2023-01-10', 87.50, 'Active'),
(4, 8, '2022-07-15', 90.00, 'Completed'),

(5, 3, '2023-07-10', 65.00, 'Active'),
(5, 7, '2023-07-10', 70.00, 'Active'),

(6, 1, '2022-07-15', 97.00, 'Completed'),
(6, 2, '2022-07-15', 96.00, 'Completed'),
(6, 4, '2023-01-10', NULL, 'Active'),

(7, 5, '2021-07-20', 58.00, 'Completed'),
(7, 9, '2022-01-15', 62.00, 'Completed'),

(8,10, '2023-07-10', NULL, 'Active'),
(8, 3, '2023-07-10', 84.00, 'Active'),

(9, 1, '2022-07-15', 79.00, 'Active'),
(9, 6, '2023-01-10', 83.00, 'Active'),

(10,2, '2021-07-20', 94.00, 'Completed'),
(10,4, '2022-01-15', 88.00, 'Completed'),
(10,8, '2021-07-20', 91.00, 'Completed');

SELECT * FROM teachers;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;