# 05 — UI/UX Design, Wireframes & Dashboard Specifications

Covers: information architecture, ASCII wireframes for the future web SPA, the
Obsidian-first experience for the MVP, and the Metabase dashboard specs
(cards, SQL, chart types).

---

## 1. UX Principles

1. **Purpose-forward:** IKIGAI alignment is visible on every learning surface.
2. **One primary action per screen** (reduce decision fatigue).
3. **Validation is a first-class state**, not an afterthought.
4. **Local & fast:** no spinners for local reads; keyboard-friendly.
5. **Separation with linking:** Learning / Business / Personal never blur.

### MVP delivery
The MVP UI is **Obsidian (capture/knowledge) + Metabase (insight)**. A dedicated
web SPA (React) is a Phase 2 deliverable; wireframes below define its target.

---

## 2. Information Architecture (target SPA)

```text
ILE
├── Home (Today)
├── Learning
│   ├── Topics (board / list)
│   ├── Topic detail (IKIGAI, XP, validation, reviews)
│   └── Study log
├── Interview
│   ├── Question bank
│   ├── Readiness
│   └── Mock interview (AI)
├── Retention (Due today)
├── Goals & Career
│   ├── Goals
│   ├── Career roadmap
│   ├── Skills matrix
│   └── Certifications
├── IKIGAI (radar + dimensions)
├── Analytics (embedded Metabase)
└── Settings
```

---

## 3. Wireframes (ASCII)

### 3.1 Home / Today
```text
┌──────────────────────────────────────────────────────────────┐
│ ILE            [Learning][Interview][Goals][IKIGAI][Analytics] │
├──────────────────────────────────────────────────────────────┤
│  Good morning, RJ            Streak 🔥 6d     Level 4 · 1,240 XP│
│                                                                │
│  ┌─ Today's Focus ─────────────┐  ┌─ Reviews Due (5) ───────┐ │
│  │ Role: AI Engineer           │  │ • Agentic AI     [Grade]│ │
│  │ Topic: Agentic AI  ▸ Start  │  │ • RAG vs FT      [Grade]│ │
│  │ Result: Build a RAG demo    │  │ • K8s probes     [Grade]│ │
│  └─────────────────────────────┘  └─────────────────────────┘ │
│                                                                │
│  ┌─ IKIGAI this week ──────────┐  ┌─ Interview Readiness ───┐ │
│  │      Passion ▓▓▓▓░           │  │ Behavioral   ███████ 72 │ │
│  │      Mission ▓▓░             │  │ System Des.  █████   58 │ │
│  │   Profession ▓▓▓▓▓           │  │ AI Eng.      ████████ 81│ │
│  │     Vocation ▓▓▓             │  │ Security     ████    44 │ │
│  └─────────────────────────────┘  └─────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### 3.2 Topic Detail
```text
┌──────────────────────────────────────────────────────────────┐
│ ← Topics / Agentic AI                        Maturity: L3 Applied│
├──────────────────────────────────────────────────────────────┤
│ Why it matters: Path to AI Engineering Lead                    │
│ Primary IKIGAI: Profession    Priority: P2    XP: 23           │
│                                                                │
│ IKIGAI Alignment   Passion ⭐⭐⭐⭐⭐  Mission ⭐⭐⭐             │
│                    Profession ⭐⭐⭐⭐⭐ Vocation ⭐⭐⭐⭐          │
│                                                                │
│ Validation Gate                                                │
│  [✓] L1 Recall     92%                                         │
│  [✓] L2 Interview  85%                                         │
│  [ ] L3 Practical  build a RAG demo            [Record]        │
│  [ ] L4 Teaching   blog / talk                 [Record]        │
│                                                                │
│ Award XP: [Read+1][Notes+2][Lab+5][Quiz+5][Present+10][Teach+15]│
│ Open note in Obsidian ▸        Next review: in 7 days          │
└──────────────────────────────────────────────────────────────┘
```

### 3.3 Interview — Mock (AI)
```text
┌──────────────────────────────────────────────────────────────┐
│ Mock Interview · Role: Senior AI Engineer · Category: System   │
├──────────────────────────────────────────────────────────────┤
│ 🤖  Design a retrieval pipeline for 10M docs with low latency. │
│                                                                │
│ 🧑  [ your answer …                                          ] │
│                                                    [Submit]    │
│ ────────────────────────────────────────────────────────────  │
│ Feedback: Strong on chunking & caching. Missed: eval harness   │
│ and cost ceilings. Score: 78/100                               │
└──────────────────────────────────────────────────────────────┘
```

### 3.4 IKIGAI Radar
```text
        Passion
           /\
          /  \            ● this week
   Vocation—●—Mission     ○ target
          \  /
           \/
       Profession
