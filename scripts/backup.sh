#!/usr/bin/env bash
# =====================================================================
# ILE — daily database backup
# Creates a gzipped pg_dump and prunes backups older than retention.
# =====================================================================
set -euo pipefail

BACKUP_DIR="/backups"
PGHOST="${POSTGRES_HOST:-postgres}"
PGUSER="${POSTGRES_USER:-ile_admin}"
PGDB="${POSTGRES_DB:-ile}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
BACKUP_FILE="${BACKUP_DIR}/ile_${TIMESTAMP}.sql.gz"

mkdir -p "${BACKUP_DIR}"

echo "[backup] Dumping ${PGDB} from ${PGHOST} ..."
pg_dump -h "${PGHOST}" -U "${PGUSER}" -d "${PGDB}" --no-owner --no-privileges \
  | gzip > "${BACKUP_FILE}"

# Retention cleanup
find "${BACKUP_DIR}" -type f -name "*.sql.gz" -mtime "+${RETENTION_DAYS}" -delete

echo "[backup] Created ${BACKUP_FILE}"
echo "[backup] Retention: ${RETENTION_DAYS} days"
