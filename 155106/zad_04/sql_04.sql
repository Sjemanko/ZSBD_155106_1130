CREATE OR REPLACE VIEW v_ranking_pensji AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking
FROM
    employees;


CREATE OR REPLACE VIEW v_ranking_pensji AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking,
    SUM(salary) OVER () AS suma_pensji_wszystkich
FROM
    employees;

CREATE OR REPLACE VIEW v_sprzedaz_pracownikow AS
SELECT
    e.last_name,
    p.product_name,
    SUM(s.quantity * s.price) AS suma_sprzedazy_pracownika,
    RANK() OVER (ORDER BY SUM(s.quantity * s.price) DESC) AS ranking_sprzedazy
FROM
    employees e
JOIN
    sales s ON e.employee_id = s.employee_id
JOIN
    products p ON s.product_id = p.product_id
GROUP BY
    e.last_name,
    p.product_name;

SELECT
    e.last_name,
    p.product_name,
    s.price,
    
    COUNT(*) OVER (
        PARTITION BY s.product_id, s.sale_date
    ) AS liczba_transakcji_dla_produktu_dnia,
    
    SUM(s.price) OVER (
        PARTITION BY s.product_id, s.sale_date
    ) AS suma_dzienna_dla_produktu,
    
    LAG(s.price) OVER (
        PARTITION BY s.product_id ORDER BY s.sale_date, s.sale_id
    ) AS poprzednia_cena,
    
    LEAD(s.price) OVER (
        PARTITION BY s.product_id ORDER BY s.sale_date, s.sale_id
    ) AS kolejna_cena

FROM
    sales s
JOIN
    employees e ON s.employee_id = e.employee_id
JOIN
    products p ON s.product_id = p.product_id;


SELECT
    p.product_name,
    s.price,
    
    SUM(s.price) OVER (
        PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM')
    ) AS suma_miesieczna,
    
    SUM(s.price) OVER (
        PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM')
        ORDER BY s.sale_date, s.sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS suma_rosnaca_miesieczna

FROM
    sales s
JOIN
    products p ON s.product_id = p.product_id;
    
    
SELECT
    p.product_name,
    p.product_category,
    TO_CHAR(s2022.sale_date, 'MM-DD') AS dzien_miesiac,
    
    s2022.price AS cena_2022,
    s2023.price AS cena_2023,
    
    (s2023.price - s2022.price) AS roznica_cen

FROM
    sales s2022
JOIN
    sales s2023
    ON s2022.product_id = s2023.product_id
   AND TO_CHAR(s2022.sale_date, 'MM-DD') = TO_CHAR(s2023.sale_date, 'MM-DD')
   AND EXTRACT(YEAR FROM s2022.sale_date) = 2022
   AND EXTRACT(YEAR FROM s2023.sale_date) = 2023

JOIN
    products p ON s2022.product_id = p.product_id
