# ILE — IKIGAI Learning Engine

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Code of Conduct](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Local-first](https://img.shields.io/badge/local--first-private%20by%20default-6f42c1.svg)](PRIVACY.md)
[![Status](https://img.shields.io/badge/status-0.1.0%20alpha-orange.svg)](CHANGELOG.md)

> A **local-first Learning Operating System** that unifies Learning Management,
> Knowledge Management, IKIGAI alignment, Career Growth, Interview Preparation,
> Business Development, and Personal Development in one platform.
>
> **Track purpose, not just activity.** Every learning action links to one of the
> four IKIGAI intersections — Passion, Mission, Profession, Vocation — and is only
> "done" once it passes validation.

```text
Learn → Practice → Validate → Apply → Reflect → Connect to IKIGAI
```

---

## Why ILE

Most study systems measure *hours studied*. ILE measures **improvement, output,
and purpose**: confidence gains, validated mastery, spaced-repetition retention,
interview readiness, and IKIGAI alignment — all stored locally and private by
default.

## What's in this repo

| Path | Purpose |
|---|---|
| `docker-compose.yml` | Local stack: Postgres, API, Metabase, backups (+ optional AI, automation). |
| `api/` | FastAPI backend (topics, sessions, XP, validation, interview, retention, AI, analytics). |
| `database/init/` | Schema (`001`), analytics views (`002`), seed (`003`). |
| `scripts/` | `backup.sh`, `restore.sh`, `cleanup-backups.sh`. |
| `vault/` | Obsidian vault (primary knowledge repository) + templates. |
| `docs/` | Full documentation set — start at [`docs/00-Index.md`](docs/00-Index.md). |
| `data/` | Runtime volumes (gitignored). |

## Architecture at a glance

- **PostgreSQL 16** — system of record (UUID keys, `user_id` on every row → SaaS-ready).
- **FastAPI** — domain logic + REST; SM-2 retention engine; local-LLM client.
- **Metabase** — dashboards over SQL views.
- **Obsidian** — notes, reflections, MOCs, knowledge graph view.
- **Ollama** *(optional)* — local AI coach, quiz, summarize, interview.
- **n8n** *(optional)* — reminders, weekly summaries, backup checks.

See [`docs/02-System-Architecture.md`](docs/02-System-Architecture.md).

---

## Quick start

**Prerequisites:** Docker Desktop (or Docker Engine + Compose).

```bash
# 1. Configure secrets
cp .env.example .env
# edit .env → set POSTGRES_PASSWORD and API_SECRET_KEY

# 2. Start the core stack
docker compose up -d

# 3. Check services
docker compose ps

# 4. Open the tools
#    API docs   → http://localhost:8000/docs
#    Metabase   → http://localhost:3000
```

Connect Metabase → PostgreSQL:
```text
Host: postgres   Port: 5432   Database: ile
User: ile_admin  Password: (your .env value)
```

Open the **Obsidian vault** at `./vault`.

### Optional profiles
```bash
docker compose --profile ai up -d                       # + local LLM (Ollama)
docker compose --profile ai --profile automation up -d  # + n8n
# Pull models once Ollama is running:
docker exec -it ile-ollama ollama pull llama3.1:8b
docker exec -it ile-ollama ollama pull nomic-embed-text
```

---

## First actions (try the loop)

```bash
# Create a topic (single-user mode needs no auth)
curl -s http://localhost:8000/topics -H 'Content-Type: application/json' \
  -d '{"title":"Agentic AI","category":"AI","status":"Learning","priority":2}'

# Log a study session
curl -s http://localhost:8000/sessions -H 'Content-Type: application/json' \
  -d '{"duration_minutes":60,"session_type":"Lab","confidence_before":2,"confidence_after":4}'

# Award XP for a lab
curl -s http://localhost:8000/xp/events -H 'Content-Type: application/json' \
  -d '{"activity":"Lab"}'

# See analytics
curl -s http://localhost:8000/analytics/learning-roi
```

Then build the **Learning Command Center** dashboard in Metabase
(see [`docs/05-UI-UX-and-Dashboards.md`](docs/05-UI-UX-and-Dashboards.md)).

---

## Backups

- Automatic daily `pg_dump` → `data/backups/`, gzipped, 30-day retention.
- Restore:
  ```bash
  docker exec -it ile-backup /scripts/restore.sh \
    /backups/ile_YYYY-MM-DD_HH-MM-SS.sql.gz
  ```
- For durability, copy `data/backups/` to an encrypted external drive / private cloud (3-2-1).

---

## Privacy & security

Local-first and private by default: no telemetry, no cloud dependency. Secrets
live only in `.env` (gitignored). All SQL is parameterized. Multi-user mode adds
JWT auth and is ready for Postgres Row-Level Security via the `user_id` on every
owned row. Details in [`docs/02-System-Architecture.md`](docs/02-System-Architecture.md#5-security--privacy).

---

## Roadmap

- **Phase 1 — Foundation (MVP):** this repo — personal Learning OS, interview-first.
- **Phase 2 — Intelligence & UX:** local AI, web SPA, knowledge graph, automation.
- **Phase 3 — Scale & SaaS:** multi-user, RBAC/RLS, managed infra, billing.

Full plan: [`docs/08-Roadmap-and-Risk.md`](docs/08-Roadmap-and-Risk.md).

---

## Documentation

Start at [`docs/00-Index.md`](docs/00-Index.md) for the complete PRD,
architecture, database, API, UI/UX, subsystems, workflows, and roadmap.

Open-source, security, and community docs: [Open Source Strategy](docs/11-Open-Source-Strategy.md),
[Licensing Guide](docs/12-Licensing-Guide.md), [Security Architecture](docs/14-Security-Architecture.md),
[Threat Model](docs/15-Threat-Model.md), [Deployment Guide](docs/23-Deployment-Guide.md).

---

## Open source & community

ILE is open source under the **[Apache License 2.0](LICENSE)**. Contributions are
welcome under the **Developer Certificate of Origin** (`git commit -s`).

| | |
|---|---|
| 📜 License | [LICENSE](LICENSE) · [NOTICE](NOTICE) · [Licensing Guide](docs/12-Licensing-Guide.md) |
| 🤝 Contributing | [CONTRIBUTING.md](CONTRIBUTING.md) · [Community Playbook](docs/16-Community-Playbook.md) |
| 🧭 Governance | [GOVERNANCE.md](GOVERNANCE.md) · [Code of Conduct](CODE_OF_CONDUCT.md) |
| 🔒 Security | [SECURITY.md](SECURITY.md) · [Supported Versions](SUPPORTED_VERSIONS.md) |
| 🕵️ Privacy | [PRIVACY.md](PRIVACY.md) · [Privacy Impact Assessment](docs/13-Privacy-Impact-Assessment.md) |
| ⚖️ Terms | [TERMS.md](TERMS.md) · [Legal & Compliance](docs/22-Legal-and-Compliance-Assessment.md) |
| 🗺️ Roadmap | [ROADMAP.md](ROADMAP.md) · [CHANGELOG.md](CHANGELOG.md) |
| 🔌 Plugins | [Plugin Development Guide](docs/17-Plugin-Development-Guide.md) |

**Reporting a vulnerability?** Do **not** open a public issue — see
[SECURITY.md](SECURITY.md).

---

## License

Apache License 2.0 — see [LICENSE](LICENSE). © 2026 TECHTARIS LLC and the ILE
contributors. You own 100% of the content you create in your instance.
