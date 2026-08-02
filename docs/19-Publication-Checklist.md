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

## 2. Legal & compliance
- [x] [`TERMS.md`](../TERMS.md) — Apache-2.0 software terms, AI disclaimers, **no
      accreditation/certification/employment guarantees**, acceptable use.
- [x] [`PRIVACY.md`](../PRIVACY.md) — local-first, no telemetry, rights, GDPR/CCPA.
- [x] [13-Privacy-Impact-Assessment.md](13-Privacy-Impact-Assessment.md) — DPIA.
- [x] [22-Legal-and-Compliance-Assessment.md](22-Legal-and-Compliance-Assessment.md).
- [ ] Counsel review of TERMS/PRIVACY/trademark **before commercial launch**.

## 3. Security
- [x] [`SECURITY.md`](../SECURITY.md) — private reporting + disclosure SLAs.
- [x] [`SUPPORTED_VERSIONS.md`](../SUPPORTED_VERSIONS.md).
- [x] [14-Security-Architecture.md](14-Security-Architecture.md).
- [x] [15-Threat-Model.md](15-Threat-Model.md) — STRIDE + OWASP mapping.
- [x] [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md).
- [x] Secure defaults (localhost binding; DB port not published; profiles off).
- [x] CI secret scanning (gitleaks) + image scan (Trivy) + SBOM (Syft SPDX).
- [ ] **No secrets in git history** — run a final scan and rotate anything found.
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
- [ ] Create GitHub org/teams referenced by CODEOWNERS (`@techtaris/*`).
- [ ] Enable GitHub Discussions + Security Advisories in repo settings.

## 5. Documentation
- [x] [`README.md`](../README.md) with quick start, badges, and community links.
- [x] [00-Index.md](00-Index.md) lists all docs (00–23).
- [x] [11-Open-Source-Strategy.md](11-Open-Source-Strategy.md) &
      [21-Product-Positioning.md](21-Product-Positioning.md).
- [x] [18-Release-and-Versioning.md](18-Release-and-Versioning.md) &
      [`CHANGELOG.md`](../CHANGELOG.md).
- [x] [23-Deployment-Guide.md](23-Deployment-Guide.md).
- [ ] Verify all internal doc links resolve (no broken anchors).

## 6. Quality & CI
- [x] `.github/workflows/ci.yml` — lint (ruff), tests, DB validation, security, SBOM.
- [x] `.github/dependabot.yml` — pip/docker/actions weekly.
- [x] Ruff clean (`ruff check` / `ruff format` pass).
- [x] Schema validated against a live Postgres 16 container (tables/views/seed/triggers).
- [ ] CI green on the default branch at publication.

## 7. Release readiness
- [x] Version set (`0.1.0`) and changelog dated.
- [ ] Tag `v0.1.0` and publish the GitHub Release (with SBOM) — see
      [18-Release-and-Versioning.md](18-Release-and-Versioning.md#5-release-process).
- [ ] Announcement drafted (Discussions / relevant communities).

## 8. Repository settings (manual, at flip-to-public)
- [ ] Set repo description + topics; link docs.
- [ ] Branch protection on `main` (require CI + review).
- [ ] Enable security features: advisories, Dependabot alerts, secret scanning.
- [ ] Confirm license shows as **Apache-2.0** in the GitHub sidebar.
- [ ] Add repo social preview / logo (respecting trademark guidance).

## 9. Final go/no-go
Publish when **all `[x]` items are verified** and the remaining `[ ]` items are
either completed or explicitly accepted as post-launch (with owners). The
**required-for-OSS-release** set (Licensing, core Legal, Security, Community,
Docs, CI) is **complete**; the open items are operational (GitHub org/settings,
final secret scan, counsel review before *commercial* launch, tagging the
release).
