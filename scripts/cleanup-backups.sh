#!/usr/bin/env bash
# =====================================================================
# ILE — manual backup pruning helper
# Removes *.sql.gz older than BACKUP_RETENTION_DAYS (default 30).
# =====================================================================
set -euo pipefail

BACKUP_DIR="${1:-/backups}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"

echo "[cleanup] Pruning backups older than ${RETENTION_DAYS} days in ${BACKUP_DIR}"
find "${BACKUP_DIR}" -type f -name "*.sql.gz" -mtime "+${RETENTION_DAYS}" -print -delete
echo "[cleanup] Done."
