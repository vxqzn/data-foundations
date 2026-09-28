DO $$
DECLARE
    v_total_slices INT;
    v_mismatches INT;
    v_max_delta NUMERIC(20, 2);
    v_macro_total NUMERIC(20, 2);
    v_subledger_total NUMERIC(20, 2);
BEGIN
    WITH subledger_summary AS (
        SELECT
            an,
            caen_key,
            size_key,
            location_key,
            SUM(valoare_ron) AS subledger_total
        FROM fact_firm_turnover
        GROUP BY an, caen_key, size_key, location_key
    ),
    slice_summary AS (
        SELECT
            COALESCE(m.an, s.an) AS an,
            COALESCE(m.caen_key, s.caen_key) AS caen_key,
            COALESCE(m.size_key, s.size_key) AS size_key,
            COALESCE(m.location_key, s.location_key) AS location_key,
            COALESCE(m.valoare_ron, 0) AS macro_val,
            COALESCE(s.subledger_total, 0) AS subledger_val,
            ABS(COALESCE(m.valoare_ron, 0) - COALESCE(s.subledger_total, 0)) AS delta
        FROM (
            SELECT *
            FROM fact_turnover
            WHERE valoare_ron > 0
        ) AS m
        FULL OUTER JOIN subledger_summary AS s
            ON m.an = s.an 
            AND m.caen_key = s.caen_key 
            AND m.size_key = s.size_key 
            AND m.location_key = s.location_key
    )
    SELECT
        COUNT(*),
        COUNT(*) FILTER (WHERE delta > 0),
        COALESCE(MAX(delta), 0),
        SUM(macro_val),
        SUM(subledger_val)
    INTO
        v_total_slices,
        v_mismatches,
        v_max_delta,
        v_macro_total,
        v_subledger_total
    FROM slice_summary;

    IF v_mismatches > 0 THEN
        RAISE EXCEPTION 'failed: % mismatches found out of % total slices. max delta: %. macro total: %. subledger total: %',
            v_mismatches, v_total_slices, v_max_delta, v_macro_total, v_subledger_total;
    ELSE
        RAISE NOTICE 'success: all % slices reconciled. macro total: %. subledger total: %',
            v_total_slices, v_macro_total, v_subledger_total;
    END IF;
END $$;