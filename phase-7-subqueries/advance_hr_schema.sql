-- =============================================================
-- Phase 7: Advanced Employee Analytics System
-- =============================================================
IF DB_ID('advanced_hr') IS NULL
BEGIN
    CREATE DATABASE advanced_hr;
END
GO
USE advanced_hr;
GO
-- =============================================================
-- departments
-- =============================================================
CREATE TABLE departments (
    dept_id INT             PRIMARY KEY IDENTITY(1,1),
    dept_name VARCHAR(100)  NULL UNIQUE,
    location VARCHAR(100)   NOT NULL,
    budget DECIMAL(15,2)    NOT NULL
        CHECK (budget > 0),
    manager_id INT          NULL
);
GO

-- =============================================================
-- employees
-- =============================================================
CREATE TABLE employees (
    emp_id INT             PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50)  NOT NULL,
    email VARCHAR(100)     NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE         NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    dept_id INT            NULL,
    manager_id INT         NULL,
    salary DECIMAL(10,2)   NOT NULL
        CHECK (salary > 0),
    is_active BIT DEFAULT 1,
    CONSTRAINT fk_emp_department
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_emp_manager
        FOREIGN KEY (manager_id)
        REFERENCES employees(emp_id)
        ON DELETE NO ACTION
);
GO

-- =============================================================
-- Add Department Manager FK
-- =============================================================
ALTER TABLE departments
ADD CONSTRAINT fk_dept_mgr
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id)
ON DELETE SET NULL;
GO

-- =============================================================
-- performance_reviews
-- =============================================================
CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    emp_id INT NOT NULL,
    review_quarter VARCHAR(2) NOT NULL
        CHECK (review_quarter IN ('Q1','Q2','Q3','Q4')),
    review_year INT NOT NULL,
    score DECIMAL(4,2) NOT NULL
        CHECK (score BETWEEN 1.00 AND 10.00),
    reviewer_id INT NULL,
    comments TEXT,
    CONSTRAINT fk_review_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_review_manager
        FOREIGN KEY (reviewer_id)
        REFERENCES employees(emp_id)
        ON DELETE NO ACTION,
    CONSTRAINT uq_review
        UNIQUE (emp_id, review_quarter, review_year)
);
GO

-- =============================================================
-- salaries_history
-- =============================================================
CREATE TABLE salaries_history (
    hist_id INT PRIMARY KEY IDENTITY(1,1),
    emp_id INT NOT NULL,
    effective_date DATE NOT NULL,
    salary_amount DECIMAL(10,2) NOT NULL
        CHECK (salary_amount > 0),
    revision_reason VARCHAR(20) NOT NULL
        CHECK (revision_reason IN
        ('Joining','Increment','Promotion','Correction')),
    CONSTRAINT fk_salary_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE
);
GO

-- =============================================================
-- projects
-- =============================================================
CREATE TABLE projects (
    project_id INT PRIMARY KEY IDENTITY(1,1),
    project_name VARCHAR(150) NOT NULL,
    dept_id INT NULL,
    status VARCHAR(20) DEFAULT 'Planning'
        CHECK (status IN
        ('Planning','Active','On Hold',
         'Completed','Cancelled')),
    budget DECIMAL(15,2)
        CHECK (budget >= 0),
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT fk_project_department
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE SET NULL
);
GO

-- =============================================================
-- employee_projects
-- =============================================================
CREATE TABLE employee_projects (
    ep_id INT PRIMARY KEY IDENTITY(1,1),
    emp_id INT NOT NULL,
    project_id INT NOT NULL,
    role VARCHAR(100) NOT NULL
        DEFAULT 'Contributor',
    hours_worked INT DEFAULT 0
        CHECK (hours_worked >= 0),
    CONSTRAINT fk_ep_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ep_project
        FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_employee_project
        UNIQUE (emp_id, project_id)
);
GO

-- -------------------------------------------------------------
-- Departments
-- -------------------------------------------------------------
INSERT INTO departments (dept_name, location, budget) VALUES
('Engineering',     'Pune',       18000000.00),
('Human Resources', 'Mumbai',      4500000.00),
('Sales',           'Delhi',      11000000.00),
('Finance',         'Bangalore',   7000000.00),
('Marketing',       'Hyderabad',   6500000.00),
('Operations',      'Chennai',     8500000.00),
('Product',         'Pune',       10000000.00);
GO
SELECT * FROM departments;

-- -------------------------------------------------------------
-- Employees
-- -------------------------------------------------------------
INSERT INTO employees
(first_name, last_name, email, phone, hire_date,
 job_title, dept_id, manager_id, salary, is_active)
VALUES
-- Engineering
('Meera','Singh','meera.singh@adv.com','9654321001','2013-03-01','VP Engineering',1,NULL,200000.00,1),
('Arjun','Sharma','arjun.sharma@adv.com','9876543001','2015-06-15','Engineering Manager',1,1,145000.00,1),
('Vikram','Nair','vikram.nair@adv.com','9871234001','2017-09-10','Senior Developer',1,2,110000.00,1),
('Divya','Joshi','divya.joshi@adv.com','9090909001','2019-01-20','Developer',1,2,78000.00,1),
('Nikhil','Gupta','nikhil.gupta@adv.com','9210987001','2021-07-11','Junior Developer',1,3,62000.00,1),
('Riya','Kapoor','riya.kapoor@adv.com','9310001001','2022-03-01','Junior Developer',1,3,60000.00,1),

