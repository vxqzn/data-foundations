DROP TABLE IF EXISTS fact_turnover CASCADE;
DROP TABLE IF EXISTS dim_caen CASCADE;
DROP TABLE IF EXISTS dim_company_size CASCADE;
DROP TABLE IF EXISTS dim_location CASCADE;
DROP INDEX IF EXISTS idx_facts;
DROP INDEX IF EXISTS idx_location;

CREATE TABLE dim_caen (
    caen_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    caen_description TEXT NOT NULL
);

CREATE TABLE dim_company_size (
    size_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    size_description TEXT NOT NULL
);

CREATE TABLE dim_location (
    location_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_name TEXT NOT NULL
);

CREATE TABLE fact_turnover (
    caen_key INT NOT NULL REFERENCES dim_caen(caen_key),
    size_key INT NOT NULL REFERENCES dim_company_size(size_key),
    location_key INT NOT NULL REFERENCES dim_location(location_key),
    an INT NOT NULL ,
    valoare_ron NUMERIC(15, 2) NOT NULL,
    CONSTRAINT pk_fact_turnover PRIMARY KEY (caen_key, size_key, location_key, an)
);

CREATE INDEX idx_facts ON fact_turnover(caen_key, an, location_key, size_key);
CREATE INDEX idx_location ON dim_location(location_name);