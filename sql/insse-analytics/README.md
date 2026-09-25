# INSSE Analytics Module

> [!NOTE]
> The primary technical documentation, dimensional star schema specifications, and `-68.4%` `EXPLAIN ANALYZE` optimization benchmarks are located on the main repository landing page: **[data-foundations README.md](../../README.md)**.

---

## Directory Contents & Script Sequence

Execute the SQL scripts chronologically against a local PostgreSQL database (`insse_analytics`):

1. **[`01_stage_ddl.sql`](01_stage_ddl.sql)**: Defines the raw staging table (`stg_insse_turnover`) for importing `insse_turnover.csv`.
2. **[`02_dimensional_ddl.sql`](02_dimensional_ddl.sql)**: Defines the Dimensional Star Schema (`fact_turnover`, `dim_caen`, `dim_company_size`, `dim_location`) and the composite B-tree index (`idx_facts`).
3. **[`03_etl_load.sql`](03_etl_load.sql)**: Automated ETL pipeline executing regex token stripping (`REGEXP_REPLACE`), sentinel nullification (`NULLIF`), dynamic scale unit conversion (Thousands, Millions, Billions $\to$ base RON), and surrogate key population.
4. **[`04_analytics_ranking.sql`](04_analytics_ranking.sql)**: Contains national concentration queries (Top 5 counties), multi-level CTEs for YoY percentage growth and partitioned market share, and the `EXPLAIN ANALYZE` running-total stress test.

## Benchmark Logs & Export Artifacts

* **Execution Plan Logs:** Pre-index plan ([`results/h_query_pre_index.txt`](results/h_query_pre_index.txt)) vs. Post-index plan ([`results/h_query_post_index.txt`](results/h_query_post_index.txt)).
* **Analytical Datasets:**
  * National concentration: [`results/top_5_counties.csv`](results/top_5_counties.csv)
  * Longitudinal YoY market share (1,002 rows): [`results/market_share_yoy.csv`](results/market_share_yoy.csv)
  * Stress-test running total output (108 rows): [`results/heavy_query_results.csv`](results/heavy_query_results.csv)
