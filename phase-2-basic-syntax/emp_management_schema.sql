-- =============================================================
-- Phase 2: Employee Management System
-- =============================================================
CREATE DATABASE employee_management;
USE employee_management;
-- -------------------------------------------------------------
-- Table 1: departments
-- -------------------------------------------------------------
CREATE TABLE departments (
    dept_id     INT          PRIMARY KEY IDENTITY(1,1),
    dept_name   VARCHAR(100) NOT NULL UNIQUE,
    location    VARCHAR(100) NOT NULL
);

-- -------------------------------------------------------------
-- Table 2: employees
-- -------------------------------------------------------------
CREATE TABLE employees (
    emp_id      INT            PRIMARY KEY IDENTITY(1,1),
    first_name  VARCHAR(50)    NOT NULL,
    last_name   VARCHAR(50)    NOT NULL,
    email       VARCHAR(100)   NOT NULL UNIQUE,
    phone       VARCHAR(20),
    hire_date   DATE           NOT NULL,
    job_title   VARCHAR(100)   NOT NULL,
    dept_id     INT,
    salary      DECIMAL(10,2)  NOT NULL CHECK (salary > 0),
    is_active   BIT            DEFAULT 1,
 
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);

-- -------------------------------------------------------------
-- Insert Departments
-- -------------------------------------------------------------
INSERT INTO departments (dept_name, location) VALUES
('Engineering',       'Pune'),
('Human Resources',   'Mumbai'),
('Sales',             'Delhi'),
('Finance',           'Bangalore'),
('Marketing',         'Hyderabad'),
('Operations',        'Chennai');
 
-- -------------------------------------------------------------
-- Insert Employees
-- -------------------------------------------------------------
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, dept_id, salary, is_active) VALUES
('Arjun',    'Sharma',    'arjun.sharma@company.com',    '9876543210', '2020-03-15', 'Senior Developer',      1, 95000.00, 1),
('Priya',    'Patel',     'priya.patel@company.com',     '9123456789', '2019-07-01', 'HR Manager',            2, 72000.00, 1),
('Rahul',    'Desai',     'rahul.desai@company.com',     '9988776655', '2021-01-10', 'Sales Executive',       3, 55000.00, 1),
('Sneha',    'Kulkarni',  'sneha.kulkarni@company.com',  '9001122334', '2018-11-20', 'Finance Analyst',       4, 80000.00, 1),
('Vikram',   'Nair',      'vikram.nair@company.com',     '9871234560', '2022-06-05', 'Junior Developer',      1, 60000.00, 1),
('Ananya',   'Iyer',      'ananya.iyer@company.com',     '9765432100', '2020-09-15', 'Marketing Specialist',  5, 58000.00, 1),
('Kiran',    'Mehta',     'kiran.mehta@company.com',     '9090909090', '2017-04-01', 'Operations Manager',    6, 88000.00, 1),
('Divya',    'Joshi',     'divya.joshi@company.com',     NULL,         '2023-02-14', 'Junior HR Executive',   2, 42000.00, 1),
('Rohan',    'Verma',     'rohan.verma@company.com',     '9112233445', '2021-08-30', 'Sales Manager',         3, 75000.00, 1),
('Meera',    'Singh',     'meera.singh@company.com',     '9654321098', '2016-12-01', 'Lead Developer',        1, 110000.00,1),
('Aditya',   'Kumar',     'aditya.kumar@company.com',    '9543210987', '2022-03-20', 'Finance Manager',       4, 92000.00, 1),
('Pooja',    'Rao',       'pooja.rao@company.com',       '9432109876', '2023-07-11', 'Marketing Intern',      5, 25000.00, 1),
('Suresh',   'Pillai',    'suresh.pillai@company.com',   '9321098765', '2015-05-18', 'Senior Operations',     6, 85000.00, 1),
('Kavita',   'Bhat',      'kavita.bhat@company.com',     NULL,         '2020-10-07', 'Sales Executive',       3, 53000.00, 1),
('Nikhil',   'Gupta',     'nikhil.gupta@company.com',    '9210987654', '2024-01-15', 'Junior Developer',      1, 48000.00, 0); 

SELECT * FROM departments;
SELECT * FROM employees;