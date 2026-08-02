# 17 — Plugin Development Guide

How to extend ILE. The plugin surface is intentionally simple and privacy-
preserving: extensions build **on top of** the same local Postgres schema and
REST API that the core uses. Pairs with [16-Community-Playbook.md](16-Community-Playbook.md)
and [14-Security-Architecture.md](14-Security-Architecture.md).

> The formal plugin API is evolving (Phase 2 on the [`ROADMAP.md`](../ROADMAP.md)).
> This guide documents the **stable extension points available today** plus the
> direction for the packaged plugin system.

---

## 1. Extension principles
- **Local-first** — plugins run on the operator's machine; no phoning home.
- **No telemetry** — plugins must not exfiltrate user data. This is a listing
  requirement (see Playbook §8).
- **User owns output** — anything a plugin generates belongs to the user.
- **Least privilege** — request only the DB/API access you need.
- **Additive** — prefer new tables/namespaced keys over mutating core schema;
  schema-affecting changes need an [RFC](16-Community-Playbook.md#rfc-process).

## 2. Extension points available today

### 2.1 REST API
The FastAPI service exposes the primary integration surface. Plugins/scripts call
it over localhost. In single-user mode no auth is required; in multi-user mode
send a JWT bearer token. Treat the OpenAPI schema (`/docs`, `/openapi.json`) as
the contract.

```bash
# Example: read topics and create a session from an external script
curl -s http://localhost:8000/topics
curl -s -X POST http://localhost:8000/sessions \
  -H 'content-type: application/json' \
  -d '{"topic_id":"<uuid>","minutes":25,"notes":"focused block"}'
```

### 2.2 Database (SQL) integrations
Read analytics via the provided **views**; write via the API where possible. If
you write directly to the DB, respect ownership (`user_id`), use parameterized
queries, and never bypass validation for user-facing data.

### 2.3 Obsidian vault
Notes are plain Markdown. Plugins can read/write vault files directly (e.g., to
generate summaries or import content). Preserve front-matter and links.

### 2.4 Automation (n8n, opt-in)
The optional `automation` profile lets you build no-code/low-code workflows that
call the ILE API on triggers/schedules.

### 2.5 Local AI (Ollama, opt-in)
Reuse the local model runtime for coach/quiz/summarize/extract/interview tasks.
Handle the `503` (model unavailable) response gracefully.

## 3. Packaged plugin model (direction)
The Phase-2 plugin system will standardize:
- A **manifest** (name, version, author, permissions, ILE version range).
- **Capabilities/permissions** a plugin declares (e.g., `read:topics`,
  `write:sessions`, `vault:read`).
- A **registration** mechanism and lifecycle hooks.
- Namespaced **storage** so plugins don't collide with core or each other.

The API surface for this will go through the RFC process before it's declared
stable.

## 4. Building a plugin (recommended shape)
1. Create a **separate repository** (Apache-2.0 or compatible recommended).
2. Interact through the **API/views/vault**, not core internals.
3. Namespace any tables/keys you create (e.g., prefix `plugin_<name>_`).
4. Ship a Compose fragment or install script so operators can add it cleanly.
5. Document required permissions and data touched.
6. Provide tests and a clear README.

## 5. Security & privacy requirements
- **No external network calls with user data** unless the user explicitly
  configures and consents to it (and it's clearly disclosed).
- Validate all inputs; use parameterized SQL; never execute AI output.
- Store secrets via env/secret files, never in the repo.
- Follow [15-Threat-Model.md](15-Threat-Model.md) considerations for any new
  entry points you add.

## 6. Compatibility & versioning
- Target a documented ILE version range; follow SemVer expectations in
  [18-Release-and-Versioning.md](18-Release-and-Versioning.md).
- Breaking core-API changes will be announced in the changelog and release notes.

## 7. Getting your plugin listed
Submit to the community plugin index (once published) via the process in
[16-Community-Playbook.md](16-Community-Playbook.md#8-ecosystem--plugins).
Listing requires: local-first, no telemetry, user-owns-data, clear permissions,
and an OSS-compatible license.

## 8. Support
Ask questions in GitHub Discussions; propose new core extension points via an
[RFC](16-Community-Playbook.md#rfc-process).
