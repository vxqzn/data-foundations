-- calibrate cost model for nvme storage
SET random_page_cost = 1.1;

-- no index baseline
DROP INDEX IF EXISTS idx_location;
DROP INDEX IF EXISTS idx_subledger_covering;
ANALYZE dim_location;
ANALYZE fact_firm_turnover;

\echo 'Running benchmark: no index baseline'
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    l.location_name,
    c.caen_description,
    sub.an,
    count(*) AS firm_count,
    sum(sub.valoare_ron) AS total_turnover_ron
FROM fact_firm_turnover AS sub
JOIN dim_location AS l
    ON sub.location_key = l.location_key
JOIN dim_caen AS c
    ON sub.caen_key = c.caen_key
WHERE l.location_name IN ('Timis', 'Cluj', 'Bucuresti')
    AND sub.an BETWEEN 2020 AND 2024
    AND c.caen_description ILIKE '%constructii%'
GROUP BY l.location_name, c.caen_description, sub.an
ORDER BY sub.an DESC, total_turnover_ron DESC;

-- index creation
CREATE INDEX IF NOT EXISTS idx_location ON dim_location(location_name);
CREATE INDEX IF NOT EXISTS idx_subledger_covering ON fact_firm_turnover(location_key, caen_key, an) INCLUDE (valoare_ron);

ANALYZE dim_location;
ANALYZE fact_firm_turnover;

-- optimized plan (index only)
\echo 'Running benchmark: optimized plan (index only)'
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    l.location_name,
    c.caen_description,
    sub.an,
    count(*) AS firm_count,
    sum(sub.valoare_ron) AS total_turnover_ron
FROM fact_firm_turnover AS sub
JOIN dim_location AS l
    ON sub.location_key = l.location_key
JOIN dim_caen AS c
    ON sub.caen_key = c.caen_key
WHERE l.location_name IN ('Timis', 'Cluj', 'Bucuresti')
    AND sub.an BETWEEN 2020 AND 2024
    AND c.caen_description ILIKE '%constructii%'
GROUP BY l.location_name, c.caen_description, sub.an
ORDER BY sub.an DESC, total_turnover_ron DESC;