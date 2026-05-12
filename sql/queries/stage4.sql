-- subqueries
employees (emp_id, emp_name, salary, dept_id)
departments (dept_id, dept_name)

SELECT
    main_emp.emp_name,
    main_emp.salary
FROM employees AS main_emp
WHERE main_emp.salary >= (
    SELECT AVG(e.salary) AS average
    FROM employees AS e
);

customers (customer_id, first_name, email, signup_date)
orders (order_id, customer_id, order_date, total_amount)

SELECT
    c1.first_name,
    c1.email
FROM customers AS c1
WHERE c1.customer_id NOT IN (
    SELECT o2.customer_id
    FROM orders AS o2
    WHERE o2.customer_id IS NOT NULL
);

user_logins (login_id, user_id, login_timestamp)

SELECT AVG(user_logins_nr.logins_number)
FROM (
    SELECT 
        user_logins.user_id,
        COUNT(user_logins.login_id) AS logins_number
    FROM user_logins
    GROUP BY user_logins.user_id
) AS user_logins_nr;

products (product_id, name, category, price)

SELECT
    p1.name,
    p1.category,
    p1.price
FROM products as p1
WHERE p1.price > (
    SELECT AVG(p2.price)
    FROM products as p2
    WHERE p1.category = p2.category
);

doctors (doctor_id, first_name, last_name, specialty)
appointments (appointment_id, doctor_id, patient_id, appointment_date, status)

SELECT
    first_name,
    last_name
FROM doctors AS d
WHERE EXISTS (
    SELECT 1
    FROM appointments AS a
    WHERE d.doctor_id = a.doctor_id
        AND appointment_date = CURRENT_DATE
);