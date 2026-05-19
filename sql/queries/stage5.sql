users (user_id, username, signup_date)
streams (stream_id, user_id, minutes_played, stream_date)

WITH heavy_listeners AS (
    SELECT
        user_id,
        SUM(minutes_played) AS total_minutes
    FROM streams AS s
    GROUP BY user_id
    HAVING SUM(minutes_played) > 5000
)

SELECT username, signup_date
FROM heavy_listeners AS hl
INNER JOIN users AS u
    ON hl.user_id = u.user_id


returns (return_id, warehouse_id, item_value)
warehouses (warehouse_id, region, manager_id)
managers (manager_id, manager_name)

WITH heavy_returns AS (
    SELECT
        warehouse_id,
        COUNT(*) AS total_returns,
        SUM(item_value) AS total_item_value
    FROM returns
    GROUP BY warehouse_id
    HAVING COUNT(*) > 500
), east_bleeding_warehouses AS (
    SELECT
        manager_id,
        (hr.total_item_value / hr.total_returns) AS avg_value_per_return
    FROM heavy_returns AS hr
    INNER JOIN warehouses AS wh
        ON hr.warehouse_id = wh.warehouse_id
    WHERE region LIKE 'East'
        AND (hr.total_item_value / hr.total_returns) > 100
)

SELECT
    manager_name,
    avg_value_per_return
FROM managers AS mg
INNER JOIN east_bleeding_warehouses AS ebw
    ON mg.manager_id = ebw.manager_id;


users (user_id, username, referrer_id)

WITH RECURSIVE referral_chain AS (
    SELECT user_id, referrer_id, 1 AS generation
    FROM users
    WHERE user_id = 505

    UNION ALL

    SELECT u.user_id, u.referrer_id, rc.generation + 1
    FROM users AS u
    INNER JOIN referral_chain AS rc
        ON u.user_id = rc.referrer_id
)

SELECT *
FROM referral_chain;


employees (employee_id, employee_name, department, salary)

SELECT
    employee_name,
    department,
    SUM(salary) OVER() AS total_payroll
FROM employees;


bookings (booking_id, hotel_id, room_type, price)

SELECT
    booking_id,
    room_type,
    price,
    AVG(price) OVER(PARTITION BY(room_type)) AS avg_price
FROM bookings;


transactions (transaction_id, account_id, amount, transaction_time)

SELECT
    transaction_id,
    amount,
    transaction_time,
    SUM(amount) OVER(ORDER BY transaction_time) AS running_balance
FROM transactions
WHERE account_id = 789
ORDER BY transaction_time;

songs (song_id, title, genre, streams)

SELECT
    title,
    genre,
    streams,
    DENSE_RANK() OVER (PARTITION BY GENRE ORDER BY streams DESC) AS genre_rank 
FROM songs;

trips (trip_id, zone_id, fare_amount, completion_time)


SELECT
    trip_id,
    fare_amount,
    completion_time,
    COALESCE(LAG(fare_amount), 0) OVER (ORDER BY completion_time) AS previous_fare
FROM trips
WHERE zone_id = 42
ORDER BY completion_time;


crypto_ticks (tick_id, symbol, price, tick_time)

SELECT
    tick_time,
    price,
    FIRST_VALUE(price) OVER (ORDER BY tick_time) AS open_price,
    LAST_VALUE(price) OVER (
        ORDER BY tick_time
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS closing_price
FROM crypto_ticks
WHERE symbol = 'BTC'
ORDER BY tick_time;


user_spending (user_id, state, total_spent)

WITH mycte AS (
    SELECT
        state,
        user_id,
        total_spent,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY total_spent DESC) AS rank
    FROM user_spending
)

SELECT
    state, user_id, total_spent
FROM mycte
WHERE rank = 1;