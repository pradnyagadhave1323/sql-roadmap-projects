USE employee_reporting;
GO

-- =============================================================
-- STRING FUNCTIONS
-- =============================================================

-- 1 UPPER / LOWER
SELECT
    emp_id,
    UPPER(first_name) AS first_upper,
    LOWER(last_name) AS last_lower,
    UPPER(first_name + ' ' + last_name) AS full_name_caps,
    LOWER(email) AS email_lower
FROM employees
WHERE is_active = 1;
GO

-- 2 CONCAT
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(job_title, ' | ', email, ' | ', ISNULL(phone,'N/A')) AS contact_card,
    CONCAT('EMP-', RIGHT('0000' + CAST(emp_id AS VARCHAR),4)) AS employee_code
FROM employees
WHERE is_active = 1;
GO

-- 3 LEN
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    LEN(email) AS email_length,
    LEN(first_name) AS first_name_length,
    LEN(CONCAT(first_name,' ',last_name)) AS full_name_length
FROM employees
WHERE is_active = 1
ORDER BY email_length DESC;
GO

-- 1.4 TRIM / LTRIM / RTRIM
SELECT
    emp_id,
    TRIM(first_name) AS trimmed_first,
    TRIM(last_name) AS trimmed_last,
    TRIM(email) AS clean_email
FROM employees;
GO

-- 5 SUBSTRING / LEFT / RIGHT
SELECT
    email,
    LEFT(email, CHARINDEX('@', email) - 1) AS username,
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS domain,
    LEFT(first_name,1) AS first_initial,
    LEFT(last_name,1) AS last_initial,
    CONCAT(LEFT(first_name,1), '.', last_name) AS formal_name,
    RIGHT(phone,4) AS last_4_digits
FROM employees
WHERE is_active = 1;
GO

-- 6 REPLACE
SELECT
    email,
    REPLACE(email, '@report.com', '@newdomain.com') AS updated_email,
    REPLACE(phone, '-', '') AS phone_no_dash,
    REPLACE(job_title, ' ', '_') AS job_title_slug
FROM employees
WHERE is_active = 1;
GO

-- 7 CHARINDEX
SELECT
    email,
    CHARINDEX('@', email) AS at_symbol_position,
    CHARINDEX('Manager', job_title) AS manager_word_at,
    CHARINDEX('Developer', job_title) AS developer_word_at
FROM employees
WHERE is_active = 1;
GO


-- 8 Padding
SELECT
    RIGHT('00000' + CAST(emp_id AS VARCHAR),5) AS padded_emp_id,
    LEFT(first_name + '............',12) AS padded_first_name,
    CONCAT('EMP-', RIGHT('0000' + CAST(emp_id AS VARCHAR),4)) AS employee_badge
FROM employees
WHERE is_active = 1;
GO


-- 9 REVERSE
SELECT
    first_name,
    REVERSE(first_name) AS reversed,
    CASE
        WHEN first_name = REVERSE(first_name)
        THEN 'Palindrome'
        ELSE 'Not Palindrome'
    END AS palindrome_check
FROM employees
WHERE is_active = 1;
GO

-- =============================================================
-- NUMERIC FUNCTIONS
-- =============================================================

-- 1 ROUND / CEILING / FLOOR
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    salary,
    ROUND(salary / 12, 2) AS monthly_exact,
    CEILING(salary / 12) AS monthly_rounded_up,
    FLOOR(salary / 12) AS monthly_rounded_down
FROM employees
WHERE is_active = 1
ORDER BY salary DESC;
GO

-- 2 ABS
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    salary,
    ABS(salary - 100000) AS abs_difference
FROM employees
WHERE is_active = 1;
GO

-- 3 MOD (%)
SELECT
    emp_id,
    CONCAT(first_name, ' ', last_name) AS employee,
    salary,
    emp_id % 2 AS odd_even
FROM employees
WHERE is_active = 1;
GO


-- 4 POWER / SQRT
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    salary,
    SQRT(salary) AS sqrt_salary,
    POWER(salary / 100000.0, 2) AS salary_squared_ratio
FROM employees
WHERE is_active = 1;
GO

-- 5 MAX / MIN quarterly bonus
SELECT
    e.first_name + ' ' + e.last_name AS employee,
    MAX(b.amount) AS highest_bonus,
    MIN(b.amount) AS lowest_bonus
FROM employees e
JOIN bonuses b
ON e.emp_id = b.emp_id
GROUP BY e.first_name, e.last_name;
GO

-- =============================================================
-- DATE & TIME FUNCTIONS
-- =============================================================

-- 1 GETDATE
SELECT
    GETDATE() AS current_datetime,
    YEAR(GETDATE()) AS current_year,
    MONTH(GETDATE()) AS current_month,
    DAY(GETDATE()) AS current_day;
GO

-- 2 YEAR / MONTH / DAY
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    hire_date,
    YEAR(hire_date) AS joining_year,
    MONTH(hire_date) AS joining_month,
    DAY(hire_date) AS joining_day,
    DATENAME(MONTH, hire_date) AS month_name,
    DATENAME(WEEKDAY, hire_date) AS day_name
