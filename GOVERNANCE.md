# ILE Governance

This document describes how the **ILE — IKIGAI Learning Engine** project is
governed and how decisions are made. It is intentionally lightweight for the
project's current stage and will evolve with the community.

## Guiding values
- **Open, transparent, and local-first.** Decisions and roadmaps are public.
- **User data ownership is non-negotiable.** No change may compromise the
  local-first, privacy-by-default posture of the core.
- **The core stays open source (Apache 2.0).** Commercial offerings, if any,
  are built *around* the open core, never by closing it.

## Roles

### Users
Anyone running ILE. Users contribute by filing issues, feedback, and ideas.

### Contributors
Anyone who submits an accepted change (code, docs, design, triage). Recognized
in the release notes and, over time, in `MAINTAINERS.md`.

### Maintainers
Contributors with merge rights for one or more areas (API, database, docs,
infra, plugins). Responsibilities:
- Review and merge PRs; triage issues; uphold the Code of Conduct.
- Cut releases and maintain the roadmap for their area.
- Mentor new contributors.

New maintainers are nominated by an existing maintainer after a sustained track
record of quality contributions, and confirmed by lazy consensus of the
maintainer group (see below).

### Steering / BDFL (current stage)
While the project is young, **TECHTARIS LLC** (project founder) acts as the
final arbiter (BDFL-style) for decisions that cannot reach consensus and for
trademark stewardship. The intent is to transition to a **maintainer-council**
model as the community grows (see *Evolution* below).

## Decision making

We use **lazy consensus**:
- Proposals are made via issues, PRs, or RFCs.
- If no maintainer objects within a reasonable review window (typically 72
  hours for non-trivial changes), the proposal is accepted.
- Objections must be substantive and include an alternative path.
- Unresolved disagreements escalate to the steering role for a final decision.

**RFCs** are required for: schema-breaking changes, new external dependencies,
security-sensitive changes, plugin API changes, and anything affecting the
privacy/local-first guarantees. See the
[Community Playbook](docs/16-Community-Playbook.md#rfc-process).

## Areas & ownership
Ownership is expressed in [`.github/CODEOWNERS`](.github/CODEOWNERS). Current
areas: `api/`, `database/`, `docs/`, `scripts/`, `vault/`, `docker-compose.yml`,
and (future) `plugins/`, `frontend/`.

## Releases
Maintainers cut releases following [SUPPORTED_VERSIONS.md](SUPPORTED_VERSIONS.md)
and the release process in
[docs/18-Release-and-Versioning.md](docs/18-Release-and-Versioning.md).

## Code of Conduct
All participants must follow the [Code of Conduct](CODE_OF_CONDUCT.md).
Enforcement decisions are made by maintainers; appeals go to the steering role.

## Trademark
"ILE", "IKIGAI Learning Engine", and associated logos are stewarded by TECHTARIS
LLC (see [docs/12-Licensing-Guide.md](docs/12-Licensing-Guide.md#trademark)).
The code is Apache-2.0; the name/brand is protected to prevent user confusion.
Forks are welcome but must not imply official endorsement.

## Changing this document
Amendments to governance are proposed via PR + RFC and require steering approval
during the current stage.

## Evolution
Planned governance milestones:
1. **Now** — Founder-led (BDFL), lazy consensus among early maintainers.
2. **500+ users / ≥3 independent maintainers** — form a **Maintainer Council**;
   move final decisions to a documented majority vote.
3. **Foundation stage (optional)** — evaluate donating the trademark/governance
   to a neutral foundation if the community warrants it.
