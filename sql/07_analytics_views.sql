-- business insights

-- geographic turnover concentration by economic zone ('08 - '24)
CREATE OR REPLACE VIEW vw_geographic_concentration AS
WITH zone_agg AS (
    SELECT
        ft.an,
        CASE
            WHEN l.location_name IN ('Municipiul Bucuresti', 'Ilfov') THEN 'bucharest_ilfov'
            WHEN l.location_name IN ('Cluj', 'Timis', 'Brasov', 'Iasi', 'Prahova') THEN 'regional_hubs'
            ELSE 'other_regions'
        END AS economic_zone,
        SUM(ft.valoare_ron) AS zone_turnover_ron
    FROM fact_turnover AS ft
    JOIN dim_location AS l 
        ON ft.location_key = l.location_key
    GROUP BY ft.an, economic_zone
)
SELECT
    an,
    economic_zone,
    zone_turnover_ron,
    ROUND(zone_turnover_ron * 100.0 / SUM(zone_turnover_ron) OVER(PARTITION BY an), 2) AS national_share_pct
FROM zone_agg
ORDER BY an DESC, national_share_pct DESC;

-- sector annual change and crisis impact ('08 - '09, '19 - '20 pandemic)
CREATE OR REPLACE VIEW vw_sector_growth_trajectory AS
WITH yearly_sector AS (
    SELECT
        ft.an,
        c.caen_description,
        SUM(ft.valoare_ron) AS turnover_ron
    FROM fact_turnover AS ft
    JOIN dim_caen AS c
        ON ft.caen_key = c.caen_key
    WHERE ft.an IN (2008, 2009, 2019, 2020, 2023, 2024)
    GROUP BY ft.an, c.caen_description
)
SELECT
    curr.an,
    curr.caen_description,
    curr.turnover_ron,
    prev.turnover_ron AS prev_year_turnover_ron,
    ROUND((curr.turnover_ron - prev.turnover_ron) / NULLIF(prev.turnover_ron, 0) * 100.0, 2) AS yoy_growth_pct
FROM yearly_sector AS curr
LEFT JOIN yearly_sector AS prev
    ON curr.caen_description = prev.caen_description
    AND curr.an = prev.an + 1
ORDER BY curr.an DESC, yoy_growth_pct ASC;

-- subledger** turnover distribution (2024)
CREATE OR REPLACE VIEW vw_firm_turnover_distribution AS
WITH firm_percentiles AS (
    SELECT
        valoare_ron,
        ntile(100) OVER (ORDER BY valoare_ron DESC) AS percentile
    FROM fact_firm_turnover
    WHERE an = 2024
)
SELECT
    CASE
        WHEN percentile = 1 THEN 'p99_top_1'
        WHEN percentile BETWEEN 2 AND 20 THEN 'p80_top_20'
        ELSE 'p80_bottom_80'
    END AS firm_tier,
    COUNT(*) AS firm_count,
    SUM(valoare_ron) AS total_turnover_ron,
    ROUND(SUM(valoare_ron) * 100.0 / SUM(SUM(valoare_ron)) OVER(), 2) AS turnover_share_pct
FROM firm_percentiles
GROUP BY 
    CASE
        WHEN percentile = 1 THEN 'p99_top_1'
        WHEN percentile BETWEEN 2 AND 20 THEN 'p80_top_20'
        ELSE 'p80_bottom_80'
    END
ORDER BY total_turnover_ron DESC;