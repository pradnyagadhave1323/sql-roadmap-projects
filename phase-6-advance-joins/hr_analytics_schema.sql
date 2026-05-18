-- =============================================================
-- Phase 6: Company HR Analytics System
-- =============================================================
CREATE DATABASE hr_analytics;
GO
USE hr_analytics;
GO
-- =============================================================
-- departments
-- =============================================================

CREATE TABLE departments (
    dept_id INT             PRIMARY KEY IDENTITY(1,1),
    dept_name VARCHAR(100)  NOT NULL UNIQUE,
    location VARCHAR(100)   NOT NULL,
    budget DECIMAL(15,2)    NOT NULL CHECK (budget > 0),
    manager_id INT          NULL
);
GO

-- =============================================================
-- employees
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
    salary DECIMAL(10,2)
        NOT NULL
        CHECK (salary > 0),
    is_active BIT DEFAULT 1,

    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE SET NULL,
    FOREIGN KEY (manager_id)
        REFERENCES employees(emp_id)
        ON DELETE NO ACTION
);
GO

-- =============================================================
-- Add FK for department manager
-- =============================================================

ALTER TABLE departments
ADD CONSTRAINT fk_dept_manager
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id)
ON DELETE SET NULL;
GO

-- =============================================================
-- attendance
-- =============================================================

CREATE TABLE attendance (
    att_id INT      PRIMARY KEY IDENTITY(1,1),
    emp_id INT      NOT NULL,
    att_date DATE   NOT NULL,
    status VARCHAR(20)
        NOT NULL
        CHECK (status IN ('Present','Absent','Late','Half Day','WFH'))
        DEFAULT 'Present',
    check_in_time TIME,
    check_out_time TIME,

    FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_attendance UNIQUE(emp_id, att_date)
);
GO

-- =============================================================
-- salaries
-- =============================================================

CREATE TABLE salaries (

    sal_id INT     PRIMARY KEY IDENTITY(1,1),
    emp_id INT     NOT NULL,
    [month] TINYINT
        NOT NULL
        CHECK ([month] BETWEEN 1 AND 12),
    [year] INT NOT NULL,
    basic_pay DECIMAL(10,2)
        NOT NULL
        CHECK (basic_pay > 0),
    bonus DECIMAL(10,2) DEFAULT 0.00,
    deductions DECIMAL(10,2) DEFAULT 0.00,
    net_pay AS (basic_pay + bonus - deductions) PERSISTED,

    FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_salary UNIQUE(emp_id, [month], [year])
);
GO

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
        CHECK (status IN ('Planning','Active','On Hold','Completed','Cancelled')),
    budget DECIMAL(15,2)
        CHECK (budget >= 0),

    FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE SET NULL
);
GO

-- =============================================================
-- employee_projects
-- =============================================================

CREATE TABLE employee_projects (
    ep_id INT          PRIMARY KEY IDENTITY(1,1),
    emp_id INT         NOT NULL,
    project_id INT     NOT NULL,
    role VARCHAR(100)
        NOT NULL
        DEFAULT 'Contributor',
    hours_worked INT
        DEFAULT 0
        CHECK (hours_worked >= 0),

    FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,

    FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_employee_project UNIQUE(emp_id, project_id)
);
GO

-- -------------------------------------------------------------
-- Departments 
-- -------------------------------------------------------------
INSERT INTO departments (dept_name, location, budget) VALUES
('Engineering',     'Pune',       15000000.00),
('Human Resources', 'Mumbai',      4000000.00),
('Sales',           'Delhi',       9000000.00),
('Finance',         'Bangalore',   6000000.00),
('Marketing',       'Hyderabad',   5500000.00),
('Operations',      'Chennai',     7000000.00);
SELECT * FROM departments;

