-- =============================================================
-- Phase 9: Employee Reporting & Analytics System
-- =============================================================
IF DB_ID('employee_views') IS NULL
BEGIN
    CREATE DATABASE employee_views;
END
GO
USE employee_views;
GO

-- =============================================================
-- departments
-- =============================================================

CREATE TABLE departments (
    dept_id INT PRIMARY KEY IDENTITY(1,1),
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    budget DECIMAL(15,2) NOT NULL
        CHECK (budget > 0),
    manager_id INT NULL
);
GO

-- =============================================================
-- employees
-- =============================================================

CREATE TABLE employees (
    emp_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    dept_id INT NULL,
    manager_id INT NULL,
    salary DECIMAL(10,2) NOT NULL
        CHECK (salary > 0),
    gender VARCHAR(10) NOT NULL
        CHECK (gender IN ('Male','Female','Other')),
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
ADD CONSTRAINT fk_dept_manager
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id)
ON DELETE SET NULL;
GO

-- =============================================================
-- salaries_log
-- =============================================================

CREATE TABLE salaries_log (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    emp_id INT NOT NULL,
    effective_date DATE NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2) NOT NULL
        CHECK (new_salary > 0),
    change_reason VARCHAR(50) NOT NULL
        CHECK (
            change_reason IN (
                'Joining',
                'Annual Increment',
                'Promotion',
                'Market Correction',
                'Demotion'
            )
        ),
    changed_by INT NULL,
    CONSTRAINT fk_salary_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_salary_changedby
        FOREIGN KEY (changed_by)
        REFERENCES employees(emp_id)
        ON DELETE NO ACTION
);
GO

-- =============================================================
-- performance_reviews
-- =============================================================

CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    emp_id INT NOT NULL,
    review_quarter VARCHAR(2) NOT NULL        CHECK (review_quarter IN ('Q1','Q2','Q3','Q4')),
    review_year INT NOT NULL,
    score DECIMAL(4,2) NOT NULL
        CHECK (score BETWEEN 1.00 AND 10.00),
    reviewer_id INT NULL,
    comments VARCHAR(MAX),
    CONSTRAINT uq_review
        UNIQUE (emp_id, review_quarter, review_year),
    CONSTRAINT fk_review_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_review_reviewer
        FOREIGN KEY (reviewer_id)
        REFERENCES employees(emp_id)
        ON DELETE NO ACTION
);
GO

-- =============================================================
-- projects
-- =============================================================

