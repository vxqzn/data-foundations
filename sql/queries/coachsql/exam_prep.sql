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
