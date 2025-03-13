DROP TABLE COUNTRIES;
DROP TABLE DEPARTMENTS;
DROP TABLE EMPLOYEES;
DROP TABLE JOB_HISTORY;
DROP TABLE JOBS;
DROP TABLE LOCATIONS;
DROP TABLE REGIONS;

CREATE TABLE COUNTRIES AS 
SELECT * FROM HR.COUNTRIES;

CREATE TABLE DEPARTMENTS AS 
SELECT * FROM HR.DEPARTMENTS;

CREATE TABLE EMPLOYEES AS 
SELECT * FROM HR.EMPLOYEES;

CREATE TABLE JOB_GRADES AS 
SELECT * FROM HR.JOB_GRADES;

CREATE TABLE JOB_HISTORY AS 
SELECT * FROM HR.JOB_HISTORY;

CREATE TABLE JOBS AS 
SELECT * FROM HR.JOBS;

CREATE TABLE LOCATIONS AS 
SELECT * FROM HR.LOCATIONS;

CREATE TABLE PRODUCTS AS 
SELECT * FROM HR.PRODUCTS;

CREATE TABLE REGIONS AS 
SELECT * FROM HR.REGIONS;

CREATE TABLE SALES AS 
SELECT * FROM HR.SALES;

-- ustawienie kluczy głównych

ALTER TABLE COUNTRIES 
ADD CONSTRAINT pk_countries__country_id 
PRIMARY KEY (country_id);

ALTER TABLE DEPARTMENTS 
ADD CONSTRAINT pk_departments__department_id 
PRIMARY KEY (department_id);

ALTER TABLE EMPLOYEES 
ADD CONSTRAINT pk_employees__employee_id 
PRIMARY KEY (employee_id);

ALTER TABLE JOB_GRADES 
ADD CONSTRAINT pk_job_grades__grade 
PRIMARY KEY (grade);

ALTER TABLE JOB_HISTORY 
ADD CONSTRAINT pk_job_history__employee_id_start_date 
PRIMARY KEY (employee_id, start_date);

ALTER TABLE JOBS 
ADD CONSTRAINT pk_jobs__job_id 
PRIMARY KEY (job_id);

ALTER TABLE LOCATIONS 
ADD CONSTRAINT pk_locations__location_id 
PRIMARY KEY (location_id);

ALTER TABLE PRODUCTS 
ADD CONSTRAINT pk_products__product_id 
PRIMARY KEY (product_id);

ALTER TABLE REGIONS 
ADD CONSTRAINT pk_regions__region_id 
PRIMARY KEY (region_id);

ALTER TABLE SALES 
ADD CONSTRAINT pk_sales__sale_id 
PRIMARY KEY (sale_id);

-- ustawienie kluczy obcych

--countries -> regions
ALTER TABLE COUNTRIES 
ADD CONSTRAINT fk_countries__regions_region_id
FOREIGN KEY (region_id)
REFERENCES REGIONS(region_id);

-- departmets -> employees
ALTER TABLE DEPARTMENTS 
ADD CONSTRAINT fk_departments__employees_manager_id
FOREIGN KEY (manager_id)
REFERENCES EMPLOYEES (employee_id);

--departments -> locations
ALTER TABLE DEPARTMENTS 
ADD CONSTRAINT fk_departments__locations_location_id
FOREIGN KEY (location_id)
REFERENCES LOCATIONS (location_id);

-- employees -> jobs
ALTER TABLE EMPLOYEES 
ADD CONSTRAINT fk_employees__jobs_job_id
FOREIGN KEY (job_id)
REFERENCES JOBS (job_id);

-- employees -> employees
ALTER TABLE EMPLOYEES 
ADD CONSTRAINT fk_employees__employees_employee_id
FOREIGN KEY (manager_id)
REFERENCES EMPLOYEES(employee_id);

--employees -> departments
ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_employees__departments_department_id
FOREIGN KEY (department_id)
REFERENCES DEPARTMENTS(department_id);

--job_history -> employees
ALTER TABLE JOB_HISTORY 
ADD CONSTRAINT fk_job_history__employees_employee_id
FOREIGN KEY (employee_id)
REFERENCES EMPLOYEES (employee_id);

--job_history -> jobs
ALTER TABLE JOB_HISTORY 
ADD CONSTRAINT fk_job_history__jobs_job_id
FOREIGN KEY (job_id)
REFERENCES JOBS (job_id);

-- job_history -> departments
ALTER TABLE JOB_HISTORY 
ADD CONSTRAINT fk_job_history__departments_department_id
FOREIGN KEY (department_id)
REFERENCES DEPARTMENTS (department_id);

-- location -> country
ALTER TABLE LOCATIONS 
ADD CONSTRAINT fk_locations__countries_country_id
FOREIGN KEY (country_id)
REFERENCES COUNTRIES (country_id);

