# ILE Documentation Index

**ILE — IKIGAI Learning Engine** · a local-first Learning Operating System.

Authoritative source material: `../IKIGAILearningEngine.md`,
`../Local_Learning_System.md`. These documents consolidate and extend both.

| # | Document | Covers |
|---|---|---|
| 01 | [Product Requirements Document](01-Product-Requirements-Document.md) | Vision, personas, functional & non-functional requirements, MVP, success metrics. |
| 02 | [System Architecture](02-System-Architecture.md) | Architecture, Docker, folder structure, security & privacy, backup/recovery, monitoring, scalability. |
| 03 | [Database Design](03-Database-Design.md) | Schema, ER diagram, tables, analytics views, migrations. |
| 04 | [API Specification](04-API-Specification.md) | REST endpoints (MVP + planned), auth, errors, versioning. |
| 05 | [UI/UX & Dashboards](05-UI-UX-and-Dashboards.md) | IA, wireframes, visual system, Metabase dashboard specs, KPIs. |
| 06 | [Subsystems](06-Subsystems.md) | Knowledge graph, IKIGAI, achievements, validation/exam, interview, retention, skills, career, analytics. |
| 07 | [Workflows](07-Workflows.md) | Learning, IKIGAI, business, personal, AI assistant, automation. |
| 08 | [Roadmap & Risk](08-Roadmap-and-Risk.md) | MVP definition, Phase 1–3 plans, tech-debt & risk registers. |

## Open-source, legal, security & community

Root community-health files live at the repository root (LICENSE, NOTICE,
CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, PRIVACY, TERMS, GOVERNANCE, ROADMAP,
SUPPORTED_VERSIONS, CHANGELOG).

| # | Document | Covers |
|---|---|---|
| 09 | [Publishing & Legal Rationale](09-Legal.md) | Why ILE is publishable; privacy, security, AI-risk, compliance, IP, licensing rationale. |
| 10 | [Open Source Rationale](10-OpenSource.md) | Why open source, Apache-2.0, open-core model, what ships open, phased plan. |
| 11 | [Open Source Strategy](11-Open-Source-Strategy.md) | Thesis, Apache-2.0 rationale, open-core model, positioning, communities, growth. |
| 12 | [Licensing Guide](12-Licensing-Guide.md) | License, DCO, user-content ownership, third-party compatibility, trademark. |
| 13 | [Privacy Impact Assessment](13-Privacy-Impact-Assessment.md) | DPIA: data inventory, flows, rights, risk register. |
| 14 | [Security Architecture](14-Security-Architecture.md) | Trust boundaries, auth, data/app/network security, hardening. |
| 15 | [Threat Model](15-Threat-Model.md) | STRIDE analysis + OWASP Top 10 mapping. |
| 16 | [Community Playbook](16-Community-Playbook.md) | Onboarding, issue workflow, RFC process, ecosystem. |
| 17 | [Plugin Development Guide](17-Plugin-Development-Guide.md) | Extension points, plugin model, security requirements. |
| 18 | [Release & Versioning](18-Release-and-Versioning.md) | SemVer, cadence, changelog, security releases. |
| 19 | [Publication Checklist](19-Publication-Checklist.md) | Final gate before making the repo public. |
| 20 | [Incident Response & DR](20-Incident-Response-and-DR.md) | Security IR, backups, disaster recovery. |
| 21 | [Product Positioning](21-Product-Positioning.md) | Mission, vision, value prop, differentiators. |
| 22 | [Legal & Compliance Assessment](22-Legal-and-Compliance-Assessment.md) | GDPR/CCPA/CPRA, IP, AI disclaimers, release-stage matrix. |
| 23 | [Deployment Guide](23-Deployment-Guide.md) | Docker Compose deploy, config, upgrades, hardening. |

## Requested artifact → where it lives

| Requested | Location |
|---|---|
| Product Requirements Document | doc 01 |
| System Architecture Document | doc 02 |
| Database Schema | `database/init/001_schema.sql` + doc 03 |
| API Specifications | doc 04 + live `/docs` |
| UI Wireframes | doc 05 §3 |
| Dashboard Specifications | doc 05 §5 |
| Docker Architecture | `docker-compose.yml` + doc 02 §4 |
| Folder Structure | doc 02 §3 |
| Obsidian Vault Structure | `vault/` + `vault/README.md` + doc 02 §3 |
| Learning Workflow Definitions | doc 07 §1–2, §8 |
| IKIGAI Workflow Definitions | doc 07 §3 + doc 06 §2 |
| Implementation Roadmap | doc 08 §2 |
| MVP Definition | doc 08 §1 |
| Phase 1/2/3 Plans | doc 08 §3–5 |
| Technical Debt & Risk Register | doc 08 §7–8 |
| Knowledge Graph Design | doc 06 §1 + `kg_edges` |
| Learning Analytics | doc 06 §9 + `database/init/002_views.sql` |
| IKIGAI Integration | doc 06 §2 |
| Achievement System | doc 06 §3 + `xp_*`/`achievements` |
| Exam & Validation System | doc 06 §4 + `validations`/`quizzes` |
| Interview Preparation System | doc 06 §5 + `interview_*` |
| Learning Retention Engine | doc 06 §6 + `services/retention.py` |
| Goal Tracking | doc 06 §8 + `goals` |
| Skill Matrix | doc 06 §7 + `v_skill_matrix` |
| Career Roadmaps | doc 06 §8 + `career_*` |
| Business Learning Workflows | doc 07 §4 |
| Personal Growth Workflows | doc 07 §5 |
| AI Assistant / Local LLM | doc 07 §6 + `routers/ai.py`, `services/llm.py` |
| Backup & Recovery | doc 02 §6 + `scripts/` |
| Security & Privacy | doc 02 §5 |
| Docker Deployment | `docker-compose.yml` + `README.md` |
| Monitoring & Observability | doc 02 §7 |
| Scalability Roadmap | doc 02 §8 |
