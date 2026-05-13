-- =============================================================
-- INSERT — Adding new records
-- =============================================================
-- 1.Add a new department
INSERT INTO departments (dept_name, location)
VALUES ('Legal', 'Kolkata')

-- 2.Add a new employee to Engineering
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, dept_id, salary)
VALUES ('Ravi', 'Shankar', 'ravi.shankar@company.com', '9000123456', CURRENT_DATE, 'Full Stack Developer', 1, 70000.00);

-- 3.Add an employee with no phone (NULL allowed)
INSERT INTO employees (first_name, last_name, email, hire_date, job_title, dept_id, salary)
VALUES ('Lalita', 'Devi', 'lalita.devi@company.com', CURRENT_DATE, 'HR Recruiter', 2, 45000.00);

-- =============================================================
-- SELECT with Filters (WHERE)
-- =============================================================
 
-- 1.Get all active employees
SELECT * FROM employees
WHERE is_active = 1;
 
-- 2.Get all employees in Engineering (dept_id = 1)
SELECT first_name, last_name, job_title, salary
FROM employees
WHERE dept_id = 1;
 
-- 3.Get employees with salary above 80,000
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 80000;
 
-- 4.Get employees hired after 2021
SELECT first_name, last_name, hire_date, job_title
FROM employees
WHERE hire_date > '2021-12-31';
 
-- 5.Find employees whose name contains 'Kumar'
SELECT * FROM employees
WHERE last_name LIKE '%Kumar%';
 
-- 6.Salary between 50,000 and 80,000
SELECT first_name, last_name, salary, job_title
FROM employees
WHERE salary BETWEEN 50000 AND 80000;
 
-- 7.Employees in Sales or Marketing (using IN)
SELECT first_name, last_name, dept_id, salary
FROM employees
WHERE dept_id IN (3, 5);
 
-- 8.Employees with no phone number (IS NULL)
SELECT first_name, last_name, email
FROM employees
WHERE phone IS NULL;
 
-- 9.Active employees with salary above 70,000 (AND)
SELECT first_name, last_name, salary
FROM employees
WHERE is_active = 1 AND salary > 70000;
 
-- 10.Employees in HR or with salary below 30,000 (OR)
SELECT first_name, last_name, dept_id, salary
FROM employees
WHERE dept_id = 2 OR salary < 30000;

-- =============================================================
-- ORDER BY — Sorting results
-- =============================================================

-- 1. All employees sorted by salary (highest first)
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC;
 
-- 2. Sort by department, then by salary within each dept
SELECT first_name, last_name, dept_id, salary
FROM employees
ORDER BY dept_id ASC, salary DESC;
 
-- 3. Sort by hire date (oldest employee first)
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date ASC;
 
-- 4. Top 5 highest paid employees
SELECT TOP 5 first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC;

-- =============================================================
-- UPDATE — Modifying records
-- =============================================================
 
-- 1 Give all Engineering employees a 10% salary raise
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 1;
 
-- 2 Update a specific employee's salary
UPDATE employees
SET salary = 78000.00
WHERE emp_id = 3;
 
-- 3 Promote an employee (change job title)
UPDATE employees
SET job_title = 'Senior Sales Executive'
WHERE emp_id = 3;
 
-- 4 Transfer an employee to a different department
UPDATE employees
SET dept_id = 4
WHERE emp_id = 6;
 
-- 5 Mark an employee as inactive (resigned)
UPDATE employees
SET is_active = 0
WHERE emp_id = 12;
 
-- 6 Give everyone in Sales a flat 5000 bonus in salary
UPDATE employees
SET salary = salary + 5000
WHERE dept_id = 3 AND is_active = 1;
 
-- =============================================================
-- JOIN — Combine employees + departments
-- =============================================================
-- 1 List all employees with their department name
SELECT
    e.first_name,
    e.last_name,
    e.job_title,
    e.salary,
    d.dept_name,
    d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name;
 
-- 2 LEFT JOIN — include employees with no department
SELECT
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
 
-- 3 Find departments with no employees
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;

-- =============================================================
-- Aggregate Functions with GROUP BY
-- =============================================================
 
-- 1 Total number of employees per department
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_employees DESC;
 
-- 2 Average salary per department
SELECT
    d.dept_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
WHERE e.is_active = 1
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_salary DESC;
 
-- 3 Total salary cost per department
SELECT
    d.dept_name,
    SUM(e.salary) AS total_salary_cost
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
WHERE e.is_active = 1
GROUP BY d.dept_id, d.dept_name
ORDER BY total_salary_cost DESC;
 
-- 4 Highest and lowest salary per department
SELECT
    d.dept_name,
    MAX(e.salary) AS highest_salary,
    MIN(e.salary) AS lowest_salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;
 
-- 5 Departments where average salary is above 70,000 (HAVING)
SELECT
    d.dept_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
WHERE e.is_active = 1
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 70000
ORDER BY avg_salary DESC;