# 11 — Open-Source Strategy

Consolidates the guidance in `docs/09-Legal.md` and `docs/10-OpenSource.md` into
an actionable strategy for releasing ILE publicly.

---

## 1. Thesis

For ILE, the hardest problem is **not** building the software — it is earning
**trust**, **users**, and **feedback** for a tool that holds deeply personal
data (learning history, career plans, IKIGAI reflections, journals). Open source
is the most direct path to all three: people can verify there is no data
harvesting, security professionals can review the code, and users can self-host
with confidence.

**Decision:** release the **core fully open source under Apache 2.0**, keep it
**local-first**, and position it as a **Personal Learning Operating System** —
not "another LMS."

## 2. Why Apache 2.0

| Reason | Benefit |
|---|---|
| Commercial-friendly | Enables future TECHTARIS services without relicensing. |
| **Explicit patent grant** | Protects users and contributors (MIT lacks this). |
| Enterprise-trusted | Widely accepted in corporate environments. |
| Permissive | Maximizes adoption, forks, and integrations. |

MIT was considered but Apache 2.0's patent protection and enterprise acceptance
win for a project that may grow into a product. See
[docs/12-Licensing-Guide.md](12-Licensing-Guide.md).

## 3. Open-core model

**Open forever (the core):**
```text
Core Learning Engine · IKIGAI Framework · Obsidian Integration
PostgreSQL Schema · Docker Deployment · Dashboards
Local AI Integration · Knowledge Graph · Retention Engine
Interview Preparation · Analytics
```

**Potential future commercial (additive, optional):**
```text
Hosted Cloud (ILE Cloud) · Enterprise Auth (SSO/OIDC/SCIM)
Team Learning Analytics · Advanced AI Agents
Organization Reporting · Multi-Tenant SaaS · Managed Hosting
Premium templates / learning packs
```

This mirrors GitLab, Mattermost, Grafana, Metabase, and Supabase: a strong open
core with optional paid services **around** it — never by closing the core.

**Open-core promise:** no feature that exists as open source will be moved
behind a paywall. Commercial value comes from convenience (hosting, support,
managed AI) and organization-scale features, not from crippling the core.

## 4. What ships open source (v1)

Nearly everything:
```text
ile/
├── api/          # backend
├── database/     # schema, views, seed
├── docker-compose.yml
├── scripts/      # backup/restore
├── vault/        # Obsidian structure + templates
├── docs/         # full documentation
└── (future) frontend/ , plugins/ , examples/
```
The bar: a newcomer can `git clone` → `docker compose up -d` → start using it.

## 5. What must NOT be in the repo
- API keys, tokens, secrets → ship `.env.example`, never `.env`.
- Customer/personal data, private prompts, internal work information.
- Proprietary content. (Enforced by `.gitignore` + CI secret scanning.)

## 6. Positioning & differentiators

**One-liner:** *A Personal Learning Operating System that aligns knowledge,
career growth, business goals, and life purpose through IKIGAI-driven learning
and measurable skill development.*

| Vs. | ILE's difference |
|---|---|
| Obsidian / Logseq / Capacities | Adds structured metrics, validation, retention, IKIGAI, dashboards — not just notes. |
| Notion | Local-first, private, purpose-driven, opinionated learning loop. |
| Coursera / Udemy | Not content delivery — a *system* to learn anything and prove it. |
| Traditional LMS | Personal, self-directed, purpose-aligned; no admin/course bloat. |

Full treatment: [docs/21-Product-Positioning.md](21-Product-Positioning.md).

## 7. Target communities
Engineers (interview prep, certs), students (exams, research), consultants
(knowledge management, career growth), and — later — organizations (internal
training, employee development).

## 8. Known risks & responses

| Risk | Response |
|---|---|
| **Someone forks it** | Expected. Value is community, brand, docs, leadership — not just code. Trademark protects the name. |
| **Support burden** | Excellent docs + issue templates + Discussions; RFCs for big asks. |
| **Scope creep** (CRM, finance, PM) | Keep core focused (Learning, Knowledge, IKIGAI, Interview). Everything else is a **plugin** or future module. |
| **Trust erosion** | Local-first, no telemetry, transparent governance, published security/privacy docs. |

## 9. Growth plan (aligned to phases)

- **Phase 1 (OSS):** local-first MVP; **goal 100 active users**; gather feedback.
- **Phase 2:** plugin architecture, community templates, learning packs, web UI, local AI; **goal 500+ users**.
- **Phase 3:** optional **ILE Cloud** (E2E-encrypted sync, managed AI, team
  features, enterprise auth) — **only after** clear, consistent usage.

## 10. Success criteria for going public
See the [Publication Checklist](19-Publication-Checklist.md). In short: deploys
via Docker Compose, all data user-owned, security/privacy/governance/legal docs
complete, backups tested, minimal legal/privacy/security risk.
