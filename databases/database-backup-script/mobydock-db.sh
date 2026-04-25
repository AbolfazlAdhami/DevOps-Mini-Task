#!/bin/bash

CONTAINER_NAME="mobydockflask_postgres_1"

DB="mobydock"
DB_USER="mobydock"
DB_PASS="yourpassword"

BACKUP_PATH="${HOME}/${DB}-sql.gz"

docker exec -e PGPASSWORD="${DB_PASS}" "${CONTAINER_NAME}" pg_dump -U "${DB_USER}" "${DB}" | gzip > "${BACKUP_PATH}"
