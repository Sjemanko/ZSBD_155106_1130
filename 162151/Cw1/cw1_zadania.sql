--  2. Do tabeli Jobs wstaw 4 rekordy --

INSERT INTO Jobs (job_title, min_salary, max_salary)
VALUES ('Programista', '5000', '10000');

INSERT INTO Jobs (job_title, min_salary, max_salary)
VALUES ('Tester', '4000', '7000');

INSERT INTO Jobs (job_title, min_salary, max_salary)
VALUES ('Analityk', '4500', '8000');

INSERT INTO Jobs (job_title, min_salary, max_salary)
VALUES ('Devops', '6000', '12000');

-- 3. Wstaw 4 rekordy do tabeli Employees --

INSERT INTO Employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct)
VALUES ('Jan', 'Kowalski', 'jank@mail.pl', '543123321', '12-9-2020', '1', '6000', '8');

INSERT INTO Employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct)
VALUES ('Andrzej', 'Nowak', 'andn@mail.pl', '523443321', '2-12-2024', '2', '4000', '6');

INSERT INTO Employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct)
VALUES ('Joanna', 'Polak', 'asiap@mail.pl', '643983321', '1-4-2018', '3', '7000', '9');

INSERT INTO Employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct)
VALUES ('Anna', 'Lewandowska', 'lewanna@mail.pl', '798123421', '19-1-2020', '4', '6000', '4');

-- 4. W tabeli Employees zmień menadżera pracownikom o id 2 i 3 na 1 --

UPDATE Employees
SET MANAGER_ID = '1'
WHERE EMPLOYEE_ID = 2 OR EMPLOYEE_ID = 3;

-- 5. Dla tabeli JOBS zwiększ min i maks wynagrodzenie o 500, jeśli anzwa zawiera 'b' lub 's'. --

UPDATE JOBS 
SET min_salary = min_salary + 500, max_salary = max_salary + 500
WHERE job_title LIKE '%b%' OR job_title LIKE '%s%';

-- 6. Z tabeli Jobs usuń rekordy, dla których max zarobki są większe od 9000 -- 

DELETE FROM Jobs WHERE max_salary > 9000;