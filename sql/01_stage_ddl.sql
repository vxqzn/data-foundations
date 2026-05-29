DROP TABLE IF EXISTS stg_insse_turnover;

CREATE TABLE stg_insse_turnover (
    activitati_economie_nationala TEXT,
    clasa_de_marime TEXT,
    macroregiuni TEXT,
    ani TEXT,
    unitate_de_masura TEXT,
    valoare TEXT
);

/*
-- if you're loading from CSV directly

COPY stg_insse_turnover
FROM '(PATH)/data-foundations/sql/insse_turnover_22_24.csv'
DELIMITER ','
CSV HEADER;

*/


/* 
-- if you pre-imported via DBeaver

INSERT INTO stg_insse_turnover
SELECT * FROM insse_turnover;

*/