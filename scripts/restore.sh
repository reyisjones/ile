#!/usr/bin/env bash
# =====================================================================
# ILE — restore database from a backup file
# Usage: restore.sh /backups/ile_YYYY-MM-DD_HH-MM-SS.sql.gz
# =====================================================================
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /backups/backup-file.sql.gz"
  exit 1
fi

BACKUP_FILE="$1"
PGHOST="${POSTGRES_HOST:-postgres}"
PGUSER="${POSTGRES_USER:-ile_admin}"
PGDB="${POSTGRES_DB:-ile}"

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "[restore] File not found: ${BACKUP_FILE}"
  exit 1
fi

echo "[restore] Restoring ${BACKUP_FILE} into ${PGDB} ..."
gunzip -c "${BACKUP_FILE}" | psql -h "${PGHOST}" -U "${PGUSER}" -d "${PGDB}"

echo "[restore] Completed from ${BACKUP_FILE}"
