-- =============================================================
-- Phase 8: Employee Reporting System
-- =============================================================
IF DB_ID('employee_reporting') IS NULL
BEGIN
    CREATE DATABASE employee_reporting;
END
GO
USE employee_reporting;
GO

-- =============================================================
-- departments
-- =============================================================
CREATE TABLE departments (
    dept_id INT            PRIMARY KEY IDENTITY(1,1),
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)  NOT NULL,
    budget DECIMAL(15,2)   NOT NULL
        CHECK (budget > 0)
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
    gender VARCHAR(10)     NOT NULL
        CHECK (gender IN ('Male','Female','Other')),
    is_active BIT          DEFAULT 1,
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
-- bonuses
-- =============================================================
CREATE TABLE bonuses (
    bonus_id INT PRIMARY KEY IDENTITY(1,1),

    emp_id INT NOT NULL,

    quarter VARCHAR(2) NOT NULL
        CHECK (quarter IN ('Q1','Q2','Q3','Q4')),

    year INT NOT NULL,

    amount DECIMAL(10,2) NOT NULL
        CHECK (amount > 0),

    reason VARCHAR(255),

    CONSTRAINT fk_bonus_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_bonus
        UNIQUE (emp_id, quarter, year)
);
GO

-- =============================================================
-- leaves
-- =============================================================
CREATE TABLE leaves (
    leave_id INT PRIMARY KEY IDENTITY(1,1),

    emp_id INT NOT NULL,

    leave_type VARCHAR(20) NOT NULL
        CHECK (
            leave_type IN
            ('Annual','Sick','Casual',
             'Maternity','Paternity','Unpaid')
        ),

    start_date DATE NOT NULL,

    end_date DATE NOT NULL,

    days_taken INT NOT NULL
        CHECK (days_taken > 0),

    status VARCHAR(20) DEFAULT 'Pending'
        CHECK (status IN ('Pending','Approved','Rejected')),

    CONSTRAINT fk_leave_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE
);
GO

-- =============================================================
-- Departments
-- =============================================================
INSERT INTO departments (dept_name, location, budget)
VALUES
('Engineering',     'Pune',       16000000.00),
('Human Resources', 'Mumbai',      4200000.00),
('Sales',           'Delhi',      10500000.00),
('Finance',         'Bangalore',   7200000.00),
('Marketing',       'Hyderabad',   6000000.00),
('Operations',      'Chennai',     8000000.00),
('Product',         'Pune',        9500000.00);
GO
SELECT * FROM departments;

