# 16 — Community Playbook

How the ILE community works: onboarding contributors, running the RFC process,
managing issues, and growing a healthy ecosystem. Pairs with
[`CONTRIBUTING.md`](../CONTRIBUTING.md), [`GOVERNANCE.md`](../GOVERNANCE.md), and
[`CODE_OF_CONDUCT.md`](../CODE_OF_CONDUCT.md).

---

## 1. Community principles
- **User-owned, local-first** — decisions preserve data ownership and privacy.
- **Kind and rigorous** — the Code of Conduct is enforced; feedback is direct
  but respectful.
- **Lazy consensus** — proposals proceed unless someone objects with reasons.
- **Show your work** — design in the open via issues and RFCs.

## 2. Contributor onboarding
1. Read [`CONTRIBUTING.md`](../CONTRIBUTING.md) and this playbook.
2. Set up the dev environment (Docker Compose, `ile` project name).
3. Find a **`good first issue`** or **`help wanted`** label.
4. Comment to claim it; ask questions in Discussions.
5. Open a PR: DCO sign-off (`git commit -s`), Conventional Commits, tests, green
   CI. See the pull-request template.
6. A maintainer reviews; iterate; merge.

### Ladder
`User → Contributor → Maintainer → Steering` (TECHTARIS as steward). Criteria in
[`GOVERNANCE.md`](../GOVERNANCE.md).

## 3. Issue & feature workflow

| Stage | Label | Meaning |
|---|---|---|
| Intake | `triage` | Needs maintainer review. |
| Ready | `good first issue`, `help wanted` | Open for contributors. |
| In progress | `in progress` | Someone is working on it. |
| Blocked | `blocked` | Waiting on a dependency/decision. |
| Needs RFC | `rfc-needed` | Significant change → open an RFC. |

- **Bugs & features:** use the issue forms in `.github/ISSUE_TEMPLATE/`.
- **Security:** never in public issues — see [`SECURITY.md`](../SECURITY.md).
- **Questions:** GitHub Discussions.

## 4. RFC process
<a id="rfc-process"></a>

The **RFC (Request for Comments)** process is how larger changes get proposed,
discussed, and accepted. It is the anchor referenced from
[`CONTRIBUTING.md`](../CONTRIBUTING.md), [`GOVERNANCE.md`](../GOVERNANCE.md), and
[`ROADMAP.md`](../ROADMAP.md).

### When an RFC is required
- New user-facing subsystems or modules.
- Database **schema changes** affecting existing data / migrations.
- Public **API contract** changes (breaking or additive-significant).
- Security, privacy, or licensing-affecting changes.
- Anything altering data ownership, telemetry, or default privacy posture.
- The **plugin API** surface (see [17-Plugin-Development-Guide.md](17-Plugin-Development-Guide.md)).

Small fixes, docs, and internal refactors **do not** need an RFC.

### How it works
1. **Draft** — open an issue titled `RFC: <title>` (or a PR adding a doc under
   `docs/rfcs/` if adopted) covering: problem, motivation, proposed design,
   alternatives, data/privacy/security impact, migration plan, and open
   questions.
2. **Discuss** — the community comments; author revises. Minimum **comment
   window of 7 days** for non-trivial RFCs.
3. **Decide** — **lazy consensus**: if there are no unresolved substantive
   objections after the window, it's **accepted**. Contested RFCs are decided by
   maintainers; the steward (TECHTARIS) breaks ties, favoring user ownership and
   privacy.
4. **Record** — mark Accepted/Rejected/Deferred with a short rationale.
5. **Implement** — track via linked issues/PRs; update docs and
   [`CHANGELOG.md`](../CHANGELOG.md).

### RFC states
`Draft → In Review → Accepted / Rejected / Deferred → Implemented`

## 5. Review expectations
- CI must be green (ruff, tests, DB validation, security scans, SBOM).
- At least one maintainer approval; two for security/schema-sensitive changes.
- Reviews focus on correctness, privacy/security impact, and fit with the
  local-first philosophy.

## 6. Communication channels
- **GitHub Issues** — bugs & tracked work.
- **GitHub Discussions** — questions, ideas, RFC pre-discussion, showcases.
- **Security advisories / security@techtaris.com** — vulnerabilities only.
- **Conduct reports** — conduct@techtaris.com.

## 7. Recognition
Contributors are credited in release notes and the changelog. Sustained,
high-quality contribution is the path to maintainer status.

## 8. Ecosystem & plugins
Third-party plugins/integrations are encouraged and live in their own repos.
See [17-Plugin-Development-Guide.md](17-Plugin-Development-Guide.md). Plugins must
respect the local-first, no-telemetry, user-owns-data principles to be listed in
the community index.

## 9. Moderation
Maintainers enforce the [`CODE_OF_CONDUCT.md`](../CODE_OF_CONDUCT.md). Escalation
path and enforcement ladder are defined there and in [`GOVERNANCE.md`](../GOVERNANCE.md).
