-- =============================================================
-- Phase 4: Employee Analytics System
-- =============================================================
CREATE DATABASE employee_analytics;
GO
USE employee_analytics;
GO

-- =============================================================
-- Departments
-- =============================================================
CREATE TABLE departments (
    dept_id INT             PRIMARY KEY IDENTITY(1,1),
    dept_name VARCHAR(100)  NOT NULL UNIQUE,
    location VARCHAR(100)   NOT NULL,
    budget DECIMAL(15,2)    NOT NULL CHECK (budget > 0),
    manager_id INT          NULL
);
-- =============================================================
-- Employees
-- =============================================================
CREATE TABLE employees (
    emp_id INT              PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50)  NOT NULL,
    last_name VARCHAR(50)   NOT NULL,
    email VARCHAR(100)      NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE          NOT NULL,
    job_title VARCHAR(100)  NOT NULL,
    dept_id INT             NULL,
    manager_id INT          NULL,
    salary DECIMAL(10,2)    NOT NULL CHECK (salary > 0),
    is_active BIT           DEFAULT 1,
    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE SET NULL,
    FOREIGN KEY (manager_id)
        REFERENCES employees(emp_id)
        ON DELETE NO ACTION
);

-- =============================================================
-- Add FK: departments.manager_id → employees.emp_id
-- =============================================================
ALTER TABLE departments
ADD CONSTRAINT fk_dept_manager
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id)
ON DELETE SET NULL;

-- =============================================================
-- projects
-- =============================================================
CREATE TABLE projects (
    project_id INT             PRIMARY KEY IDENTITY(1,1),
    project_name VARCHAR(150)  NOT NULL,
    dept_id INT                NULL,
    start_date DATE            NOT NULL,
    end_date DATE,
    status VARCHAR(20)
        DEFAULT 'Planning'
        CHECK (
            status IN (
                'Planning',
                'Active',
                'On Hold',
                'Completed',
                'Cancelled'
            )
        ),
    budget DECIMAL(15,2)    CHECK (budget >= 0),
    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE SET NULL
);
-- =============================================================
-- employee_projects
-- =============================================================
CREATE TABLE employee_projects (
    emp_project_id INT      PRIMARY KEY IDENTITY(1,1),
    emp_id INT              NOT NULL,
    project_id INT          NOT NULL,
    role VARCHAR(100)       NOT NULL DEFAULT 'Contributor',
    hours_worked INT        DEFAULT 0 CHECK (hours_worked >= 0),
    FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE,
    UNIQUE (emp_id, project_id)
);

-- =============================================================
-- Insert Departments
-- =============================================================
INSERT INTO departments (dept_name, location, budget)
VALUES
('Engineering',     'Pune',      12000000.00),
('Human Resources', 'Mumbai',     3500000.00),
('Sales',           'Delhi',      7500000.00),
('Finance',         'Bangalore',  5000000.00),
('Marketing',       'Hyderabad',  4500000.00),
('Operations',      'Chennai',    6000000.00),
('Product',         'Pune',       8000000.00);

-- =============================================================
-- Insert Employees
-- =============================================================
INSERT INTO employees (
    first_name,
    last_name,
    email,
    phone,
    hire_date,
    job_title,
    dept_id,
    manager_id,
    salary,
    is_active
)
VALUES
('Meera',  'Singh',   'meera.singh@corp.com',   '9654321001', '2015-03-01', 'VP of Engineering', 1, NULL, 180000.00, 1),
('Arjun',  'Sharma',  'arjun.sharma@corp.com',  '9876543001', '2017-06-15', 'Lead Developer',    1, 1,    120000.00, 1),
('Vikram', 'Nair',    'vikram.nair@corp.com',   '9871234001', '2019-09-10', 'Senior Developer',  1, 2,     95000.00, 1),
('Divya',  'Joshi',   'divya.joshi@corp.com',   '9090909001', '2021-01-20', 'Junior Developer',  1, 2,     60000.00, 1),
('Nikhil', 'Gupta',   'nikhil.gupta@corp.com',  '9210987001', '2022-07-11', 'Junior Developer',  1, 3,     55000.00, 1),
('Priya',  'Patel',   'priya.patel@corp.com',   '9123456001', '2016-04-01', 'HR Director',       2, NULL, 130000.00, 1),
('Divya',  'Mehta',   'divya.mehta@corp.com',   '9001122001', '2020-08-15', 'HR Manager',        2, 6,     80000.00, 1),
('Lalita', 'Devi',    'lalita.devi@corp.com',   NULL,         '2023-02-01', 'HR Executive',      2, 7,     45000.00, 1),
('Rohan',  'Verma',   'rohan.verma@corp.com',   '9112233001', '2018-11-01', 'Sales Director',    3, NULL, 140000.00, 1),
('Rahul',  'Desai',   'rahul.desai@corp.com',   '9988776001', '2020-05-10', 'Sales Manager',     3, 9,     85000.00, 1),
('Kavita', 'Bhat',    'kavita.bhat@corp.com',   NULL,         '2021-03-22', 'Sales Executive',   3, 10,    55000.00, 1),
('Suresh', 'Pillai',  'suresh.pillai@corp.com', '9321098001', '2021-06-01', 'Sales Executive',   3, 10,    52000.00, 1),
('Sneha',  'Kulkarni','sneha.kulkarni@corp.com','9001234001', '2017-09-15', 'Finance Director',  4, NULL, 150000.00, 1),
('Aditya', 'Kumar',   'aditya.kumar@corp.com',  '9543210001', '2019-04-01', 'Finance Manager',   4, 13,   100000.00, 1),
('Pooja',  'Rao',     'pooja.rao@corp.com',     '9432109001', '2022-12-01', 'Finance Analyst',   4, 14,    62000.00, 1),
('Ananya', 'Iyer',    'ananya.iyer@corp.com',   '9765432001', '2018-07-20', 'Marketing Director',5, NULL, 135000.00, 1),
('Kiran',  'Mehta',   'kiran.mehta@corp.com',   '9090001001', '2020-10-05', 'Marketing Manager', 5, 16,    88000.00, 1),
('Ravi',   'Shankar', 'ravi.shankar@corp.com',  '9000123001', '2023-03-14', 'Marketing Specialist',5,17,   58000.00, 1),
('Kiran',  'Bhat',    'kiran.bhat@corp.com',    '9300001001', '2014-01-10', 'Operations Director',6,NULL, 145000.00,1),
('Amit',   'Verma',   'amit.verma@corp.com',    '9200001001', '2018-03-01', 'Operations Manager', 6,19,    92000.00,1),
('Neha',   'Sharma',  'neha.sharma@corp.com',   '9100001001', '2021-08-20', 'Operations Analyst', 6,20,    65000.00,1),
('Deepak', 'Joshi',   'deepak.joshi@corp.com',  '9800001001', '2016-05-15', 'Product Director',  7,NULL, 160000.00,1),
('Meera',  'Patel',   'meera.patel@corp.com',   '9700001001', '2019-11-01', 'Product Manager',   7,22,   105000.00,1),
('Sanjay', 'Iyer',    'sanjay.iyer@corp.com',   '9600001001', '2022-04-10', 'Product Analyst',   7,23,    70000.00,1),
('Raj',    'Kumar',   'raj.kumar@corp.com',     '9500001001', '2020-01-15', 'Developer',         1,2,     72000.00,0);

