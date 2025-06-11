CREATE VIEW v_wysokie_pensje AS 
SELECT * FROM employees WHERE salary > 6000;


DROP VIEW v_wysokie_pensje;


CREATE VIEW v_wysokie_pensje AS
SELECT * FROM employees
WHERE salary > 12000;

DROP VIEW v_wysokie_pensje;

CREATE VIEW v_finance AS 
SELECT employee_id, last_name, first_name from employees
WHERE department_id = 100;

CREATE VIEW v_salary_between_5000_and_12000 AS 
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date from employees
WHERE salary between 5000 and 12000;

CREATE OR REPLACE VIEW v_statystyki_dzialow AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS liczba_pracownikow,
    ROUND(AVG(e.salary), 2) AS srednia_pensja,
    MAX(e.salary) AS najwyzsza_pensja
FROM
    departments d
JOIN
    employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) >= 4;


