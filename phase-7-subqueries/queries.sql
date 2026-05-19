-- =============================================================
-- SCALAR SUBQUERY
-- =============================================================

-- 1 Each employee's salary vs company-wide average
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    salary,
    (SELECT ROUND(AVG(salary), 2)
     FROM employees
     WHERE is_active = 1) AS company_avg_salary
FROM employees
WHERE is_active = 1
ORDER BY salary DESC;
GO

-- 2 Employees earning above overall company average
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    salary
FROM employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
    WHERE is_active = 1
)
AND is_active = 1
ORDER BY salary DESC;
GO

-- 3 Highest-paid employee
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    job_title,
    salary
FROM employees
WHERE salary =
(
    SELECT MAX(salary)
    FROM employees
    WHERE is_active = 1
);
GO

-- 4 Lowest-paid active employee
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    job_title,
    salary
FROM employees
WHERE salary =
(
    SELECT MIN(salary)
    FROM employees
    WHERE is_active = 1
);
GO

-- 5 Employees earning above average
SELECT
    COUNT(*) AS employees_above_avg
FROM employees
WHERE salary >
(
    SELECT AVG(salary) AS Avg_sal
    FROM employees
)
AND is_active = 1;

-- =============================================================
-- COLUMN SUBQUERY (IN / NOT IN)
-- =============================================================

-- 1 Employees assigned to projects
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    job_title
FROM employees
WHERE emp_id IN
(
    SELECT DISTINCT emp_id
    FROM employee_projects
)
AND is_active = 1;
GO

-- 2 Employees NOT assigned to projects
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    job_title
FROM employees
WHERE emp_id NOT IN
(
    SELECT DISTINCT emp_id
    FROM employee_projects
)
AND is_active = 1;
GO

-- 3 Employees working on active projects
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title
FROM employees e
WHERE e.emp_id IN
(
    SELECT ep.emp_id
    FROM employee_projects ep
    JOIN projects p
    ON ep.project_id = p.project_id
    WHERE p.status = 'Active'
)
AND e.is_active = 1;
GO

-- 4 Departments with active projects
SELECT
    dept_name,
    location
FROM departments
WHERE dept_id IN
(
    SELECT DISTINCT dept_id
    FROM projects
    WHERE status = 'Active'
);
GO

-- 5 Employees never reviewed
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    job_title,
    hire_date
FROM employees
WHERE emp_id NOT IN
(
    SELECT DISTINCT emp_id
    FROM performance_reviews
)
AND is_active = 1;
GO

-- =============================================================
-- DERIVED TABLE SUBQUERY
-- =============================================================

-- 1 Department salary summary
SELECT
    dept_summary.dept_name,
    dept_summary.headcount,
    dept_summary.avg_salary,
    dept_summary.total_payroll
FROM
(
    SELECT
        d.dept_name,
        COUNT(e.emp_id) AS headcount,
        ROUND(AVG(e.salary),2) AS avg_salary,
        SUM(e.salary) AS total_payroll
    FROM employees e
    JOIN departments d
    ON e.dept_id = d.dept_id
    WHERE e.is_active = 1
    GROUP BY d.dept_id, d.dept_name
) AS dept_summary
ORDER BY dept_summary.avg_salary DESC;
GO

-- 2 Employee performance tier
SELECT
    emp_name,
    job_title,
    avg_score,
    CASE
        WHEN avg_score >= 9.0 THEN 'Elite'
        WHEN avg_score >= 8.0 THEN 'High Performer'
        WHEN avg_score >= 7.0 THEN 'Solid Performer'
        WHEN avg_score >= 6.0 THEN 'Needs Improvement'
        ELSE 'At Risk'
    END AS performance_tier
FROM
(
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
        e.job_title,
        ROUND(AVG(pr.score),2) AS avg_score
    FROM employees e
    JOIN performance_reviews pr
    ON e.emp_id = pr.emp_id
    WHERE e.is_active = 1
    GROUP BY
        e.emp_id,
        e.first_name,
        e.last_name,
        e.job_title
) AS perf_summary
ORDER BY avg_score DESC;
GO

