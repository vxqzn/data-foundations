INSERT INTO dim_caen(caen_description)
SELECT DISTINCT activitati_economie_nationala
FROM stg_insse_turnover
WHERE activitati_economie_nationala IS NOT NULL;

INSERT INTO dim_company_size(size_description)
SELECT DISTINCT clasa_de_marime
FROM stg_insse_turnover
WHERE clasa_de_marime IS NOT NULL;

INSERT INTO dim_location(location_name)
SELECT DISTINCT macroregiuni
FROM stg_insse_turnover
WHERE macroregiuni IS NOT NULL;

INSERT INTO fact_turnover(caen_key, size_key, location_key, an, valoare_ron)
SELECT
    c.caen_key,
    s.size_key,
    l.location_key,
    REPLACE(stg.ani, 'Anul ', '')::INT AS an,
    CASE 
        WHEN stg.unitate_de_masura ILIKE '%Miliarde%' THEN (NULLIF(REGEXP_REPLACE(stg.valoare, '[^0-9.]', '', 'g'), '')::NUMERIC * 1000000000) 
        WHEN stg.unitate_de_masura ILIKE '%Milioane%' THEN (NULLIF(REGEXP_REPLACE(stg.valoare, '[^0-9.]', '', 'g'), '')::NUMERIC * 1000000)
        WHEN stg.unitate_de_masura ILIKE '%Mii%' THEN (NULLIF(REGEXP_REPLACE(stg.valoare, '[^0-9.]', '', 'g'), '')::NUMERIC * 1000)
        ELSE NULLIF(REGEXP_REPLACE(stg.valoare, '[^0-9.]', '', 'g'), '')::NUMERIC
    END AS valoare_ron
FROM stg_insse_turnover AS stg
INNER JOIN dim_caen AS c
    ON stg.activitati_economie_nationala = c.caen_description
INNER JOIN dim_company_size AS s
    ON stg.clasa_de_marime = s.size_description
INNER JOIN dim_location AS l
    ON stg.macroregiuni = l.location_name;
