-- Exercise 1
SELECT
    a.nume,
    a.prenume,
    a.salariu,
    TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_ang) / 12) AS ANI_VECHIME
FROM angajati a
LEFT JOIN departamente d 
    ON a.id_dep = d.id_dep
WHERE UPPER(d.oras) = 'TIMISOARA'
ORDER BY a.salariu DESC;

-- Exercise 2
SELECT
    d.denumire AS DEPARTAMENT,
    COUNT(*) AS NR_ANGAJATI,
    ROUND(AVG(a.salariu), 0) AS SALARIU_MEDIU,
    MAX(a.salariu) AS SALARIU_MAX
FROM angajati a
LEFT JOIN departamente d 
    ON a.id_dep = d.id_dep
GROUP BY d.denumire
ORDER BY AVG(a.salariu) DESC;

-- Exercise 3
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE raport_salarii(oras_input IN VARCHAR2) AS

    v_medie     NUMBER;
    v_contor    NUMBER := 0;
    v_label     VARCHAR2(20);

    CURSOR c_angajati IS 
        SELECT a.nume, a.prenume, a.salariu
        FROM angajati a
        JOIN departamente d ON a.id_dep = d.id_dep
        WHERE UPPER(d.oras) = UPPER(oras_input);

    v_rand c_angajati%ROWTYPE;

BEGIN
    SELECT AVG(salariu) INTO v_medie FROM angajati;

    OPEN c_angajati;
    LOOP
        FETCH c_angajati INTO v_rand;
        EXIT WHEN c_angajati%NOTFOUND;

        IF v_rand.salariu >= v_medie THEN
            v_label := 'PESTE MEDIE';
        ELSE
            v_label := 'SUB MEDIE';
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_rand.nume || ' ' || v_rand.prenume || ' - ' || v_rand.salariu || ' - ' || v_label);
        v_contor := v_contor + 1;
    END LOOP;
    CLOSE c_angajati;

    DBMS_OUTPUT.PUT_LINE('Total angajati procesati: ' || v_contor);
END raport_salarii;
/

EXEC raport_salarii('');


-- Exercise 1
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE get_balance(acc_id IN NUMBER) IS
    balance_holder      NUMBER;

BEGIN
    SELECT balance INTO balance_holder FROM accounts WHERE account_id = acc_id;
    
    DBMS_OUTPUT.PUT_LINE('The balance is: ' || balance_holder);
END;
/

-- Exercise 2
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION calc_dept_payroll(p_dept_id IN NUMBER) RETURN NUMBER IS
    v_total_payroll NUMBER := 0;
    v_current_salary NUMBER;

    CURSOR c_emp_salaries IS
        SELECT salary FROM employees WHERE department_id = p_dept_id;

BEGIN
    OPEN c_emp_salaries;

    LOOP
        FETCH c_emp_salaries INTO v_current_salary;
        EXIT WHEN c_emp_salaries%NOTFOUND;

        v_total_payroll := v_total_payroll + v_current_salary;
    END LOOP;

    CLOSE c_emp_salaries;

    RETURN v_total_payroll;
END;
/


SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE run_stock_warning(p_treshold NUMBER) IS

    CURSOR c_quantity_check IS
        SELECT item_name, stock_quantity FROM inventory WHERE stock_quantity < p_treshold;
    
BEGIN
    FOR i IN c_quantity_check LOOP
        DBMS_OUTPUT.PUT_LINE('WARNING: ' || i.item_name || ' is low. Only ' || i.stock_quantity || ' left.');
    END LOOP;
END;
/


------------------------------------------------------------------


-- DEPARTAMENTE
ID_DEP | DENUMIRE     | ORAS
-------|--------------|----------
1      | Vanzari      | Timisoara
2      | IT           | Cluj
3      | HR           | Timisoara
4      | Financiar    | Bucuresti

-- ANGAJATI
ID_ANG | NUME          | PRENUME  | SALARIU | DATA_ANG   | ID_DEP | ID_SEF
-------|---------------|----------|---------|------------|--------|-------
1      | Ionescu       | Andrei   | 6200    | 01/03/2019 | 1      | NULL
2      | Popescu       | Maria    | 7200    | 15/06/2018 | 2      | NULL
3      | Stan          | Cristian | 4500    | 10/01/2021 | 1      | 1
4      | Dumitrescu    | Elena    | 8000    | 20/09/2017 | 2      | 2
5      | Georgescu     | Ion      | 3800    | 05/11/2022 | 3      | NULL
6      | Popa          | Ana      | 6100    | 12/04/2020 | 4      | NULL
7      | Marin         | Vlad     | 4200    | 28/07/2021 | 1      | 1
8      | Nistor        | Ioana    | 5500    | 03/02/2019 | 2      | 2
9      | Dobre         | Radu     | 3200    | 17/12/2023 | 3      | 5
10     | Costea        | Simona   | 9500    | 08/08/2016 | 4      | 6


-- Function Exercise
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION nr_peste_medie(p_id_dep IN NUMBER) RETURN NUMBER IS
    
    v_contor NUMBER := 0;
    v_medie NUMBER;

    CURSOR c_belt IS
        SELECT a.salariu FROM angajati a JOIN departamente d ON a.id_dep = d.id_dep WHERE d.id_dep = p_id_dep;

    v_rand c_belt%ROWTYPE;

BEGIN
    SELECT AVG(salariu) INTO v_medie FROM angajati WHERE id_dep = p_id_dep;

    OPEN c_belt;
    LOOP
        FETCH c_belt INTO v_rand;
        EXIT WHEN c_belt%NOTFOUND;

        IF v_rand.salariu >= v_medie THEN
            v_contor := v_contor + 1;
        END IF;
    END LOOP;
    CLOSE c_belt;
    
    RETURN v_contor;
END;
/

-- Procedure exercise
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE raport_departament(p_salariu_min IN NUMBER, p_salariu_max IN NUMBER) IS

    CURSOR belt IS
        SELECT a.nume, a.prenume, d.denumire, a.salariu FROM angajati a JOIN departamente d ON a.id_dep = d.id_dep;

    v_rand belt%ROWTYPE;
    v_buget_total NUMBER := 0;

BEGIN
    OPEN belt;
    LOOP
        FETCH belt INTO v_rand;
        EXIT WHEN belt%NOTFOUND;

        IF v_rand.salariu >= p_salariu_min AND v_rand.salariu <= p_salariu_max THEN
            v_buget_total := v_buget_total + v_rand.salariu;
            DBMS_OUTPUT.PUT_LINE(v_rand.nume || ' ' || v_rand.prenume || ' - ' || v_rand.denumire || ' - ' || v_rand.salariu);
        END IF; 
    END LOOP;
    CLOSE belt;

    DBMS_OUTPUT.PUT_LINE('Buget total: ' || v_buget_total);
END;
/