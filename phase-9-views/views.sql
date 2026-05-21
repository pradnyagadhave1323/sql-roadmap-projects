-- =============================================================
-- Phase 9: Employee Reporting & Analytics System
-- =============================================================
USE employee_views;
GO
-- =============================================================
-- SIMPLE VIEWS
-- =============================================================

-- VIEW 1: Clean active employee list
CREATE OR ALTER VIEW v_active_employees AS
SELECT
    emp_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    UPPER(job_title) AS designation,
    gender,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE()) AS tenure_years,
    is_active
FROM employees
WHERE is_active = 1;
GO

-- VIEW 2: Engineering team
CREATE OR ALTER VIEW v_engineering_team AS
SELECT
    emp_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    job_title,
    hire_date,
    salary
FROM employees
WHERE dept_id = 1
  AND is_active = 1;
GO

-- VIEW 3: Salary audit trail
CREATE OR ALTER VIEW v_salary_audit AS
SELECT
    sl.log_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    sl.effective_date,
    sl.old_salary,
    sl.new_salary,
    ROUND(sl.new_salary - ISNULL(sl.old_salary, 0), 2) AS salary_increase,
    sl.change_reason,
    CONCAT(hr.first_name, ' ', hr.last_name) AS changed_by_name
FROM salaries_log sl
JOIN employees e
    ON sl.emp_id = e.emp_id
LEFT JOIN employees hr
    ON sl.changed_by = hr.emp_id;
GO

-- =============================================================
-- SECURE VIEWS
-- =============================================================

-- VIEW 4: Public employee directory
CREATE OR ALTER VIEW v_employee_directory AS
SELECT
    CONCAT('EMP-', RIGHT('0000' + CAST(emp_id AS VARCHAR), 4)) AS employee_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    job_title,
    email,
    gender,
    hire_date,
    is_active
FROM employees;
GO

-- VIEW 5: Team roster
CREATE OR ALTER VIEW v_team_roster AS
SELECT
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    e.email,
    d.dept_name,
    d.location,
    e.hire_date,
    DATEDIFF(YEAR, e.hire_date, GETDATE()) AS years_in_company
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.is_active = 1;
GO

-- =============================================================
-- JOINED VIEWS
-- =============================================================

-- VIEW 6: Full employee profile
CREATE OR ALTER VIEW v_employee_full_profile AS
SELECT
    CONCAT('EMP-', RIGHT('0000' + CAST(e.emp_id AS VARCHAR), 4)) AS emp_code,
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.job_title,
    e.email,
    e.phone,
    e.gender,
    e.hire_date,
    DATEDIFF(YEAR, e.hire_date, GETDATE()) AS tenure_years,
    e.salary,
    ROUND(e.salary / 12.0, 2) AS monthly_salary,
    d.dept_name,
    d.location,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    e.is_active
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN employees m
    ON e.manager_id = m.emp_id;
GO


-- VIEW 7: Manager hierarchy
CREATE OR ALTER VIEW v_manager_hierarchy AS
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title AS employee_title,
    d.dept_name,
    CONCAT(m.first_name, ' ', m.last_name) AS reports_to,
    m.job_title AS manager_title,
    CASE
        WHEN e.manager_id IS NULL THEN 'Top Level'
        ELSE 'Has Manager'
    END AS hierarchy_level
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.emp_id
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.is_active = 1;
GO


-- VIEW 8: Performance detail
CREATE OR ALTER VIEW v_performance_detail AS
SELECT
    pr.review_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    d.dept_name,
    pr.review_quarter,
    pr.review_year,
    pr.score,
    CASE
        WHEN pr.score >= 9.0 THEN 'Elite'
        WHEN pr.score >= 8.0 THEN 'High Performer'
        WHEN pr.score >= 7.0 THEN 'Solid'
        WHEN pr.score >= 6.0 THEN 'Needs Improvement'
        ELSE 'At Risk'
    END AS rating_label,
    CONCAT(r.first_name, ' ', r.last_name) AS reviewer_name,
    pr.comments
FROM performance_reviews pr
JOIN employees e
    ON pr.emp_id = e.emp_id
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN employees r
    ON pr.reviewer_id = r.emp_id;
GO


-- VIEW 9: Project team roster
CREATE OR ALTER VIEW v_project_team AS
SELECT
    p.project_id,
    p.project_name,
    p.status AS project_status,
    d.dept_name,
    CONCAT(e.first_name, ' ', e.last_name) AS team_member,
    e.job_title,
    ep.role AS project_role,
    ep.hours_worked
