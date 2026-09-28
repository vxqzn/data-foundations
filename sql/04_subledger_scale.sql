SELECT setseed(0.64);

DROP TABLE IF EXISTS fact_firm_turnover CASCADE;

CREATE UNLOGGED TABLE fact_firm_turnover (
    firm_id BIGINT GENERATED ALWAYS AS IDENTITY,
    an INT NOT NULL,
    caen_key INT NOT NULL,
    size_key INT NOT NULL,
    location_key INT NOT NULL,
    valoare_ron NUMERIC(15, 2) NOT NULL,
    cui VARCHAR(16) NOT NULL
);

DO $$ DECLARE v_year INT;
BEGIN
    FOR v_year IN 2008..2024 LOOP
        RAISE NOTICE 'generating for: %', v_year;

        INSERT INTO fact_firm_turnover (an, caen_key, size_key, location_key, valoare_ron, cui)
        WITH macro_slices AS (
            SELECT
                an,
                caen_key,
                size_key,
                location_key,
                valoare_ron,
                SUM (valoare_ron) OVER() AS annual_total,
                GREATEST(1, ROUND(3764706 * (valoare_ron / SUM(valoare_ron) OVER())))::INT AS slice_firms
            FROM fact_turnover
            WHERE an = v_year AND valoare_ron > 0
        ),
        row_expansion AS (
            SELECT
                an,
                caen_key,
                size_key,
                location_key,
                valoare_ron AS slice_total,
                annual_total,
                slice_firms,
                g.firm_id,
                POWER(1.0 - RANDOM(), -1.0 / 1.15) AS raw_weight,
                'RO' || LPAD((10000000 + (random() * 89999999)::INT)::TEXT, 8, '0') AS cui
            FROM macro_slices AS ms
            CROSS JOIN LATERAL generate_series(1, ms.slice_firms) AS g(firm_id)
        ),
        weighted_firms AS (
            SELECT
                an,
                caen_key,
                size_key,
                location_key,
                slice_total,
                annual_total,
                slice_firms,
                firm_id,
                cui,
                raw_weight,
                ROUND(slice_total * (raw_weight / SUM(raw_weight) OVER(PARTITION BY an, caen_key, size_key, location_key))::NUMERIC, 2) AS unadjusted_value
            FROM row_expansion
        )
        SELECT
            an,
            caen_key,
            size_key,
            location_key,
            CASE
                WHEN firm_id = slice_firms THEN
                    slice_total - COALESCE(
                        SUM(unadjusted_value) OVER(
                            PARTITION BY caen_key, size_key, location_key
                            ORDER BY firm_id
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ),
                        0
                    )
                ELSE unadjusted_value
            END AS valoare_ron, cui
        FROM weighted_firms;
    END LOOP;
END$$;

ALTER TABLE fact_firm_turnover SET LOGGED;
ANALYZE fact_firm_turnover;