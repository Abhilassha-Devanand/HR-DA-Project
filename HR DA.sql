/* =========================================================
   HR ANALYTICS PROJECT – EMPLOYEE ATTRITION ANALYSIS
   Database  : hr
   Table     : hr_data
   ========================================================= */


/* ---------- DATABASE & TABLE SETUP ---------- */

CREATE DATABASE IF NOT EXISTS hr;
USE hr;

-- Rename table to follow best practices
RENAME TABLE `wa_fn-usec_-hr-employee-attrition` TO hr_data;

-- Fix incorrect column name (encoding issue)
ALTER TABLE hr_data
RENAME COLUMN ï»¿Age TO Age;


/* ---------- DATA VALIDATION ---------- */

-- View sample data
SELECT * FROM hr_data;

-- Total number of employees (Headcount KPI)
SELECT COUNT(*) AS total_employees
FROM hr_data;


/* ---------- WORKFORCE DISTRIBUTION ---------- */

-- Department-wise employee count
SELECT Department, COUNT(*) AS employee_count
FROM hr_data
GROUP BY Department;


/* ---------- ATTRITION ANALYSIS (CORE KPI) ---------- */

-- Employees who left the company
SELECT COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes';

-- Attrition vs Retention split
SELECT Attrition, COUNT(*) AS employee_count
FROM hr_data
GROUP BY Attrition;

-- Overall Attrition Rate (%)
SELECT
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM hr_data;

-- Retention Rate (%)
SELECT
    ROUND(
        100 - (
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*)
        ),
        2
    ) AS retention_rate_percentage
FROM hr_data;


/* ---------- DEPARTMENT-WISE ATTRITION ---------- */

-- Attrition count by department
SELECT Department, COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Department;

-- Attrition rate by department
SELECT
    Department,
    ROUND(
        COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate
FROM hr_data
GROUP BY Department
ORDER BY attrition_rate DESC;


/* ---------- SALARY & COMPENSATION ANALYSIS ---------- */

-- Average monthly income of all employees
SELECT ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM hr_data;

-- Department-wise average salary
SELECT Department, ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM hr_data
GROUP BY Department;

-- Average income of employees who left
SELECT ROUND(AVG(MonthlyIncome), 2) AS avg_income_leavers
FROM hr_data
WHERE Attrition = 'Yes';


/* ---------- AGE & EXPERIENCE ANALYSIS ---------- */

-- Average age of employees
SELECT ROUND(AVG(Age), 1) AS avg_employee_age
FROM hr_data;

-- Age group distribution
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS employee_count
FROM hr_data
GROUP BY age_group;

-- Average tenure (Years at Company)
SELECT ROUND(AVG(YearsAtCompany), 2) AS avg_tenure
FROM hr_data;


/* ---------- WORK ENVIRONMENT & ENGAGEMENT ---------- */

-- Overtime impact on attrition
SELECT OverTime, COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY OverTime;

-- Job Satisfaction vs Attrition
SELECT JobSatisfaction, COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobSatisfaction;

-- Promotion delay vs Attrition
SELECT YearsSinceLastPromotion, COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion DESC;


/* =========================================================
   KEY INSIGHTS
   =========================================================
   1. Certain departments show significantly higher attrition
      rates, indicating department-specific issues.
   2. Employees working overtime exhibit higher attrition,
      suggesting burnout and workload imbalance.
   3. Lower job satisfaction levels strongly correlate with
      higher employee attrition.
   4. Employees with longer gaps since last promotion are
      more likely to leave the organization.
   5. Attrition is more common among employees with lower
      average monthly income.
   ========================================================= */


/* =========================================================
   BUSINESS RECOMMENDATIONS
   =========================================================
   1. Reduce excessive overtime in high-attrition departments
      to improve work-life balance.
   2. Introduce structured promotion cycles to reduce employee
      frustration and improve retention.
   3. Improve engagement initiatives for employees with low
      job satisfaction scores through feedback programs and
      career development plans.
   ========================================================= */
