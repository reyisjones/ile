# 01 — Product Requirements Document (PRD)

**Product:** ILE — IKIGAI Learning Engine
**Type:** Local-first Learning Operating System
**Status:** v0.1 (foundational)
**Source of truth:** `IKIGAILearningEngine.md`, `Local_Learning_System.md`

---

## 1. Product Vision

Most study systems track **activity** (hours logged) instead of **purpose**
(why you learn and how it advances your life). ILE closes that gap.

ILE is a single, local-first platform that unifies **Learning Management,
Knowledge Management, IKIGAI alignment, Career Growth, Interview Preparation,
Business Development, and Personal Development**. Every learning action is
connected to purpose through the four IKIGAI intersections — **Passion,
Mission, Profession, Vocation** — and is only considered "done" after it passes
**validation**.

> **Vision statement:** *Turn learning into measurable life advancement.* ILE
> makes purpose the primary metric, proves knowledge through validation, and
> compounds it into skills, projects, career moves, and business outcomes.

### Guiding principles
1. **Purpose over activity** — track *why*, not just *how long*.
2. **Validation over completion** — nothing is "learned" until proven.
3. **Local-first & private by default** — your data stays on your machine.
4. **Simple MVP, extensible core** — start personal, grow to SaaS.
5. **Separation of domains** — Learning, Business, Personal stay distinct but linked.
6. **Knowledge is a graph** — topics, skills, goals, and purpose interconnect.

### The learning loop
```text
Learn → Practice → Validate → Apply → Reflect → Connect to IKIGAI
```

---

## 2. Problem Statement

- Study effort is not tied to purpose or measurable outcomes.
- Notes accumulate but knowledge is rarely tested or retained.
- Interview prep, career goals, and business learning live in disconnected tools.
- Cloud tools create privacy risk and recurring cost for what is personal data.
- There is no single "learning OS" that spans purpose → skill → career → business.

---

## 3. Goals & Non-Goals

### Goals (v1)
- Capture learning topics with explicit **IKIGAI alignment**.
- Log study sessions and compute **confidence improvement**, not just hours.
- Provide an **XP / achievement** layer to sustain motivation.
- Enforce a **4-level validation** gate (Recall, Interview, Practical, Teaching).
- Run a **spaced-repetition retention** engine.
- Deliver **interview preparation** with a question bank and readiness scoring.
- Surface everything through **Metabase dashboards** and an API.
- Keep **Obsidian** as the primary knowledge repository.
- Run entirely **locally via Docker Compose**.

### Non-Goals (v1)
- Multi-tenant SaaS billing, teams, org admin (designed for, not built in v1).
- Mobile native apps (responsive web later).
- Cloud sync / hosting (optional, opt-in, much later).
- Full LMS course authoring / SCORM.

---

## 4. User Personas

| Persona | Description | Primary needs |
|---|---|---|
| **The Owner (RJ)** | Engineer preparing for interviews while running TECHTARIS. | Interview readiness, IKIGAI alignment, retention, local privacy. |
| **The Professional** | Working engineer leveling up for a promotion. | Skill matrix, career roadmap, certifications, validation. |
| **The Consultant** | Independent expert turning skills into services. | Vocation tracking, business initiatives, teaching artifacts. |
| **The Researcher** | Deep specialist tracking evolving fields. | Knowledge graph, retention, deep notes in Obsidian. |
| **The Student** | Learner building fundamentals. | Guided workflow, quizzes, achievements, spaced review. |
| **The Organization (future)** | Team enabling structured growth. | Multi-user, RBAC, shared dashboards, analytics. |

### Persona → priority order (from source docs)
```text
1. Interview preparation
2. Current work learning
3. TECHTARIS business learning
4. General technical learning
5. Personal development
```

---

## 5. Functional Requirements

IDs are grouped by capability. **P0** = MVP, **P1** = Phase 2, **P2** = Phase 3.

### 5.1 Learning Management
- **FR-L1 (P0):** Create/edit/archive learning topics with category, priority (1–5), status, and target date.
- **FR-L2 (P0):** Assign a **primary IKIGAI dimension** and per-dimension star alignment (0–5).
- **FR-L3 (P0):** Log study sessions (duration, type, focus, confidence before/after, notes).
- **FR-L4 (P0):** Track **maturity level** per topic (0 Discovered → 5 Expert).
- **FR-L5 (P1):** Weekly planning: limit active topics to 5, pick 1 primary role + 3 topics.

### 5.2 Knowledge Management
- **FR-K1 (P0):** Obsidian vault is the note store; topics carry frontmatter reconciled with DB.
- **FR-K2 (P1):** AI knowledge extraction from notes into concepts/relationships.
- **FR-K3 (P1):** Knowledge graph edges between topics, skills, projects, goals, IKIGAI, careers.

### 5.3 Achievement / XP
- **FR-A1 (P0):** Award XP per activity (Read 1, Notes 2, Lab 5, Quiz 5, Presentation 10, Teach 15, Project 20).
- **FR-A2 (P0):** Maintain an immutable XP ledger and per-topic XP totals.
- **FR-A3 (P1):** Unlock badges/achievements from machine-checkable criteria.

