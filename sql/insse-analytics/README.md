# INSSE County Data Analysis

PostgreSQL star schema and analytical pipeline for Romanian county economic turnover data (2008 to 2024).

---

## English

### Database Schema
Designed as a Dimensional Star Schema to optimize query speeds and maintain clean data integrity:
* **fact_turnover**: Holds numerical turnover metrics, years, and foreign keys.
* **dim_caen**: National industry classification descriptions (CAEN codes).
* **dim_location**: Geographic macroregions and counties.
* **dim_company_size**: Classification categories of company sizes.

### ETL & Sanitization
Raw data contains dirty string inputs (such as ":" or "-" representing missing or confidential data). The ETL script cleans and scales data dynamically:
* Strips non-numeric characters using `REGEXP_REPLACE` and converts empty structures to safe database nulls using `NULLIF`.
* Scales monetary value strings to numeric RON values based on scale units (Thousands, Millions, Billions).

### Performance Optimization (EXPLAIN ANALYZE)
A composite index was applied to the fact table: `CREATE INDEX idx_facts ON fact_turnover(location_key, size_key, caen_key, an)`.

| Metric | Pre-Index Scan | Post-Index Scan | Change (%) |
| :--- | :--- | :--- | :--- |
| **Execution Time** | 7.619 ms | 2.401 ms | -68.4% |
| **Shared Buffer Hits** | 10,825 | 2,587 | -76.1% |
| **Scan Type** | Sequential Scan (fact_turnover) | Bitmap Index Scan (idx_facts) | Optimized |

### Reference Logs and Export Results
* Raw Pre-Index Execution Plan: [h_query_pre_index.txt](results/h_query_pre_index.txt)
* Raw Post-Index Execution Plan: [h_query_post_index.txt](results/h_query_post_index.txt)
* Top 5 Counties by Turnover: [top_5_counties.csv](results/top_5_counties.csv)
* YoY Growth and National Market Share Rank: [market_share_yoy.csv](results/market_share_yoy.csv)
* Heavy Query Execution Results: [heavy_query_results.csv](results/heavy_query_results.csv)

### Local DBeaver Import Guide
To replicate the analytics and run the SQL scripts locally:
1. Connect DBeaver to your local PostgreSQL instance and create a database named `insse_analytics`.
2. Right-click the schema Tables folder, select **Import Data**, and choose the raw CSV file [insse_turnover.csv](insse_turnover.csv).
3. Set the target table name to `insse_turnover` and complete the import wizard.
4. Execute the SQL scripts in chronological order:
   * `01_stage_ddl.sql`: Creates the staging structure and loads records from DBeaver's import.
   * `02_dimensional_ddl.sql`: Defines the fact, dimension tables, primary/foreign keys, and indexes.
   * `03_etl_load.sql`: Runs the safe-cast cleaning transformations and inserts records into the star schema.
   * `04_analytics_ranking.sql`: Contains the CTE and Window Function analytical queries.

---

## Romana

### Schema Bazei de Date
Proiectata ca o schema dimensionala de tip Star pentru optimizarea vitezei de interogare:
* **fact_turnover**: Contine valorile numerice ale cifrei de afaceri, anii si cheile externe.
* **dim_caen**: Clasificarea activitatilor din economia nationala (coduri CAEN).
* **dim_location**: Macroregiuni si judete.
* **dim_company_size**: Clasele de marime ale intreprinderilor.

### ETL si Sanitizare
Datele brute contin caractere non-numerice (cum ar fi ":" sau "-" reprezentand date lipsa sau confidentiale). Scriptul ETL curata si scaleaza datele automat:
* Elimina caracterele non-numerice folosind `REGEXP_REPLACE` si converteste sirurile goale in null-uri sigure folosind `NULLIF`.
* Scaleaza valorile monetare in RON pe baza unitatii de masura (Mii, Milioane, Miliarde).

### Optimizarea Performantei (EXPLAIN ANALYZE)
A fost aplicat un index compus pe tabela de facte: `CREATE INDEX idx_facts ON fact_turnover(location_key, size_key, caen_key, an)`.

| Metrica | Pre-Index | Post-Index | Diferenta (%) |
| :--- | :--- | :--- | :--- |
| **Timp de Executie** | 7.619 ms | 2.401 ms | -68.4% |
| **Shared Buffer Hits** | 10,825 | 2,587 | -76.1% |
| **Tip Scanare** | Scanare Secventiala (fact_turnover) | Scanare Index Bitmap (idx_facts) | Optimizat |

### Fisiere de Log si Rezultate Exportate
* Plan de Executie Pre-Index (Raw Log): [h_query_pre_index.txt](results/h_query_pre_index.txt)
* Plan de Executie Post-Index (Raw Log): [h_query_post_index.txt](results/h_query_post_index.txt)
* Top 5 Judete dupa Cifra de Afaceri: [top_5_counties.csv](results/top_5_counties.csv)
* Cresterea YoY si Cota de Piata Nationala: [market_share_yoy.csv](results/market_share_yoy.csv)
* Rezultatele Interogarii Complexe: [heavy_query_results.csv](results/heavy_query_results.csv)

### Ghid de Import local in DBeaver
Pentru a rula interogarile si scripturile SQL local:
1. Conectati DBeaver la o instanta locala de PostgreSQL si creati o baza de date numita `insse_analytics`.
2. Dati click-dreapta pe folderul Tables al schemei, selectati **Import Data** si alegeti fisierul CSV brut [insse_turnover.csv](insse_turnover.csv).
3. Configurati numele tabelei tinta ca `insse_turnover` si finalizati asistentul de import.
4. Executati scripturile SQL in ordine cronologica:
   * `01_stage_ddl.sql`: Creeaza structura de staging si incarca inregistrarile din importul initial.
   * `02_dimensional_ddl.sql`: Defineste tabelele de facte si dimensiuni, cheile primare/externe si indecsii.
   * `03_etl_load.sql`: Ruleaza transformarile de curatare si incarca inregistrarile in schema star.
   * `04_analytics_ranking.sql`: Contine interogarile analitice cu CTE-uri complexe si Functii Fereastra.
