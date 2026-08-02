# 09 — Publishing & Legal Rationale

Origin rationale for publishing ILE and the legal posture behind it. This is the
*why*; the authoritative, actionable treatment lives in [`TERMS.md`](../TERMS.md),
[`PRIVACY.md`](../PRIVACY.md), [12-Licensing-Guide.md](12-Licensing-Guide.md),
[13-Privacy-Impact-Assessment.md](13-Privacy-Impact-Assessment.md), and
[22-Legal-and-Compliance-Assessment.md](22-Legal-and-Compliance-Assessment.md).

---

## 1. Why ILE is worth publishing

ILE is publishable for general use and differentiated because it combines
capabilities that are usually separate products:

- Learning Management (LMS)
- Knowledge Management (Obsidian-style)
- Personal Knowledge Graph
- Career Development & Interview Preparation
- Goal Tracking & IKIGAI / purpose alignment
- Learning Analytics & AI coaching

That integration — not any single feature — is the unique value.

## 2. Who benefits

| Audience | Value |
|---|---|
| Individuals | Learn faster, retain longer, track career growth, prep for interviews, align learning with purpose. |
| Professionals (SWE, AI, DevOps, security, architects, consultants, researchers) | Structured skill development and interview readiness. |
| Organizations (future) | Employee training, skills tracking, knowledge retention, learning analytics. |
| Educational institutions (future) | Student portfolios, self-directed learning, career-readiness. |

## 3. The real challenge: engagement, not technology

The primary risk is **long-term usage**. Many people start learning systems;
few continue past 30–60 days. The product must minimize manual data entry,
complex workflows, and dashboard overload, and feel **simple, useful, and
motivating**. This directly shapes the MVP scope in
[08-Roadmap-and-Risk.md](08-Roadmap-and-Risk.md).

## 4. Legal essentials for a public release

For the free, self-hosted release the required set is small (all present in the
repo):

- **Terms of Use** — user responsibilities, platform limitations, and explicit
  statements of **no employment guarantees** and **no educational
  accreditation**. → [`TERMS.md`](../TERMS.md)
- **Privacy Policy** — what data exists, where it is stored, whether it is
  shared, and user rights. → [`PRIVACY.md`](../PRIVACY.md)
- **Copyright & license notices** → [`LICENSE`](../LICENSE), [`NOTICE`](../NOTICE)
- **Cookie policy** — only if/when a web UI sets cookies.

## 5. Privacy: the most important area

The platform may hold sensitive information — career goals, study habits,
performance scores, journals, reflections, interview notes, and personal
aspirations. Mitigations, in order of importance:

1. **Local-first by default** — data stays on the user's device (like Obsidian,
   Joplin, Logseq), which sharply reduces legal and compliance burden.
2. **Explicit user control** — the user chooses *Local only* → *Local + Backup*
   → *Cloud Sync*; cloud is never forced.
3. **No telemetry, no tracking, no accounts** in the default mode.

Full analysis: [13-Privacy-Impact-Assessment.md](13-Privacy-Impact-Assessment.md).

## 6. Security posture

For any publicly reachable deployment:

- **Authentication:** prefer passkeys, OAuth/OIDC, and MFA over
  username+password alone.
- **Encryption:** TLS 1.3 in transit; AES-256 at rest (especially for any cloud
  deployment).
- **Secrets:** never store API keys, tokens, or passwords in plaintext; use
  `.env` (git-ignored) and secret managers.

Design and controls: [14-Security-Architecture.md](14-Security-Architecture.md),
[15-Threat-Model.md](15-Threat-Model.md).

## 7. AI-specific risk

Because ILE includes AI coaching:

- **Hallucinations** — users may over-trust AI output; the UI/terms must state it
  may be inaccurate.
- **Career/interview/learning advice** — must be framed as **guidance only**,
  with no guarantees.

These disclaimers are codified in
[`TERMS.md`](../TERMS.md#5-ai-features--important-disclaimers).

## 8. Compliance by stage

| Stage | Typically required |
|---|---|
| Free, self-hosted | Privacy Policy, Terms, copyright notices, cookie policy (if web). |
| Enterprise / hosted | SOC 2, GDPR, CCPA/CPRA, Data Processing Agreements, security reviews. |

Matrix and obligations: [22-Legal-and-Compliance-Assessment.md](22-Legal-and-Compliance-Assessment.md).

## 9. Intellectual property

- **Users own 100% of their content** — notes, reflections, and generated
  output. The platform claims no ownership.
- **Export capability** (Markdown, JSON, CSV, PDF) builds trust and supports
  data-portability rights.

Details: [12-Licensing-Guide.md](12-Licensing-Guide.md#3-user-content-ownership).

## 10. Licensing choice

**Apache 2.0** is preferred over MIT because it adds an explicit patent grant and
is enterprise- and commercial-friendly, leaving room for a future TECHTARIS
offering. An **open-core** model (free community edition; optional
professional/enterprise features later) is the intended path — see
[10-OpenSource.md](10-OpenSource.md) and
[11-Open-Source-Strategy.md](11-Open-Source-Strategy.md).

## 11. Business risks

| Risk | Impact |
|---|---|
| User data loss | Very High |
| Security breach | Very High |
| Privacy violation | Very High |
| User abandonment | High |
| Excessive complexity | High |
| Lack of backups | High |
| AI misinformation | Medium |

Backup/recovery and incident handling: [20-Incident-Response-and-DR.md](20-Incident-Response-and-DR.md).

## 12. Recommended phased release

- **Phase 1 — Local only:** Docker, Obsidian, PostgreSQL, Metabase, local LLM.
  No cloud, no accounts, no telemetry. Keeps legal, security, and privacy risk
  low.
- **Phase 2 — Optional:** sync, AI, and cloud backup as opt-in features.
- **Phase 3 — Evaluate SaaS:** only after ~100+ consistently active users.

Full plan: [08-Roadmap-and-Risk.md](08-Roadmap-and-Risk.md) and [`ROADMAP.md`](../ROADMAP.md).

## 13. Positioning

The strongest positioning is **not** "another LMS," but:

> A **Personal Learning Operating System** that aligns knowledge, career growth,
> business goals, and life purpose through IKIGAI-driven learning and measurable
> skill development.

This differentiates ILE from Obsidian, Notion, Coursera, Udemy, and traditional
LMS platforms. See [21-Product-Positioning.md](21-Product-Positioning.md).
