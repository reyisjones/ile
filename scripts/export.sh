#!/usr/bin/env bash
# =====================================================================
# ILE — one-command data export
#
# Exports ALL of your data so you can take it anywhere (data ownership):
#   • Every PostgreSQL table -> CSV  (spreadsheet-friendly)
#   • Every PostgreSQL table -> JSON (machine-friendly)
#   • The Obsidian vault     -> Markdown (copied as-is)
#   • A manifest + README describing the export
#
# Run from the repository root while the stack is up:
#   ./scripts/export.sh
#
# Output: data/exports/ile-export-<timestamp>/  (+ a .tar.gz archive)
#
# Everything stays local. Nothing is uploaded.
# =====================================================================
set -euo pipefail

# ---- Resolve repo root (script may be called from anywhere) ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

# ---- Load .env if present (for POSTGRES_* and VAULT_PATH) ----
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

PGUSER="${POSTGRES_USER:-ile_admin}"
PGDB="${POSTGRES_DB:-ile}"
VAULT_PATH="${VAULT_PATH:-./vault}"
SERVICE="${ILE_DB_SERVICE:-postgres}"

# ---- Detect docker compose command ----
if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
else
  echo "[export] ERROR: docker compose not found. Is Docker installed?" >&2
  exit 1
fi

# ---- Verify the database service is running ----
# (Capture first, then match — avoids SIGPIPE under `set -o pipefail`.)
RUNNING_SERVICES="$("${COMPOSE[@]}" ps --services --filter status=running 2>/dev/null || true)"
case $'\n'"${RUNNING_SERVICES}"$'\n' in
  *$'\n'"${SERVICE}"$'\n'*) : ;;  # running — continue
  *)
    echo "[export] ERROR: the '${SERVICE}' service is not running." >&2
    echo "[export] Start the stack first:  ${COMPOSE[*]} up -d" >&2
    exit 1
    ;;
esac

# psql helper: runs SQL inside the DB container, output to host stdout.
psql_exec() {
  "${COMPOSE[@]}" exec -T "${SERVICE}" \
    psql -U "${PGUSER}" -d "${PGDB}" "$@"
}

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
OUT_DIR="data/exports/ile-export-${TIMESTAMP}"
CSV_DIR="${OUT_DIR}/csv"
JSON_DIR="${OUT_DIR}/json"
VAULT_OUT="${OUT_DIR}/vault"

mkdir -p "${CSV_DIR}" "${JSON_DIR}"

echo "[export] Exporting database '${PGDB}' via service '${SERVICE}' ..."

# ---- Enumerate public tables (portable; no mapfile for bash 3.2) ----
TABLES=()
while IFS= read -r _tbl; do
  [ -n "${_tbl}" ] && TABLES+=("${_tbl}")
done < <(psql_exec -tAc \
  "SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename" \
  | tr -d '\r')

if [ "${#TABLES[@]}" -eq 0 ]; then
  echo "[export] WARNING: no tables found in schema 'public'." >&2
fi

TABLE_COUNT=0
for tbl in "${TABLES[@]}"; do
  [ -n "${tbl}" ] || continue
  echo "  • ${tbl}"
  # CSV (with header)
  psql_exec -c "\copy (SELECT * FROM public.\"${tbl}\") TO STDOUT WITH CSV HEADER" \
    > "${CSV_DIR}/${tbl}.csv"
  # JSON (array of row objects; empty array if no rows)
  psql_exec -tAc \
    "SELECT COALESCE(json_agg(t), '[]'::json) FROM public.\"${tbl}\" t" \
    > "${JSON_DIR}/${tbl}.json"
  TABLE_COUNT=$((TABLE_COUNT + 1))
done

# ---- Copy the Obsidian vault (Markdown notes) ----
NOTE_COUNT=0
if [ -d "${VAULT_PATH}" ]; then
  echo "[export] Copying vault from '${VAULT_PATH}' ..."
  mkdir -p "${VAULT_OUT}"
  # Copy everything except Obsidian workspace/cache cruft.
  rsync -a \
    --exclude '.obsidian/workspace*.json' \
    --exclude '.obsidian/cache/' \
    --exclude '.trash/' \
    "${VAULT_PATH}/" "${VAULT_OUT}/" 2>/dev/null \
    || cp -R "${VAULT_PATH}/." "${VAULT_OUT}/"
  NOTE_COUNT="$(find "${VAULT_OUT}" -type f -name '*.md' | wc -l | tr -d ' ')"
else
  echo "[export] NOTE: vault path '${VAULT_PATH}' not found — skipping notes."
fi

# ---- Write a manifest + README ----
cat > "${OUT_DIR}/manifest.json" <<JSON
{
  "export_timestamp": "${TIMESTAMP}",
  "database": "${PGDB}",
  "tables_exported": ${TABLE_COUNT},
  "markdown_notes": ${NOTE_COUNT},
  "formats": ["csv", "json", "markdown"]
}
JSON

cat > "${OUT_DIR}/README.md" <<MD
# ILE Data Export — ${TIMESTAMP}

This is a complete, portable copy of your ILE data. It is yours to keep,
move, or import elsewhere.

## Contents
- \`csv/\`   — one CSV per database table (spreadsheet-friendly).
- \`json/\`  — one JSON array per database table (machine-friendly).
- \`vault/\` — your Obsidian notes (Markdown), copied as-is.
- \`manifest.json\` — summary of what was exported.

## Summary
- Tables exported: ${TABLE_COUNT}
- Markdown notes:  ${NOTE_COUNT}

## Notes
- Generated locally by \`scripts/export.sh\`. Nothing was uploaded.
- To restore the database from a full backup instead, see
  \`scripts/restore.sh\` and \`docs/20-Incident-Response-and-DR.md\`.
MD

# ---- Package into a tar.gz for easy sharing/archiving ----
ARCHIVE="data/exports/ile-export-${TIMESTAMP}.tar.gz"
tar -czf "${ARCHIVE}" -C "data/exports" "ile-export-${TIMESTAMP}"

echo ""
echo "[export] Done."
echo "[export]   Folder:  ${OUT_DIR}"
echo "[export]   Archive: ${ARCHIVE}"
echo "[export]   Tables:  ${TABLE_COUNT}   Notes: ${NOTE_COUNT}"
echo "[export] Tip: copy the archive to encrypted storage (3-2-1 backups)."
