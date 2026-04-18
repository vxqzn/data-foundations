-- GROUP BY, COUNT, SUM, Execution Order, COUNT vs COUNT(column), The Alias Trap and basic aggregate functions

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

SELECT
    inv.category,
    MIN(inv.price) AS min_price,
    MAX(inv.price) AS max_price,
    SUM(inv.price * inv.stock_quantity) AS total_stock_value
FROM inventory AS inv
WHERE stock_quantity > 0
GROUP BY category
HAVING SUM(inv.price * inv.stock_quantity) > 5000;

SELECT
    agent_id,
    priority_level,
    ROUND(AVG(resolution_time_minutes), 1) AS avg_resolution_time
FROM support_tickets
WHERE is_resolved = TRUE
GROUP BY agent_id, priority_level
HAVING COUNT(agent_id) > 10;

SELECT
    store_id,
    SUM(gross_revenue) AS total_revenue,
    SUM(operating_cost) AS total_cost,
    (SUM(gross_revenue) - SUM(operating_cost)) AS net_profit
FROM monthly_financials
WHERE NOT gross_revenue = 0
GROUP BY store_id
HAVING (SUM(gross_revenue) - SUM(operating_cost)) > 10000;

SELECT
    platform,
    SUM(clicks) AS total_clicks,
    SUM(spend) AS total_spend,
    (SUM(spend) / SUM(clicks)) AS cost_per_click
FROM ad_campaigns
WHERE NOT spend = 0
GROUP BY platform
HAVING SUM(clicks) > 500
    AND (SUM(spend) / SUM(clicks)) < 2;

SELECT
    facility_id,
    SUM(forklift_trips) AS total_trips,
    SUM(incident_reports) AS total_incidents
FROM warehouse_operations
WHERE NOT zone = 'Loading Dock'
GROUP BY facility_id
HAVING SUM(forklift_trips) > 5000
    AND SUM(incident_reports) = 0;

SELECT
    product_id,
    COUNT(*) AS verified_review_count,
    ROUND(AVG(review_score), 2) AS avg_score
FROM customer_reviews
WHERE is_verified_purchase = TRUE
GROUP BY product_id
HAVING COUNT(*) > 50
    AND AVG(review_score) >= 4.0;