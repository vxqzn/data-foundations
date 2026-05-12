-- Joins Section

-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT starttime
FROM cd.bookings
INNER JOIN cd.members ON cd.bookings.memid = cd.members.memid
WHERE surname = 'Farrell' AND firstname = 'David';

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
SELECT starttime AS start, name
FROM cd.bookings
INNER JOIN cd.facilities ON cd.bookings.facid = cd.facilities.facid
WHERE DATE(starttime) = '2012-09-21' AND name LIKE 'Tennis Court%'
ORDER BY starttime;

-- How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
SELECT DISTINCT recs.firstname AS firstname, recs.surname AS surname
FROM cd.members mems
INNER JOIN cd.members recs ON recs.memid = mems.recommendedby
ORDER BY surname, firstname;

-- How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).
SELECT
    mem.firstname AS memfname,
    mem.surname AS memsname,
    rec.firstname AS recfname,
    rec.surname AS recsname
FROM cd.members mem
LEFT JOIN cd.members rec
    ON rec.memid = mem.recommendedby
ORDER BY mem.surname, mem.firstname;

-- How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.
SELECT DISTINCT
    mem.firstname || ' ' || mem.surname AS members,
    fac.name AS facility
FROM cd.members mem
INNER JOIN cd.bookings book
    ON mem.memid = book.memid
INNER JOIN cd.facilities fac
    ON book.facid = fac.facid
        AND fac.name LIKE 'Tennis Court%'
WHERE fac.name IS NOT NULL
ORDER BY members, facility;

-- How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.
SELECT
    mem.firstname || ' ' || mem.surname AS member,
    fac.name as facility,
    CASE
        WHEN mem.memid = 0 THEN book.slots * fac.guestcost
        ELSE book.slots * fac.membercost
    END AS cost
FROM cd.members mem
INNER JOIN cd.bookings book
    ON mem.memid = book.memid
INNER JOIN cd.facilities fac
    ON book.facid = fac.facid
WHERE DATE(book.starttime) = '2012-09-14'
    AND (
        CASE
            WHEN mem.memid = 0 THEN book.slots * fac.guestcost
            ELSE book.slots * fac.membercost
        END 
    ) > 30
ORDER BY cost DESC;

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


-- JOINs
employees (emp_id, name, dept_id)
departments (dept_id, dept_name)

SELECT
    e.name,
    d.dept_name
FROM employees AS e
INNER JOIN departments AS d
    ON e.dept_id = d.dept_id;


products (product_id, product_name, price)
sales (sale_id, product_id, amount, sale_date)

SELECT
    p.product_name,
    COALESCE(s.amount::text, 'not sold') AS sale_amount
FROM products AS p
LEFT JOIN sales AS s
    ON p.product_id = s.product_id;


registrations (reg_id, reg_name, reg_email)
attendees (badge_id, attendee_name, attendee_email)

SELECT
    r.reg_id,
    a.badge_id,
    r.reg_name
FROM registrations AS r
FULL OUTER JOIN attendees AS a
    ON r.reg_email = a.attendee_email;

-- upgr
SELECT
    COALESCE(r.reg_name, a.attendee_name) AS final_name,
    COALESCE(r.reg_email, a.attendee_email) AS final_email,
    r.reg_id,
    a.badge_id,
    CASE
        WHEN r.reg_id IS NOT NULL AND a.badge_id IS NOT NULL THEN 'Registered & Attended.'
        WHEN r.reg_id IS NOT NULL AND a.badge_id IS NULL THEN 'No-Show'
        WHEN r.reg_id IS NULL AND a.badge_id IS NO NULL THEN 'Walk-in'
    END AS attendee_status
FROM registrations AS r
FULL OUTER JOIN attendees AS a
    ON r.reg_email = a.attendee_email;


artists (artist_id, artist_name)
albums (album_id, artist_id, album_name)
tracks (track_id, album_id, track_name)

SELECT
    ar.artist_name AS artist,
    al.album_name AS album,
    tr.track_name AS track
FROM artists AS ar
LEFT JOIN albums AS al
    ON ar.artist_id = al.artist_id
LEFT JOIN tracks AS tr
    ON al.album_id = tr.album_id; 