# 06 — Subsystems: Knowledge Graph, Analytics, IKIGAI, Achievements, Validation, Interview, Retention, Skills & Career

This document specifies the behavioral subsystems that sit on top of the schema.

---

## 1. Knowledge Graph

### Purpose
Model the *relationships* between everything the learner tracks so the system
can answer questions like: *"Which topics advance my AI Engineering Lead path?"*
or *"What must I learn before this certification?"*

### Node types
`topic, skill, project, goal, career_path, certification,
business_initiative, ikigai_dimension, interview_question`.

### Edge (relation) types
| Relation | Meaning | Example |
|---|---|---|
| `requires` | prerequisite dependency | Kubernetes `requires` Containers |
| `depends_on` | soft dependency | RAG `depends_on` Embeddings |
| `advances` | contributes to a goal/career | Agentic AI `advances` AI Eng Lead |
| `applies` | knowledge used in a project | Agentic AI `applies` in Support Bot |
| `teaches` | validated by teaching artifact | Agentic AI `teaches` Blog Post |
| `aligns_with` | purpose linkage | AI Consulting `aligns_with` Vocation |
| `relates_to` | generic association | PQC `relates_to` Cryptography |

### Storage
Single generic table `kg_edges (source_type, source_id, relation,
target_type, target_id, weight)`, unique on the full tuple, indexed on both
endpoints. This avoids a table explosion and lets the graph grow organically.

### Queries (Phase 2 API)
```sql
-- Neighbors of a node
SELECT * FROM kg_edges
WHERE (source_type='topic' AND source_id=:id)
   OR (target_type='topic' AND target_id=:id);

-- Prerequisite chain (recursive)
WITH RECURSIVE chain AS (
  SELECT source_id, target_id FROM kg_edges
  WHERE relation='requires' AND target_id=:topic
  UNION ALL
  SELECT e.source_id, e.target_id FROM kg_edges e
  JOIN chain c ON e.target_id = c.source_id
  WHERE e.relation='requires'
)
SELECT * FROM chain;
```

### Visualization
- **Obsidian graph view** for the note layer (organic, free).
- **Phase 2 SPA** renders `kg_edges` with a force-directed graph (Cytoscape/D3),
  colored by IKIGAI dimension.

---

## 2. IKIGAI Integration

The purpose layer is woven through the whole system, not bolted on.

- **Every topic** has a `primary_ikigai` and a 0–5 star rating per dimension
  (`topic_ikigai_alignment`).
- **Goals & business initiatives** also carry `primary_ikigai`.
- **Analytics** aggregate study minutes per dimension (`v_ikigai_distribution`)
  → the **IKIGAI radar**.
- **Weekly review** captures an `ikigai_alignment` score (0–100).
- **Achievement** `ikigai_balance` rewards touching all four dimensions in a week.

**Alignment score (per topic)** = average of the four dimension stars scaled to
100. **Weekly IKIGAI alignment** = share of study minutes that map to a
dimension × balance factor across the four.

Guiding question enforced by templates: **"Why am I learning this?"**

---

## 3. Achievement / XP System

### Point rules (`xp_rules`)
`Read 1 · Notes 2 · Lab 5 · Quiz 5 · Presentation 10 · Teach 15 · Project 20`.

### Mechanics
- Awarding XP writes an immutable `xp_events` row; a trigger updates
  `topics.xp_total`.
- **Levels** are derived from cumulative XP (display-only), e.g.
  `level = floor(sqrt(total_xp / 25))`.
- **Badges** (`achievements`) unlock via machine-checkable `criteria` JSON,
  evaluated by a Phase 2 rules engine, recorded in `user_achievements`.

### Sample criteria
```json
{ "streak_days": 7 }          // 7-Day Streak
{ "validation_level": 4 }     // The Teacher
{ "ready_categories": 3, "min_score": 80 }  // Interview Ready
{ "weekly_xp": 100 }          // Centurion
{ "dimensions": 4 }           // IKIGAI Balance
```

This turns learning into a **personal RPG** while keeping the signal honest
(XP is earned by real activities, validation gates real mastery).

---

## 4. Validation & Exam System

Nothing is "learned" until it passes validation. Four escalating levels:

| Level | Method | Evidence | Score |
|---|---|---|---|
| **L1 Recall** | Explain in 2 minutes, no notes | self/AI rating | 0–100% |
| **L2 Interview** | Answer 3 interview questions | self/AI/peer | 0–100% |
| **L3 Practical** | Build something (agent, RAG, dashboard) | artifact link | Pass/Fail |
| **L4 Teaching** | Presentation / blog / video / workshop | artifact link | artifact |

