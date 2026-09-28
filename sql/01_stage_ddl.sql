DROP TABLE IF EXISTS stg_insse_turnover CASCADE;

CREATE TABLE stg_insse_turnover (
    activitati_economie_nationala TEXT,
    clasa_de_marime TEXT,
    macroregiuni TEXT,
    ani TEXT,
    unitate_de_masura TEXT,
    valoare TEXT
);

\copy stg_insse_turnover FROM '/data/insse_turnover.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');