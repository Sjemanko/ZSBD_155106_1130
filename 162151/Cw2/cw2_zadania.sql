-- 1. Z tabeli employees wypisz w jednej kolumnie nazwisko i zarobki – nazwij --
-- kolumnę wynagrodzenie, dla osób z departamentów 20 i 50 z zarobkami --
-- pomiędzy 2000 a 7000, uporządkuj kolumny według nazwiska --

SELECT last_name || ', ' || salary AS Wynagrodzenie
FROM EMPLOYEES
WHERE department_id IN (20, 50)
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;

-- 2. Z tabeli employees wyciągnąć informację data zatrudnienia, nazwisko oraz --
-- kolumnę podaną przez użytkownika dla osób mających menadżera --
-- zatrudnionych w roku 2005. Uporządkować według kolumny podanej przez --
-- użytkownika --

SELECT hire_date, last_name,  &user_input
FROM Employees
WHERE manager_id IS NOT NULL
AND EXTRACT(YEAR FROM hire_date) = 2005
ORDER BY &user_input;

-- 3. Wypisać imiona i nazwiska razem, zarobki oraz numer telefonu porządkując --
-- dane według pierwszej kolumny malejąco a następnie drugiej rosnąco (użyć --
-- numerów do porządkowania) dla osób z trzecią literą nazwiska ‘e’ oraz częścią --
-- imienia podaną przez użytkownika --

SELECT first_name || ' ' || last_name AS Nazwa, salary, phone_number
FROM Employees
WHERE last_name LIKE '__e%'
AND first_name LIKE '%&user_input%'
ORDER BY 1 DESC, 2 ASC;

-- 4. Wypisać imię i nazwisko, liczbę miesięcy przepracowanych – funkcje --
-- months_between oraz round oraz kolumnę wysokość_dodatku jako (użyć CASE --
-- lub DECODE): --
-- ● 10% wynagrodzenia dla liczby miesięcy do 150 --
-- ● 20% wynagrodzenia dla liczby miesięcy od 150 do 200 --
-- ● 30% wynagrodzenia dla liczby miesięcy od 200 --
-- ● uporządkować według liczby miesięcy --

SELECT first_name, last_name, 
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS miesiace_przepracowane,
       CASE 
           WHEN MONTHS_BETWEEN(SYSDATE, hire_date) <= 150 THEN salary * 0.1
           WHEN MONTHS_BETWEEN(SYSDATE, hire_date) BETWEEN 151 AND 200 THEN salary * 0.2
           ELSE salary * 0.3
       END AS wysokość_dodatku
FROM employees
ORDER BY miesiace_przepracowane;

-- 5. Dla każdego działów w których minimalna płaca jest wyższa niż 5000 wypisz --
-- sumę oraz średnią zarobków zaokrągloną do całości nazwij odpowiednio --
-- kolumny --

SELECT department_id, ROUND(AVG(salary)) AS srednia, ROUND(SUM(SALARY)) as suma
FROM Employees
GROUP BY department_id
HAVING MIN(salary) > 5000;

-- 6. Wypisać nazwisko, numer departamentu, nazwę departamentu, id pracy, dla --
-- osób z pracujących Toronto --

SELECT employees.last_name, employees.department_id, departments.department_name, employees.job_id
FROM Employees
JOIN Departments ON employees.department_id=departments.department_id
JOIN Locations ON departments.location_id=locations.location_id
WHERE locations.city = 'Toronto';

-- 7. Dla pracowników o imieniu „Jennifer” wypisz imię i nazwisko tego pracownika --
-- oraz osoby które z nim współpracują --

SELECT e1.first_name, e1.last_name, e2.first_name AS coworker_first, e2.last_name AS coworker_last
FROM employees e1
JOIN employees e2 ON e1.department_id = e2.department_id AND e1.employee_id != e2.employee_id
WHERE e1.first_name = 'Jennifer';

-- 8. Wypisać wszystkie departamenty w których nie ma pracowników --

SELECT department_name
FROM departments
WHERE department_id NOT IN (SELECT DISTINCT department_id FROM employees);

-- 9. Wypisz imię i nazwisko, id pracy, nazwę departamentu, zarobki, oraz --
-- odpowiedni grade dla każdego pracownika --

SELECT e.first_name, e.last_name, e.job_id, d.department_name, e.salary,
       CASE 
           WHEN salary < 2999 THEN 'A'
           WHEN salary BETWEEN 3000 AND 4999 THEN 'B'
           WHEN salary BETWEEN 5000 AND 7999 THEN 'C'
           WHEN salary BETWEEN 8000 AND 9999 THEN 'D'
           WHEN salary BETWEEN 10000 AND 14999 THEN 'E'
           ELSE 'F'
       END AS grade
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 10.Wypisz imię nazwisko oraz zarobki dla osób które zarabiają więcej niż średnia --
-- wszystkich, uporządkuj malejąco według zarobków --

SELECT first_name, last_name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) from Employees)
ORDER BY salary DESC;

-- 11.Wypisz id imię i nazwisko osób, które pracują w departamencie z osobami --
-- mającymi w nazwisku „u” --

SELECT e1.employee_id, e1.first_name, e1.last_name
FROM Employees e1
JOIN Employees e2 ON e1.employee_id = e2.employee_id
WHERE e1.department_id = e2.department_id AND e2.last_name LIKE '%u%';

-- 12.Znajdź pracowników, którzy pracują dłużej niż średnia długość zatrudnienia w --
-- firmie. -- 

SELECT first_name, last_name, hire_date
FROM employees
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) > 
      (SELECT AVG(MONTHS_BETWEEN(SYSDATE, hire_date)) FROM employees);

-- 13.Wypisz nazwę departamentu, liczbę pracowników oraz średnie wynagrodzenie --
-- w każdym departamencie. Sortuj według liczby pracowników malejąco. --

SELECT d.department_name, COUNT(e.employee_id) AS liczba_pracownikow, AVG(e.salary)
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY liczba_pracownikow DESC;