-- 3 Salary growth report
SELECT
    emp_name,
    job_title,
    joining_salary,
    current_salary,
    ROUND(current_salary - joining_salary,2) AS absolute_growth,
    ROUND(
        (current_salary - joining_salary)
        / joining_salary * 100,
        1
    ) AS growth_pct
FROM
(
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
        e.job_title,
        e.salary AS current_salary,
        first_sal.joining_salary
    FROM employees e
    JOIN
    (
        SELECT
            emp_id,
            MIN(salary_amount) AS joining_salary
        FROM salaries_history
        WHERE revision_reason = 'Joining'
        GROUP BY emp_id
    ) AS first_sal
    ON e.emp_id = first_sal.emp_id
    WHERE e.is_active = 1
) AS growth_data
ORDER BY growth_pct DESC;
GO

-- =============================================================
-- CORRELATED SUBQUERY
-- =============================================================

-- 1 Latest review score
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    e.salary,
    (
        SELECT TOP 1 pr.score
        FROM performance_reviews pr
        WHERE pr.emp_id = e.emp_id
        ORDER BY pr.review_year DESC,
                 pr.review_quarter DESC
    ) AS latest_review_score
FROM employees e
WHERE e.is_active = 1
ORDER BY latest_review_score DESC;
GO

-- 2 Salary revision count
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    e.salary,
    (
        SELECT COUNT(*)
        FROM salaries_history sh
        WHERE sh.emp_id = e.emp_id
    ) AS total_salary_revisions
FROM employees e
WHERE e.is_active = 1
ORDER BY total_salary_revisions DESC;
GO

-- 3 Joining salary
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    e.salary AS current_salary,
    (
        SELECT TOP 1 sh.salary_amount
        FROM salaries_history sh
        WHERE sh.emp_id = e.emp_id
        ORDER BY sh.effective_date ASC
    ) AS joining_salary
FROM employees e
WHERE e.is_active = 1;
GO

-- 4 Highest paid employee per department
SELECT
    d.dept_name,
    d.budget,
    (
        SELECT TOP 1
            CONCAT(e.first_name, ' ', e.last_name)
        FROM employees e
        WHERE e.dept_id = d.dept_id
          AND e.is_active = 1
        ORDER BY e.salary DESC
    ) AS top_earner,
    (
        SELECT TOP 1 e.salary
        FROM employees e
        WHERE e.dept_id = d.dept_id
          AND e.is_active = 1
        ORDER BY e.salary DESC
    ) AS top_salary
FROM departments d;
GO

-- =============================================================
-- EXISTS / NOT EXISTS
-- =============================================================

-- 1 Employees having reviews
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    e.salary
FROM employees e
WHERE EXISTS
(
    SELECT 1
    FROM performance_reviews pr
    WHERE pr.emp_id = e.emp_id
)
AND e.is_active = 1;
GO

-- 2 Employees without reviews
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title
FROM employees e
WHERE NOT EXISTS
(
    SELECT 1
    FROM performance_reviews pr
    WHERE pr.emp_id = e.emp_id
)
AND e.is_active = 1;
GO

-- 3 Departments with active employees
SELECT
    dept_name
FROM departments d
WHERE EXISTS
(
    SELECT 1
    FROM employees e
    WHERE e.dept_id = d.dept_id
      AND e.is_active = 1
);
GO

-- 4 Projects having assigned employees
SELECT
    project_name,
    status,
    budget
FROM projects p
WHERE EXISTS
(
    SELECT 1
    FROM employee_projects ep
    WHERE ep.project_id = p.project_id
);
GO

-- =============================================================
-- ANY / ALL
-- =============================================================

-- 1 More than ANY HR employee
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    e.salary
FROM employees e
WHERE e.salary >
(
    SELECT MIN(salary)
    FROM employees
    WHERE dept_id = 2
      AND is_active = 1
)
AND e.dept_id != 2
AND e.is_active = 1
ORDER BY e.salary;
GO

