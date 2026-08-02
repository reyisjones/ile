# 15 — Threat Model

STRIDE-based threat model for ILE. Pairs with
[14-Security-Architecture.md](14-Security-Architecture.md) and
[13-Privacy-Impact-Assessment.md](13-Privacy-Impact-Assessment.md).

---

## 1. Assets

| Asset | Why it matters |
|---|---|
| User learning/career/reflection data (Postgres) | Personal, potentially sensitive. |
| Notes/journals (Obsidian vault) | Highly personal free-text. |
| Backups | Contain everything above. |
| Auth credentials / JWT keys (multi-user) | Account takeover risk. |
| AI prompts/responses | May contain sensitive context. |
| The host itself | Compromise = full data access. |

## 2. Actors & entry points

- **Legitimate operator** (single user or admin).
- **Additional users** (multi-user mode).
- **Network attacker** — only relevant if the operator exposes ports/remote access.
- **Malicious dependency / supply-chain**.
- **Local attacker** with host/disk access (lost laptop, shared machine).

Default deployment is **localhost-only**, which eliminates most remote actors.

## 3. STRIDE analysis

| STRIDE | Threat | Default-mode risk | Mitigation |
|---|---|---|---|
| **Spoofing** | Impersonating a user | Low (no network auth surface locally) | Multi-user: JWT, strong password KDF, (roadmap) MFA/passkeys/OIDC. |
| **Tampering** | Modifying data/requests | Low–Med | Validated inputs (Pydantic), parameterized SQL, DB constraints/triggers, RLS (multi-user), TLS for remote. |
| **Repudiation** | Denying an action | Low | Timestamped rows, `ai_interactions` log; structured auth/admin audit log (roadmap). |
| **Information disclosure** | Leaking data | **Med (operator-dependent)** | Localhost default; disk + backup encryption guidance; no telemetry; generic errors; secret scanning; RLS. |
| **Denial of service** | Exhausting resources | Low–Med | Reverse-proxy rate limits; container resource limits; local LLM sized to host. |
| **Elevation of privilege** | User→admin, container→host | Low–Med | RBAC; least-priv DB role; non-root/read-only containers; dropped caps; patched images. |

## 4. Key threat scenarios & responses

1. **Operator exposes API to the internet without auth.**
   *Impact:* full data exposure. *Response:* single-user mode is documented as
   localhost-only; use multi-user + reverse proxy + TLS + auth for remote; docs
   warn prominently. (Threat: Info disclosure/Spoofing.)
2. **Lost/stolen device.** *Response:* full-disk encryption; encrypted backups;
   the app stores no plaintext passwords. (Info disclosure.)
3. **Malicious/compromised dependency.** *Response:* pinned deps, Dependabot,
   Trivy scan, gitleaks, SBOM, review of new deps in PRs. (Tampering/EoP.)
4. **Backup left on an unencrypted share.** *Response:* docs mandate encryption
   for off-device copies; 3-2-1 strategy. (Info disclosure.)
5. **Sensitive prompt sent to an external LLM.** *Response:* local LLM by
   default; external providers non-default and flagged. (Info disclosure.)
6. **Cross-tenant data access (future multi-user).** *Response:* RLS on
   `user_id`, tenant-isolation tests before GA, authZ filters on every query. (EoP/Info disclosure.)
7. **Container escape.** *Response:* non-root, read-only FS, dropped
   capabilities, resource limits, updated base images. (EoP.)

## 5. OWASP Top 10 mapping

| OWASP (2021) | Status / control |
|---|---|
| A01 Broken Access Control | RLS + per-`user_id` filters + RBAC (multi-user); N/A single-user localhost. |
| A02 Cryptographic Failures | TLS for remote; hashed passwords; disk/backup encryption guidance. |
| A03 Injection | Parameterized SQLAlchemy; Pydantic validation; no shell/SQL string building. |
| A04 Insecure Design | Local-first, secure defaults, threat model, least privilege. |
| A05 Security Misconfiguration | Secure defaults; hardening checklist; profiles off by default. |
| A06 Vulnerable Components | Pinned deps, Dependabot, Trivy, SBOM. |
| A07 Auth Failures | Strong KDF, JWT, (roadmap) MFA/passkeys, throttling. |
| A08 Software/Data Integrity | Signed images where available, SBOM, CI checks, DCO. |
| A09 Logging/Monitoring Failures | Timestamps, AI logs; audit log + alerting on roadmap. |
| A10 SSRF | No user-controlled server-side fetch in core; external LLM opt-in and validated. |

## 6. Residual risk
With default local-only deployment and the hardening checklist applied, residual
risk is **Low**. The dominant residual risks are **operator configuration**
(exposure, encryption, backups) — mitigated by secure defaults and clear docs.

## 7. Maintenance
Re-review this model on major architecture changes (esp. multi-user, hosted
mode, new external integrations) and at least annually. Track findings as
security issues per [SECURITY.md](../SECURITY.md).