FROM employee_projects ep
JOIN employees e
    ON ep.emp_id = e.emp_id
JOIN projects p
    ON ep.project_id = p.project_id
JOIN departments d
    ON p.dept_id = d.dept_id;
GO

-- =============================================================
-- AGGREGATED VIEWS
-- =============================================================

-- VIEW 10: Department summary
CREATE OR ALTER VIEW v_department_summary AS
SELECT
    d.dept_id,
    d.dept_name,
    d.location,
    d.budget,
    COUNT(e.emp_id) AS headcount,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    SUM(e.salary) AS total_payroll,
    ROUND((SUM(e.salary) / d.budget) * 100, 1) AS payroll_pct_of_budget
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
   AND e.is_active = 1
GROUP BY d.dept_id, d.dept_name, d.location, d.budget;
GO


-- VIEW 11: Salary bands
CREATE OR ALTER VIEW v_salary_bands AS
SELECT
    CASE
        WHEN salary >= 150000 THEN 'Band A - Executive'
        WHEN salary >= 100000 THEN 'Band B - Senior'
        WHEN salary BETWEEN 70000 AND 99999 THEN 'Band C - Mid-Level'
        WHEN salary BETWEEN 50000 AND 69999 THEN 'Band D - Junior'
        ELSE 'Band E - Entry Level'
    END AS salary_band,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary_in_band,
    MIN(salary) AS min_in_band,
    MAX(salary) AS max_in_band
FROM employees
WHERE is_active = 1
GROUP BY CASE
        WHEN salary >= 150000 THEN 'Band A - Executive'
        WHEN salary >= 100000 THEN 'Band B - Senior'
        WHEN salary BETWEEN 70000 AND 99999 THEN 'Band C - Mid-Level'
        WHEN salary BETWEEN 50000 AND 69999 THEN 'Band D - Junior'
        ELSE 'Band E - Entry Level'
    END;
GO


-- VIEW 12: Performance summary
CREATE OR ALTER VIEW v_performance_summary AS
SELECT
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    d.dept_name,
    COUNT(pr.review_id) AS total_reviews,
    ROUND(AVG(pr.score), 2) AS avg_score,
    MIN(pr.score) AS lowest_score,
    MAX(pr.score) AS highest_score,
    CASE
        WHEN AVG(pr.score) >= 9.0 THEN 'Elite'
        WHEN AVG(pr.score) >= 8.0 THEN 'High Performer'
        WHEN AVG(pr.score) >= 7.0 THEN 'Solid'
        WHEN AVG(pr.score) >= 6.0 THEN 'Needs Improvement'
        ELSE 'At Risk'
    END AS overall_rating
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
LEFT JOIN performance_reviews pr
    ON e.emp_id = pr.emp_id
WHERE e.is_active = 1
GROUP BY e.emp_id, e.first_name, e.last_name, e.job_title, d.dept_name;
GO


-- VIEW 13: Project analytics
CREATE OR ALTER VIEW v_project_analytics AS
SELECT
    p.project_id,
    p.project_name,
    d.dept_name,
    p.status,
    p.budget,
    p.start_date,
    p.end_date,
    DATEDIFF(DAY, p.start_date, ISNULL(p.end_date, GETDATE())) AS duration_days,
    COUNT(ep.emp_id) AS team_size,
    SUM(ep.hours_worked) AS total_hours_logged,
    ROUND(SUM((e.salary / 160.0) * ep.hours_worked), 2) AS est_labour_cost,
    ROUND(p.budget - SUM((e.salary / 160.0) * ep.hours_worked), 2) AS budget_remaining
FROM projects p
JOIN departments d
    ON p.dept_id = d.dept_id
JOIN employee_projects ep
    ON p.project_id = ep.project_id
JOIN employees e
    ON ep.emp_id = e.emp_id
GROUP BY p.project_id, p.project_name, d.dept_name,
         p.status, p.budget, p.start_date, p.end_date;
GO


