DROP TABLE IF EXISTS stg_insse_turnover;

CREATE TABLE stg_insse_turnover (
    activitati_economie_nationala TEXT,
    clasa_de_marime TEXT,
    macroregiuni TEXT,
    ani TEXT,
    unitate_de_masura TEXT,
    valoare TEXT
);


-- After importing "insse_turnover_22_24.csv" into a "insse_turnover" DBeaver table
INSERT INTO stg_insse_turnover
SELECT * FROM insse_turnover;
