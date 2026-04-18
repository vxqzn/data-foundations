-- GROUP BY, COUNT, SUM, and basic aggregate functions

SELECT
    orders.status,
    COUNT(orders.order_id) AS order_count,
    SUM(orders.total_amount) AS total_revenue
FROM orders
GROUP BY status;

SELECT
    sales.region,
    MAX(sales.sale_amount) AS max_sale,
    ROUND(AVG(sales.sale_amount), 2) AS avg_sale
FROM sales
GROUP BY region;

SELECT
    department,
    COUNT(employee_id) AS staff_count
FROM employees
GROUP BY department
HAVING COUNT(employee_id) > 3;

SELECT
    wv.page_path,
    COUNT(DISTINCT wv.visitor_id) AS unique_visitor_count
FROM website_visits as wv
GROUP BY wv.page_path
HAVING COUNT(DISTINCT wv.visitor_id) > 5;

SELECT
    region,
    AVG(amount) AS avg_transaction_value
FROM transactions
WHERE NOT is_cancelled
GROUP BY region
HAVING AVG(amount) > 150;

SELECT
    department,
    COUNT(*) AS total_count,
    COUNT(bonus_points) AS bonus_earner_count
FROM staff_rewards
GROUP BY department;