# 10 — Open Source Rationale

Why ILE is released as open source, which parts are open, and how an open-core
model could evolve. This captures the *reasoning*; the full plan and execution
are in [11-Open-Source-Strategy.md](11-Open-Source-Strategy.md).

---

## 1. Why open source fits ILE

For a project like ILE the hardest problems are not coding — they are getting
users, gathering feedback, building trust, validating the concept, and growing a
community. Open source directly helps all of them:

- Anyone can **verify there is no data harvesting**.
- Security professionals can **review the code**.
- Users can **self-host**.
- Contributors can **improve features**.
- The project gains **visibility and reputation**.

This matters especially because ILE holds sensitive data — learning history,
career plans, personal goals, IKIGAI reflections, and knowledge bases. Users are
far more likely to trust an **open-source, local-first** platform.

## 2. License: Apache 2.0

**Apache 2.0** is the chosen license:

- Commercial- and enterprise-friendly.
- Includes an explicit **patent grant**.
- Permits a future SaaS/commercial offering.

MIT is simpler but offers less protection. Because ILE may eventually become a
TECHTARIS product, Apache 2.0 is the better fit. Rationale and obligations:
[12-Licensing-Guide.md](12-Licensing-Guide.md).

## 3. Open-core model

**Open (the core):**

- Core learning engine and IKIGAI framework
- Obsidian integration
- PostgreSQL schema
- Docker deployment
- Dashboards (Metabase)
- Local AI integration
- Knowledge graph

**Potential future commercial add-ons:**

- Hosted cloud version and managed hosting
- Enterprise authentication (SSO)
- Team learning analytics and organization reporting
- Advanced AI agents and enterprise knowledge graph
- Multi-tenant SaaS

This mirrors how GitLab, Mattermost, Grafana, Metabase, and Supabase grew. Full
strategy: [11-Open-Source-Strategy.md](11-Open-Source-Strategy.md).

## 4. What ships open in v1

Nearly everything. A user should be able to:

```bash
git clone <repo>
docker compose up -d
```

and start using it. The actual repository layout:

```text
ile/
├── api/               # FastAPI backend (domain logic, REST, retention, AI client)
├── database/init/     # Schema, analytics views, seed data
├── docker-compose.yml # Local stack: Postgres, API, Metabase, backups (+ opt AI/automation)
├── scripts/           # backup / restore / cleanup
├── vault/             # Obsidian vault (primary knowledge repository) + templates
├── docs/              # Full documentation set
└── data/              # Runtime volumes (git-ignored)
```

See [23-Deployment-Guide.md](23-Deployment-Guide.md) for setup and profiles.

## 5. Security hygiene for an open repo

Never commit secrets — API keys, tokens, passwords, customer/personal data, or
private prompts. Ship a template instead:

```text
.env.example      ✅ committed
.env              ❌ git-ignored
```

CI scans for leaked secrets (gitleaks) and vulnerable dependencies/images
(Trivy). See [14-Security-Architecture.md](14-Security-Architecture.md#5-application-security).

## 6. Community opportunities

Likely adopters: **engineers** (interview prep, certifications, technical
learning), **students** (coursework, research, exam prep), **consultants**
(knowledge management, career growth), and **organizations** (internal training,
employee development). Onboarding and contribution flow:
[16-Community-Playbook.md](16-Community-Playbook.md).

## 7. Risks and how they're handled

| Risk | Response |
|---|---|
| Someone forks it | Expected and fine. Long-term value is community, brand, docs, and leadership — not just code. |
| Support burden | Strong documentation is critical; the `docs/` set and templates address this. |
| Scope creep | Keep v1 focused on **learning, knowledge, IKIGAI, interview readiness**; everything else becomes plugins or later modules. |

Plugin path: [17-Plugin-Development-Guide.md](17-Plugin-Development-Guide.md).

## 8. Phased plan

- **Phase 1 (open source):** local-first ILE — Obsidian, PostgreSQL, Docker,
  Metabase, local AI, learning analytics, interview prep, IKIGAI, knowledge
  graph. Goal: **~100 active users**.
- **Phase 2:** plugin architecture, community templates, learning packs, career
  roadmaps. Goal: **500+ users**.
- **Phase 3:** optional **ILE Cloud** — team collaboration, shared dashboards,
  managed AI, enterprise authentication.

Tracked in [`ROADMAP.md`](../ROADMAP.md).

## 9. Recommendation

Keep the core **fully open source under Apache 2.0**, remain **local-first**, and
position ILE as a **Personal Learning Operating System**. This aligns with the
IKIGAI vision, minimizes privacy concerns, and maximizes adoption.
