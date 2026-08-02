# Supported Versions

ILE — IKIGAI Learning Engine follows [Semantic Versioning](https://semver.org/):
`MAJOR.MINOR.PATCH`.

## Version support policy

Because ILE is **pre-1.0**, the API and schema may change between minor
versions. We document breaking changes in [CHANGELOG.md](CHANGELOG.md) and
provide migration notes.

| Version | Status | Security fixes | Notes |
|---|---|---|---|
| `0.1.x` | **Current** | ✅ Yes | Foundation / MVP series. |
| `< 0.1` | Unreleased | — | Pre-release development. |

Support commitment once we reach **1.0**:

- **Latest MAJOR.MINOR** — full support (features, fixes, security).
- **Previous MINOR** — security and critical bug fixes for **6 months**.
- **Previous MAJOR** — security fixes for **12 months** after the next major ships.
- Older versions — community-supported (best effort), no guarantees.

## Upgrading

- Patch (`0.1.0 → 0.1.1`): safe, backward-compatible. Pull images, restart.
- Minor (`0.1 → 0.2`): may include additive schema changes; run provided
  migrations. Review the CHANGELOG.
- Major (`0.x → 1.0`, `1 → 2`): may include breaking changes; follow the
  migration guide in the release notes.

Always **back up first** (`scripts/backup.sh` runs daily; verify a restore
before a major upgrade).

## Reporting

Security issues → [SECURITY.md](SECURITY.md). Bugs and upgrade problems →
GitHub issues with the version you are running (`GET /` returns the API version).