-- =============================================================
-- Employees
-- =============================================================
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
    gender,
    is_active
)
VALUES
('Meera',   'Singh',    'meera.singh@report.com',   '9654321001', '2013-03-15', 'VP Engineering',       1, NULL, 198000.00, 'Female', 1),
('Arjun',   'Sharma',   'arjun.sharma@report.com',  '9876543001', '2015-06-01', 'Engineering Manager',  1, 1,    142000.00, 'Male',   1),
('Vikram',  'Nair',     'vikram.nair@report.com',   '9871234001', '2017-09-20', 'Senior Developer',     1, 2,    108000.00, 'Male',   1),
('Divya',   'Joshi',    'divya.joshi@report.com',   '9090909001', '2019-02-14', 'Developer',            1, 2,     76000.00, 'Female', 1),
('Nikhil',  'Gupta',    'nikhil.gupta@report.com',  '9210987001', '2021-08-01', 'Junior Developer',     1, 3,     60000.00, 'Male',   1),
('Riya',    'Kapoor',   'riya.kapoor@report.com',   '9310001001', '2022-04-10', 'Junior Developer',     1, 3,     58000.00, 'Female', 1),
('Priya',   'Patel',    'priya.patel@report.com',   '9123456001', '2014-05-01', 'HR Director',          2, NULL, 152000.00, 'Female', 1),
('Deepak',  'Mehta',    'deepak.mehta@report.com',  '9001122001', '2018-09-10', 'HR Manager',           2, 7,     88000.00, 'Male',   1),
('Lalita',  'Devi',     'lalita.devi@report.com',   NULL,         '2022-03-01', 'HR Executive',         2, 8,     50000.00, 'Female', 1),
('Rohan',   'Verma',    'rohan.verma@report.com',   '9112233001', '2016-12-01', 'Sales Director',       3, NULL, 162000.00, 'Male',   1),
('Rahul',   'Desai',    'rahul.desai@report.com',   '9988776001', '2018-06-15', 'Sales Manager',        3, 10,    92000.00, 'Male',   1),
('Kavita',  'Bhat',     'kavita.bhat@report.com',   NULL,         '2020-04-20', 'Senior Sales Exec',    3, 11,    70000.00, 'Female', 1),
('Suresh',  'Pillai',   'suresh.pillai@report.com', '9321098001', '2020-07-05', 'Sales Executive',      3, 11,    56000.00, 'Male',   1),
('Pooja',   'Menon',    'pooja.menon@report.com',   '9411001001', '2023-02-01', 'Junior Sales Exec',    3, 11,    43000.00, 'Female', 1),
('Sneha',   'Kulkarni', 'sneha.kulkarni@report.com','9001234001', '2015-10-01', 'Finance Director',     4, NULL, 168000.00, 'Female', 1),
('Aditya',  'Kumar',    'aditya.kumar@report.com',  '9543210001', '2017-05-15', 'Finance Manager',      4, 15,   112000.00, 'Male',   1),
('Tanvi',   'Shah',     'tanvi.shah@report.com',    '9511001001', '2021-01-10', 'Finance Analyst',      4, 16,    72000.00, 'Female', 1),
('Ananya',  'Iyer',     'ananya.iyer@report.com',   '9765432001', '2016-08-20', 'Marketing Director',   5, NULL, 158000.00, 'Female', 1),
('Kiran',   'Mehta',    'kiran.mehta@report.com',   '9090001001', '2019-11-01', 'Marketing Manager',    5, 18,    98000.00, 'Male',   1),
('Ravi',    'Shankar',  'ravi.shankar@report.com',  '9000123001', '2022-01-17', 'Marketing Analyst',    5, 19,    62000.00, 'Male',   1),
('Nisha',   'Jain',     'nisha.jain@report.com',    '9611001001', '2023-05-01', 'Marketing Intern',     5, 19,    33000.00, 'Female', 1),
('Kiran',   'Bhat',     'kiran.bhat@report.com',    '9300001001', '2012-02-10', 'Operations Director',  6, NULL, 172000.00, 'Male',   1),
('Amit',    'Verma',    'amit.verma@report.com',    '9200001001', '2016-04-01', 'Operations Manager',   6, 22,   105000.00, 'Male',   1),
('Neha',    'Sharma',   'neha.sharma@report.com',   '9100001001', '2020-09-15', 'Operations Analyst',   6, 23,    70000.00, 'Female', 1),
('Deepak',  'Joshi',    'deepak.joshi@report.com',  '9800001001', '2014-06-01', 'Product Director',     7, NULL, 178000.00, 'Male',   1),
('Meera',   'Patel',    'meera.patel@report.com',   '9700001001', '2018-01-15', 'Product Manager',      7, 25,   118000.00, 'Female', 1),
('Sanjay',  'Iyer',     'sanjay.iyer@report.com',   '9600001001', '2020-05-20', 'Product Analyst',      7, 26,    80000.00, 'Male',   1),
('Raj',     'Kumar',    'raj.kumar@report.com',     '9500001001', '2019-03-01', 'Developer',            1, 2,     78000.00, 'Male',   0);
GO
SELECT * FROM employees;