CREATE TABLE projects (
    project_id INT PRIMARY KEY IDENTITY(1,1),
    project_name VARCHAR(150) NOT NULL,
    dept_id INT NULL,
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
    role VARCHAR(100)
        DEFAULT 'Contributor',
    hours_worked INT
        DEFAULT 0
        CHECK (hours_worked >= 0),
    CONSTRAINT uq_employee_project
        UNIQUE (emp_id, project_id),
    CONSTRAINT fk_ep_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ep_project
        FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
        ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------
-- Departments
-- -------------------------------------------------------------
INSERT INTO departments (dept_name, location, budget) VALUES
('Engineering',     'Pune',       18000000.00),
('Human Resources', 'Mumbai',      4500000.00),
('Sales',           'Delhi',      11000000.00),
('Finance',         'Bangalore',   7500000.00),
('Marketing',       'Hyderabad',   6500000.00),
('Operations',      'Chennai',     8500000.00),
('Product',         'Pune',       10500000.00);

-- -------------------------------------------------------------
-- Employees
-- -------------------------------------------------------------
INSERT INTO employees
(first_name, last_name, email, phone, hire_date, job_title,
 dept_id, manager_id, salary, gender, is_active)
VALUES
('Meera',   'Singh',    'meera.singh@views.com',    '9654321001','2013-03-15','VP Engineering',       1,NULL,200000.00,'Female',1),
('Arjun',   'Sharma',   'arjun.sharma@views.com',   '9876543001','2015-06-01','Engineering Manager',  1,1,145000.00,'Male',1),
('Vikram',  'Nair',     'vikram.nair@views.com',    '9871234001','2017-09-20','Senior Developer',     1,2,112000.00,'Male',1),
('Divya',   'Joshi',    'divya.joshi@views.com',    '9090909001','2019-02-14','Developer',            1,2,78000.00,'Female',1),
('Nikhil',  'Gupta',    'nikhil.gupta@views.com',   '9210987001','2021-08-01','Junior Developer',     1,3,62000.00,'Male',1),
('Riya',    'Kapoor',   'riya.kapoor@views.com',    '9310001001','2022-04-10','Junior Developer',     1,3,58000.00,'Female',1),
('Priya',   'Patel',    'priya.patel@views.com',    '9123456001','2014-05-01','HR Director',          2,NULL,155000.00,'Female',1),
('Deepak',  'Mehta',    'deepak.mehta@views.com',   '9001122001','2018-09-10','HR Manager',           2,7,90000.00,'Male',1),
('Lalita',  'Devi',     'lalita.devi@views.com',    NULL,'2022-03-01','HR Executive',                2,8,52000.00,'Female',1),
('Rohan',   'Verma',    'rohan.verma@views.com',    '9112233001','2016-12-01','Sales Director',       3,NULL,165000.00,'Male',1),
('Rahul',   'Desai',    'rahul.desai@views.com',    '9988776001','2018-06-15','Sales Manager',        3,10,95000.00,'Male',1),
('Kavita',  'Bhat',     'kavita.bhat@views.com',    NULL,'2020-04-20','Senior Sales Exec',           3,11,72000.00,'Female',1),
('Suresh',  'Pillai',   'suresh.pillai@views.com',  '9321098001','2020-07-05','Sales Executive',      3,11,58000.00,'Male',1),
('Pooja',   'Menon',    'pooja.menon@views.com',    '9411001001','2023-02-01','Junior Sales Exec',    3,11,44000.00,'Female',1),

('Sneha',   'Kulkarni', 'sneha.kulkarni@views.com', '9001234001','2015-10-01','Finance Director',     4,NULL,170000.00,'Female',1),
('Aditya',  'Kumar',    'aditya.kumar@views.com',   '9543210001','2017-05-15','Finance Manager',      4,15,115000.00,'Male',1),
('Tanvi',   'Shah',     'tanvi.shah@views.com',     '9511001001','2021-01-10','Finance Analyst',      4,16,74000.00,'Female',1),
('Ananya',  'Iyer',     'ananya.iyer@views.com',    '9765432001','2016-08-20','Marketing Director',   5,NULL,160000.00,'Female',1),
('Kiran',   'Mehta',    'kiran.mehta@views.com',    '9090001001','2019-11-01','Marketing Manager',    5,18,100000.00,'Male',1),
('Ravi',    'Shankar',  'ravi.shankar@views.com',   '9000123001','2022-01-17','Marketing Analyst',    5,19,64000.00,'Male',1),
('Nisha',   'Jain',     'nisha.jain@views.com',     '9611001001','2023-05-01','Marketing Intern',     5,19,34000.00,'Female',1),
('Kiran',   'Bhat',     'kiran.bhat@views.com',     '9300001001','2012-02-10','Operations Director',  6,NULL,175000.00,'Male',1),
('Amit',    'Verma',    'amit.verma@views.com',     '9200001001','2016-04-01','Operations Manager',   6,22,108000.00,'Male',1),
('Neha',    'Sharma',   'neha.sharma@views.com',    '9100001001','2020-09-15','Operations Analyst',   6,23,72000.00,'Female',1),
('Deepak',  'Joshi',    'deepak.joshi@views.com',   '9800001001','2014-06-01','Product Director',     7,NULL,180000.00,'Male',1),
('Meera',   'Patel',    'meera.patel@views.com',    '9700001001','2018-01-15','Product Manager',      7,25,120000.00,'Female',1),
('Sanjay',  'Iyer',     'sanjay.iyer@views.com',    '9600001001','2020-05-20','Product Analyst',      7,26,82000.00,'Male',1),
('Raj',     'Kumar',    'raj.kumar@views.com',      '9500001001','2019-03-01','Developer',            1,2,80000.00,'Male',0);
GO
-- -------------------------------------------------------------
-- Set department managers
-- -------------------------------------------------------------
UPDATE departments SET manager_id =  1 WHERE dept_id = 1;
UPDATE departments SET manager_id =  7 WHERE dept_id = 2;
UPDATE departments SET manager_id = 10 WHERE dept_id = 3;
UPDATE departments SET manager_id = 15 WHERE dept_id = 4;
UPDATE departments SET manager_id = 18 WHERE dept_id = 5;
UPDATE departments SET manager_id = 22 WHERE dept_id = 6;
UPDATE departments SET manager_id = 25 WHERE dept_id = 7;

-- -------------------------------------------------------------
-- Salaries Log (audit trail)
-- -------------------------------------------------------------
INSERT INTO salaries_log (emp_id, effective_date, old_salary, new_salary, change_reason, changed_by) VALUES
(1, '2013-03-15', NULL,      130000.00,'Joining',           7),
(1, '2015-04-01', 130000.00, 158000.00,'Annual Increment',  7),
(1, '2018-04-01', 158000.00, 180000.00,'Promotion',         7),
(1, '2021-04-01', 180000.00, 195000.00,'Annual Increment',  7),
(1, '2023-04-01', 195000.00, 200000.00,'Annual Increment',  7),
(2, '2015-06-01', NULL,       92000.00,'Joining',           7),
(2, '2017-07-01',  92000.00, 110000.00,'Annual Increment',  8),
(2, '2020-04-01', 110000.00, 130000.00,'Promotion',         8),
(2, '2023-04-01', 130000.00, 145000.00,'Annual Increment',  8),
(3, '2017-09-20', NULL,       72000.00,'Joining',           7),
(3, '2019-10-01',  72000.00,  88000.00,'Annual Increment',  8),
(3, '2022-04-01',  88000.00, 112000.00,'Promotion',         8),
(4, '2019-02-14', NULL,       55000.00,'Joining',           7),
(4, '2021-03-01',  55000.00,  68000.00,'Annual Increment',  8),
(4, '2023-04-01',  68000.00,  78000.00,'Annual Increment',  8),
(5, '2021-08-01', NULL,       50000.00,'Joining',           8),
(5, '2022-08-01',  50000.00,  56000.00,'Annual Increment',  8),
(5, '2023-08-01',  56000.00,  62000.00,'Annual Increment',  8),
(10,'2016-12-01', NULL,      108000.00,'Joining',           7),
(10,'2019-01-01', 108000.00, 138000.00,'Promotion',         8),
(10,'2022-04-01', 138000.00, 155000.00,'Annual Increment',  8),
(10,'2023-04-01', 155000.00, 165000.00,'Annual Increment',  8),
(15,'2015-10-01', NULL,      108000.00,'Joining',           7),
(15,'2017-10-01', 108000.00, 132000.00,'Promotion',         7),
(15,'2020-04-01', 132000.00, 155000.00,'Annual Increment',  8),
(15,'2023-04-01', 155000.00, 170000.00,'Annual Increment',  8),
(25,'2014-06-01', NULL,      112000.00,'Joining',           7),
(25,'2016-07-01', 112000.00, 138000.00,'Promotion',         7),
(25,'2020-04-01', 138000.00, 165000.00,'Annual Increment',  8),
(25,'2023-04-01', 165000.00, 180000.00,'Annual Increment',  8);

-- -------------------------------------------------------------
-- Performance Reviews
-- -------------------------------------------------------------
INSERT INTO performance_reviews (emp_id, review_quarter, review_year, score, reviewer_id, comments) VALUES
(2, 'Q4',2022, 8.8, 1,'Excellent engineering leadership'),
(3, 'Q4',2022, 7.9, 2,'Good delivery, improving code quality'),
(4, 'Q4',2022, 6.8, 2,'Meets expectations'),
(5, 'Q4',2022, 6.2, 3,'Junior learning curve — on track'),
(7, 'Q4',2022, 9.1,NULL,'Outstanding HR transformation'),
(8, 'Q4',2022, 7.6, 7,'Reliable and consistent performer'),
(10,'Q4',2022, 9.2,NULL,'Exceeded sales target by 22%'),
(11,'Q4',2022, 7.8,10,'Strong pipeline management'),
(12,'Q4',2022, 6.9,11,'Targets met'),
(15,'Q4',2022, 9.4,NULL,'Flawless audit and budget cycle'),
(16,'Q4',2022, 8.2,15,'Strong financial modelling'),
(18,'Q4',2022, 8.7,NULL,'Brand campaign exceeded KPIs'),
(19,'Q4',2022, 8.0,18,'Creative and driven manager'),
(22,'Q4',2022, 9.0,NULL,'Zero operational downtime in 2022'),
(23,'Q4',2022, 8.1,22,'Process improvement champion'),
(25,'Q4',2022, 9.1,NULL,'Record product adoption metrics'),
(26,'Q4',2022, 8.4,25,'Roadmap delivered ahead of schedule'),
(2, 'Q4',2023, 9.1, 1,'Best engineering output in company history'),
(3, 'Q4',2023, 8.7, 2,'Promoted to lead for 2024'),
(4, 'Q4',2023, 7.6, 2,'Solid improvement over 2022'),
(5, 'Q4',2023, 7.2, 3,'Steady growth continuing'),
(6, 'Q4',2023, 6.8, 3,'Shows real promise'),
(7, 'Q4',2023, 9.3,NULL,'HR portal launch a success'),
(8, 'Q4',2023, 8.2, 7,'Recruitment targets smashed'),
(10,'Q4',2023, 9.5,NULL,'28% above annual sales target'),
(11,'Q4',2023, 8.3,10,'Revenue up 18% year-on-year'),
(12,'Q4',2023, 7.5,11,'Consistent enterprise client retention'),
(13,'Q4',2023, 6.6,11,'Needs to improve closing rate'),
(15,'Q4',2023, 9.5,NULL,'Best Finance Director in company history'),
(16,'Q4',2023, 8.7,15,'Exceptional financial planning 2023'),
(17,'Q4',2023, 7.8,16,'Solid analytical work'),
(18,'Q4',2023, 9.0,NULL,'40% lead growth via new campaign'),
(19,'Q4',2023, 8.4,18,'Social media strategy paying off'),
(20,'Q4',2023, 7.6,19,'Good data-driven analysis'),
(22,'Q4',2023, 9.2,NULL,'Operations excellence award winner'),
(23,'Q4',2023, 8.5,22,'Supply chain redesign delivered'),
(24,'Q4',2023, 7.4,23,'Good analytical output'),
(25,'Q4',2023, 9.6,NULL,'Product grew 3x users in 2023'),
(26,'Q4',2023, 8.9,25,'Excellent stakeholder management'),
(27,'Q4',2023, 7.9,26,'Detail-oriented product analysis');

-- -------------------------------------------------------------
-- Projects
-- -------------------------------------------------------------
INSERT INTO projects (project_name, dept_id, status, budget, start_date, end_date) VALUES
('AI Platform v1',          1,'Active',    2000000.00,'2023-06-01',NULL),
('ERP Migration',           1,'Active',    1800000.00,'2023-01-01','2024-06-30'),
('HR Self-Service Portal',  2,'Completed',  420000.00,'2022-09-01','2023-08-31'),
('CRM Rollout',             3,'Active',    850000.00,'2023-03-01',NULL),
('Budget Automation',       4,'Active',    320000.00,'2023-07-01',NULL),
('Brand Relaunch',          5,'Completed', 720000.00,'2022-11-01','2023-10-31'),
('Supply Chain Optimise',   6,'Active',   1200000.00,'2023-05-01',NULL),
('Product Analytics Suite', 7,'Active',    950000.00,'2023-08-01',NULL);

-- -------------------------------------------------------------
-- Employee–Project Assignments
-- -------------------------------------------------------------
INSERT INTO employee_projects (emp_id, project_id, role, hours_worked) VALUES
(1, 1,'Executive Sponsor',   45),(2, 1,'Tech Lead',           380),(2, 2,'Tech Lead',           350),
(3, 1,'Senior Developer',   360),(3, 2,'Senior Developer',    400),(4, 1,'Developer',           290),
(4, 2,'Developer',          270),(5, 1,'Junior Developer',    210),(6, 2,'Junior Developer',    190),
(7, 3,'Project Owner',       75),(8, 3,'HR Lead',             180),(9, 3,'HR Analyst',          150),
(10,4,'Sales Sponsor',       65),(11,4,'Sales Lead',          200),(12,4,'Senior Sales',        230),
(13,4,'Sales Executive',    195),(15,5,'Finance Sponsor',      55),(16,5,'Finance Lead',        220),
(17,5,'Finance Analyst',    250),(18,6,'Marketing Owner',      85),(19,6,'Marketing Manager',  240),
(20,6,'Marketing Analyst',  270),(22,7,'Ops Sponsor',          75),(23,7,'Ops Manager',         360),
(24,7,'Ops Analyst',        410),(25,8,'Product Director',     95),(26,8,'Product Manager',    300),
(27,8,'Product Analyst',    340);