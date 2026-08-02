# 21 — Product Positioning

What ILE is, who it's for, and why it's different. Companion to
[11-Open-Source-Strategy.md](11-Open-Source-Strategy.md).

---

## 1. One-liner
**ILE (IKIGAI Learning Engine) is a local-first, open-source Personal Learning
Operating System** that unifies learning, knowledge, career growth, interview
prep, and purpose (IKIGAI) — with AI that runs on your own machine and data you
fully own.

## 2. Mission
Give individuals a private, durable system to **learn deliberately, retain what
matters, and align their growth with purpose and career** — without surrendering
their data to a cloud vendor.

## 3. Vision
A world where your learning history, knowledge, and career context are a
**personal asset you own for life** — portable, private, and augmented by AI you
control.

## 4. Value proposition
- **Own your data forever** — Postgres + Markdown on your machine; no lock-in.
- **One system, not ten tabs** — learning, notes, career, interview, IKIGAI, and
  analytics integrated, so insights compound.
- **Private AI** — coaching, quizzes, summaries via a **local** LLM; nothing
  leaves your device by default.
- **Retention by design** — spaced-repetition (SM-2) and validation baked into
  the model, not bolted on.
- **Purpose-aligned** — IKIGAI reflection connects daily learning to what you
  love, what you're good at, what the world needs, and what you can be paid for.
- **Open & extensible** — Apache-2.0, self-hostable, scriptable, plugin-ready.

## 5. Who it's for
- Self-directed learners & career-switchers.
- Engineers/knowledge workers prepping for interviews or leveling up.
- Privacy-conscious "personal knowledge management" power users.
- Builders who want to script/extend their own learning stack.

## 6. Differentiators vs. alternatives

| Tool | What it does well | Gap ILE fills |
|---|---|---|
| **Obsidian** | Local Markdown notes, graph, plugins | No structured learning model, XP/retention, career/IKIGAI, or analytics DB. ILE *uses* an Obsidian vault for notes and adds the engine around it. |
| **Notion** | Flexible docs/DB, collaboration | Cloud-hosted (data not yours), no spaced repetition, no local AI, no purpose framework. |
| **Logseq** | Local outliner, backlinks | Note-centric; no integrated learning/career/interview system or analytics. |
| **Capacities** | Object-based notes | Cloud, note-focused; no retention engine or career/IKIGAI integration. |
| **Anki** | Best-in-class spaced repetition | Flashcards only; no notes, projects, career, analytics, or purpose. ILE embeds SM-2 across the whole learning lifecycle. |
| **Coursera / Udemy** | Course content & delivery | Content consumption, not *your* system of record; no personal knowledge, retention tracking, or career/IKIGAI integration. |
| **Corporate LMS** | Compliance training, org tracking | Org-owned, employer-controlled, not personal, no purpose/PKM. |
| **ChatGPT & cloud AI** | Powerful assistance | Cloud data exposure, no persistent personal model, no local option, no structured learning system. ILE keeps AI **local** and grounded in *your* data. |

**Positioning statement:** *For self-directed learners and career-builders who
refuse to rent their own growth data, ILE is the local-first learning OS that
unifies notes, retention, career, and purpose with private on-device AI — unlike
cloud PKM apps and single-purpose tools that fragment your data and lock it away.*

## 7. Category
ILE defines a **Personal Learning Operating System (PLOS)** — broader than a
note app (PKM), a flashcard app (SRS), or a course platform (LMS). It's the
integration layer that ties them to career and purpose.

## 8. What ILE is *not*
- Not a cloud SaaS you log into (self-hosted by default).
- Not an accredited education or certification provider — in-app levels/XP/
  "readiness" are **personal indicators only** (see [`TERMS.md`](../TERMS.md#5-ai-features--important-disclaimers)).
- Not a data-harvesting product — **no telemetry**, ever, in core.

## 9. Proof points
- Apache-2.0, self-hostable via Docker Compose in minutes.
- 31-table schema + analytics views as the durable system of record.
- Local LLM integration (Ollama) with graceful fail-safe.
- Full open-source governance, security, and privacy documentation.

## 10. Messaging guardrails
Avoid outcome guarantees ("get hired", "guaranteed raise"). Emphasize
**ownership, privacy, integration, and deliberate practice** — the durable,
honest advantages. See [22-Legal-and-Compliance-Assessment.md](22-Legal-and-Compliance-Assessment.md#8-consumer-protection--marketing-guardrails).