```

### 3.5 Retention — Due Today
```text
┌ Due Today (5) ───────────────────────────────────────────────┐
│ Entity            Type      Last     Interval   Action        │
│ Agentic AI        topic     7d ago   7 → ?      [0..5] Grade  │
│ RAG vs Fine-tune  question  3d ago   3 → ?      [0..5] Grade  │
└──────────────────────────────────────────────────────────────┘
```

---

## 4. Visual System

- **Color = IKIGAI dimension:** Passion `#E64980`, Mission `#12B886`,
  Profession `#4C6EF5`, Vocation `#F59F00` (matches `ikigai_dimensions.color_hex`).
- **Typography:** system UI stack; monospace for code/labs.
- **States:** Planned·Learning·Practicing·Applied·Teaching·Completed shown as a
  left-to-right progress rail.
- **Accessibility:** WCAG AA contrast; never encode meaning by color alone
  (pair with labels/icons).

---

## 5. Metabase Dashboards

Connect Metabase → Postgres:
```text
Host: postgres  Port: 5432  DB: ile  User: ile_admin  Password: (from .env)
```

### 5.1 Dashboard: **Learning Command Center** (MVP)

| Card | Chart | Source |
|---|---|---|
| Daily Study Time | Line | `v_daily_study_time` |
| Weekly Study Time | Bar | `v_weekly_study_time` |
| Confidence Improvement | Line | `v_confidence_improvement` |
| Study Time by Type | Pie/Bar | `v_study_by_type` |
| Interview Readiness | Horizontal bar | `v_interview_readiness` |
| Questions Due for Review | Table | `v_questions_due` |

Example SQL (also available as views):
```sql
-- Daily study time
SELECT session_date, SUM(duration_minutes) AS total_minutes
FROM study_sessions WHERE user_id = {{user}}
GROUP BY session_date ORDER BY session_date;
```

### 5.2 Dashboard: **IKIGAI & Purpose**

| Card | Chart | Source |
|---|---|---|
| IKIGAI Learning Distribution | Radar/Bar | `v_ikigai_distribution` |
| Topic XP Leaderboard | Row/Bar | `v_topic_xp` |
| Weekly XP Earned | Bar | `v_weekly_xp` |
| Maturity by Topic | Table | `v_topic_xp` (maturity_level) |

### 5.3 Dashboard: **Retention & Mastery**

| Card | Chart | Source |
|---|---|---|
| Retention Overview | Donut | `v_retention_overview` |
| Reviews Due | Table | `v_reviews_due` |
| Skill Matrix (gap) | Table/Heatmap | `v_skill_matrix` |

### 5.4 Dashboard: **Learning ROI**

| Card | Chart | Source |
|---|---|---|
| Hours Invested | Big number | `v_learning_roi` |
| Projects Shipped | Big number | `v_learning_roi` |
| Certifications | Big number | `v_learning_roi` |
| Validations Passed | Big number | `v_learning_roi` |

### 5.5 Dashboard-level filters
- **User** (`user_id`) — enables multi-user later.
- **Date range** — bound to `session_date` / `created_at`.
- **Category / Domain** — for focused study reviews.

---

## 6. KPIs Surfaced in the UI

| KPI | Definition | Target |
|---|---|---|
| Consistency | Study days / week | ≥ 5 |
| Focused minutes | Sum of `duration_minutes` | 300–600 / wk |
| Confidence delta | `after − before` avg | positive trend |
| Interview readiness | Avg confidence × coverage | ≥ 80 in top 3 |
| Retention | % recalled at 7/30d | ≥ 80% |
| IKIGAI alignment | % active topics with primary dimension | ≥ 90% |
| Learning ROI | Validated outputs vs hours | ≥ 1 artifact/topic/mo |