-- VIEW 14: Salary change summary
CREATE OR ALTER VIEW v_salary_change_summary AS
SELECT
    YEAR(sl.effective_date) AS change_year,
    DATENAME(MONTH, sl.effective_date) AS change_month,
    COUNT(*) AS salary_changes,
    SUM(CASE WHEN sl.change_reason = 'Annual Increment' THEN 1 ELSE 0 END) AS increments,
    SUM(CASE WHEN sl.change_reason = 'Promotion' THEN 1 ELSE 0 END) AS promotions,
    ROUND(AVG(sl.new_salary - ISNULL(sl.old_salary, 0)), 2) AS avg_increase
FROM salaries_log sl
GROUP BY YEAR(sl.effective_date), MONTH(sl.effective_date), DATENAME(MONTH, sl.effective_date);
GO

-- =============================================================
-- FILTERED VIEWS
-- =============================================================

-- VIEW 15: Active projects
CREATE OR ALTER VIEW v_active_projects AS
SELECT
    project_id,
    project_name,
    dept_id,
    budget,
    start_date,
    DATEDIFF(DAY, start_date, GETDATE()) AS days_running
FROM projects
WHERE status = 'Active';
GO


-- VIEW 16: Senior employees
CREATE OR ALTER VIEW v_senior_employees AS
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    job_title,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE()) AS tenure_years,
    salary
FROM employees
WHERE DATEDIFF(YEAR, hire_date, GETDATE()) >= 10
  AND is_active = 1;
GO


-- VIEW 17: New joiners
CREATE OR ALTER VIEW v_new_joiners AS
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    job_title,
    hire_date,
    DATEDIFF(DAY, hire_date, GETDATE()) AS days_since_joining,
    salary
FROM employees
WHERE hire_date >= DATEADD(YEAR, -2, GETDATE())
  AND is_active = 1;
GO


-- VIEW 18: Unreviewed employees
CREATE OR ALTER VIEW v_unreviewed_employees AS
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    d.dept_name,
    e.hire_date
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.is_active = 1
  AND NOT EXISTS (
        SELECT 1
        FROM performance_reviews pr
        WHERE pr.emp_id = e.emp_id
    );
GO

-- =============================================================
-- NESTED VIEWS
-- =============================================================

-- VIEW 19: High earners
CREATE OR ALTER VIEW v_high_earners AS
SELECT
    emp_code,
    full_name,
    job_title,
    dept_name,
    salary,
    tenure_years
FROM v_employee_full_profile
WHERE salary >= 100000
  AND is_active = 1;
GO


-- VIEW 20: Top performers
CREATE OR ALTER VIEW v_top_performers AS
SELECT
    employee,
    job_title,
    dept_name,
    avg_score,
    total_reviews,
    overall_rating
FROM v_performance_summary
WHERE avg_score >= 8.5;
GO


-- VIEW 21: Departments over budget
CREATE OR ALTER VIEW v_dept_over_budget AS
SELECT
    dept_name,
    location,
    budget,
    total_payroll,
    payroll_pct_of_budget
FROM v_department_summary
WHERE payroll_pct_of_budget > 60;
GO


-- VIEW 22: Executive dashboard
CREATE OR ALTER VIEW v_executive_dashboard AS
SELECT
    (SELECT COUNT(*) FROM employees WHERE is_active = 1) AS total_active_employees,
    (SELECT COUNT(*) FROM departments) AS total_departments,
    (SELECT ROUND(AVG(salary), 0) FROM employees WHERE is_active = 1) AS company_avg_salary,
    (SELECT SUM(salary) FROM employees WHERE is_active = 1) AS total_annual_payroll,
    (SELECT COUNT(*) FROM projects WHERE status = 'Active') AS active_projects,
    (SELECT ROUND(AVG(score), 2)
        FROM performance_reviews
        WHERE review_year = 2023) AS avg_performance_2023,
    (SELECT COUNT(*)
        FROM employees
        WHERE DATEDIFF(YEAR, hire_date, GETDATE()) >= 5
          AND is_active = 1) AS employees_5plus_years;
GO

-- =============================================================
-- VIEW MANAGEMENT COMMANDS
-- =============================================================

-- List all views
SELECT name
FROM sys.views;
GO

-- View definition
EXEC sp_helptext 'v_department_summary';
GO

-- =============================================================
-- QUERYING SIMPLE VIEWS
-- =============================================================

SELECT * FROM v_active_employees;
GO

SELECT * FROM v_engineering_team ORDER BY salary DESC;
GO

SELECT TOP 20 * FROM v_salary_audit;
GO

