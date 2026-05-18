-- =============================================================
-- INNER JOIN 
-- =============================================================

-- 1 Every active employee with their department details
SELECT
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    d.dept_name,
    e.salary
FROM employees e
INNER JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.is_active = 1
ORDER BY d.dept_name, e.salary DESC;
GO

-- 2 Employees with January 2024 salary details
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    s.basic_pay,
    s.bonus,
    s.deductions,
    s.net_pay
FROM employees e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
WHERE s.month = 1
  AND s.year = 2024
ORDER BY s.net_pay DESC;
GO

-- 3 Employees with attendance records
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    a.att_date,
    a.status,
    a.check_in_time
FROM employees e
INNER JOIN attendance a
    ON e.emp_id = a.emp_id
ORDER BY a.att_date
GO

-- 4 Employees on active projects
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    p.project_name,
    ep.role,
    ep.hours_worked,
    p.status
FROM employees e
INNER JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
INNER JOIN projects p
    ON ep.project_id = p.project_id
WHERE p.status = 'Active'
ORDER BY p.project_name, ep.hours_worked DESC;
GO

-- =============================================================
-- LEFT JOIN
-- =============================================================

-- 1 All employees with salary details
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    s.month,
    s.net_pay
FROM employees e
LEFT JOIN salaries s
    ON e.emp_id = s.emp_id
ORDER BY e.emp_id;
GO

-- 2 Employees with attendance
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    a.att_date,
    a.status
FROM employees e
LEFT JOIN attendance a
    ON e.emp_id = a.emp_id
WHERE e.is_active = 1
ORDER BY employee, a.att_date;
GO

-- 2.3 Employees not assigned to projects
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee
FROM employees e
LEFT JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
WHERE ep.ep_id IS NULL
  AND e.is_active = 1;
GO

-- 4 Departments with no employees
SELECT
    d.dept_name
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
   AND e.is_active = 1
WHERE e.emp_id IS NULL;
GO

-- =============================================================
-- RIGHT JOIN
-- =============================================================

-- 1 All departments
SELECT
    d.dept_name,
    d.location,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title
FROM employees e
RIGHT JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY d.dept_name;
GO

-- 2 All projects with assigned employees
SELECT
    p.project_name,
    p.status,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    ep.hours_worked
FROM employee_projects ep
RIGHT JOIN projects p
    ON ep.project_id = p.project_id
LEFT JOIN employees e
    ON ep.emp_id = e.emp_id
ORDER BY p.project_name;
GO

-- =============================================================
-- SELF JOIN
-- =============================================================

-- 1 Employee and manager details
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.salary AS employee_salary,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    m.job_title AS manager_title
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.emp_id
WHERE e.is_active = 1
ORDER BY manager_name, employee;
GO

-- 2 Top-level employees
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    job_title,
    salary
FROM employees
WHERE manager_id IS NULL
  AND is_active = 1
ORDER BY salary DESC;
GO

-- 3 Manager report count
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
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

-- 4 Average salary of each manager team
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
    m.salary AS manager_salary,
    COUNT(e.emp_id) AS team_size,
    ROUND(AVG(e.salary), 2) AS avg_team_salary
FROM employees m
INNER JOIN employees e
    ON e.manager_id = m.emp_id
WHERE e.is_active = 1
GROUP BY
    m.emp_id,
    m.first_name,
    m.last_name,
    m.salary
ORDER BY avg_team_salary DESC;
GO

-- 5 Full org chart
SELECT
    CONCAT(director.first_name, ' ', director.last_name) AS level_1_director,
    CONCAT(manager.first_name, ' ', manager.last_name) AS level_2_manager,
    CONCAT(staff.first_name, ' ', staff.last_name) AS level_3_staff
FROM employees staff
JOIN employees manager
    ON staff.manager_id = manager.emp_id
JOIN employees director
    ON manager.manager_id = director.emp_id
WHERE staff.is_active = 1
ORDER BY level_1_director, level_2_manager;
GO

-- 6 Employees earning more than manager
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.salary AS emp_salary,
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
    m.salary AS mgr_salary,
    (e.salary - m.salary) AS salary_difference
FROM employees e
JOIN employees m
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary
  AND e.is_active = 1;
GO

-- =============================================================
-- ATTENDANCE ANALYTICS
-- =============================================================

-- 1 Attendance summary
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    d.dept_name,
    COUNT(a.att_id) AS total_days_logged,

    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN a.status = 'Late' THEN 1 ELSE 0 END) AS late_days,
    SUM(CASE WHEN a.status = 'WFH' THEN 1 ELSE 0 END) AS wfh_days,
    SUM(CASE WHEN a.status = 'Half Day' THEN 1 ELSE 0 END) AS half_days,

    ROUND(
        CAST(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS FLOAT)
        / COUNT(*) * 100, 1
    ) AS attendance_pct

FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN attendance a
    ON e.emp_id = a.emp_id
WHERE e.is_active = 1
GROUP BY
    e.emp_id,
    e.first_name,
    e.last_name,
    d.dept_name
ORDER BY attendance_pct DESC;
GO

-- =============================================================
-- PAYROLL REPORTS
-- =============================================================

-- 1 Monthly payroll summary
SELECT
    DATENAME(MONTH, DATEFROMPARTS(2024, s.month, 1)) AS month_name,
    COUNT(s.emp_id) AS employees_paid,
    SUM(s.basic_pay) AS total_basic,
    SUM(s.bonus) AS total_bonus,
    SUM(s.deductions) AS total_deductions,
    SUM(s.net_pay) AS total_net_payroll
FROM salaries s
WHERE s.year = 2024
GROUP BY s.month
ORDER BY s.month;
GO

-- =============================================================
-- HR ANALYTICS REPORTS
-- =============================================================

-- REPORT 1: Department dashboard
SELECT
    d.dept_name,
    d.location,
    d.budget AS dept_budget,
    COUNT(e.emp_id) AS headcount,
    ROUND(AVG(e.salary), 0) AS avg_salary,
    SUM(e.salary) AS monthly_payroll_estimate,
    ROUND(
        CAST(SUM(e.salary) AS FLOAT) / d.budget * 100,
        1
    ) AS salary_pct_of_budget

FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
   AND e.is_active = 1
GROUP BY
    d.dept_id,
    d.dept_name,
    d.location,
    d.budget
ORDER BY headcount DESC;
GO

-- REPORT 2: Employee performance dashboard
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    d.dept_name,
    e.job_title,
    e.salary,
    COUNT(DISTINCT a.att_id) AS days_logged,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN a.status = 'Late' THEN 1 ELSE 0 END) AS late_count,
    ISNULL(SUM(ep.hours_worked), 0) AS total_project_hours,
    COUNT(DISTINCT ep.project_id) AS projects_assigned

FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN attendance a
    ON e.emp_id = a.emp_id
LEFT JOIN employee_projects ep
    ON e.emp_id = ep.emp_id
WHERE e.is_active = 1
GROUP BY
    e.emp_id,
    e.first_name,
    e.last_name,
    d.dept_name,
    e.job_title,
    e.salary
ORDER BY total_project_hours DESC, present_days DESC;
GO