--sales -> products
ALTER TABLE SALES 
ADD CONSTRAINT fk_sales__products_product_id
FOREIGN KEY (product_id)
REFERENCES PRODUCTS (product_id);

--sales -> employees
ALTER TABLE SALES 
ADD CONSTRAINT fk_sales__employees_employee_id
FOREIGN KEY (employee_id)
REFERENCES EMPLOYEES (employee_id);


-- queries

--Z tabeli employees wypisz w jednej kolumnie nazwisko i zarobki – nazwij
--kolumnę wynagrodzenie, dla osób z departamentów 20 i 50 z zarobkami
--pomiędzy 2000 a 7000, uporządkuj kolumny według nazwiska

SELECT 
    last_name ||' '|| salary as wynagrodzenie
FROM EMPLOYEES e
    WHERE 1=1 
    AND (e.department_id = 20 OR e.department_id = 50)
--    AND (e.salary BETWEEN 2000 AND 7000)
ORDER BY e.last_name;

--Z tabeli employees wyciągnąć informację data zatrudnienia, nazwisko oraz
--kolumnę podaną przez użytkownika dla osób mających menadżera
--zatrudnionych w roku 2005. Uporządkować według kolumny podanej przez
--użytkownika

SELECT 
    hire_date, 
    last_name,
    &user_column
FROM EMPLOYEES e
    WHERE 1=1
    AND EXTRACT(YEAR FROM hire_date) = 2005
    AND e.manager_id IS NOT NULL
ORDER BY &user_column;

--Wypisać imiona i nazwiska razem, zarobki oraz numer telefonu porządkując
--dane według pierwszej kolumny malejąco a następnie drugiej rosnąco (użyć
--numerów do porządkowania) dla osób z trzecią literą nazwiska ‘e’ oraz częścią
--imienia podaną przez użytkownika

-- Danielle

SELECT 
    first_name||' '|| last_name, 
    salary,
    phone_number
FROM EMPLOYEES e
    WHERE 1=1
    AND SUBSTR(last_name, 3, 1) = 'e'
    AND first_name LIKE '%' || :user_name || '%'
ORDER BY 1 DESC, 2 ASC;

--Wypisać imię i nazwisko, liczbę miesięcy przepracowanych – funkcje
--months_between oraz round oraz kolumnę wysokość_dodatku jako (użyć CASE
--lub DECODE):

SELECT 
    first_name,
    last_name,
    round(months_between((SYSDATE), hire_date)) AS months,
    CASE 
        WHEN round(months_between((select SYSTIMESTAMP FROM DUAL), hire_date)) < 150 THEN salary * 0.1
        WHEN round(months_between((select SYSTIMESTAMP FROM DUAL), hire_date)) BETWEEN 150 AND 200 THEN salary * 0.2
        ELSE salary * 0.3
    END AS wysokosc_dodatku
FROM EMPLOYEES
ORDER BY months;


--Dla każdego działów w których minimalna płaca jest wyższa niż 5000 wypisz
--sumę oraz średnią zarobków zaokrągloną do całości nazwij odpowiednio
--kolumny

SELECT 
    department_id AS dzial,
    SUM(salary) AS suma_zarobkow,
    ROUND(AVG(salary)) AS srednia_zarobkow
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 5000;

--Wypisać nazwisko, numer departamentu, nazwę departamentu, id pracy, dla
--osób z pracujących Toronto

SELECT 
    e.last_name, 
    e.department_id,
    d.department_name,
    e.job_id
FROM EMPLOYEES e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';


-- Dla pracowników o imieniu „Jennifer” wypisz imię i nazwisko tego pracownika
--oraz osoby które z nim współpracują

SELECT 
    e1.first_name AS imie_pracownika, 
    e1.last_name AS nazwisko_pracownika, 
    e2.first_name AS imie_wspolpracownika, 
    e2.last_name AS nazwisko_wspolpracownika
FROM employees e1
JOIN employees e2 
    ON e1.department_id = e2.department_id 
    AND e1.employee_id <> e2.employee_id    
WHERE e1.first_name = 'Jennifer';

--Wypisać wszystkie departamenty w których nie ma pracowników

SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.department_id IS NULL;

-- wypisz imię i nazwisko, 
--id pracy, nazwę departamentu, zarobki, 
--oraz odpowiedni grade dla każdego pracownika

SELECT 
    e.first_name ||' '||e.last_name,
    e.job_id,
    d.department_name,
    e.salary,
    (SELECT jg.grade from job_grades jg WHERE e.salary BETWEEN jg.min_salary AND jg.max_salary) as grade
FROM employees e
JOIN departments d ON e.department_id = d.department_id

-- Wypisz imię i nazwisko oraz zarobki dla osób, 
--które zarabiają więcej niż średnia wszystkich, 
--uporzadkuj malejaco według zarobkow


