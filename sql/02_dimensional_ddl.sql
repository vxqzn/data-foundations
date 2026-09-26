DROP TABLE IF EXISTS fact_turnover;
DROP TABLE IF EXISTS dim_caen;
DROP TABLE IF EXISTS dim_company_size;
DROP TABLE IF EXISTS dim_location;
DROP INDEX IF EXISTS idx_facts;

CREATE TABLE dim_caen (
    caen_key SERIAL PRIMARY KEY,
    caen_description TEXT
);

CREATE TABLE dim_company_size (
    size_key SERIAL PRIMARY KEY,
    size_description TEXT
);

CREATE TABLE dim_location (
    location_key SERIAL PRIMARY KEY,
    location_name TEXT
);

CREATE TABLE fact_turnover (
    caen_key INT REFERENCES dim_caen(caen_key),
    size_key INT REFERENCES dim_company_size(size_key),
    location_key INT REFERENCES dim_location(location_key),
    an INT,
    valoare_ron NUMERIC,
    CONSTRAINT pk_fact_turnover PRIMARY KEY (caen_key, size_key, location_key, an)
);

CREATE INDEX idx_facts ON fact_turnover(caen_key, an, location_key, size_key);
CREATE INDEX idx_dim_location_name ON dim_location(location_name);