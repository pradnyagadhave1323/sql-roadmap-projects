-- =============================================================
-- Phase 1: Student Management System
-- File: seed.sql
-- Description: Inserts sample data into all tables
-- Run this AFTER schema.sql
-- =============================================================

USE student_management;

-- -------------------------------------------------------------
-- Insert Students
-- -------------------------------------------------------------
INSERT INTO students (first_name, last_name, email, date_of_birth, phone) VALUES
('Arjun',   'Sharma',   'arjun.sharma@email.com',   '2001-03-15', '9876543210'),
('Priya',   'Patel',    'priya.patel@email.com',    '2002-07-22', '9123456789'),
('Rahul',   'Desai',    'rahul.desai@email.com',    '2000-11-08', '9988776655'),
('Sneha',   'Kulkarni', 'sneha.kulkarni@email.com', '2001-05-30', '9001122334'),
('Vikram',  'Nair',     'vikram.nair@email.com',    '2003-01-17', '9871234560'),
('Ananya',  'Iyer',     'ananya.iyer@email.com',    '2002-09-03', '9765432100'),
('Kiran',   'Mehta',    'kiran.mehta@email.com',    '2001-12-25', '9090909090'),
('Divya',   'Joshi',    'divya.joshi@email.com',    '2000-04-14', NULL);

-- -------------------------------------------------------------
-- Insert Courses
-- -------------------------------------------------------------
INSERT INTO courses (course_name, instructor, credits) VALUES
('Database Management Systems', 'Prof. Rajesh Kumar',  4),
('Data Structures & Algorithms','Prof. Meena Iyer',    4),
('Web Development Basics',      'Prof. Anil Sharma',   3),
('Python Programming',          'Prof. Sunita Rao',    3),
('Computer Networks',           'Prof. Deepak Joshi',  4),
('Operating Systems',           'Prof. Kavita Singh',  4);

-- -------------------------------------------------------------
-- Insert Enrollments
-- -------------------------------------------------------------
INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2024-01-10', 88.50),
(1, 2, '2024-01-10', 92.00),
(1, 3, '2024-01-11', 76.00),
(2, 1, '2024-01-10', 95.00),
(2, 4, '2024-01-12', 89.00),
(3, 2, '2024-01-10', 70.50),
(3, 5, '2024-01-13', 83.00),
(4, 1, '2024-01-10', NULL),   -- enrolled but grade not yet assigned
(4, 3, '2024-01-11', 91.00),
(4, 6, '2024-01-14', 78.50),
(5, 4, '2024-01-12', 65.00),
(5, 5, '2024-01-13', 72.00),
(6, 2, '2024-01-10', 88.00),
(6, 6, '2024-01-14', 94.50),
(7, 1, '2024-01-10', 60.00),
(7, 3, '2024-01-11', 55.00),  -- below passing
(8, 4, '2024-01-12', 87.00),
(8, 5, '2024-01-13', NULL);   -- grade pending
