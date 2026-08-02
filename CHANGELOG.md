# Changelog

All notable changes to ILE — IKIGAI Learning Engine are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Open-source publication package: `LICENSE` (Apache-2.0), `NOTICE`,
  `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`, `SECURITY.md`,
  `SUPPORTED_VERSIONS.md`, `PRIVACY.md`, `TERMS.md`, `ROADMAP.md`.
- GitHub community files: issue/PR templates, CI workflow, `CODEOWNERS`, funding.
- Documentation: Open-Source Strategy, Legal & Compliance Assessment, Privacy
  Impact Assessment, Security Architecture, Threat Model, Community Playbook,
  Plugin Development Guide, Licensing Guide, Deployment Guide, Release &
  Versioning, Incident Response & DR, Product Positioning, Publication Checklist.

## [0.1.0] — 2026-08-02

### Added
- Local-first Docker Compose stack: PostgreSQL, FastAPI API, Metabase, backup
  sidecar; optional `ai` (Ollama) and `automation` (n8n) profiles.
- Database: full schema (`001_schema.sql`), analytics views (`002_views.sql`),
  reference + example seed (`003_seed.sql`). Validated against Postgres 16.
- API: topics, study sessions, XP/achievements, validations, interview
  questions, spaced-repetition retention (SM-2), local AI, analytics, health.
- Obsidian vault structure with templates (topic, daily, interview, weekly,
  scorecard) and IKIGAI dimension notes.
- Backup/restore/cleanup scripts with 30-day retention.
- Documentation set (PRD, architecture, database, API, UI/UX, subsystems,
  workflows, roadmap & risk).

[Unreleased]: https://github.com/techtaris/ile/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/techtaris/ile/releases/tag/v0.1.0