-- 2 More than ALL Marketing employees
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    e.salary
FROM employees e
WHERE e.salary >
(
    SELECT MAX(salary)
    FROM employees
    WHERE dept_id = 5
      AND is_active = 1
)
AND e.dept_id != 5
AND e.is_active = 1
ORDER BY e.salary;
GO

-- =============================================================
-- ADVANCED REPORTS
-- =============================================================

-- REPORT 1: Salary Analysis Dashboard
SELECT
    analysis.employee,
    analysis.dept_name,
    analysis.job_title,
    analysis.joining_salary,
    analysis.current_salary,
    analysis.salary_growth_pct,
    analysis.avg_review_score
FROM
(
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS employee,
        d.dept_name,
        e.job_title,
        (
            SELECT TOP 1 sh.salary_amount
            FROM salaries_history sh
            WHERE sh.emp_id = e.emp_id
            ORDER BY sh.effective_date ASC
        ) AS joining_salary,
        e.salary AS current_salary,
        ROUND(
            (
                e.salary -
                (
                    SELECT TOP 1 sh.salary_amount
                    FROM salaries_history sh
                    WHERE sh.emp_id = e.emp_id
                    ORDER BY sh.effective_date ASC
                )
            ) /
            (
                SELECT TOP 1 sh.salary_amount
                FROM salaries_history sh
                WHERE sh.emp_id = e.emp_id
                ORDER BY sh.effective_date ASC
            ) * 100,
            1
        ) AS salary_growth_pct,
        (
            SELECT ROUND(AVG(pr.score),2)
            FROM performance_reviews pr
            WHERE pr.emp_id = e.emp_id
        ) AS avg_review_score
    FROM employees e
    JOIN departments d
    ON e.dept_id = d.dept_id
    WHERE e.is_active = 1
) AS analysis
ORDER BY salary_growth_pct DESC;
GO

-- REPORT 2: Department Analytics
SELECT
    d.dept_name,
    d.location,
    d.budget,
    (
        SELECT COUNT(*)
        FROM employees e
        WHERE e.dept_id = d.dept_id
          AND e.is_active = 1
    ) AS headcount,
    (
        SELECT ROUND(AVG(e.salary),2)
        FROM employees e
        WHERE e.dept_id = d.dept_id
          AND e.is_active = 1
    ) AS avg_salary,
    (
        SELECT SUM(e.salary)
        FROM employees e
        WHERE e.dept_id = d.dept_id
          AND e.is_active = 1
    ) AS total_payroll
FROM departments d;
GO

-- REPORT 3: Performance Consistency
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.job_title,
    d.dept_name,
    (
        SELECT COUNT(*)
        FROM performance_reviews pr
        WHERE pr.emp_id = e.emp_id
    ) AS total_reviews,
    (
        SELECT ROUND(AVG(pr.score),2)
        FROM performance_reviews pr
        WHERE pr.emp_id = e.emp_id
    ) AS avg_score
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.is_active = 1
AND NOT EXISTS
(
    SELECT 1
    FROM performance_reviews pr
    WHERE pr.emp_id = e.emp_id
      AND pr.score < 8.0
)
AND EXISTS
(
    SELECT 1
    FROM performance_reviews pr
    WHERE pr.emp_id = e.emp_id
)
ORDER BY avg_score DESC;
GO

-- REPORT 4: Project ROI Report
SELECT
    p.project_name,
    d.dept_name,
    p.status,
    p.budget,
    (
        SELECT COUNT(*)
        FROM employee_projects ep
        WHERE ep.project_id = p.project_id
    ) AS team_size,
    (
        SELECT SUM(ep.hours_worked)
        FROM employee_projects ep
        WHERE ep.project_id = p.project_id
    ) AS total_hours,
    (
        SELECT ROUND(
            SUM(ep.hours_worked * e.salary / 160),
            2
        )
        FROM employee_projects ep
        JOIN employees e
        ON ep.emp_id = e.emp_id
        WHERE ep.project_id = p.project_id
    ) AS est_labour_cost
FROM projects p
JOIN departments d
ON p.dept_id = d.dept_id;
GO