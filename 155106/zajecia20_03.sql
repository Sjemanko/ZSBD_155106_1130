-- tworzenie widoku
CREATE VIEW v_pensje AS 
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary > 10000;

SELECT * FROM v_pensje;

--ALTER VIEW v_pensje AS 

-- edycja widoku
CREATE OR REPLACE VIEW v_pensje AS 
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 12000;

SELECT * FROM v_pensje;

-- usuwanie widoku
DROP VIEW v_pensje;

-- 1. Utwórz widok v_wysokie_pensje, dla tabeli employees który pokaże wszystkich
-- pracowników zarabiających więcej niż 6000.

CREATE VIEW v_wysokie_pensje AS
SELECT employee_id, first_name, last_name, salary
FROM employees 
WHERE salary > 6000;

SELECT * FROM v_wysokie_pensje;

-- 2. Zmień definicję widoku v_wysokie_pensje aby pokazywał tylko pracowników
--zarabiających powyżej 12000.

CREATE OR REPLACE VIEW v_wysokie_pensje as 
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 12000;

SELECT * FROM v_wysokie_pensje;

-- 3. Usuń widok v_wysokie_pensje.

DROP VIEW v_wysokie_pensje;
SELECT * FROM v_wysokie_pensje;

-- 4. Stwórz widok dla tabeli employees zawierający: employee_id, last_name, first_name, dla
--pracowników z departamentu o nazwie Finance

CREATE VIEW v_employees_finance_department AS 
SELECT employee_id, last_name, first_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE department_name = 'Finance';

SELECT * FROM v_employees_finance_department;

-- 5. Stwórz widok dla tabeli employees zawierający: employee_id, last_name, first_name,
--salary, job_id, email, hire_date dla pracowników mających zarobki pomiędzy 5000 a
--12000.

CREATE VIEW v_employees_salary_between_5000_12000 AS 
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000;

SELECT * FROM v_employees_salary_between_5000_12000;


-- 6. Poprzez utworzone widoki sprawdź czy możesz:
--a. dodać nowego pracownika
INSERT INTO 
v_employees_salary_between_5000_12000(employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES 
(502, 'last_name', 'first_name', 5001, 'IT_PROG', 'email', '06/01/03');

--b. edytować pracownika
UPDATE v_employees_salary_between_5000_12000 SET last_name = 'edited_last_name'
WHERE last_name = 'last_name';

--c. usunąć pracownika
DELETE FROM v_employees_salary_between_5000_12000 
WHERE first_name = 'first_name';

-- 7. Stwórz widok, który dla każdego działu który zatrudnia przynajmniej 4 pracowników
--wyświetli: identyfikator działu, nazwę działu, liczbę pracowników w dziale, średnią
--pensja w dziale i najwyższa pensja w dziale.
--a. Sprawdź czy możesz dodać dane do tego widoku.


SELECT d.department_id, d.department_name, COUNT(*) as employee_count, AVG(e.salary), MAX(e.salary)
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) > 3;

--SELECT count(*) as liczba_pracownikow, department_id FROM employees
--GROUP BY department_id;



--CREATE VIEW v_more_than_4_employees_in_department AS 
--