-- =============================================================
-- Update Department Managers
-- =============================================================
UPDATE departments SET manager_id = 1  WHERE dept_id = 1;
UPDATE departments SET manager_id = 6  WHERE dept_id = 2;
UPDATE departments SET manager_id = 9  WHERE dept_id = 3;
UPDATE departments SET manager_id = 13 WHERE dept_id = 4;
UPDATE departments SET manager_id = 16 WHERE dept_id = 5;
UPDATE departments SET manager_id = 19 WHERE dept_id = 6;
UPDATE departments SET manager_id = 22 WHERE dept_id = 7;

-- =============================================================
-- Insert Projects
-- =============================================================
INSERT INTO projects (
    project_name,
    dept_id,
    start_date,
    end_date,
    status,
    budget
)
VALUES
('Customer Portal Redesign',  1, '2024-01-15', '2024-06-30', 'Completed',  800000.00),
('Mobile App Development',    1, '2024-03-01', '2024-12-31', 'Active',    1200000.00),
('ERP System Migration',      1, '2023-09-01', '2024-09-30', 'Active',    2000000.00),
('HR Digital Transformation', 2, '2024-02-01', '2024-08-31', 'Active',     350000.00),
('Q3 Sales Campaign',         3, '2024-07-01', '2024-09-30', 'Completed',  500000.00),
('Annual Sales Strategy',     3, '2024-11-01', '2025-01-31', 'Active',     300000.00),
('Budget Forecasting Tool',   4, '2024-04-01', '2024-10-31', 'Active',     250000.00),
('Brand Refresh Campaign',    5, '2024-05-01', '2024-11-30', 'Active',     600000.00),
('Social Media Analytics',    5, '2024-08-01', NULL,         'Planning',   150000.00),
('Supply Chain Optimisation', 6, '2023-06-01', '2024-03-31', 'Completed',  900000.00),
('Product Roadmap 2025',      7, '2024-09-01', '2025-03-31', 'Active',     400000.00),
('AI Feature Integration',    7, '2024-06-01', '2025-06-30', 'Active',    1500000.00);

-- =============================================================
-- Assign Employees to Projects
-- =============================================================
INSERT INTO employee_projects (
    emp_id,
    project_id,
    role,
    hours_worked
)
VALUES
(2,1,'Tech Lead',320),
(3,1,'Backend Developer',280),
(4,1,'Frontend Developer',240),
(2,2,'Tech Lead',200),
(3,2,'Senior Developer',310),
(5,2,'Junior Developer',180),
(1,3,'Project Sponsor',60),
(2,3,'Tech Lead',400),
(3,3,'Backend Developer',350),
(4,3,'Developer',300),
(20,3,'Operations Analyst',120),
(6,4,'Project Owner',80),
(7,4,'HR Lead',160),
(8,4,'HR Analyst',140),
(24,4,'Product Analyst',60),
(9,5,'Campaign Owner',100),
(10,5,'Sales Manager',180),
(11,5,'Sales Executive',200),
(12,5,'Sales Executive',190),
(9,6,'Strategy Lead',90),
(10,6,'Sales Manager',120),
(13,7,'Project Sponsor',40),
(14,7,'Finance Lead',200),
(15,7,'Finance Analyst',240),
(16,8,'Marketing Owner',80),
(17,8,'Marketing Manager',220),
(18,8,'Specialist',260),
(17,9,'Marketing Manager',40),
(18,9,'Specialist',30),
(19,10,'Project Owner',100),
(20,10,'Operations Manager',350),
(21,10,'Analyst',400),
(22,11,'Product Director',80),
(23,11,'Product Manager',200),
(24,11,'Product Analyst',180),
(1,12,'Executive Sponsor',30),
(22,12,'Product Director',100),
(23,12,'Product Manager',300),
(2,12,'Tech Lead',250),
(3,12,'Senior Developer',280);

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM projects;
SELECT * FROM employee_projects;