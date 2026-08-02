# Contributing to ILE — IKIGAI Learning Engine

Thank you for your interest in contributing! ILE is a **local-first Learning
Operating System**. This guide explains how to propose changes, our standards,
and the contribution workflow.

By participating you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

---

## Table of contents
- [Ways to contribute](#ways-to-contribute)
- [Project principles](#project-principles)
- [Development environment](#development-environment)
- [Contribution workflow](#contribution-workflow)
- [Developer Certificate of Origin (DCO)](#developer-certificate-of-origin-dco)
- [Coding standards](#coding-standards)
- [Commit & PR conventions](#commit--pr-conventions)
- [Tests & CI](#tests--ci)
- [Security issues](#security-issues)
- [RFCs for larger changes](#rfcs-for-larger-changes)
- [License of contributions](#license-of-contributions)

---

## Ways to contribute
- Report bugs and file well-scoped feature requests (use the issue templates).
- Improve documentation (docs are first-class — small PRs welcome).
- Add tests, fix bugs, or implement roadmap items labeled `good first issue` / `help wanted`.
- Build **plugins** (see [docs/17-Plugin-Development-Guide.md](docs/17-Plugin-Development-Guide.md)).
- Propose designs via the [RFC process](#rfcs-for-larger-changes).

## Project principles
Contributions should respect the core design values (see
[docs/01-Product-Requirements-Document.md](docs/01-Product-Requirements-Document.md)):

1. **Local-first & private by default** — no mandatory cloud, no telemetry.
2. **Purpose over activity** — features tie back to IKIGAI/validation, not vanity metrics.
3. **Simple MVP, extensible core** — prefer small, composable changes.
4. **Separation of domains** — Learning / Business / Personal stay distinct.
5. **User owns their data** — always support export and deletion.

## Development environment

Prerequisites: Docker Desktop (or Docker Engine + Compose), Python 3.12 for
local API work.

```bash
git clone https://github.com/techtaris/ile.git
cd ile
cp .env.example .env          # set POSTGRES_PASSWORD and API_SECRET_KEY

# Full stack
docker compose up -d
#   API docs → http://localhost:8000/docs
#   Metabase → http://localhost:3000

# API-only local dev (against the compose Postgres)
cd api
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Validate database changes against a throwaway container before opening a PR:
```bash
docker run --rm -e POSTGRES_PASSWORD=test -e POSTGRES_DB=ile \
  -e POSTGRES_USER=ile_admin -d --name ile-sqltest \
  -v "$PWD/database/init:/docker-entrypoint-initdb.d:ro" postgres:16
```

## Contribution workflow

1. **Search first** — check existing issues/PRs to avoid duplication.
2. **Open an issue** describing the problem or proposal (skip for trivial fixes).
3. **Fork & branch** from `main`:
   - `feat/<short-name>`, `fix/<short-name>`, `docs/<short-name>`, `chore/<short-name>`.
4. **Make focused changes.** One logical change per PR. Update docs and tests.
5. **Run checks locally** (lint, tests, SQL validation).
6. **Sign your commits** (DCO — see below).
7. **Open a Pull Request** using the PR template; link the issue (`Closes #123`).
8. **Review** — a maintainer reviews; address feedback; keep the branch rebased on `main`.
9. **Merge** — maintainers use *squash merge* with a Conventional Commit title.

## Developer Certificate of Origin (DCO)

ILE uses the [DCO](https://developercertificate.org/) instead of a CLA. Every
commit must be signed off, certifying you have the right to submit it under the
project license:

```bash
git commit -s -m "feat: add retention grade endpoint"
```

This appends a `Signed-off-by: Your Name <you@example.com>` trailer. PRs with
unsigned commits will be asked to amend.

## Coding standards

**Python (API):**
- Target Python 3.12; use type hints and Pydantic models at boundaries.
- Format with **ruff format**; lint with **ruff**. Keep functions small and pure where possible.
- All SQL must be parameterized (no string interpolation).
- Every user-owned query filters by `user_id`.

**SQL (database):**
- Additive migrations; never edit an applied migration.
- Use `CHECK` constraints and FKs; document new tables in
  [docs/03-Database-Design.md](docs/03-Database-Design.md).

**Docs:**
- Markdown, wrapped ~90 cols, relative links, no secrets in examples.

## Commit & PR conventions

Use [Conventional Commits](https://www.conventionalcommits.org/):
`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `perf:`, `ci:`, `build:`.

PRs should:
- Have a clear title and description (what/why, not just how).
- Reference issues and note breaking changes (`BREAKING CHANGE:` footer).
- Include screenshots for UI changes and sample requests for API changes.

## Tests & CI

- Add/extend tests for behavior changes (pytest for the API — introduced in Phase 2).
- CI runs lint, tests, SQL init validation, and dependency/secret scanning.
- Do not merge with a red pipeline.

## Security issues

**Do not open public issues for vulnerabilities.** Follow
[SECURITY.md](SECURITY.md) for responsible disclosure.

## RFCs for larger changes

For significant features, schema changes, or architectural shifts, open an
**RFC** first (see the Community Playbook,
[docs/16-Community-Playbook.md](docs/16-Community-Playbook.md#rfc-process)).
This saves everyone effort by aligning on design before implementation.

## License of contributions

Contributions are licensed under **Apache License 2.0** (see [LICENSE](LICENSE)).
You retain copyright to your contributions; the DCO sign-off grants the project
the rights it needs. **Users own all content they create in ILE** — the project
never claims ownership of user notes or generated data.
