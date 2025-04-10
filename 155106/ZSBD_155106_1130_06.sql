-- procedury
set SERVEROUTPUT on;
-- nagłówek
-- sekcja wykonywalna
-- sekcja obsługi błędów


CREATE OR REPLACE PROCEDURE powitanie AS
BEGIN
dbms_output.put_line('hello');
END powitanie;

-- wywołanie
BEGIN 
powitanie;
END;

-- procedury z parametrem wejściowym

CREATE OR REPLACE PROCEDURE powitanie1 (
    imie IN VARCHAR2
) AS
BEGIN
dbms_output.put_line('hello ' || imie || '!');
END powitanie1;


-- wywołanie
BEGIN 
powitanie1('Ania');
END;

CREATE OR REPLACE PROCEDURE square (
    input IN NUMBER,
    output OUT NUMBER
) AS
BEGIN
output := input * input;
dbms_output.put_line('SQUARE OF ' || input || ' = ' || output);
END square;


-- wywołanie
DECLARE 
resulthehe NUMBER;
BEGIN 
square(5, resulthehe);
END;


-- zad.01

CREATE OR REPLACE PROCEDURE add_row_to_jobs (
    Job_id IN VARCHAR2,
    Job_title IN VARCHAR2
) AS 
BEGIN 
    INSERT INTO JOBS(job_id, job_title) VALUES (Job_id, Job_title);

EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Some kind of error occurred');
END add_row_to_jobs;

-- wywołanie
BEGIN 
add_row_to_jobs('TEST_ID', 'TEST_TITLE');
END;


-- zad.02

CREATE OR REPLACE PROCEDURE modify_job_title(
    Jobid IN Jobs.job_id%type,
    Jobtitle IN Jobs.job_title%type
) AS 
BEGIN 
    UPDATE Jobs SET job_title = Jobtitle WHERE job_id = Jobid;
    dbms_output.put_line(SQL%ROWCOUNT);

EXCEPTION
    IF SQL%ROWCOUNT == 0 THEN
    RAISE 
END modify_job_title;

    
-- wywołanie
BEGIN 
modify_job_title('TEST_ID', 'TEST_TITLE2');
END;

-- zad.03

CREATE OR REPLACE PROCEDURE delete_job_row(
    jobid IN jobs.job_id%type
) AS 
BEGIN
    DELETE FROM JOBS WHERE job_id = jobid;

END delete_job_row;