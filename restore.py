import os

def main():
    backup = "pelican-local-env-db-2025-04-29T11-14-01.backup"

    os.system('kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = \'pelican_db\';" -c "drop database pelican_db" -U postgres')
    os.system('kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -c "create database pelican_db" -U postgres')
    os.system(f'kubectl cp {backup} postgresql-0:tmp/pelican.backup -n local')
    os.system('kubectl exec postgresql-0 -n local -- env PGPASSWORD=admin psql -U postgres -d pelican_db -f tmp/pelican.backup')


if __name__ == "__main__":
    main()