SELECT
employee,
COUNT(*)           AS salary_changes,
MIN(old_salary)    AS starting_salary,
MAX(new_salary)    AS current_salary
FROM v_salary_audit
GROUP BY employee
HAVING COUNT(*) >= 2
ORDER BY salary_changes DESC;
GO

-- =============================================================
-- USING SECURE VIEWS
-- =============================================================

SELECT * FROM v_employee_directory ORDER BY full_name;
GO

SELECT * FROM v_team_roster ORDER BY dept_name, years_in_company DESC;
GO

SELECT *
FROM v_employee_directory
WHERE full_name LIKE '%Sharma%' OR job_title LIKE '%Director%';
GO

SELECT gender, COUNT(*) AS count
FROM v_employee_directory
WHERE is_active = 1
GROUP BY gender;
GO

-- =============================================================
-- QUERYING JOINED VIEWS
-- =============================================================

SELECT * FROM v_employee_full_profile
WHERE is_active = 1
ORDER BY salary DESC;
GO

SELECT * FROM v_manager_hierarchy
WHERE dept_name = 'Engineering';
GO

SELECT * FROM v_manager_hierarchy
WHERE hierarchy_level = 'Top Level'
ORDER BY dept_name;
GO

SELECT * FROM v_performance_detail
WHERE review_year = 2023
ORDER BY score DESC;
GO

SELECT
reviewer_name,
COUNT(*)             AS reviews_conducted,
ROUND(AVG(score), 2) AS avg_score_given
FROM v_performance_detail
WHERE reviewer_name IS NOT NULL
GROUP BY reviewer_name
ORDER BY reviews_conducted DESC;
GO

SELECT * FROM v_project_team
WHERE project_status = 'Active'
ORDER BY project_name, hours_worked DESC;
GO

SELECT TOP 10
team_member,
job_title,
COUNT(DISTINCT project_id) AS projects_assigned,
SUM(hours_worked)          AS total_hours
FROM v_project_team
GROUP BY team_member, job_title
ORDER BY total_hours DESC;
GO

-- =============================================================
-- QUERYING AGGREGATED VIEWS
-- =============================================================

SELECT * FROM v_department_summary ORDER BY headcount DESC;
GO

SELECT dept_name, avg_salary, headcount
FROM v_department_summary
ORDER BY avg_salary DESC;
GO

SELECT dept_name, budget, total_payroll, payroll_pct_of_budget
FROM v_department_summary
WHERE payroll_pct_of_budget > 50
ORDER BY payroll_pct_of_budget DESC;
GO

SELECT * FROM v_salary_bands;
GO

SELECT
SUM(CASE WHEN salary_band LIKE 'Band A%' THEN employee_count ELSE 0 END) AS band_a,
SUM(CASE WHEN salary_band LIKE 'Band B%' THEN employee_count ELSE 0 END) AS band_b,
SUM(CASE WHEN salary_band LIKE 'Band C%' THEN employee_count ELSE 0 END) AS band_c,
SUM(CASE WHEN salary_band LIKE 'Band D%' THEN employee_count ELSE 0 END) AS band_d,
SUM(CASE WHEN salary_band LIKE 'Band E%' THEN employee_count ELSE 0 END) AS band_e
FROM v_salary_bands;
GO

SELECT * FROM v_performance_summary
ORDER BY avg_score DESC;
GO

SELECT employee, job_title, dept_name, avg_score
FROM v_performance_summary
WHERE overall_rating = '🔴 At Risk';
GO

SELECT
dept_name,
COUNT(*)                  AS employees_reviewed,
ROUND(AVG(avg_score), 2)  AS dept_avg_score,
MIN(avg_score)            AS lowest_score,
MAX(avg_score)            AS highest_score
FROM v_performance_summary
WHERE total_reviews > 0
GROUP BY dept_name
ORDER BY dept_avg_score DESC;
GO

SELECT * FROM v_project_analytics ORDER BY budget_remaining ASC;
GO

SELECT project_name, dept_name, budget, est_labour_cost, budget_remaining
FROM v_project_analytics
WHERE budget_remaining < 0;
GO

SELECT * FROM v_salary_change_summary;
GO

-- =============================================================
-- QUERYING FILTERED VIEWS
-- =============================================================

SELECT * FROM v_active_projects ORDER BY days_running DESC;
GO

SELECT * FROM v_senior_employees ORDER BY tenure_years DESC;
GO

SELECT * FROM v_new_joiners ORDER BY hire_date DESC;
GO

SELECT * FROM v_unreviewed_employees;
GO