-- -------------------------------------------------------------
-- Step 2: Employees 
-- -------------------------------------------------------------
INSERT INTO employees
(
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
('Meera',  'Singh',   'meera.singh@hr.com',   '9654321001', '2014-03-01', 'VP Engineering',      1, NULL, 190000.00, 1),
('Arjun',  'Sharma',  'arjun.sharma@hr.com',  '9876543001', '2016-06-15', 'Lead Developer',      1, 1,    130000.00, 1),
('Vikram', 'Nair',    'vikram.nair@hr.com',   '9871234001', '2018-09-10', 'Senior Developer',    1, 2,     98000.00, 1),
('Divya',  'Joshi',   'divya.joshi@hr.com',   '9090909001', '2020-01-20', 'Junior Developer',    1, 2,     62000.00, 1),
('Nikhil', 'Gupta',   'nikhil.gupta@hr.com',  '9210987001', '2022-07-11', 'Junior Developer',    1, 3,     58000.00, 1),
('Priya',  'Patel',   'priya.patel@hr.com',   '9123456001', '2015-04-01', 'HR Director',         2, NULL, 140000.00, 1),
('Divya',  'Mehta',   'divya.mehta@hr.com',   '9001122001', '2019-08-15', 'HR Manager',          2, 6,     82000.00, 1),
('Lalita', 'Devi',    'lalita.devi@hr.com',   NULL,         '2022-02-01', 'HR Executive',        2, 7,     48000.00, 1),
('Rohan',  'Verma',   'rohan.verma@hr.com',   '9112233001', '2017-11-01', 'Sales Director',      3, NULL, 150000.00, 1),
('Rahul',  'Desai',   'rahul.desai@hr.com',   '9988776001', '2019-05-10', 'Sales Manager',       3, 9,     88000.00, 1),
('Kavita', 'Bhat',    'kavita.bhat@hr.com',   NULL,         '2021-03-22', 'Sales Executive',     3, 10,    57000.00, 1),
('Suresh', 'Pillai',  'suresh.pillai@hr.com', '9321098001', '2021-06-01', 'Sales Executive',     3, 10,    54000.00, 1),
('Sneha',  'Kulkarni','sneha.kulkarni@hr.com','9001234001', '2016-09-15', 'Finance Director',    4, NULL, 160000.00, 1),
('Aditya', 'Kumar',   'aditya.kumar@hr.com',  '9543210001', '2018-04-01', 'Finance Manager',     4, 13,   105000.00, 1),
('Pooja',  'Rao',     'pooja.rao@hr.com',     '9432109001', '2022-12-01', 'Finance Analyst',     4, 14,    65000.00, 1),
('Ananya', 'Iyer',    'ananya.iyer@hr.com',   '9765432001', '2017-07-20', 'Marketing Director',  5, NULL, 145000.00, 1),
('Kiran',  'Mehta',   'kiran.mehta@hr.com',   '9090001001', '2019-10-05', 'Marketing Manager',   5, 16,    92000.00, 1),
('Ravi',   'Shankar', 'ravi.shankar@hr.com',  '9000123001', '2023-03-14', 'Marketing Analyst',   5, 17,    60000.00, 1),
('Kiran',  'Bhat',    'kiran.bhat@hr.com',    '9300001001', '2013-01-10', 'Operations Director', 6, NULL, 155000.00, 1),
('Amit',   'Verma',   'amit.verma@hr.com',    '9200001001', '2017-03-01', 'Operations Manager',  6, 19,    95000.00, 1),
('Neha',   'Sharma',  'neha.sharma@hr.com',   '9100001001', '2020-08-20', 'Operations Analyst',  6, 20,    68000.00, 1),
('Raj',    'Kumar',   'raj.kumar@hr.com',     '9500001001', '2019-01-15', 'Developer',           1, 2,     75000.00, 0);
SELECT * FROM employees;

-- -------------------------------------------------------------
-- Step 3: Set department managers
-- -------------------------------------------------------------
UPDATE departments SET manager_id = 1  WHERE dept_id = 1;
UPDATE departments SET manager_id = 6  WHERE dept_id = 2;
UPDATE departments SET manager_id = 9  WHERE dept_id = 3;
UPDATE departments SET manager_id = 13 WHERE dept_id = 4;
UPDATE departments SET manager_id = 16 WHERE dept_id = 5;
UPDATE departments SET manager_id = 19 WHERE dept_id = 6;

-- -------------------------------------------------------------
-- Step 4: Projects
-- -------------------------------------------------------------
INSERT INTO projects (project_name, dept_id, start_date, end_date, status, budget) VALUES
('Mobile App v2.0',           1, '2024-01-10', '2024-08-31', 'Active',    1500000.00),  -- p1
('ERP Migration',             1, '2023-06-01', '2024-06-30', 'Active',    2500000.00),  -- p2
('HR Portal Automation',      2, '2024-02-01', '2024-07-31', 'Active',     400000.00),  -- p3
('Q2 Sales Drive',            3, '2024-04-01', '2024-06-30', 'Completed',  600000.00),  -- p4
('Annual Budget Forecast',    4, '2024-03-01', '2024-09-30', 'Active',     300000.00),  -- p5
('Brand Relaunch Campaign',   5, '2024-05-01', '2024-11-30', 'Active',     700000.00),  -- p6
('Supply Chain Optimisation', 6, '2023-09-01', '2024-03-31', 'Completed',  900000.00);  -- p7
SELECT * FROM projects;

-- -------------------------------------------------------------
-- Step 5: Employee–Project Assignments
-- -------------------------------------------------------------
INSERT INTO employee_projects (emp_id, project_id, role, hours_worked) VALUES
(1,  2, 'Executive Sponsor',   40),
(2,  1, 'Tech Lead',          320),
(2,  2, 'Tech Lead',          400),
(3,  1, 'Senior Developer',   310),
(3,  2, 'Senior Developer',   360),
(4,  1, 'Frontend Developer', 280),
(5,  1, 'Junior Developer',   200),
(6,  3, 'Project Owner',       80),
(7,  3, 'HR Lead',            180),
(8,  3, 'HR Analyst',         160),
(9,  4, 'Campaign Owner',     120),
(10, 4, 'Sales Lead',         200),
(11, 4, 'Sales Executive',    180),
(12, 4, 'Sales Executive',    175),
(13, 5, 'Project Sponsor',     50),
(14, 5, 'Finance Lead',       210),
(15, 5, 'Finance Analyst',    250),
(16, 6, 'Marketing Owner',     90),
(17, 6, 'Marketing Manager',  240),
(18, 6, 'Marketing Analyst',  270),
(19, 7, 'Project Owner',      100),
(20, 7, 'Operations Manager', 380),
(21, 7, 'Operations Analyst', 420);
SELECT * FROM employee_projects;

-- -------------------------------------------------------------
-- Step 6: Attendance 
-- -------------------------------------------------------------
-- January 2024 (22 working days sampled)
INSERT INTO attendance (emp_id, att_date, status, check_in_time, check_out_time) VALUES
(1, '2024-01-02','Present','09:00:00','18:10:00'),(1,'2024-01-03','Present','08:55:00','18:00:00'),
(1, '2024-01-04','WFH',   NULL,       NULL),      (1,'2024-01-05','Present','09:05:00','18:15:00'),
(1, '2024-01-08','Absent', NULL,       NULL),      (1,'2024-01-09','Present','09:00:00','18:00:00'),
(2, '2024-01-02','Present','09:10:00','18:30:00'),(2,'2024-01-03','Present','09:00:00','18:20:00'),
(2, '2024-01-04','Present','08:50:00','18:00:00'),(2,'2024-01-05','Late',   '10:15:00','18:30:00'),
(2, '2024-01-08','Present','09:00:00','18:10:00'),(2,'2024-01-09','Present','09:05:00','18:00:00'),
(3, '2024-01-02','Present','09:00:00','18:00:00'),(3,'2024-01-03','Absent', NULL,       NULL),
(3, '2024-01-04','Present','08:55:00','18:05:00'),(3,'2024-01-05','Present','09:00:00','18:00:00'),
(3, '2024-01-08','WFH',   NULL,       NULL),      (3,'2024-01-09','Present','09:00:00','18:00:00'),
(4, '2024-01-02','Present','09:05:00','18:00:00'),(4,'2024-01-03','Present','09:00:00','17:55:00'),
(4, '2024-01-04','Late',  '10:30:00','18:30:00'), (4,'2024-01-05','Present','09:00:00','18:00:00'),
(4, '2024-01-08','Absent', NULL,       NULL),      (4,'2024-01-09','Half Day','09:00:00','13:00:00'),
(5, '2024-01-02','Present','09:00:00','18:00:00'),(5,'2024-01-03','Present','09:00:00','18:00:00'),
(5, '2024-01-04','Present','08:45:00','18:00:00'),(5,'2024-01-05','Absent', NULL,       NULL),
(6, '2024-01-02','Present','09:00:00','18:00:00'),(6,'2024-01-03','WFH',   NULL,       NULL),
(6, '2024-01-04','Present','09:00:00','18:00:00'),(6,'2024-01-05','Present','08:50:00','18:10:00'),
(7, '2024-01-02','Present','09:05:00','18:00:00'),(7,'2024-01-03','Present','09:00:00','18:00:00'),
(7, '2024-01-04','Absent', NULL,       NULL),      (7,'2024-01-05','Late',  '10:00:00','18:30:00'),
(8, '2024-01-02','Present','09:00:00','18:00:00'),(8,'2024-01-03','Present','09:00:00','18:00:00'),
(8, '2024-01-04','Present','08:55:00','17:50:00'),(8,'2024-01-05','Present','09:00:00','18:05:00'),
(9, '2024-01-02','Present','09:00:00','18:00:00'),(9,'2024-01-03','Present','09:00:00','18:00:00'),
(9, '2024-01-04','WFH',   NULL,       NULL),      (9,'2024-01-05','Absent', NULL,       NULL),
(10,'2024-01-02','Present','09:00:00','18:00:00'),(10,'2024-01-03','Late', '10:20:00','18:40:00'),
(10,'2024-01-04','Present','09:00:00','18:00:00'),(10,'2024-01-05','Present','09:00:00','18:00:00'),
(11,'2024-01-02','Present','09:00:00','18:00:00'),(11,'2024-01-03','Present','09:05:00','18:10:00'),
(12,'2024-01-02','Absent', NULL,       NULL),      (12,'2024-01-03','Present','09:00:00','18:00:00'),
(13,'2024-01-02','Present','09:00:00','18:00:00'),(13,'2024-01-03','Present','09:00:00','18:00:00'),
(13,'2024-01-04','Present','08:45:00','18:00:00'),(13,'2024-01-05','WFH',   NULL,       NULL),
(14,'2024-01-02','Present','09:00:00','18:00:00'),(14,'2024-01-03','Present','09:05:00','18:00:00'),
(14,'2024-01-04','Late',  '09:45:00','18:30:00'), (14,'2024-01-05','Present','09:00:00','18:00:00'),
(15,'2024-01-02','Present','09:00:00','18:00:00'),(15,'2024-01-03','Absent', NULL,       NULL),
(16,'2024-01-02','Present','09:00:00','18:00:00'),(16,'2024-01-03','Present','09:00:00','18:00:00'),
(16,'2024-01-04','Present','08:50:00','18:00:00'),(16,'2024-01-05','Present','09:00:00','18:00:00'),
(17,'2024-01-02','Present','09:00:00','18:00:00'),(17,'2024-01-03','WFH',   NULL,       NULL),
(18,'2024-01-02','Present','09:00:00','18:00:00'),(18,'2024-01-03','Late', '10:05:00','18:20:00'),
(19,'2024-01-02','Present','09:00:00','18:00:00'),(19,'2024-01-03','Present','09:00:00','18:00:00'),
(19,'2024-01-04','Present','08:40:00','18:00:00'),(19,'2024-01-05','Present','09:00:00','18:00:00'),
(20,'2024-01-02','Present','09:00:00','18:00:00'),(20,'2024-01-03','Present','09:05:00','18:05:00'),
(20,'2024-01-04','Absent', NULL,       NULL),      (20,'2024-01-05','Present','09:00:00','18:00:00'),
(21,'2024-01-02','Present','09:00:00','18:00:00'),(21,'2024-01-03','Present','09:00:00','18:00:00');

-- February 2024
INSERT INTO attendance (emp_id, att_date, status, check_in_time, check_out_time) VALUES
(1, '2024-02-01','Present','09:00:00','18:00:00'),(1,'2024-02-02','WFH',NULL,NULL),
(2, '2024-02-01','Present','09:00:00','18:20:00'),(2,'2024-02-02','Present','08:55:00','18:00:00'),
(3, '2024-02-01','Late','10:10:00','18:30:00'),   (3,'2024-02-02','Present','09:00:00','18:00:00'),
(4, '2024-02-01','Present','09:00:00','18:00:00'),(4,'2024-02-02','Absent',NULL,NULL),
(5, '2024-02-01','Present','09:00:00','18:00:00'),(5,'2024-02-02','Present','09:00:00','18:00:00'),
(6, '2024-02-01','Present','09:00:00','18:00:00'),(6,'2024-02-02','Present','08:50:00','18:10:00'),
(7, '2024-02-01','Present','09:00:00','18:00:00'),(7,'2024-02-02','Late','10:30:00','18:30:00'),
(8, '2024-02-01','Absent',NULL,NULL),              (8,'2024-02-02','Present','09:00:00','18:00:00'),
(9, '2024-02-01','Present','09:00:00','18:00:00'),(9,'2024-02-02','Present','09:00:00','18:00:00'),
(10,'2024-02-01','Present','09:05:00','18:00:00'),(10,'2024-02-02','WFH',NULL,NULL),
(11,'2024-02-01','Present','09:00:00','18:00:00'),(11,'2024-02-02','Present','09:00:00','18:00:00'),
(12,'2024-02-01','Present','09:00:00','18:00:00'),(12,'2024-02-02','Late','09:50:00','18:15:00'),
(13,'2024-02-01','Present','08:55:00','18:00:00'),(13,'2024-02-02','Present','09:00:00','18:00:00'),
(14,'2024-02-01','Present','09:00:00','18:00:00'),(14,'2024-02-02','Absent',NULL,NULL),
(15,'2024-02-01','Present','09:00:00','18:00:00'),(15,'2024-02-02','Present','09:00:00','18:00:00'),
(16,'2024-02-01','WFH',NULL,NULL),                (16,'2024-02-02','Present','09:00:00','18:00:00'),
(17,'2024-02-01','Present','09:00:00','18:00:00'),(17,'2024-02-02','Present','09:05:00','18:05:00'),
(18,'2024-02-01','Present','09:00:00','18:00:00'),(18,'2024-02-02','Present','09:00:00','18:00:00'),
(19,'2024-02-01','Present','08:45:00','18:00:00'),(19,'2024-02-02','Present','09:00:00','18:00:00'),
(20,'2024-02-01','Present','09:00:00','18:00:00'),(20,'2024-02-02','WFH',NULL,NULL),
(21,'2024-02-01','Present','09:00:00','18:00:00'),(21,'2024-02-02','Late','10:00:00','18:30:00')
SELECT * FROM attendance;

-- -------------------------------------------------------------
-- Step 7: Monthly Salaries 
-- -------------------------------------------------------------
INSERT INTO salaries (emp_id, month, year, basic_pay, bonus, deductions) VALUES
-- January 2024
(1, 1,2024,190000.00,20000.00,15000.00),(2, 1,2024,130000.00,10000.00,10000.00),
(3, 1,2024, 98000.00, 5000.00, 8000.00),(4, 1,2024, 62000.00,     0.00, 5500.00),
(5, 1,2024, 58000.00,     0.00, 5000.00),(6, 1,2024,140000.00,15000.00,12000.00),
(7, 1,2024, 82000.00, 3000.00, 7000.00),(8, 1,2024, 48000.00,     0.00, 4000.00),
(9, 1,2024,150000.00,18000.00,13000.00),(10,1,2024, 88000.00, 8000.00, 8000.00),
(11,1,2024, 57000.00,     0.00, 5000.00),(12,1,2024, 54000.00,     0.00, 4800.00),
(13,1,2024,160000.00,20000.00,14000.00),(14,1,2024,105000.00, 8000.00, 9500.00),
(15,1,2024, 65000.00,     0.00, 5800.00),(16,1,2024,145000.00,15000.00,12500.00),
(17,1,2024, 92000.00, 5000.00, 8200.00),(18,1,2024, 60000.00,     0.00, 5300.00),
(19,1,2024,155000.00,18000.00,13500.00),(20,1,2024, 95000.00, 6000.00, 8500.00),
(21,1,2024, 68000.00,     0.00, 6000.00),
-- February 2024
(1, 2,2024,190000.00,     0.00,15000.00),(2, 2,2024,130000.00,     0.00,10000.00),
(3, 2,2024, 98000.00,     0.00, 8000.00),(4, 2,2024, 62000.00,     0.00, 5500.00),
(5, 2,2024, 58000.00,     0.00, 5000.00),(6, 2,2024,140000.00,     0.00,12000.00),
(7, 2,2024, 82000.00,     0.00, 7000.00),(8, 2,2024, 48000.00,     0.00, 4000.00),
(9, 2,2024,150000.00,     0.00,13000.00),(10,2,2024, 88000.00,     0.00, 8000.00),
(11,2,2024, 57000.00,     0.00, 5000.00),(12,2,2024, 54000.00,     0.00, 4800.00),
(13,2,2024,160000.00,     0.00,14000.00),(14,2,2024,105000.00,     0.00, 9500.00),
(15,2,2024, 65000.00,     0.00, 5800.00),(16,2,2024,145000.00,     0.00,12500.00),
(17,2,2024, 92000.00,     0.00, 8200.00),(18,2,2024, 60000.00,     0.00, 5300.00),
(19,2,2024,155000.00,     0.00,13500.00),(20,2,2024, 95000.00,     0.00, 8500.00),
(21,2,2024, 68000.00,     0.00, 6000.00),
-- March 2024
(1, 3,2024,190000.00,25000.00,15000.00),(2, 3,2024,130000.00,12000.00,10000.00),
(3, 3,2024, 98000.00, 6000.00, 8000.00),(4, 3,2024, 62000.00, 2000.00, 5500.00),
(5, 3,2024, 58000.00, 1500.00, 5000.00),(6, 3,2024,140000.00,18000.00,12000.00),
(7, 3,2024, 82000.00, 4000.00, 7000.00),(8, 3,2024, 48000.00, 1000.00, 4000.00),
(9, 3,2024,150000.00,20000.00,13000.00),(10,3,2024, 88000.00,10000.00, 8000.00),
(11,3,2024, 57000.00, 2000.00, 5000.00),(12,3,2024, 54000.00, 2000.00, 4800.00),
(13,3,2024,160000.00,22000.00,14000.00),(14,3,2024,105000.00,10000.00, 9500.00),
(15,3,2024, 65000.00, 3000.00, 5800.00),(16,3,2024,145000.00,18000.00,12500.00),
(17,3,2024, 92000.00, 6000.00, 8200.00),(18,3,2024, 60000.00, 2000.00, 5300.00),
(19,3,2024,155000.00,20000.00,13500.00),(20,3,2024, 95000.00, 7000.00, 8500.00),
(21,3,2024, 68000.00, 2500.00, 6000.00)
SELECT * FROM salaries;