### 5.4 Validation / Exam
- **FR-V1 (P0):** Record validations at **4 levels**: Recall (%), Interview (%), Practical (pass/fail), Teaching (artifact).
- **FR-V2 (P0):** A topic cannot be marked Completed without passing required validations.
- **FR-V3 (P1):** Quiz engine: authored or AI-generated questions, attempts, scoring.
- **FR-V4 (P2):** Practical labs and presentation/teaching capture with artifact links.

### 5.5 Interview Preparation
- **FR-I1 (P0):** Question bank by role/category with STAR structure and confidence (1–5).
- **FR-I2 (P0):** Readiness score (0–100) per category.
- **FR-I3 (P1):** AI mock interview simulations with transcript + feedback.

### 5.6 Retention
- **FR-R1 (P0):** Spaced review ladder (1, 3, 7, 14, 30, 90 days) with SM-2 easing.
- **FR-R2 (P0):** Retention labels: Excellent / Good / Weak / Forgotten / In Review.
- **FR-R3 (P1):** "Due today" review queue across topics and questions.

### 5.7 Goals, Career, Business, Personal
- **FR-G1 (P1):** Goals with horizon (week→life), IKIGAI link, and progress %.
- **FR-G2 (P1):** Career paths with ordered milestones.
- **FR-G3 (P1):** Certifications lifecycle (Planned→Passed→Expired).
- **FR-G4 (P1):** Business initiatives (TECHTARIS) with stage pipeline.
- **FR-G5 (P0):** Tasks per domain with priority and due date; separation rules enforced.

### 5.8 Analytics & Dashboards
- **FR-D1 (P0):** Metabase "Learning Command Center" (study time, confidence, readiness).
- **FR-D2 (P1):** IKIGAI radar, retention overview, learning ROI, XP trends, skill matrix.

### 5.9 AI Assistant (Local)
- **FR-AI1 (P1):** Local LLM for coaching, quiz generation, summarization, extraction, interview simulation.
- **FR-AI2 (P1):** Log all AI interactions locally (audit trail).

### 5.10 Platform
- **FR-P1 (P0):** Docker Compose deployment (Postgres, API, Metabase, backup).
- **FR-P2 (P0):** Automatic daily backups with 30-day retention + restore.
- **FR-P3 (P1):** Optional profiles: `ai` (Ollama), `automation` (n8n).

---

## 6. Non-Functional Requirements

| Category | Requirement |
|---|---|
| **Privacy** | All data local by default; no outbound network calls except opt-in. |
| **Security** | Secrets in `.env` (never committed); parameterized SQL; JWT for multi-user; least-privilege DB role for backups. |
| **Performance** | API p95 < 200 ms for CRUD on a single-user dataset; dashboards render < 3 s. |
| **Reliability** | Healthchecks on Postgres/API; restart policies; verified nightly backup. |
| **Portability** | Runs on macOS/Linux/Windows with Docker Desktop; no cloud dependency. |
| **Maintainability** | Typed Python (Pydantic/SQLAlchemy 2.0); SQL migrations; documented schema. |
| **Extensibility** | UUID PKs + `user_id` on every owned row for future multi-tenant RLS. |
| **Usability** | Frictionless single-user mode (no login); simple data entry. |
| **Observability** | Structured logs; `/health` + `/ready`; AI latency captured. |
| **Backup/Recovery** | RPO ≤ 24 h (daily dump); RTO minutes (restore script). |
| **Data integrity** | CHECK constraints, FKs, triggers keep derived data consistent. |
| **Scalability** | Vertical first; clean path to managed Postgres + horizontal API. |

---

## 7. MVP Definition (summary)

The MVP is the smallest system that proves the core thesis — *purpose-linked,
validated learning* — end to end, locally.

**In:** Topics + IKIGAI alignment, study sessions, XP ledger, 4-level
validation records, interview question bank + readiness, spaced-repetition
retention, tasks, Metabase Learning Command Center, Docker stack, daily backups,
Obsidian vault + templates, FastAPI CRUD + analytics endpoints.

**Out (deferred):** AI assistant, knowledge-graph UI, quiz engine UI, mock
interviews, goals/career/business modules UI, n8n automation, multi-user auth UI.

See `08-Roadmap-and-Risk.md` for the full MVP scope and acceptance criteria.

---

## 8. Success Metrics

- **Consistency:** ≥ 5 study days/week.
- **Effort:** 300–600 focused minutes/week.
- **Confidence:** positive `confidence_after − confidence_before` trend.
- **Coverage:** ≥ 5 interview questions per priority category.
- **Retention:** ≥ 80% recall at 7 and 30 days.
- **Purpose:** ≥ 90% of active topics have an IKIGAI primary alignment.
- **Output:** ≥ 1 validated artifact (project/blog/talk) per active topic per month.
