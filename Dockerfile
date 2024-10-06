# Dockerfile.init
FROM postgres:latest

WORKDIR /app
COPY db_backup.sql /app/db_backup.sql

CMD ["sh", "-c", "until pg_isready -h postgres-service -p 5432; do echo 'Waiting for PostgreSQL...'; sleep 2; done; psql -U postgres -d shredder_db -f /app/db_backup.sql"]