-- =============================================================
-- Bonuses
-- =============================================================
INSERT INTO bonuses
(
    emp_id,
    quarter,
    year,
    amount,
    reason
)
VALUES
(1,  'Q4', 2022, 35000.00, 'Annual performance excellence'),
(2,  'Q2', 2022, 18000.00, 'Successful platform launch'),
(2,  'Q4', 2022, 22000.00, 'Year-end performance bonus'),
(3,  'Q4', 2022, 12000.00, 'Consistent delivery'),
(4,  'Q4', 2022,  8000.00, 'Good improvement over year'),
(7,  'Q4', 2022, 25000.00, 'HR transformation leadership'),
(8,  'Q4', 2022, 10000.00, 'Recruitment targets met'),
(10, 'Q2', 2022, 28000.00, 'Exceeded Q2 sales target by 22%'),
(10, 'Q4', 2022, 32000.00, 'Top sales director of the year'),
(11, 'Q4', 2022, 15000.00, 'Sales manager of the quarter'),
(12, 'Q4', 2022,  9000.00, 'Consistent client retention'),
(15, 'Q4', 2022, 30000.00, 'Perfect audit season'),
(16, 'Q4', 2022, 14000.00, 'Financial modelling excellence'),
(18, 'Q4', 2022, 26000.00, 'Brand campaign 40% above target'),
(19, 'Q4', 2022, 12000.00, 'Marketing team leadership'),
(22, 'Q4', 2022, 28000.00, 'Zero downtime entire year'),
(23, 'Q4', 2022, 13000.00, 'Process optimisation award'),
(25, 'Q4', 2022, 32000.00, 'Record product adoption'),
(26, 'Q4', 2022, 16000.00, 'Roadmap delivered early'),
(1,  'Q1', 2023, 20000.00, 'Q1 architecture milestone'),
(1,  'Q3', 2023, 22000.00, 'Mid-year excellence award'),
(1,  'Q4', 2023, 40000.00, 'Best VP of the year'),
(2,  'Q1', 2023, 15000.00, 'Microservices delivery'),
(2,  'Q3', 2023, 12000.00, 'Security patch leadership'),
(2,  'Q4', 2023, 25000.00, 'Annual performance'),
(3,  'Q2', 2023, 10000.00, 'Code quality improvement'),
(3,  'Q4', 2023, 14000.00, 'Mentoring junior developers'),
(4,  'Q4', 2023, 10000.00, 'Significant growth 2022→2023'),
(7,  'Q1', 2023, 18000.00, 'HR policy rollout'),
(7,  'Q4', 2023, 28000.00, 'HR transformation complete'),
(10, 'Q1', 2023, 20000.00, '3 new enterprise accounts'),
(10, 'Q2', 2023, 22000.00, 'Sales campaign 310% ROI'),
(10, 'Q4', 2023, 38000.00, '28% above annual target'),
(11, 'Q2', 2023, 12000.00, 'Q2 enterprise closures'),
(11, 'Q4', 2023, 18000.00, 'Revenue up 15%'),
(15, 'Q1', 2023, 20000.00, 'Cost reduction plan'),
(15, 'Q4', 2023, 36000.00, 'Best Finance Director award'),
(18, 'Q1', 2023, 18000.00, '40% lead growth campaign'),
(18, 'Q4', 2023, 30000.00, 'Brand relaunch success'),
(22, 'Q4', 2023, 32000.00, 'Operations excellence award'),
(25, 'Q2', 2023, 18000.00, 'Product v2.0 launch'),
(25, 'Q4', 2023, 42000.00, '3x user growth in 2023'),
(26, 'Q2', 2023, 14000.00, 'Roadmap stakeholder praise'),
(26, 'Q4', 2023, 20000.00, 'Product analytics launch');
GO
SELECT * FROM bonuses;
-- =============================================================
-- Leaves
-- =============================================================
INSERT INTO leaves
(
    emp_id,
    leave_type,
    start_date,
    end_date,
    days_taken,
    status
)
VALUES
(1,  'Annual',    '2023-12-26', '2024-01-02',  5, 'Approved'),
(2,  'Sick',      '2023-11-10', '2023-11-12',  3, 'Approved'),
(2,  'Annual',    '2023-08-14', '2023-08-18',  5, 'Approved'),
(3,  'Casual',    '2024-01-15', '2024-01-15',  1, 'Approved'),
(3,  'Annual',    '2023-05-01', '2023-05-05',  5, 'Approved'),
(4,  'Sick',      '2023-09-20', '2023-09-21',  2, 'Approved'),
(4,  'Maternity', '2023-03-01', '2023-06-30', 90, 'Approved'),
(5,  'Annual',    '2023-12-22', '2023-12-29',  5, 'Approved'),
(6,  'Casual',    '2024-02-05', '2024-02-05',  1, 'Pending'),
(7,  'Annual',    '2023-10-23', '2023-10-27',  5, 'Approved'),
(8,  'Sick',      '2024-01-08', '2024-01-10',  3, 'Approved'),
(9,  'Casual',    '2024-01-22', '2024-01-22',  1, 'Approved'),
(10, 'Annual',    '2023-12-27', '2024-01-03',  6, 'Approved'),
(11, 'Sick',      '2023-10-04', '2023-10-06',  3, 'Approved'),
(12, 'Annual',    '2023-07-10', '2023-07-14',  5, 'Approved'),
(13, 'Casual',    '2023-11-20', '2023-11-20',  1, 'Approved'),
(14, 'Sick',      '2024-02-01', '2024-02-02',  2, 'Pending'),
(15, 'Annual',    '2023-12-26', '2024-01-01',  5, 'Approved'),
(16, 'Paternity', '2023-06-01', '2023-06-15', 15, 'Approved'),
(17, 'Sick',      '2024-01-29', '2024-01-30',  2, 'Approved'),
(18, 'Annual',    '2024-01-15', '2024-01-19',  5, 'Approved'),
(19, 'Casual',    '2023-12-29', '2023-12-29',  1, 'Approved'),
(20, 'Annual',    '2023-06-05', '2023-06-09',  5, 'Approved'),
(22, 'Annual',    '2023-09-04', '2023-09-08',  5, 'Approved'),
(23, 'Sick',      '2024-01-16', '2024-01-17',  2, 'Approved'),
(24, 'Casual',    '2023-12-08', '2023-12-08',  1, 'Approved'),
(25, 'Annual',    '2023-12-26', '2024-01-02',  5, 'Approved'),
(26, 'Sick',      '2023-08-21', '2023-08-22',  2, 'Approved'),
(27, 'Annual',    '2023-11-13', '2023-11-17',  5, 'Approved');
GO
SELECT * FROM leaves;