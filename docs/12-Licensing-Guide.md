# 12 — Licensing Guide

How ILE is licensed, why, how it interacts with third-party components, and how
the trademark is handled.

---

## 1. Project license: Apache 2.0

ILE's own source code and documentation are licensed under the **Apache License,
Version 2.0** ([`LICENSE`](../LICENSE), [`NOTICE`](../NOTICE)). Rationale:
commercial-friendly, explicit patent grant, enterprise-accepted, permissive for
adoption. See [11-Open-Source-Strategy.md](11-Open-Source-Strategy.md#2-why-apache-20).

### Applying license headers
New source files should carry the short header (see the LICENSE appendix):

```python
# Copyright 2026 TECHTARIS LLC and the ILE contributors
# SPDX-License-Identifier: Apache-2.0
```

SQL/YAML/Markdown may use the equivalent comment syntax; docs don't require a
header.

## 2. Contributions: DCO, not CLA

Contributions are accepted under the **Developer Certificate of Origin**
(sign-off via `git commit -s`). Contributors **retain copyright**; the sign-off
certifies the right to contribute under Apache 2.0. There is **no CLA** and no
copyright assignment. See [`CONTRIBUTING.md`](../CONTRIBUTING.md#developer-certificate-of-origin-dco).

## 3. User content ownership

**Users own 100% of their content** — notes, reflections, answers, goals, and
any AI-assisted output they generate in their instance. The project claims no
license over user data. This is stated in [`TERMS.md`](../TERMS.md#4-your-content-and-ownership)
and [`PRIVACY.md`](../PRIVACY.md).

## 4. Third-party components & compatibility

ILE **orchestrates** independent open-source software rather than embedding it.
Components are pulled as container images or Python dependencies at deploy time.

| Component | License | How ILE uses it | Compatibility |
|---|---|---|---|
| PostgreSQL | PostgreSQL License (permissive) | Separate container | ✅ |
| FastAPI, Starlette | MIT | Python dependency | ✅ |
| SQLAlchemy | MIT | Python dependency | ✅ |
| Pydantic | MIT | Python dependency | ✅ |
| Uvicorn | BSD-3-Clause | Python dependency | ✅ |
| httpx | BSD-3-Clause | Python dependency | ✅ |
| psycopg | LGPL-3.0 | Python dependency (dynamically linked, unmodified) | ✅ (no relinking obligations for use) |
| python-jose, passlib | MIT/BSD | Python dependency | ✅ |
| Ollama | MIT | Separate container (opt-in) | ✅ |
| Metabase | **AGPL-3.0** (OSS edition) | **Separate container**, unmodified | ✅ see §5 |
| n8n | Sustainable Use License | Separate container (opt-in) | ⚠️ see §6 |
| Obsidian | Proprietary (free personal use) | Host app; ILE only reads/writes Markdown | ✅ no redistribution |

The authoritative, versioned inventory is the **SBOM** generated in CI
(`ile-sbom.spdx.json`), plus `api/requirements.txt`.

## 5. Metabase (AGPL) — why it's fine

Metabase's open-source edition is **AGPL-3.0**. AGPL's network-copyleft applies
to *modified* versions of Metabase offered over a network. ILE:
- Ships **no modified Metabase**; it runs the **official image unchanged**.
- Communicates with it as a **separate service** over the network (arm's-length),
  which does **not** make ILE a derivative of Metabase.

Therefore ILE remains Apache-2.0. Anyone who *modifies* the Metabase container
and offers it over a network must comply with AGPL for that component — an
obligation on them, not on ILE. Metabase is also **optional**: dashboards are a
convenience layer over Postgres views; the API exposes the same analytics.

## 6. n8n (Sustainable Use License) — usage note

n8n is under the **Sustainable Use License** (source-available, not OSI-open).
ILE only offers it as an **optional `automation` profile** and does not
redistribute or modify it. Self-hosting n8n for internal automation is permitted
under its license. If a fully-OSI stack is required, users can disable the
`automation` profile; core ILE does not depend on n8n.

## 7. Trademark
<a id="trademark"></a>

The **code** is Apache-2.0, but the Apache License **does not grant trademark
rights** (License §6). The names **"ILE"** and **"IKIGAI Learning Engine"** and
associated logos are stewarded by **TECHTARIS LLC**.

**Permitted:** stating that your product/fork "uses" or "is based on ILE";
nominative references in docs and talks.
**Not permitted:** using the ILE name/logo in a way that implies official
endorsement, or naming a competing distribution "ILE" in a confusing way.
Forks must rename user-facing branding if they diverge materially.

Rationale: protecting the name prevents user confusion about which distribution
is authentic — a *trust* safeguard, fully compatible with open source (same
pattern as many CNCF/Apache projects).

## 8. Compliance obligations when redistributing ILE

If you redistribute ILE (Source or Object):
1. Include the [`LICENSE`](../LICENSE) and [`NOTICE`](../NOTICE) files.
2. Retain existing copyright/attribution notices.
3. Mark files you changed as modified.
4. Don't use the ILE trademarks to imply endorsement.

## 9. Changing the license
The core license will **not** be made more restrictive. Any license change
requires an RFC and steering approval and would apply only to future versions;
existing releases remain under Apache-2.0 irrevocably.