-- HR
('Priya','Patel','priya.patel@adv.com','9123456001','2014-04-01','HR Director',2,NULL,155000.00,1),
('Divya','Mehta','divya.mehta@adv.com','9001122001','2018-08-15','HR Manager',2,7,90000.00,1),
('Lalita','Devi','lalita.devi@adv.com',NULL,'2022-02-01','HR Executive',2,8,52000.00,1),

-- Sales
('Rohan','Verma','rohan.verma@adv.com','9112233001','2016-11-01','Sales Director',3,NULL,165000.00,1),
('Rahul','Desai','rahul.desai@adv.com','9988776001','2018-05-10','Sales Manager',3,10,95000.00,1),
('Kavita','Bhat','kavita.bhat@adv.com',NULL,'2020-03-22','Senior Sales Exec',3,11,72000.00,1),
('Suresh','Pillai','suresh.pillai@adv.com','9321098001','2020-06-01','Sales Executive',3,11,58000.00,1),
('Pooja','Menon','pooja.menon@adv.com','9411001001','2023-01-10','Junior Sales Exec',3,11,45000.00,1),

-- Finance
('Sneha','Kulkarni','sneha.kulkarni@adv.com','9001234001','2015-09-15','Finance Director',4,NULL,170000.00,1),
('Aditya','Kumar','aditya.kumar@adv.com','9543210001','2017-04-01','Finance Manager',4,15,115000.00,1),
('Pooja','Rao','pooja.rao@adv.com','9432109001','2021-12-01','Senior Analyst',4,16,80000.00,1),
('Tanvi','Shah','tanvi.shah@adv.com','9511001001','2023-06-01','Finance Analyst',4,16,58000.00,1),

-- Marketing
('Ananya','Iyer','ananya.iyer@adv.com','9765432001','2016-07-20','Marketing Director',5,NULL,160000.00,1),
('Kiran','Mehta','kiran.mehta@adv.com','9090001001','2018-10-05','Marketing Manager',5,19,100000.00,1),
('Ravi','Shankar','ravi.shankar@adv.com','9000123001','2021-03-14','Marketing Analyst',5,20,65000.00,1),
('Nisha','Jain','nisha.jain@adv.com','9611001001','2023-04-01','Marketing Intern',5,20,35000.00,1),

-- Operations
('Kiran','Bhat','kiran.bhat@adv.com','9300001001','2012-01-10','Operations Director',6,NULL,175000.00,1),
('Amit','Verma','amit.verma@adv.com','9200001001','2016-03-01','Operations Manager',6,23,108000.00,1),
('Neha','Sharma','neha.sharma@adv.com','9100001001','2019-08-20','Operations Analyst',6,24,72000.00,1),

-- Product
('Deepak','Joshi','deepak.joshi@adv.com','9800001001','2014-05-15','Product Director',7,NULL,180000.00,1),
('Meera','Patel','meera.patel@adv.com','9700001001','2017-11-01','Product Manager',7,26,120000.00,1),
('Sanjay','Iyer','sanjay.iyer@adv.com','9600001001','2020-04-10','Product Analyst',7,27,82000.00,1),

-- Inactive Employee
('Raj','Kumar','raj.kumar@adv.com','9500001001','2019-01-15','Developer',1,2,80000.00,0);
GO
SELECT * FROM employees;

-- -------------------------------------------------------------
-- Set Department Managers
-- -------------------------------------------------------------
UPDATE departments SET manager_id = 1  WHERE dept_id = 1;
UPDATE departments SET manager_id = 7  WHERE dept_id = 2;
UPDATE departments SET manager_id = 10 WHERE dept_id = 3;
UPDATE departments SET manager_id = 15 WHERE dept_id = 4;
UPDATE departments SET manager_id = 19 WHERE dept_id = 5;
UPDATE departments SET manager_id = 23 WHERE dept_id = 6;
UPDATE departments SET manager_id = 26 WHERE dept_id = 7;
GO

-- -------------------------------------------------------------
-- Performance Reviews
-- -------------------------------------------------------------
INSERT INTO performance_reviews
(emp_id, review_quarter, review_year, score, reviewer_id, comments)
VALUES
(2,'Q1',2022,8.5,1,'Excellent delivery on Q1 roadmap'),
(3,'Q1',2022,7.8,2,'Good work, needs improvement on documentation'),
(4,'Q1',2022,6.5,2,'Meets expectations'),
(5,'Q1',2022,5.9,3,'Learning curve expected for junior role'),
(7,'Q1',2022,9.0,NULL,'Outstanding HR policy rollout'),
(10,'Q1',2022,8.8,NULL,'Exceeded sales targets by 18%'),
(15,'Q1',2022,9.2,NULL,'Led flawless audit season'),
(19,'Q1',2022,8.6,NULL,'Brand awareness campaign was a success'),
(23,'Q1',2022,9.1,NULL,'Zero downtime across Q1'),
(26,'Q1',2022,8.9,NULL,'Product vision execution was exceptional'),