Rules:
- Each attempt is a `validations` row (`level`, `method`, `score_pct`,
  `passed`, `artifact_url`, `evaluated_by`).
- **Passing a level promotes** the topic's `maturity_level` (API-enforced).
- A topic reaches **Completed** only after its required levels pass.

### Quiz engine (Phase 2)
`quizzes → quiz_questions → quiz_attempts`. Questions are authored or
AI-generated (`generated_by`), typed (`mcq/short/code/truefalse`), scored per
attempt with per-question detail in JSON. Passing a quiz can auto-create an
L1/L2 validation.

### Exam types roadmap
Quizzes (P1) → Practical labs with artifact capture (P2) → Interview
simulations (P1/P2) → Presentation/teaching capture (P2).

---

## 5. Interview Preparation System

Interview prep is the **highest-priority** learning domain in v1.

### Question bank (`interview_questions`)
Role + category, short & detailed answers, **STAR** fields, confidence (1–5),
spaced review dates.

### Categories & weights (from source)
| Category | Weight |
|---|---:|
| Behavioral | 20% |
| System Design | 20% |
| Coding & Algorithms | 15% |
| AI Engineering | 15% |
| DevOps & Cloud | 15% |
| Security & Reliability | 10% |
| English Communication | 5% |

### Readiness (`interview_readiness`, `v_interview_readiness`)
Per-category score 0–100 derived from avg confidence × coverage. The
`interview_ready` achievement fires at 80+ across three categories.

### Mock interviews (Phase 2)
`interview_simulations` records mode (ai/self/peer), transcript JSON, overall
score, and feedback. The AI interviewer asks one question at a time and grades
with specific feedback (see AI subsystem in `07-Workflows.md`).

### Suggested weekly cadence
```text
Mon Behavioral+English · Tue AI Eng · Wed DevOps+Cloud
Thu System Design · Fri Coding+Security · Sat Mock · Sun Review
```

---

## 6. Learning Retention Engine

### Model
Simplified **SM-2** over a fixed ladder floor `[1, 3, 7, 14, 30, 90]` days.

- Each reviewable entity (`topic` or `question`) has a `review_schedule` row.
- A graded recall (`quality` 0–5) computes the next interval:
  - `quality < 3` → lapse: reset repetitions, relearn from day 1.
  - `quality ≥ 3` → advance the ladder, then `interval × ease_factor`.
  - `ease_factor` updated by SM-2, floored at 1.3.
- **Retention labels:** Excellent (5) · Good (4) · In Review (3) · Weak (1–2) ·
  Forgotten (0). Surfaced in `v_retention_overview`.

Implemented in `api/app/services/retention.py`; exposed via `/retention`.

### Review scheduling
`review_logs` stores each recall event for analytics (retention over time).
The **Due Today** queue (`v_reviews_due`) drives daily practice.

---

## 7. Skill Matrix

`skills` tracks `current_level` vs `target_level` (0–5), `confidence`, and
`last_assessed`. `v_skill_matrix` computes the **gap** for prioritization.

- Skills connect to topics/projects/careers via `kg_edges` (`requires`,
  `advances`).
- **Skill-gap analysis** (Phase 3): rank skills by gap × career weight to
  recommend the next topic.

Heatmap in Metabase: rows = skills, color = gap (green closed → red wide).

---

## 8. Career Roadmaps

`career_paths` → ordered `career_milestones` (Pending/InProgress/Done).

- A career path links to the skills and certifications that `advance` it via
  `kg_edges`.
- **Roadmap view** (Phase 2 SPA): a timeline of milestones with the topics and
  certifications feeding each, plus a readiness rollup.
- Example: *AI Engineering Lead* → milestones: {RAG mastery, Agentic systems,
  System design at scale, Team leadership} each backed by topics + validations.

---

## 9. Learning Analytics (summary)

Analytics are computed in SQL views (see `03-Database-Design.md §6`) and
surfaced by both Metabase and `/analytics`. Core metric philosophy from the
source docs: **measure improvement and usable output, not just hours.**

| Metric family | Views |
|---|---|
| Effort & consistency | `v_daily_study_time`, `v_weekly_study_time` |
| Growth | `v_confidence_improvement`, `v_weekly_xp` |
| Purpose | `v_ikigai_distribution` |
| Mastery | `v_topic_xp`, `v_skill_matrix`, `v_retention_overview` |
| Readiness | `v_interview_readiness`, `v_questions_due` |
| ROI | `v_learning_roi` |
