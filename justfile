[windows]
set shell := ["powershell.exe", "-NoLogo", "-Command"]

default:
    @just --list

container:= "insse-warehouse"
db_user := "postgres"
db_name := "insse_dw"

up:
    docker compose up -d
    @echo "waiting for pgsql to be ready..."
    @docker compose exec -T {{container}} sh -c "until pg_isready -U {{db_user}} -d {{db_name}}; do sleep 1; done"

down:
    docker compose down

clean:
    docker compose down -v

hydrate scale="3764706": up
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/01_stage_ddl.sql
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/02_dimensional_ddl.sql
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/03_etl_load.sql
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -c "SET app.scale_firms = '{{scale}}';" -f /scripts/04_subledger_scale.sql

audit:
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/05_reconciliation_audit.sql

bench:
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/06_benchmarks.sql

export-results:
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/07_analytics_views.sql
    docker compose exec -T {{container}} psql -U {{db_user}} -d {{db_name}} -v ON_ERROR_STOP=1 -f /scripts/08_export_results.sql

psql:
    docker compose exec -it {{container}} psql -U {{db_user}} -d {{db_name}}