-- =============================================================
-- QUERYING NESTED VIEWS
-- =============================================================

SELECT * FROM v_high_earners;
GO

SELECT dept_name, COUNT(*) AS high_earner_count, AVG(salary) AS avg_high_earner_salary
FROM v_high_earners
GROUP BY dept_name
ORDER BY avg_high_earner_salary DESC;
GO

SELECT * FROM v_top_performers;
GO

SELECT
tp.employee,
tp.job_title,
tp.dept_name,
tp.avg_score,
he.salary
FROM v_top_performers tp
JOIN v_high_earners he ON tp.employee = he.full_name
ORDER BY tp.avg_score DESC;
GO

SELECT * FROM v_dept_over_budget;
GO

SELECT * FROM v_executive_dashboard;
GO

-- =============================================================
-- ADVANCED VIEW ANALYTICS
-- =============================================================

SELECT
fp.full_name,
fp.job_title,
fp.dept_name,
fp.salary,
ps.avg_score,
ps.overall_rating,
CASE
WHEN fp.salary >= 100000 AND ps.avg_score < 7.0 THEN '⚠️ High Pay / Low Performance'
WHEN fp.salary >= 100000 AND ps.avg_score >= 8.5 THEN '✅ High Pay / High Performance'
ELSE '➡️ Standard'
END AS pay_performance_flag
FROM v_employee_full_profile fp
LEFT JOIN v_performance_summary ps ON fp.full_name = ps.employee
WHERE fp.is_active = 1
ORDER BY fp.salary DESC;
GO

SELECT
ds.dept_name,
ds.headcount,
ds.avg_salary,
ds.payroll_pct_of_budget,
ROUND(AVG(ps.avg_score), 2) AS dept_avg_performance_score
FROM v_department_summary ds
LEFT JOIN v_performance_summary ps ON ds.dept_name = ps.dept_name
GROUP BY ds.dept_name, ds.headcount, ds.avg_salary, ds.payroll_pct_of_budget
ORDER BY dept_avg_performance_score DESC;
GO

SELECT
CASE
WHEN tenure_years >= 10 THEN '10+ years'
WHEN tenure_years >= 7  THEN '7–9 years'
WHEN tenure_years >= 5  THEN '5–6 years'
WHEN tenure_years >= 2  THEN '2–4 years'
ELSE '< 2 years'
END AS tenure_group,
COUNT(*)               AS employee_count,
ROUND(AVG(salary), 0)  AS avg_salary,
MIN(salary)            AS min_salary,
MAX(salary)            AS max_salary
FROM v_employee_full_profile
WHERE is_active = 1
GROUP BY CASE
WHEN tenure_years >= 10 THEN '10+ years'
WHEN tenure_years >= 7  THEN '7–9 years'
WHEN tenure_years >= 5  THEN '5–6 years'
WHEN tenure_years >= 2  THEN '2–4 years'
ELSE '< 2 years'
END
ORDER BY avg_salary DESC;
GO

SELECT
gender,
COUNT(*)               AS headcount,
ROUND(AVG(salary), 2)  AS avg_salary,
MIN(salary)            AS min_salary,
MAX(salary)            AS max_salary,
SUM(salary)            AS total_payroll
FROM v_employee_full_profile
WHERE is_active = 1
GROUP BY gender;
GO

SELECT
project_name,
dept_name,
budget,
total_hours_logged,
est_labour_cost,
ROUND(total_hours_logged / (budget / 100000), 1) AS hours_per_lakh_budget
FROM v_project_analytics
ORDER BY hours_per_lakh_budget DESC;
GO

SELECT
fp.emp_code,
fp.full_name,
fp.job_title,
fp.dept_name,
fp.tenure_years,
fp.salary,
ps.avg_score         AS performance_score,
ps.overall_rating,
ISNULL(pt.total_project_hours, 0) AS project_hours,
ISNULL(pt.projects_on, 0)         AS projects_assigned
FROM v_employee_full_profile fp
LEFT JOIN v_performance_summary ps ON fp.full_name = ps.employee
LEFT JOIN (
SELECT
team_member,
SUM(hours_worked) AS total_project_hours,
COUNT(DISTINCT project_id) AS projects_on
FROM v_project_team
GROUP BY team_member
) pt ON fp.full_name = pt.team_member
WHERE fp.is_active = 1
ORDER BY fp.salary DESC;
GO