FROM employees
WHERE is_active = 1;
GO

-- 3 DATEDIFF
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    hire_date,
    DATEDIFF(DAY, hire_date, GETDATE()) AS tenure_days,
    DATEDIFF(YEAR, hire_date, GETDATE()) AS tenure_years
FROM employees
WHERE is_active = 1;
GO

-- 4 DATEADD
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    hire_date,
    DATEADD(YEAR, 1, hire_date) AS one_year_anniversary,
    DATEADD(YEAR, 5, hire_date) AS five_year_anniversary
FROM employees
WHERE is_active = 1;
Go

-- 5 FORMAT Date
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    hire_date,
    FORMAT(hire_date, 'dd/MM/yyyy') AS short_date,
    FORMAT(hire_date, 'dd MMM yyyy') AS formal_date
FROM employees
WHERE is_active = 1;
GO

-- =============================================================
-- CONDITIONAL LOGIC
-- =============================================================

-- 1 CASE WHEN Salary Bands
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    salary,
    CASE
        WHEN salary >= 150000 THEN 'Band A'
        WHEN salary >= 100000 THEN 'Band B'
        WHEN salary >= 70000 THEN 'Band C'
        WHEN salary >= 50000 THEN 'Band D'
        ELSE 'Band E'
    END AS salary_band
FROM employees
WHERE is_active = 1
ORDER BY salary DESC;
GO

-- 2 CASE WHEN Tenure
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE()) AS years_in_company,
    CASE
        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) >= 10 THEN 'Veteran'
        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) >= 5 THEN 'Experienced'
        ELSE 'New Joiner'
    END AS tenure_category
FROM employees
WHERE is_active = 1;
GO

-- 3 ISNULL
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    ISNULL(phone, 'Not Provided') AS phone_display,
    ISNULL(CAST(manager_id AS VARCHAR), 'No Manager') AS manager_info
FROM employees
WHERE is_active = 1;
GO

-- 4 COALESCE
SELECT
    CONCAT(first_name, ' ', last_name) AS employee,
    COALESCE(phone, email, 'No Contact') AS best_contact
FROM employees
WHERE is_active = 1;
GO

-- =============================================================
-- REPORTS
-- =============================================================

-- 1 Salary Report
SELECT
    CONCAT('EMP-', RIGHT('0000' + CAST(e.emp_id AS VARCHAR),4)) AS emp_code,
    UPPER(e.first_name + ' ' + e.last_name) AS employee_name,
    UPPER(d.dept_name) AS department,
    e.job_title,
    CONCAT('₹ ', FORMAT(e.salary, 'N0')) AS annual_ctc,
    CONCAT('₹ ', FORMAT(e.salary / 12, 'N0')) AS monthly_salary
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.is_active = 1
ORDER BY e.salary DESC;
GO

-- 2 Bonus Summary
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    SUM(b.amount) AS total_bonus,
    MAX(b.amount) AS highest_bonus,
    MIN(b.amount) AS lowest_bonus
FROM employees e
LEFT JOIN bonuses b
ON e.emp_id = b.emp_id
GROUP BY e.first_name, e.last_name
ORDER BY total_bonus DESC;
GO

-- 3 Leave Summary
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    d.dept_name,
    SUM(l.days_taken) AS total_leave_days,
    CASE
        WHEN SUM(l.days_taken) > 30 THEN 'High Leave'
        WHEN SUM(l.days_taken) > 10 THEN 'Normal'
        ELSE 'Low Leave'
    END AS leave_flag
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id
LEFT JOIN leaves l
ON e.emp_id = l.emp_id
WHERE e.is_active = 1
GROUP BY e.first_name, e.last_name, d.dept_name
ORDER BY total_leave_days DESC;
GO

-- =============================================================
-- ANALYTICS
-- =============================================================

-- 1 Hiring Trend by Year
SELECT
    YEAR(hire_date) AS hiring_year,
    COUNT(*) AS total_hires
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hiring_year;
GO

-- 2 Hiring by Month
SELECT
    DATENAME(MONTH, hire_date) AS month_name,
    COUNT(*) AS hires
FROM employees
GROUP BY DATENAME(MONTH, hire_date), MONTH(hire_date)
ORDER BY MONTH(hire_date);
GO

-- 3 Hiring by Day
SELECT
    DATENAME(WEEKDAY, hire_date) AS day_name,
    COUNT(*) AS total_hires
FROM employees
GROUP BY DATENAME(WEEKDAY, hire_date);
GO

-- 4 Leave Summary by Month
SELECT
    DATENAME(MONTH, start_date) AS leave_month,
    COUNT(*) AS leave_requests,
    SUM(days_taken) AS total_days_off
FROM leaves
GROUP BY DATENAME(MONTH, start_date), MONTH(start_date)
ORDER BY MONTH(start_date);
GO
