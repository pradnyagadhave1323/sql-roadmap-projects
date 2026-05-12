-- =============================================================
-- Phase 1: Student Management System
-- File: schema.sql
-- Description: Creates the database tables
-- Run this FIRST before seed.sql or queries.sql
-- =============================================================

-- Create and use the database
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

-- -------------------------------------------------------------
-- Table 1: students
-- Stores personal information about each student
-- -------------------------------------------------------------
CREATE TABLE students (
    student_id    INT           PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)   NOT NULL,
    last_name     VARCHAR(50)   NOT NULL,
    email         VARCHAR(100)  NOT NULL UNIQUE,
    date_of_birth DATE,
    phone         VARCHAR(20),
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------
-- Table 2: courses
-- Stores available courses offered
-- -------------------------------------------------------------
CREATE TABLE courses (
    course_id     INT           PRIMARY KEY AUTO_INCREMENT,
    course_name   VARCHAR(100)  NOT NULL,
    instructor    VARCHAR(100)  NOT NULL,
    credits       INT           NOT NULL CHECK (credits BETWEEN 1 AND 6),
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------
-- Table 3: enrollments
-- Junction table — links students to courses (many-to-many)
-- A student can enroll in many courses
-- A course can have many students
-- -------------------------------------------------------------
CREATE TABLE enrollments (
    enrollment_id   INT           PRIMARY KEY AUTO_INCREMENT,
    student_id      INT           NOT NULL,
    course_id       INT           NOT NULL,
    enrollment_date DATE          NOT NULL DEFAULT (CURRENT_DATE),
    grade           DECIMAL(4,2),                         -- e.g. 88.50 out of 100

    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)   ON DELETE CASCADE,

    UNIQUE (student_id, course_id)   -- prevent duplicate enrollments
);
