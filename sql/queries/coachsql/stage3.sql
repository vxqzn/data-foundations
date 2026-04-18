-- INNER JOIN mechanics, table aliasing, and 1-to-many matching

SELECT
    u.email,
    s.plan_tier,
    s.monthly_fee
FROM users u
INNER JOIN subscriptions s
    ON u.user_id = s.user_id;

SELECT
    u.email,
    s.login_timestamp,
    p.amount
FROM users u
INNER JOIN sessions s
    ON u.user_id = s.user_id
INNER JOIN purchases p
    ON s.session_id = p.session_id;

SELECT
    e.first_name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id;

SELECT
    c.customer_id,
    c.name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT
    p.product_name,
    w.region_name
FROM products p
CROSS JOIN warehouses w;

SELECT
    i.transaction_ref,
    b.transaction_ref,
    i.internal_amount,
    b.cleared_amount
FROM internal_ledger i
FULL OUTER JOIN bank_statement b
    ON i.transaction_ref = b.transaction_ref;

SELECT
    workers.employee_name AS worker_name,
    managers.employee_name AS manager_name
FROM employees workers
LEFT JOIN employees managers
    ON workers.manager_id = managers.emp_id;

SELECT
    d.name AS doctor_name,
    d.specialty,
    a.appointment_date,
    p.name AS patient_name
FROM doctors d
LEFT JOIN appointments a
    ON d.doctor_id = a.doctor_id
LEFT JOIN patients p
    ON a.patient_id = p.patient_id;

SELECT
    u.username,
    l.login_date
FROM users u
LEFT JOIN logins l
    ON u.user_id = l.user_id
        AND l.status = 'failed';

SELECT
    e.employee_name,
    d.device_type
FROM employees e
LEFT JOIN devices d
    ON e.emp_id = d.emp_id
        AND d.device_status = 'active';

SELECT
    d.department_name,
    e.employee_name,
    b.amount
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
LEFT JOIN bonuses b
    ON e.emp_id = b.emp_id
        AND b.amount > 5000;

SELECT
    p.project_name,
    t.task_name,
    a.developer_name
FROM projects p
LEFT JOIN tasks t
    ON p.project_id = t.project_id
LEFT JOIN assignments a
    ON t.task_id = a.task_id
        AND a.role = 'lead';

SELECT
    v.vendor_name,
    s.software_name,
    l.employee_id
FROM vendors v
LEFT JOIN software s
    ON v.vendor_id = s.vendor_id
LEFT JOIN licenses l
    ON s.software_id = l.software_id
        AND l.status = 'active';

SELECT
    f.flight_id,
    dep.city_name AS departure_city,
    arr.city_name AS arrival_city
FROM flights f
LEFT JOIN airports dep
    ON f.departure_code = dep.airport_code
LEFT JOIN airports arr
    ON f.arrival_code = arr.airport_code;

SELECT
    u.email,
    d.discount_code,
    p.purchase_amount
FROM users u
LEFT JOIN discounts d
    ON u.user_id = d.user_id
        AND d.is_redeemed = TRUE
LEFT JOIN purchases p
    ON d.discount_id = p.discount_id;

SELECT
    r.restaurant_name,
    i.grade,
    v.description
FROM restaurants r
LEFT JOIN inspections i
    ON r.restaurant_id = i.restaurant_id
        AND i.grade = 'F'
LEFT JOIN violations v
    ON i.inspection_id = v.inspection_id;

SELECT
    s.student_name,
    c.course_name,
    c.level
FROM students s
LEFT JOIN enrollments e
    ON s.student_id = e.student_id
LEFT JOIN courses c
    ON e.course_id = c.course_id
        AND c.level = 'advanced';