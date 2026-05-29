-- "List of the top 5 counties ranked by total turnover."
SELECT
    dim_location.location_name,
    SUM(fact_turnover.valoare_ron) AS total_value
FROM fact_turnover
INNER JOIN dim_location
    ON fact_turnover.location_key = dim_location.location_key
GROUP BY dim_location.location_name
ORDER BY total_value DESC
LIMIT 5;

-- "Displayed by year sections(2022/2023/2024), of all the counties and relevant data (total value, year on year growth, market share), ranked by growth% and ordered by year on year growth (highest to lowest)."
WITH cte_county_base AS (
    SELECT
        fact_turnover.an AS an,
        dim_location.location_name AS location_name,
        dim_caen.caen_description AS caen_description,
        SUM(valoare_ron) AS total_value
    FROM fact_turnover
    INNER JOIN dim_location
        ON fact_turnover.location_key = dim_location.location_key
    INNER JOIN dim_caen
        ON fact_turnover.caen_key = dim_caen.caen_key
    GROUP BY 
        fact_turnover.an,
        dim_location.location_name,
        dim_caen.caen_description
),
cte_with_lag AS (
    SELECT
        an,
        location_name,
        caen_description,
        total_value,
        LAG(total_value, 1) OVER(
            PARTITION BY location_name, caen_description 
            ORDER BY an
        ) AS prev_value
    FROM cte_county_base
),
cte_yoy_growth AS (
    SELECT
        an,
        location_name,
        caen_description,
        total_value,
        prev_value,
        (total_value - prev_value) / NULLIF(prev_value, 0) AS yoy_growth
    FROM cte_with_lag
),
cte_market_share AS (
    SELECT
        an,
        location_name,
        caen_description,
        total_value,
        yoy_growth,
        SUM(total_value) OVER(PARTITION BY an, caen_description) AS total_national,
        (total_value / NULLIF(SUM(total_value) OVER(PARTITION BY an, caen_description), 0)) * 100 AS market_share_pct
    FROM cte_yoy_growth
)
SELECT
    an,
    location_name,
    caen_description,
    total_value,
    yoy_growth,
    market_share_pct,
    DENSE_RANK() OVER(PARTITION BY an, caen_description ORDER BY yoy_growth DESC) AS growth_rank
FROM cte_market_share;

-- Runs a heavy query on the database, forcing a sequential scan through a large number of rows (to be used as efficiency reference for pre-indexing and post-indexing)
SELECT
    l.location_name,
    c.caen_description,
    f.an,
    f.valoare_ron,
    SUM(f.valoare_ron) OVER(
        PARTITION BY l.location_name, c.caen_description
        ORDER BY f.an
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_turnover
FROM fact_turnover AS f
INNER JOIN dim_location AS l
    ON f.location_key = l.location_key
INNER JOIN dim_caen AS c
    ON f.caen_key = c.caen_key
INNER JOIN dim_company_size AS s
    ON f.size_key = s.size_key
WHERE s.size_description LIKE '%Micro%'
    AND (c.caen_description LIKE '%IT%' OR c.caen_description LIKE '%Constructii%')
    AND l.location_name IN ('Timis', 'Arad', 'Sibiu', 'Alba')
    AND f.an BETWEEN 2022 AND 2024;
