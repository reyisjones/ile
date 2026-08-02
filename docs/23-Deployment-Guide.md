# 23 — Deployment Guide

How to run, operate, and upgrade ILE. Focused on the default **Docker Compose**
deployment. Pairs with [14-Security-Architecture.md](14-Security-Architecture.md)
and [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md).

---

## 1. Prerequisites
- **Docker** and **Docker Compose v2**.
- ~2 GB free RAM for core services (more if running the local LLM).
- (Optional) **Obsidian** for editing the notes vault.

## 2. Services & profiles

| Service | Role | Default |
|---|---|---|
| `postgres` | System of record (PostgreSQL 16) | on |
| `api` | FastAPI REST API | on |
| `metabase` | Analytics dashboards | on |
| `backup` | Scheduled `pg_dump` sidecar | on |
| `ollama` | Local LLM (profile `ai`) | opt-in |
| `n8n` | Automation (profile `automation`) | opt-in |

Compose project name: **`ile`** · network: **`ile-net`**.

## 3. First-time setup
```bash
# 1. Configure environment
cp .env.example .env
# edit .env: set POSTGRES_PASSWORD, API/JWT secrets, backup retention, etc.

# 2. Start core services
docker compose -p ile up -d

# 3. (optional) Start with local AI and/or automation
docker compose -p ile --profile ai up -d
docker compose -p ile --profile ai --profile automation up -d
```
Init SQL in `database/init/` is applied alphabetically on first Postgres start
(schema, views, seed data).

### Endpoints (default, localhost)
- API: `http://localhost:8000` (docs at `/docs`).
- Metabase: `http://localhost:3000`.

## 4. Configuration (key env vars)

| Variable | Purpose |
|---|---|
| `POSTGRES_USER` / `POSTGRES_PASSWORD` / `POSTGRES_DB` | Database credentials. |
| `API_SINGLE_USER_MODE` | `true` (default, no auth, localhost only) or `false` (JWT/multi-user). |
| `JWT_SECRET` (multi-user) | Signing key for tokens — strong, random, secret. |
| `OLLAMA_BASE_URL` | Local model endpoint (profile `ai`). |
| `BACKUP_RETENTION_DAYS` | Days to keep dumps (default 30). |

**Never commit `.env`.** It is git-ignored; CI scans for leaked secrets.

## 5. Upgrades
```bash
# 1. Back up first (see doc 20)
#    dump Postgres + back up the vault

# 2. Get the new version
git pull            # or download the release
docker compose -p ile pull

# 3. Apply and restart (migrations run idempotently)
docker compose -p ile up -d

# 4. Verify: API health, row/view counts, a quick smoke test
```
- Read the release notes for **breaking/schema** changes
  ([18-Release-and-Versioning.md](18-Release-and-Versioning.md)).
- **Rollback:** stop the stack, restore the pre-upgrade DB dump, check out the
  previous release tag, `up -d`. See
  [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md#c3-restore-procedure-postgres).

## 6. Backups & recovery
The `backup` sidecar writes dumps to `data/backups/`. Follow **3-2-1** and
encrypt off-device copies. Test restores monthly. Full procedure:
[20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md#part-c--backup--disaster-recovery).

## 7. Production / remote access hardening
Single-user mode is **localhost-only**. To expose ILE beyond your machine:
1. Set `API_SINGLE_USER_MODE=false`; configure JWT + strong secrets.
2. Put ILE behind an **HTTPS reverse proxy** (Caddy/Traefik/Nginx) with TLS 1.3,
   auth, and rate limiting.
3. Do **not** publish the Postgres port; keep it inside `ile-net`.
4. Enable full-disk encryption and Postgres RLS (multi-user).
5. Restrict/disable Metabase and n8n exposure.

Full checklist: [14-Security-Architecture.md](14-Security-Architecture.md#9-hardening-checklist-for-operators-productionremote).

## 8. Operations
```bash
docker compose -p ile ps                 # status
docker compose -p ile logs -f api        # follow API logs
docker compose -p ile exec postgres \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"   # DB shell
docker compose -p ile down               # stop (keeps volumes)
docker compose -p ile down -v            # stop + DELETE data volumes (careful)
```

## 9. Health & monitoring
- API exposes a health/docs endpoint for smoke checks.
- Monitor container status and disk space (backups grow).
- For remote deployments, add uptime checks at the reverse proxy.

## 10. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| API 503 on AI features | Ollama not running | Start the `ai` profile; check `OLLAMA_BASE_URL`. |
| DB init didn't seed | Volume already existed | Fresh volume, or apply init SQL manually. |
| Can't reach API remotely | Localhost binding / no proxy | Set up reverse proxy + multi-user auth (§7). |
| Metabase can't connect | Wrong DB creds | Match Metabase config to `.env`. |

## 11. Scaling path
The stack is single-host by default but designed to grow: `user_id` on every
owned row and RLS enable multi-tenant SaaS; Postgres can move to a managed
instance; the API scales horizontally behind the proxy. See
[11-Open-Source-Strategy.md](11-Open-Source-Strategy.md) and the
[`ROADMAP.md`](../ROADMAP.md).
