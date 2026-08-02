# 22 — Legal & Compliance Assessment

Identifies the legal requirements to satisfy **before public release** and for
future hosted/enterprise stages. Companion to [`PRIVACY.md`](../PRIVACY.md),
[`TERMS.md`](../TERMS.md), [13-Privacy-Impact-Assessment.md](13-Privacy-Impact-Assessment.md),
and [12-Licensing-Guide.md](12-Licensing-Guide.md).

> This is an engineering/compliance assessment, **not legal advice**. Have
> counsel review `TERMS.md`, `PRIVACY.md`, and trademark strategy before a
> commercial launch.

---

## 1. Release-stage matrix

| Requirement | Free OSS (self-host) | Hosted "ILE Cloud" (future) |
|---|---|---|
| License (Apache-2.0) | ✅ Required | ✅ |
| NOTICE / attribution | ✅ | ✅ |
| Privacy Policy | ✅ (software behavior) | ✅ (service; controller duties) |
| Terms of Service/Use | ✅ | ✅ (service terms + SLA) |
| Cookie Policy | ➖ (no web cookies in core) | ✅ (if web app sets cookies) |
| Copyright notices | ✅ | ✅ |
| Trademark strategy | ✅ (stewardship) | ✅ (registration recommended) |
| DPA / sub-processors | ➖ N/A (no data received) | ✅ Required |
| GDPR/CCPA/CPRA controller duties | Operator's responsibility | ✅ Provider is controller/processor |
| SOC 2 / security attestation | ➖ | ✅ (enterprise) |
| Accessibility (WCAG) | Recommended | ✅ (enterprise/public sector) |

**For the current open-source release, the required set is small:** LICENSE,
NOTICE, PRIVACY, TERMS, copyright notices, and trademark stewardship — all
present in this repository.

## 2. Roles under data-protection law

- **Self-hosting:** the operator is the **controller** (and, if they serve other
  users, must meet controller obligations). Maintainers receive no data → not a
  processor; **no DPA applies**.
- **Hosted future:** the provider (TECHTARIS) becomes controller/processor and
  must provide DPAs, sub-processor lists, breach notification, and honor data
  subject rights operationally.

## 3. GDPR (EU/EEA/UK)

| Obligation | How ILE addresses it |
|---|---|
| Lawful basis | Self-use/legitimate interest; consent for opt-in AI/sync. |
| Privacy by design & default (Art. 25) | Local-first, no telemetry, opt-in features. See PIA §4. |
| Transparency (Arts. 13–14) | PRIVACY.md + open source. |
| Data subject rights (Arts. 15–22) | Access/export/rectify/erase/restrict — PIA §5. |
| Portability (Art. 20) | Markdown + SQL/CSV/JSON export. |
| Security (Art. 32) | Encryption guidance, parameterized SQL, RLS-ready. See doc 14. |
| Records / DPIA (Arts. 30, 35) | This assessment + PIA (doc 13). |
| Breach notification (Arts. 33–34) | IR plan (doc 20); operator notifies their authority. |
| International transfers | None by default (local); hosted stage needs SCCs. |

## 4. CCPA / CPRA (California)

- ILE **does not sell or share** personal information and has no capability to.
- Provides the technical means for **know/delete/correct/portability**.
- No cross-context behavioral advertising, no tracking.
- For a hosted service, add "Do Not Sell/Share" (N/A but stated), a privacy
  rights request flow, and required disclosures.

## 5. Other jurisdictions (awareness)
Local-first design generally eases compliance with regimes such as PIPEDA (CA),
LGPD (BR), and similar, because processing occurs on the user's own systems.
Operators remain responsible for their jurisdiction.

## 6. AI-specific legal posture

Mandatory disclaimers are codified in [`TERMS.md`](../TERMS.md#5-ai-features--important-disclaimers):
- AI output may be inaccurate ("hallucinations"); **advisory only**.
- Learning, **career**, interview, and business guidance are **not** professional
  advice and carry **no guarantees**.
- The platform must **never** claim educational accreditation, professional
  certification, or employment/career guarantees. In-app "XP", "levels",
  "readiness", and "certifications" are personal indicators only.
- Emerging AI transparency rules (e.g., EU AI Act for certain uses): ILE's
  personal-productivity, non-decisional use is low-risk; label AI-generated
  content in the UI (Phase 2) and keep the human in the loop.

## 7. Intellectual property

| Item | Position |
|---|---|
| User notes & generated content | **User owns all** (TERMS §4; Licensing §3). |
| Contributor IP | Retained by contributor; DCO sign-off; Apache-2.0 grant. |
| Project code/docs | Apache-2.0. |
| Third-party components | Their own licenses; see doc 12 + SBOM. |
| Copyright notice | "© 2026 TECHTARIS LLC and the ILE contributors". |
| Trademark | ILE / IKIGAI Learning Engine stewarded by TECHTARIS; registration recommended before commercial launch. |

## 8. Consumer-protection & marketing guardrails
Avoid outcome claims ("get hired", "guaranteed promotion"). Use accurate,
non-deceptive descriptions. Keep testimonials truthful and substantiated.

## 9. Export & sanctions
Apache-2.0 OSS distribution is broadly permissible; if bundling cryptography,
note standard OSS crypto exemptions. Comply with applicable sanctions for any
hosted service.

## 10. Pre-publication legal checklist
- [x] LICENSE (Apache-2.0) + NOTICE present.
- [x] PRIVACY.md and TERMS.md present with AI disclaimers and no-guarantee clauses.
- [x] Copyright notice standardized.
- [x] Trademark stewardship documented (doc 12 §7).
- [x] PIA (doc 13) and this assessment complete.
- [ ] Counsel review of TERMS/PRIVACY/trademark before **commercial** launch.
- [ ] Trademark search/registration for "ILE" / "IKIGAI Learning Engine" (pre-commercial).
- [ ] Cookie policy authored **if/when** a web UI sets cookies.

## 11. Conclusion
The **open-source, local-first release is low legal risk** and its required
documents are in place. Elevated obligations (DPA, SOC 2, cookie policy,
registered trademark, counsel-reviewed terms) attach only when a **hosted or
enterprise** offering begins — planned for Phase 3 and gated behind that work.
