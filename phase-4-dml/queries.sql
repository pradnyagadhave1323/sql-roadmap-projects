USE employee_analytics;
GO
-- =============================================================
-- INNER JOIN
-- =============================================================

-- 1 All employees with their department name
SELECT
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name,
    e.salary
FROM employees e
INNER JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.salary DESC;
GO

-- 2 All active employees with their department
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    d.dept_name,
    e.salary
FROM employees e
INNER JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.is_active = 1
ORDER BY e.salary DESC;
GO

-- 3 All projects with their department name and budget
SELECT
    p.project_name,
    d.dept_name,
    p.status,
    p.budget
FROM projects p
INNER JOIN departments d
    ON p.dept_id = d.dept_id
ORDER BY p.status, p.budget DESC;
GO

-- 4 Employees assigned to projects with their role
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    p.project_name,
    ep.role,
    ep.hours_worked
FROM employee_projects ep
INNER JOIN employees e
    ON ep.emp_id = e.emp_id
INNER JOIN projects p
    ON ep.project_id = p.project_id
ORDER BY p.project_name, ep.hours_worked DESC;
GO

-- =============================================================
-- LEFT JOIN
-- =============================================================

-- 1 All departments with their employees
SELECT
    d.dept_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
ORDER BY d.dept_name;
GO

-- 2 All employees with projects
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    p.project_name
FROM employees e
LEFT JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
LEFT JOIN projects p
    ON ep.project_id = p.project_id
WHERE e.is_active = 1
ORDER BY employee_name;
GO

-- 3 Employees not assigned to any project
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name
FROM employees e
LEFT JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
WHERE ep.emp_project_id IS NULL
GO

-- 4 Projects with no employees assigned
SELECT
    p.project_name,
    d.dept_name,
    p.status
FROM projects p
LEFT JOIN employee_projects ep
    ON p.project_id = ep.project_id
LEFT JOIN departments d
    ON p.dept_id = d.dept_id
WHERE ep.emp_project_id IS NULL;
GO


-- =============================================================
-- SELF JOIN
-- =============================================================

-- 1 Every employee with their manager
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.emp_id
WHERE e.is_active = 1
ORDER BY manager_name, employee_name;
GO

-- 2 Top-level employees
SELECT
    CONCAT(first_name, ' ', last_name) AS employee_name,
    salary
FROM employees
WHERE manager_id IS NULL
  AND is_active = 1
ORDER BY salary DESC;
GO

-- 3 Managers with report count
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    m.job_title,
    COUNT(e.emp_id) AS direct_reports
FROM employees m
INNER JOIN employees e
    ON e.manager_id = m.emp_id
WHERE e.is_active = 1
GROUP BY
    m.emp_id,
    m.first_name,
    m.last_name,
    m.job_title
ORDER BY direct_reports DESC;
GO

-- =============================================================
-- MULTI-TABLE JOIN
-- =============================================================

-- 1 Project + department + manager
SELECT
    p.project_name,
    p.status,
    d.dept_name,
    CONCAT(m.first_name, ' ', m.last_name) AS dept_manager,
    p.budget AS project_budget,
    d.budget AS dept_budget
FROM projects p
JOIN departments d
    ON p.dept_id = d.dept_id
LEFT JOIN employees m
    ON d.manager_id = m.emp_id
ORDER BY p.status, p.budget DESC;
GO

-- 2 Full employee picture
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    d.dept_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
    p.project_name,
    ep.role,
    ep.hours_worked
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN employees m
    ON e.manager_id = m.emp_id
LEFT JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
LEFT JOIN projects p
    ON ep.project_id = p.project_id
WHERE e.is_active = 1
ORDER BY d.dept_name, employee;
GO

-- =============================================================
-- FILTERING
-- =============================================================

-- 1 Salary between 80K and 120K
SELECT
    CONCAT(first_name, ' ', last_name) AS employee_name,
    salary
FROM employees
WHERE salary BETWEEN 80000 AND 120000
  AND is_active = 1
ORDER BY salary DESC;
GO

-- 2 Employees hired in 2020 or later
SELECT
    CONCAT(first_name, ' ', last_name) AS employee_name,
    hire_date
FROM employees
WHERE hire_date >= '2020-01-01'
ORDER BY hire_date;
GO

-- 3 Job title contains Manager
SELECT
    CONCAT(first_name, ' ', last_name) AS employee_name,
    job_title,
    salary
FROM employees
WHERE job_title LIKE '%Manager%'
  AND is_active = 1;
GO

-- 4 Employees in selected departments
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    d.dept_name,
    e.salary
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
WHERE d.dept_name IN ('Engineering', 'Sales', 'Product')
  AND e.is_active = 1
ORDER BY d.dept_name, e.salary DESC;
GO