(2,'Q4',2023,9.2,1,'Best year in engineering team history'),
(3,'Q4',2023,8.8,2,'Promoted to lead for 2024'),
(4,'Q4',2023,8.0,2,'Significant growth from Q1 2022'),
(5,'Q4',2023,7.5,3,'Steady progression continuing'),
(10,'Q4',2023,9.5,NULL,'Smashed annual sales target by 28%'),
(15,'Q4',2023,9.5,NULL,'Most impactful Finance Director'),
(23,'Q4',2023,9.3,NULL,'Operations excellence award winner'),
(26,'Q4',2023,9.6,NULL,'Product grew 3x users in 2023');
GO
SELECT * FROM performance_reviews;

-- -------------------------------------------------------------
-- Salary History
-- -------------------------------------------------------------
INSERT INTO salaries_history
(emp_id, effective_date, salary_amount, revision_reason)
VALUES

(1,'2013-03-01',130000.00,'Joining'),
(1,'2015-04-01',155000.00,'Increment'),
(1,'2017-04-01',175000.00,'Promotion'),
(1,'2020-04-01',195000.00,'Increment'),
(1,'2023-04-01',200000.00,'Increment'),

(2,'2015-06-15',90000.00,'Joining'),
(2,'2017-07-01',108000.00,'Increment'),
(2,'2019-07-01',125000.00,'Promotion'),
(2,'2022-04-01',138000.00,'Increment'),
(2,'2023-04-01',145000.00,'Increment'),

(3,'2017-09-10',70000.00,'Joining'),
(3,'2019-10-01',85000.00,'Increment'),
(3,'2021-04-01',98000.00,'Promotion'),
(3,'2023-04-01',110000.00,'Increment'),

(10,'2016-11-01',105000.00,'Joining'),
(10,'2018-11-01',128000.00,'Promotion'),
(10,'2021-04-01',150000.00,'Increment'),
(10,'2023-04-01',165000.00,'Increment'),

(15,'2015-09-15',105000.00,'Joining'),
(15,'2017-10-01',128000.00,'Promotion'),
(15,'2020-04-01',152000.00,'Increment'),
(15,'2023-04-01',170000.00,'Increment'),

(26,'2014-05-15',110000.00,'Joining'),
(26,'2016-06-01',135000.00,'Promotion'),
(26,'2019-04-01',158000.00,'Increment'),
(26,'2023-04-01',180000.00,'Increment');
GO
SELECT * FROM salaries_history;

-- -------------------------------------------------------------
-- Projects
-- -------------------------------------------------------------
INSERT INTO projects
(project_name, dept_id, status, budget, start_date, end_date)
VALUES

('AI Platform Build',1,'Active',2000000.00,'2023-06-01',NULL),
('Legacy System Migration',1,'Active',1500000.00,'2023-01-01','2024-06-30'),
('HR Self-Service Portal',2,'Completed',400000.00,'2022-09-01','2023-06-30'),
('Enterprise Sales CRM',3,'Active',800000.00,'2023-03-01',NULL),
('Budget Automation Tool',4,'Active',350000.00,'2023-07-01',NULL),
('Brand 2.0 Campaign',5,'Completed',700000.00,'2022-11-01','2023-09-30'),
('Supply Chain AI',6,'Active',1200000.00,'2023-05-01',NULL),
('Product Analytics Suite',7,'Active',900000.00,'2023-08-01',NULL);
GO
SELECT * FROM projects;

-- -------------------------------------------------------------
-- Employee Project Assignments
-- -------------------------------------------------------------
INSERT INTO employee_projects
(emp_id, project_id, role, hours_worked)
VALUES

(1,1,'Executive Sponsor',50),
(2,1,'Tech Lead',400),
(2,2,'Tech Lead',380),
(3,1,'Senior Developer',360),
(3,2,'Senior Developer',420),
(4,1,'Developer',300),
(4,2,'Developer',280),
(5,1,'Junior Developer',220),
(6,2,'Junior Developer',200),

(7,3,'Project Owner',80),
(8,3,'HR Lead',190),
(9,3,'HR Analyst',160),

(10,4,'Sales Sponsor',70),
(11,4,'Sales Lead',210),
(12,4,'Senior Sales Exec',240),
(13,4,'Sales Executive',200),

(15,5,'Finance Sponsor',60),
(16,5,'Finance Lead',230),
(17,5,'Senior Analyst',260),

(19,6,'Marketing Owner',90),
(20,6,'Marketing Manager',250),
(21,6,'Marketing Analyst',280),

(23,7,'Ops Sponsor',80),
(24,7,'Ops Manager',370),
(25,7,'Ops Analyst',430),

(26,8,'Product Director',100),
(27,8,'Product Manager',310),
(28,8,'Product Analyst',350);
GO
SELECT * FROM employee_projects;
