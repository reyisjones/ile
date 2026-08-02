# 18 — Release & Versioning

Versioning scheme, release cadence, and how releases are cut. Pairs with
[`CHANGELOG.md`](../CHANGELOG.md) and [`SUPPORTED_VERSIONS.md`](../SUPPORTED_VERSIONS.md).

---

## 1. Versioning: Semantic Versioning
ILE follows **SemVer 2.0.0**: `MAJOR.MINOR.PATCH`.

| Bump | When |
|---|---|
| **MAJOR** | Backward-incompatible changes to the API, DB schema (breaking), or CLI/config contracts. |
| **MINOR** | Backward-compatible new features (additive schema/API, new modules). |
| **PATCH** | Backward-compatible bug/security fixes. |

Pre-1.0 (current, `0.1.x`): minor versions may include breaking changes, called
out clearly in the changelog and release notes.

## 2. Release channels
- **Stable** — tagged releases (`vX.Y.Z`) with signed/pinned images where
  available.
- **Pre-release** — `-rc.N` / `-beta.N` tags for testing.
- **`main`** — always green, but not guaranteed release-stable between tags.

## 3. Cadence
- **Patch:** as needed (bugs/security).
- **Minor:** roughly every few weeks once features land.
- **Major:** only when a breaking change is necessary; announced ahead of time
  via an [RFC](16-Community-Playbook.md#rfc-process) and the roadmap.

## 4. Changelog
Maintained in [`CHANGELOG.md`](../CHANGELOG.md) using **Keep a Changelog** format
with sections: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.
Every user-facing PR updates the `[Unreleased]` section. At release, `[Unreleased]`
is renamed to the new version with the date.

## 5. Release process
1. Ensure `main` is green (ruff, tests, DB validation, security scans, SBOM).
2. Update [`CHANGELOG.md`](../CHANGELOG.md): move `[Unreleased]` → `[X.Y.Z] - YYYY-MM-DD`.
3. Bump the version (e.g., `VERSION` file / package metadata).
4. Tag: `git tag -s vX.Y.Z -m "vX.Y.Z"` and push the tag.
5. CI builds artifacts + **SBOM** and publishes the GitHub Release with notes.
6. Announce in Discussions; update docs if needed.

## 6. Release notes
Each release includes: highlights, upgrade/migration notes (esp. schema
changes), breaking changes, security fixes (with advisory links), and
contributor credits.

## 7. Database migrations
- Additive changes ship as new init/migration SQL applied idempotently.
- Breaking schema changes require an [RFC](16-Community-Playbook.md#rfc-process),
  a migration path, and clear upgrade notes.
- Operators should **back up before upgrading** (see
  [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md#part-c--backup--disaster-recovery)).

## 8. Security releases
Security fixes are prioritized and may ship out-of-band as a patch. They get a
`Security` changelog entry and a GitHub Security Advisory (and CVE if warranted).
Supported versions receive backports per [`SUPPORTED_VERSIONS.md`](../SUPPORTED_VERSIONS.md).
Process detail in [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md#part-a--security-incident-response-maintainers).

## 9. Deprecation policy
Deprecations are announced in the changelog `Deprecated` section at least one
minor release before removal (post-1.0), with a documented migration path.

## 10. Upgrading (operators)
See [23-Deployment-Guide.md](23-Deployment-Guide.md#5-upgrades) for the pull/
migrate/restart flow and rollback guidance.
