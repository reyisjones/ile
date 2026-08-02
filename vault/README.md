# ILE Vault (Obsidian)

This folder is the **primary knowledge repository** for the IKIGAI Learning
Engine. Open it directly as an Obsidian vault. Structured metrics live in
PostgreSQL; durable knowledge, notes, and reflections live here.

## Structure

```text
vault/
├── 00-Dashboard/            # Home, MOCs, quick links
├── 01-Learning/            # Highest priority domain
│   ├── Interviews/
│   ├── Work/
│   ├── AI/
│   ├── DevOps/
│   ├── Security/
│   ├── Post-Quantum/
│   ├── English/
│   └── Completed/
├── 02-Business/            # TECHTARIS, clients, ops, finance
│   ├── TECHTARIS/
│   ├── Clients/
│   ├── Operations/
│   └── Finance/
├── 03-Personal/            # Tasks, finance, health, home
│   ├── Tasks/
│   ├── Finance/
│   ├── Health/
│   └── Home/
├── 04-Templates/          # Obsidian templates (Templater-friendly)
├── 10-IKIGAI/             # Purpose layer
│   ├── Passion/
│   ├── Mission/
│   ├── Profession/
│   ├── Vocation/
│   ├── Learning-Achievements/
│   ├── Learning-Scorecards/
│   ├── Annual-Reviews/
│   └── Life-Dashboard/
└── 99-Archive/            # Retired notes
```

## Linking convention

Keep domains separated but linked, never mixed:

```markdown
Related business project: [[TECHTARIS Payment System]]
Learning topic: [[Stripe Integration Security]]
IKIGAI dimension: [[Profession]]
```

## Frontmatter contract (kept in sync with Postgres)

Every Topic note should carry frontmatter so it can be reconciled with the
`topics` table:

```yaml
---
type: topic
title: Agentic AI
category: AI
status: Practicing        # Planned|Learning|Practicing|Applied|Teaching|Completed
maturity: 3               # 0..5
primary_ikigai: Profession
priority: 3               # 1..5
xp_total: 23
retention: Good
---
```
