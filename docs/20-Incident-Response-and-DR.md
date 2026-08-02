# 20 — Incident Response & Disaster Recovery

How to respond to security incidents and recover from data loss. Pairs with
[`SECURITY.md`](../SECURITY.md), [14-Security-Architecture.md](14-Security-Architecture.md),
and [15-Threat-Model.md](15-Threat-Model.md).

Two audiences: **project maintainers** (vulnerabilities in ILE) and **operators**
(incidents/outages on their own deployment).

---

## Part A — Security incident response (maintainers)

### A1. Reporting intake
Vulnerabilities are reported privately via **GitHub Security Advisories** or
**security@techtaris.com** (see [`SECURITY.md`](../SECURITY.md)). Do not use
public issues.

### A2. Severity & response SLAs (CVSS-guided)

| Severity | Ack | Fix target |
|---|---|---|
| Critical | 48h | 7 days |
| High | 48h | 14 days |
| Medium | 72h | 30 days |
| Low | 5 days | next release |

### A3. Response process
1. **Triage** — confirm, reproduce, assign severity/CVSS.
2. **Contain** — private advisory branch; no public disclosure yet.
3. **Fix** — patch + regression test; prepare backported fixes for supported
   versions (see [`SUPPORTED_VERSIONS.md`](../SUPPORTED_VERSIONS.md)).
4. **Coordinate** — keep reporter updated; agree disclosure timeline (safe
   harbor honored).
5. **Release** — publish patched release, **GHSA advisory**, CVE if warranted,
   and a [`CHANGELOG.md`](../CHANGELOG.md) `Security` entry.
6. **Post-mortem** — blameless retro; add tests/hardening; update this doc &
   threat model.

### A4. Coordinated disclosure
Default embargo up to **90 days** or until a fix ships, whichever first, adjusted
by severity and active exploitation. Credit reporters unless they opt out.

---

## Part B — Operator incident response

If you run ILE and suspect a breach:
1. **Contain** — take the instance offline / disconnect from the network; stop
   exposing ports.
2. **Preserve** — snapshot logs and the Postgres volume before changes.
3. **Assess** — determine what data was reachable (see data map, doc 13 §3).
4. **Rotate** — change secrets, JWT keys, DB passwords, any external tokens.
5. **Recover** — restore from a known-good backup (Part C).
6. **Notify** — if you're a controller for others' data, follow your legal
   breach-notification duties (GDPR 72h, etc.).
7. **Report upstream** — if the cause is an ILE vulnerability, tell
   security@techtaris.com.

---

## Part C — Backup & disaster recovery

### C1. What's backed up
- **PostgreSQL** — automated `pg_dump` by the backup sidecar to
  `data/backups/`, pruned after `BACKUP_RETENTION_DAYS` (default 30).
- **Obsidian vault** — plain Markdown files on the host; back up with normal
  file backups / git (private repo).
- **Config** — `.env`, compose overrides (store secrets securely, never in a
  public repo).

### C2. Recommended strategy — **3-2-1**
- **3** copies, **2** different media, **1** off-site.
- **Encrypt** any copy that leaves the host.
- Automate and **test restores** — an untested backup is not a backup.

### C3. Restore procedure (Postgres)
```bash
# 1. Stop the API so nothing writes during restore
docker compose -p ile stop api

# 2. Restore the latest dump into the database
gunzip -c data/backups/<latest>.sql.gz \
  | docker compose -p ile exec -T postgres \
      psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

# 3. Restart and verify
docker compose -p ile start api
# smoke-test: hit the API health endpoint and confirm row counts/views
```

### C4. Vault restore
Restore Markdown files from your file backup or git history into the vault path;
ILE reads them directly — no import step required.

### C5. Recovery objectives (targets)

| Metric | Target (self-host) |
|---|---|
| RPO (max data loss) | ≤ 24h (daily backups); lower with more frequent dumps. |
| RTO (time to recover) | ≤ 1h for a single-host restore. |

### C6. DR test cadence
- **Monthly:** restore the latest dump into a throwaway DB and verify table/view
  counts and a few sample rows.
- **After upgrades:** confirm backups still restore against the new schema.
- **Document** each test date/result.

### C7. Continuity notes
- ILE is **stateless except the database and vault** — reprovisioning the app is
  fast; protecting Postgres + vault is what matters.
- Keep infrastructure-as-code (compose files) in version control so the stack can
  be rebuilt anywhere.

---

## Part D — Contacts & references
- Security reports: **security@techtaris.com** / GitHub Security Advisories.
- Privacy: **privacy@techtaris.com** · Legal: **legal@techtaris.com**.
- Related: [`SECURITY.md`](../SECURITY.md), [14](14-Security-Architecture.md),
  [15](15-Threat-Model.md), [13](13-Privacy-Impact-Assessment.md).
