# Security Policy

The ILE — IKIGAI Learning Engine team takes security seriously. ILE is
**local-first**: by default your data never leaves your machine. Still, we want
the code to be safe to self-host and eventually to run as a multi-user service.

## Supported versions

See [SUPPORTED_VERSIONS.md](SUPPORTED_VERSIONS.md) for the versions that receive
security updates.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues,
discussions, or pull requests.**

Instead, use one of the following private channels:

1. **GitHub Security Advisories** — preferred. Go to the repository's
   **Security → Report a vulnerability** to open a private advisory.
2. **Email** — **security@techtaris.com**. Encrypt with our PGP key if the
   report is sensitive (key fingerprint published in the repository security
   advisory page).

Please include:
- A description of the vulnerability and its impact.
- Steps to reproduce (proof-of-concept if possible).
- Affected version/commit and configuration (e.g., single-user vs multi-user).
- Any suggested remediation.

## Our commitment (coordinated disclosure)

| Stage | Target |
|---|---|
| Acknowledge receipt | within **3 business days** |
| Initial assessment & severity (CVSS) | within **7 business days** |
| Fix or mitigation plan | within **30 days** for High/Critical |
| Public disclosure | coordinated, after a fix is available |

We will keep you informed throughout, credit you in the advisory (unless you
prefer to remain anonymous), and coordinate a disclosure timeline. We support a
standard **90-day** disclosure window, accelerated for actively exploited issues.

## Scope

**In scope:** the ILE codebase in this repository — the API (`api/`), database
schema (`database/`), scripts (`scripts/`), Docker configuration, and default
security posture.

**Out of scope (report upstream):** vulnerabilities in third-party components
we depend on but do not maintain (PostgreSQL, Metabase, Ollama, n8n, Obsidian,
Docker). If a default ILE configuration exposes such an issue, that
configuration *is* in scope.

## Safe harbor

We consider good-faith security research conducted under this policy to be
authorized. We will not pursue legal action against researchers who:
- Make a good-faith effort to avoid privacy violations and data destruction,
- Only interact with accounts/systems they own or have permission to test,
- Give us reasonable time to remediate before public disclosure.

## Security posture summary

- **Local-first, no telemetry** by default; no outbound calls except opt-in,
  in-network Ollama.
- **Secrets** live only in `.env` (git-ignored); `.env.example` ships instead.
- **Parameterized SQL** throughout; Pydantic validation at boundaries; DB
  `CHECK` constraints as defense-in-depth.
- **Multi-user readiness:** JWT auth and per-row `user_id` enable Postgres
  Row-Level Security when enabled.
- **Backups:** daily encrypted-at-rest guidance (3-2-1); restore is tested.

Full details: [docs/14-Security-Architecture.md](docs/14-Security-Architecture.md),
[docs/15-Threat-Model.md](docs/15-Threat-Model.md), and
[docs/20-Incident-Response-and-DR.md](docs/20-Incident-Response-and-DR.md).

## Hardening checklist for self-hosters

- Set strong, unique `POSTGRES_PASSWORD` and `API_SECRET_KEY` in `.env`.
- Do not expose Postgres (5432) or the API (8000) to the public internet;
  keep them on localhost or a private network.
- If exposing the UI/API, put a TLS-terminating reverse proxy in front and
  enable multi-user auth (`API_SINGLE_USER_MODE=false`).
- Encrypt the disk / backups volume; copy backups off-device (encrypted).
- Keep container images updated; enable Dependabot/scanning on forks.
