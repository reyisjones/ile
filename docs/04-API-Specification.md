# 04 — API Specification

**Service:** ILE API (FastAPI)
**Base URL (local):** `http://localhost:8000`
**Interactive docs:** `/docs` (Swagger), `/redoc`
**Auth:** single-user mode (no header) by default; `Authorization: Bearer <JWT>`
when `API_SINGLE_USER_MODE=false`.

Conventions:
- JSON everywhere; IDs are UUID strings.
- Timestamps are ISO-8601 (UTC).
- Errors use standard HTTP codes with `{ "detail": "..." }`.
- All list endpoints are implicitly scoped to the current user.

Legend: **[MVP]** implemented in v0.1 · **[P1]/[P2]** planned.

---

## 1. System

| Method | Path | Description |
|---|---|---|
| GET | `/` | Service info + mode. **[MVP]** |
| GET | `/health` | Liveness. **[MVP]** |
| GET | `/ready` | Readiness (DB check). **[MVP]** |

---

## 2. Topics — `/topics` **[MVP]**

| Method | Path | Description |
|---|---|---|
| GET | `/topics?status=&category=` | List topics (filterable). |
| POST | `/topics` | Create a topic. |
| GET | `/topics/{id}` | Get one. |
| PATCH | `/topics/{id}` | Partial update. |
| DELETE | `/topics/{id}` | Delete. |

**Create body**
```json
{
  "title": "Agentic AI",
  "category": "AI",
  "priority": 3,
  "status": "Learning",
  "maturity_level": 1,
  "why_it_matters": "Path to AI Engineering Lead",
  "primary_ikigai": "<ikigai_dimension_uuid>",
  "target_date": "2026-09-01"
}
```

**Response 201** → full topic incl. `id`, `xp_total`, `retention_state`.

---

## 3. Study Sessions — `/sessions` **[MVP]**

| Method | Path | Description |
|---|---|---|
| GET | `/sessions` | Recent sessions (latest 200). |
| POST | `/sessions` | Log a session. |

**Create body**
```json
{
  "topic_id": "<uuid|null>",
  "duration_minutes": 60,
  "session_type": "Interview Practice",
  "focus_score": 4,
  "confidence_before": 2,
  "confidence_after": 4,
  "notes": "Practiced production incident answers."
}
```

---

## 4. XP / Achievements — `/xp` **[MVP]**

| Method | Path | Description |
|---|---|---|
| POST | `/xp/events` | Award XP for an activity (points come from `xp_rules`). |
| GET | `/xp/total` | Total XP for the user. |

**Award body** → `{ "topic_id": "<uuid>", "activity": "Lab", "source": "manual" }`
Activities: `Read, Notes, Lab, Quiz, Presentation, Teach, Project`.

---

## 5. Interview — `/interview` **[MVP]**

| Method | Path | Description |
|---|---|---|
| GET | `/interview/questions?category=` | List questions (weakest first). |
| POST | `/interview/questions` | Add a question (STAR-ready). |
| POST | `/interview/simulate` | Start an AI mock interview. **[P1]** |

---

## 6. Validation — `/validations` **[MVP]**

| Method | Path | Description |
|---|---|---|
| GET | `/validations` | List validation attempts. |
| POST | `/validations` | Record an attempt (level 1–4). Passing promotes maturity. |

**Body** → `{ "topic_id": "<uuid>", "level": 4, "method": "teaching", "passed": true, "artifact_url": "https://..." }`

---

## 7. Retention — `/retention` **[MVP]**

| Method | Path | Description |
|---|---|---|
| GET | `/retention/due` | Items due today. |
| POST | `/retention/{entity_type}/{entity_id}/track` | Start tracking a topic/question. |
| POST | `/retention/{schedule_id}/grade` | Grade recall (0–5); computes next review via SM-2. |

**Grade body** → `{ "quality": 4 }` (0 = blackout … 5 = perfect).

---

## 8. AI Assistant — `/ai` **[P1]** (requires `ai` profile / Ollama)

| Method | Path | Description |
|---|---|---|
| POST | `/ai/generate` | Run a local-LLM task. |

**Body** → `{ "kind": "coach", "prompt": "...", "topic_id": "<uuid|null>" }`
`kind ∈ {coach, quiz, summarize, extract, interview}`.
Returns `{ kind, model, response, latency_ms }`. Logged to `ai_interactions`.
Returns **503** if the local LLM is not running.

---

## 9. Analytics — `/analytics` **[MVP]** (reads SQL views)

| Method | Path | View |
|---|---|---|
| GET | `/analytics/ikigai-distribution` | `v_ikigai_distribution` |
| GET | `/analytics/interview-readiness` | `v_interview_readiness` |
| GET | `/analytics/retention-overview` | `v_retention_overview` |
| GET | `/analytics/learning-roi` | `v_learning_roi` |
| GET | `/analytics/weekly-study` | `v_weekly_study_time` |
| GET | `/analytics/topic-xp` | `v_topic_xp` |

---

## 10. Planned Resources (Phase 2/3)

| Resource | Endpoints | Phase |
|---|---|---|
| Skills | `/skills` CRUD + assess | P1 |
| Goals | `/goals` CRUD + progress | P1 |
| Career paths | `/careers`, `/careers/{id}/milestones` | P1 |
| Certifications | `/certifications` CRUD | P1 |
| Projects | `/projects` CRUD | P1 |
| Business initiatives | `/business` CRUD | P1 |
| Quizzes | `/quizzes`, `/quizzes/{id}/attempts` | P1 |
| Knowledge graph | `/graph/edges`, `/graph/neighbors` | P2 |
| Achievements | `/achievements`, auto-unlock engine | P2 |
| Auth | `/auth/login`, `/auth/register`, `/auth/me` | P2 (multi-user) |
| Vault sync | `/vault/reconcile` (frontmatter ↔ DB) | P2 |

---

## 11. Error Model

| Code | Meaning |
|---|---|
| 400 | Validation / bad activity / bad entity_type. |
| 401 | Missing/invalid token (multi-user mode). |
| 404 | Resource not found or not owned by user. |
| 422 | Pydantic body validation error. |
| 503 | Local LLM unavailable. |

---

## 12. Versioning & Compatibility

- Current: unversioned local API (`0.1.0`).
- Phase 2: introduce `/{v1}` prefix before any breaking change.
- Additive changes (new fields/endpoints) do not bump the major version.