-- 5 Employees with no phone number
SELECT
    CONCAT(first_name, ' ', last_name) AS employee_name
FROM employees
WHERE phone IS NULL;
GO

-- 6 Active projects not ended
SELECT
    project_name,
    status,
    start_date,
    end_date
FROM projects
WHERE status = 'Active'
ORDER BY end_date;
GO

-- =============================================================
-- SORTING
-- =============================================================

-- 1 Employees sorted by salary
SELECT
    CONCAT(first_name, ' ', last_name) AS employee_name,
    salary
FROM employees
WHERE is_active = 1
ORDER BY salary DESC;
GO

-- 2 Sort by department then salary
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name,
    e.job_title,
    e.salary
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.is_active = 1
ORDER BY d.dept_name ASC, e.salary DESC;
GO

-- 3 Projects sorted by status and budget
SELECT
    project_name,
    status,
    budget
FROM projects
ORDER BY status ASC, budget DESC;
GO

-- 4 Longest-serving employees
SELECT TOP 10
    CONCAT(first_name, ' ', last_name) AS employee_name,
    hire_date,
    job_title,
    salary
FROM employees
WHERE is_active = 1
ORDER BY hire_date ASC;
GO

-- =============================================================
-- AGGREGATIONS
-- =============================================================

-- 1 Total employees per department
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
   AND e.is_active = 1
GROUP BY d.dept_id, d.dept_name
ORDER BY total_employees DESC;
GO

-- 2 Average salary per department
SELECT
    d.dept_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e
    ON d.dept_id = e.dept_id
WHERE e.is_active = 1
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_salary DESC;
GO

-- 3 Total hours per project
SELECT
    p.project_name,
    p.status,
    COUNT(ep.emp_id) AS team_size,
    SUM(ep.hours_worked) AS total_hours
FROM projects p
LEFT JOIN employee_projects ep
    ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name, p.status
ORDER BY total_hours DESC;
GO

-- 4 Departments with more than 3 employees
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count
FROM departments d
JOIN employees e
    ON d.dept_id = e.dept_id
WHERE e.is_active = 1
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.emp_id) > 3
ORDER BY employee_count DESC;
GO

-- 5 Average hours worked per employee
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(ep.project_id) AS projects_count,
    SUM(ep.hours_worked) AS total_hours,
    ROUND(AVG(ep.hours_worked), 1) AS avg_hours_per_project
FROM employees e
JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
GROUP BY e.emp_id, e.first_name, e.last_name
ORDER BY total_hours DESC;
GO

-- =============================================================
-- BUSINESS REPORTS
-- =============================================================

-- Report 1: Department Summary
SELECT
    d.dept_name,
    d.location,
    d.budget AS dept_budget,
    COUNT(DISTINCT e.emp_id) AS headcount,
    ROUND(AVG(e.salary), 0) AS avg_salary,
    SUM(e.salary) AS total_payroll,
    COUNT(DISTINCT p.project_id) AS active_projects
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
   AND e.is_active = 1
LEFT JOIN projects p
    ON d.dept_id = p.dept_id
   AND p.status = 'Active'
GROUP BY
    d.dept_id,
    d.dept_name,
    d.location,
    d.budget
ORDER BY headcount DESC;
GO

-- Report 2: Top paid employees per department
SELECT
    dept_name,
    employee_name,
    salary,
    dept_rank
FROM (
    SELECT
        d.dept_name,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        e.salary,
        RANK() OVER (
            PARTITION BY d.dept_id
            ORDER BY e.salary DESC
        ) AS dept_rank
    FROM employees e
    JOIN departments d
        ON e.dept_id = d.dept_id
    WHERE e.is_active = 1
) ranked
WHERE dept_rank <= 3
ORDER BY dept_name, dept_rank;
GO

-- Report 3: Project workload report
SELECT
    p.project_name,
    d.dept_name,
    p.status,
    COUNT(ep.emp_id) AS team_size,
    SUM(ep.hours_worked) AS total_hours_logged,
    ROUND(
        p.budget / NULLIF(SUM(ep.hours_worked), 0),
        2
    ) AS cost_per_hour
FROM projects p
JOIN departments d
    ON p.dept_id = d.dept_id
LEFT JOIN employee_projects ep
    ON p.project_id = ep.project_id
GROUP BY
    p.project_id,
    p.project_name,
    d.dept_name,
    p.status,
    p.budget
ORDER BY total_hours_logged DESC;
GO

-- Report 4: Employee project involvement
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name,
    COUNT(ep.project_id) AS projects_assigned,
    SUM(ep.hours_worked) AS total_hours_worked
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
WHERE e.is_active = 1
GROUP BY
    e.emp_id,
    e.first_name,
    e.last_name,
    d.dept_name
ORDER BY projects_assigned DESC, total_hours_worked DESC;
GO
