# ILE Public Roadmap

This is the community-facing roadmap for **ILE — IKIGAI Learning Engine**. It
complements the detailed engineering plan in
[docs/08-Roadmap-and-Risk.md](docs/08-Roadmap-and-Risk.md). The roadmap is a
direction, not a promise of dates; priorities shift with community feedback.

**North star:** *A Personal Learning Operating System that aligns knowledge,
career growth, business goals, and life purpose through IKIGAI-driven learning
and measurable skill development.*

The **core platform stays open source (Apache 2.0) and local-first, forever.**

---

## Phase 1 — Foundation (Open Source) · MVP

**Goal:** a daily-usable, private, self-hosted Learning OS. **Target: 100 active users.**

- [x] Docker Compose stack (Postgres, API, Metabase, backups)
- [x] Full schema, analytics views, seed data
- [x] FastAPI backend: topics, sessions, XP, validation, interview, retention, analytics
- [x] Obsidian vault + templates
- [x] Local-first, no telemetry, daily backups + restore
- [x] Open-source governance, license, and legal/security docs
- [x] pytest suite + CI (lint, tests, SQL validation, dependency/secret scan)
- [x] SBOM generation in CI
- [x] One-command data export (Markdown/JSON/CSV) — `scripts/export.sh`
- [ ] Metabase starter dashboards shipped as importable JSON
- [ ] Getting-started screencast + docs polish

### Phase 1 — remaining before the 0.1.x milestone closes
- **Metabase starter dashboards (importable JSON).** Ship ready-made dashboards
  (Learning Command Center, Retention, Interview Readiness) as importable files
  built over the existing SQL views in `database/init/002_views.sql`.
- **Getting-started screencast + docs polish.** A short end-to-end walkthrough
  (clone → `docker compose up` → first learning loop) plus README/quick-start
  refinements. The screencast is a manual recording task.

## Phase 2 — Intelligence, UX & Plugins

**Goal:** reduce friction, add leverage. **Target: 500+ users.**

- [ ] Local AI (Ollama): coach, quiz, summarize, extract, mock interview
- [ ] Web SPA (React) covering the daily loop (see wireframes in docs 05)
- [ ] Quiz engine UI; AI quizzes auto-create validations
- [ ] Knowledge graph API + force-directed visualization
- [ ] Goals / Career / Skills / Certifications / Business modules
- [ ] **Plugin architecture** + Plugin Development Guide + first community plugins
- [ ] Community templates & "learning packs"
- [ ] Automation (n8n): reminders, weekly summary, review scheduler, backup checks
- [ ] Optional multi-user auth (JWT) with Postgres RLS
- [ ] Alembic migrations; Metabase app DB on Postgres
- [ ] Observability: Prometheus/Grafana, uptime checks

## Phase 3 — Optional Services & Enterprise (Open Core)

**Goal:** sustainable optional offerings around the open core. **Only after
clear, consistent usage.**

- [ ] **Optional** hosted sync (end-to-end encrypted) — bring-your-own-storage first
- [ ] **Optional** managed AI services
- [ ] Multi-tenant SaaS ("ILE Cloud") with its own privacy policy & consent
- [ ] Team learning analytics, organizational dashboards
- [ ] Enterprise authentication (SSO/OIDC, SCIM), RBAC, audit exports
- [ ] Premium templates / learning packs (core remains free & open)
- [ ] Compliance: SOC 2 readiness, DPAs, data export/delete tooling

> **Open-core promise:** the Core Learning Engine, IKIGAI framework, Obsidian
> integration, PostgreSQL schema, Docker deployment, dashboards, local AI
> integration, and knowledge graph remain open source. Commercial features are
> additive and optional — never achieved by closing the core.

---

## How priorities are set
- Community issues/discussions and 👍 reactions signal demand.
- Larger items go through the [RFC process](docs/16-Community-Playbook.md#rfc-process).
- Maintainers group items into milestones; see GitHub Milestones/Projects.

## Out of scope (kept as plugins/future modules)
Full CRM, finance, project management, and general business tooling. The core
stays focused on **Learning, Knowledge, IKIGAI, Interview Readiness**; everything
else should be a plugin.

## Get involved
Pick a `good first issue`, propose a plugin, or open an RFC. See
[CONTRIBUTING.md](CONTRIBUTING.md).
