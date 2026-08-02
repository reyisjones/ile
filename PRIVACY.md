# Privacy Policy

**Project:** ILE — IKIGAI Learning Engine
**Effective date:** 2026-08-02
**Applies to:** the open-source, self-hosted ILE software in this repository.

> **Summary:** ILE is **local-first**. When you self-host ILE, **you** are the
> data controller. The software collects **no telemetry**, makes **no outbound
> network calls** by default, and stores everything on infrastructure you
> control. You own your data and can export or delete it at any time.

---

## 1. Who this applies to

This policy describes how the **ILE software** handles data. Because ILE is
self-hosted, the project maintainers (TECHTARIS LLC and contributors) **do not
operate a server, do not receive your data, and have no access to it.** You, the
operator, are responsible for the deployment you run.

If a hosted "ILE Cloud" service is offered in the future, it will have its own,
separate privacy policy and consent flow.

## 2. Data ILE stores (on your infrastructure)

ILE is a learning system, so it stores what you put into it:

| Category | Examples | Where |
|---|---|---|
| Learning data | Topics, study sessions, XP, validations, maturity | PostgreSQL |
| Interview data | Questions, STAR answers, readiness, simulations | PostgreSQL |
| Knowledge | Notes, reflections, journals, MOCs | Obsidian vault (Markdown files) |
| Purpose | IKIGAI alignment, goals, career paths | PostgreSQL |
| Business/Personal | Initiatives, tasks (kept separate by design) | PostgreSQL |
| AI interactions | Prompts/responses to your **local** LLM | PostgreSQL (`ai_interactions`) |
| Analytics | Aggregations for dashboards | PostgreSQL views, Metabase |
| Backups | Nightly `pg_dump` archives | `data/backups/` on your disk |

**This can be sensitive information** (career goals, performance scores,
journals, reflections). Treat the deployment accordingly (see §7).

## 3. Why it is stored

Solely to provide the app's features to you: tracking learning, computing
retention/readiness, powering dashboards, and enabling AI coaching. There is no
secondary use, profiling for advertising, or resale — the software has no
capability to do any of that.

## 4. What ILE does NOT do

- ❌ No telemetry, analytics beacons, crash reporting, or "phone home."
- ❌ No third-party trackers or cookies in the core.
- ❌ No selling, sharing, or transmitting your data to the maintainers or anyone.
- ❌ No mandatory account or cloud dependency.

The only network calls ILE can make are to a **local LLM (Ollama)** on your own
network, and only when you enable the optional `ai` profile and invoke AI
features.

## 5. AI data handling

- AI runs **locally** via Ollama (opt-in). Prompts and responses stay on your
  machine and are logged to `ai_interactions` for your own history/audit.
- If you choose to configure an **external** model provider (not shipped by
  default), your prompts would leave your machine under that provider's terms.
  ILE will surface a clear warning before any such integration is used.
- AI output is **advisory only** — see the disclaimers in [TERMS.md](TERMS.md).

## 6. Your rights & controls (data portability, erasure, retention)

Because you hold the data, you have full control:

- **Export**
  - Notes: plain Markdown files in `vault/` — copy them anywhere.
  - Structured data: `scripts/backup.sh` produces a portable SQL dump; you can
    also export CSV/JSON from any table or view (e.g., via `psql \copy` or
    Metabase export). Roadmap: one-command `export` to Markdown/JSON/CSV.
- **Delete (right to be forgotten)**
  - Delete rows/records via the API/SQL, delete vault files, or destroy the
    `data/` volumes. `ON DELETE CASCADE` removes dependent records.
- **Retention**
  - You set it. Backups auto-prune after `BACKUP_RETENTION_DAYS` (default 30).
  - Nothing is retained anywhere off your machine.
- **Consent**
  - Optional features (AI, backups, future sync) are **off or opt-in** by
    default. Enabling a profile is your consent to that feature's local behavior.

See [docs/13-Privacy-Impact-Assessment.md](docs/13-Privacy-Impact-Assessment.md)
for the full assessment and the data-flow mapping.

## 7. Security of your data

ILE ships secure defaults, but self-hosting security is ultimately yours:
- Secrets in `.env` (git-ignored); strong `POSTGRES_PASSWORD` / `API_SECRET_KEY`.
- Don't expose Postgres/API to the public internet; use TLS + auth if you do.
- Encrypt disks and backups; keep an off-device encrypted copy (3-2-1).

Details: [SECURITY.md](SECURITY.md), [docs/14-Security-Architecture.md](docs/14-Security-Architecture.md).

## 8. Children's privacy

ILE is a general-purpose tool for personal use and is not directed at children
under 13 (or the applicable age in your jurisdiction). As the operator, you are
responsible for lawful use.

## 9. Compliance posture (GDPR/CCPA/CPRA)

For a self-hosted deployment, **you are the controller/business** under GDPR,
CCPA, and CPRA. ILE is designed with **privacy-by-design and by-default** and
provides the technical means for access, portability, and erasure. The project
maintainers are **not** a processor of your data because they never receive it.
A DPA is therefore not applicable to self-hosting. See
[docs/22-Legal-and-Compliance-Assessment.md](docs/22-Legal-and-Compliance-Assessment.md) and the
compliance assessment for details.

## 10. Changes to this policy

Material changes will be noted in [CHANGELOG.md](CHANGELOG.md) and this file's
effective date updated. Because the software doesn't collect data centrally,
changes affect only how the software behaves in future versions you choose to run.

## 11. Contact

Questions about the project's privacy design: **privacy@techtaris.com**.
(For your own deployment's privacy obligations to your users, you are the
point of contact.)
