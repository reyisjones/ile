# 19 — Publication Checklist

Final gate before making the ILE repository public. Verifies that licensing,
legal, security, privacy, community, and quality requirements are met.

Legend: **[x]** done · **[ ]** to do (operator/maintainer action).

---

## 1. Licensing & IP
- [x] [`LICENSE`](../LICENSE) — Apache-2.0 full text.
- [x] [`NOTICE`](../NOTICE) — attribution + third-party components.
- [x] [12-Licensing-Guide.md](12-Licensing-Guide.md) — license, DCO, third-party
      compatibility, trademark.
- [x] Copyright notice standardized: "© 2026 TECHTARIS LLC and the ILE contributors".
- [x] Contribution model = **DCO** (no CLA); documented in [`CONTRIBUTING.md`](../CONTRIBUTING.md).
- [ ] (Pre-commercial) Trademark search/registration for "ILE" / "IKIGAI Learning Engine".
      *Deferred: only needed before a commercial launch.*

## 2. Legal & compliance
- [x] [`TERMS.md`](../TERMS.md) — Apache-2.0 software terms, AI disclaimers, **no
      accreditation/certification/employment guarantees**, acceptable use.
- [x] [`PRIVACY.md`](../PRIVACY.md) — local-first, no telemetry, rights, GDPR/CCPA.
- [x] [13-Privacy-Impact-Assessment.md](13-Privacy-Impact-Assessment.md) — DPIA.
- [x] [22-Legal-and-Compliance-Assessment.md](22-Legal-and-Compliance-Assessment.md).
- [ ] Counsel review of TERMS/PRIVACY/trademark **before commercial launch**.
      *Deferred: not required for the free, self-hosted OSS release.*

## 3. Security
- [x] [`SECURITY.md`](../SECURITY.md) — private reporting + disclosure SLAs.
- [x] [`SUPPORTED_VERSIONS.md`](../SUPPORTED_VERSIONS.md).
- [x] [14-Security-Architecture.md](14-Security-Architecture.md).
- [x] [15-Threat-Model.md](15-Threat-Model.md) — STRIDE + OWASP mapping.
- [x] [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md).
- [x] Secure defaults (localhost binding; DB port not published; profiles off).
- [x] CI secret scanning (gitleaks) + image scan (Trivy) + SBOM (Syft SPDX).
- [x] **No secrets in git history** — full-history scan (files + credential
      patterns across all blobs) found nothing; `.env` never committed.
- [x] `.gitignore` excludes `.env`, secrets, local data/backups.

## 4. Community & governance
- [x] [`CODE_OF_CONDUCT.md`](../CODE_OF_CONDUCT.md) — Contributor Covenant 2.1.
- [x] [`CONTRIBUTING.md`](../CONTRIBUTING.md).
- [x] [`GOVERNANCE.md`](../GOVERNANCE.md).
- [x] [16-Community-Playbook.md](16-Community-Playbook.md) — incl. [RFC process](16-Community-Playbook.md#rfc-process).
- [x] [17-Plugin-Development-Guide.md](17-Plugin-Development-Guide.md).
- [x] `.github/ISSUE_TEMPLATE/*` (bug, feature, config).
- [x] `.github/PULL_REQUEST_TEMPLATE.md`.
- [x] `.github/CODEOWNERS`.
- [x] `.github/FUNDING.yml`.
- [x] CODEOWNERS/FUNDING point at the current maintainer (`@reyisjones`).
      *Replace with `@org/team` handles once a GitHub org exists.*
- [x] Enable GitHub Discussions + Security Advisories (private vulnerability
      reporting) in repo settings.

## 5. Documentation
- [x] [`README.md`](../README.md) with quick start, badges, and community links.
- [x] [00-Index.md](00-Index.md) lists all docs (00–23).
- [x] [11-Open-Source-Strategy.md](11-Open-Source-Strategy.md) &
      [21-Product-Positioning.md](21-Product-Positioning.md).
- [x] [18-Release-and-Versioning.md](18-Release-and-Versioning.md) &
      [`CHANGELOG.md`](../CHANGELOG.md).
- [x] [23-Deployment-Guide.md](23-Deployment-Guide.md).
- [x] Verify all internal doc links resolve (no broken anchors) — all 48
      markdown files' relative links + anchors validated.

## 6. Quality & CI
- [x] `.github/workflows/ci.yml` — lint (ruff), tests, DB validation, security, SBOM.
- [x] `.github/dependabot.yml` — pip/docker/actions weekly.
- [x] Ruff clean (`ruff check` / `ruff format` pass).
- [x] Schema validated against a live Postgres 16 container (tables/views/seed/triggers).
- [x] CI green on the default branch (all 5 jobs pass on `main`).

## 7. Release readiness
- [x] Version set (`0.1.0`) and changelog dated.
- [x] Tag `v0.1.0` and publish the GitHub Release (with SBOM) — see
      [18-Release-and-Versioning.md](18-Release-and-Versioning.md#5-release-process).
- [x] Announcement drafted (see §10 below).

## 8. Repository settings (manual, at flip-to-public)
- [x] Set repo description + topics; link docs.
- [x] Branch protection on `main` (require the 5 CI checks; PRs for contributors).
- [x] Enable security features: advisories, Dependabot alerts, secret scanning
      + push protection.
- [x] Confirm license shows as **Apache-2.0** in the GitHub sidebar.
- [ ] Add repo social preview / logo (respecting trademark guidance).
      *Deferred: needs a logo/image asset.*

## 9. Final go/no-go
Publish when **all `[x]` items are verified** and the remaining `[ ]` items are
either completed or explicitly accepted as post-launch (with owners). The
**required-for-OSS-release** set (Licensing, core Legal, Security, Community,
Docs, CI) is **complete and verified**. The repository is **published**
(`reyisjones/ile`, public, Apache-2.0), CI is green on `main`, branch protection
is on, security features are enabled, and **`v0.1.0` is released** with an SBOM.

The only remaining `[ ]` items are intentionally deferred and gated behind a
**commercial** launch or a design asset:
- Trademark search/registration (pre-commercial).
- Legal counsel review of TERMS/PRIVACY/trademark (pre-commercial).
- Social-preview logo/image.
- CODEOWNERS/FUNDING `@org/team` handles (once a GitHub org is created).

## 10. Announcement draft

> **ILE — IKIGAI Learning Engine v0.1.0 is open source** 🎉
>
> ILE is a **local-first Learning Operating System**: one private, self-hosted
> platform that unifies learning, knowledge management, career growth, interview
> prep, and purpose (IKIGAI) — with AI that runs on *your* machine and data you
> fully own. No telemetry, no accounts, no cloud lock-in.
>
> Under the hood: PostgreSQL + FastAPI + Metabase + Obsidian, deployed via Docker
> Compose, with a spaced-repetition (SM-2) retention engine and an optional local
> LLM (Ollama).
>
> - ⭐ Repo: https://github.com/reyisjones/ile
> - 📦 Release: https://github.com/reyisjones/ile/releases/tag/v0.1.0
> - 📖 Docs: `docs/00-Index.md` · 🚀 Deploy: `docs/23-Deployment-Guide.md`
> - 🪪 Apache-2.0 · contributions via DCO
>
> Feedback and contributors welcome — open an Issue, start a Discussion, or
> propose an RFC. This is an alpha MVP foundation; the roadmap is in `ROADMAP.md`.

*Suggested venues:* GitHub Discussions (Announcements), r/selfhosted,
r/ObsidianMD, Hacker News (Show HN), relevant Discord/Slack communities. Tailor
tone per venue; keep claims accurate (no employment/accreditation guarantees).
