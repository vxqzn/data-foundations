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


-- Group by's
freight_logs (log_id, driver_name, destination, weight_lbs, trip_status)

SELECT
    driver_name,
    SUM(weight_lbs) AS total_weight
FROM freight_logs flog
WHERE UPPER(trip_status) != 'BROKEN DOWN'
GROUP BY driver_name;

-- Having's
consignment_sales (sale_id, seller_name, sneaker_name, profit_cut, is_returned)

SELECT
    seller_name,
    SUM(profit_cut) AS total_profit
FROM consignment_sales cs
WHERE is_returned = FALSE
GROUP BY seller_name
HAVING SUM(profit_cut) >= 5000;

-- Count's
repair_jobs (job_id, mechanic_name, service_type, customer_phone)

SELECT
    rj.mechanic_name,
    COUNT(*) AS jobs,
    COUNT(rj.customer_phone) AS jobs_with_phone_number
FROM repair_jobs rj
GROUP BY rj.mechanic_name
ORDER BY jobs DESC;

-- Case's
sneaker_sales (sale_id, shoe_name, profit_margin)

SELECT
    ss.shoe_name,
    ss.profit_margin,
    CASE
        WHEN profit_margin >= 200 THEN 'Grail'
        WHEN profit_margin >= 50 THEN 'Bread and Butter'
        ELSE 'Clearance'
    END AS status
FROM sneaker_sales ss;

-- Coalesce's
crew_payroll (runner_name, base_pay, bonus_pay)

SELECT
    cp.runner_name,
    SUM(COALESCE(cp.base_pay, 0) + COALESCE(cp.bonus_pay, 0)) AS payroll
FROM crew_payroll cp
GROUP BY cp.runner_name
ORDER BY payroll DESC;

-- NULLIF's, CAST's, "::"'s
street_team (runner_name, doors_knocked, sales_made)

SELECT
    st.runner_name,
    CAST(SUM(st.sales_made) AS NUMERIC) / NULLIF(SUM(st.doors_knocked), 0) AS conversion_rate
FROM street_team st
GROUP BY st.runner_name
ORDER BY conversion_rate DESC;

-- FILTER's
rent_payments (payment_id, building_id, tenant_id, payment_date, amount, status)

SELECT
    rp.building_id,
    COUNT(rp.payment_id) AS payments,
    SUM(rp.amount) FILTER (WHERE UPPER(status) = 'CLEARED') AS total_cleared,
    SUM(rp.amount) FILTER (WHERE UPPER(status) = 'LATE' OR UPPER(status) = 'BOUNCED') AS total_pending
FROM rent_payments rp
GROUP BY rp.building_id;

-- Stage 2 final boss
listings (id, seller_id, category, ask_price, sale_price, shipping_fee)

SELECT
    l.category,
    SUM(l.ask_price) AS total_potential_value,
    SUM(COALESCE(l.sale_price, 0) + COALESCE(l.shipping_fee, 0)) FILTER (WHERE l.sale_price > 0) AS actual_cash_flow,
    SUM(l.ask_price - l.sale_price) FILTER (WHERE l.sale_price > 0 AND l.sale_price < l.ask_price) AS discount_hit
FROM listings l
GROUP BY l.category
HAVING AVG(l.ask_price) > 500