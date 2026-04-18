-- LIMIT, Aliasing, WHERE, ORDER BY

SELECT first_name, last_name, salary
FROM employees
LIMIT 10;

SELECT
    first_name,
    last_name,
    hire_date AS started_on
FROM employees
WHERE department = 'Engineering';

SELECT
    first_name,
    last_name,
    salary
FROM employees
WHERE department = 'Sales'
    AND salary > 80000
ORDER BY salary DESC, last_name ASC;


-- DISTINCT, NULL handling

SELECT DISTINCT
    product_category
FROM customer_purchases
ORDER BY product_category ASC;

SELECT
    cp.purchase_id,
    cp.customer_id,
    cp.purchase_date
FROM customer_purchases AS cp
WHERE discount_code IS NULL
ORDER BY cp.purchase_date DESC;

SELECT DISTINCT
    er.department
FROM employee_records AS er
WHERE er.termination_date IS NULL
ORDER BY er.department DESC;

SELECT DISTINCT
    ws.destination_city
FROM warehouse_shipments AS ws
WHERE ws.delivery_date IS NULL
ORDER BY ws.destination_city ASC;

SELECT DISTINCT
    inv.category
FROM product_inventory AS inv
WHERE inv.supplier_id = 42
    AND inv.expiration_date IS NULL
ORDER BY inv.category DESC
LIMIT 5;

SELECT DISTINCT
    gc.ip_address
FROM guest_checkouts AS gc
WHERE gc.email_provided IS NULL
ORDER BY gc.ip_address ASC
LIMIT 10;