# Local Learning & Life Management System

## 1. Purpose

Build a simple, local-first system to organize:

1. **Learning** — highest priority, focused first on interview preparation.
2. **Business** — TECHTARIS projects, client work, operations, and planning.
3. **Personal** — appointments, home tasks, finances, and personal goals.

The system should:

- Run locally with Docker.
- Store data in local folders.
- Keep learning, business, and personal work clearly separated.
- Track study plans, sessions, skills, interview questions, projects, and results.
- Create daily backups automatically.
- Display learning progress through dashboards and graphs.
- Scale later to work-related learning, certifications, research, and other activities.

---

# 2. Recommended Simple Architecture

Use four main components:

| Component | Purpose |
|---|---|
| **Obsidian** | Notes, study material, interview answers, summaries, and knowledge organization |
| **PostgreSQL** | Structured storage for sessions, goals, topics, tasks, and metrics |
| **Metabase** | Dashboards and graphs |
| **Docker Compose** | Local deployment and service management |

Optional later:

- **n8n** for reminders, automation, and scheduled reports.
- **Vikunja** for advanced task management.
- **Local LLM** for private summaries, quizzes, and study reviews.

---

# 3. Core Design Principle

Keep the system divided into three domains:

```text
Learning
Business
Personal
```

Learning remains the highest-priority domain.

Use the following priority order:

```text
1. Interview preparation
2. Current work learning
3. TECHTARIS business learning
4. General technical learning
5. Personal development
```

---

# 4. Local Folder Structure

Create the project in a local folder:

```text
local-learning-system/
├── docker-compose.yml
├── .env
├── README.md
├── data/
│   ├── postgres/
│   ├── metabase/
│   └── backups/
├── scripts/
│   ├── backup.sh
│   ├── restore.sh
│   └── cleanup-backups.sh
├── database/
│   └── init.sql
└── vault/
    ├── 00-Dashboard/
    ├── 01-Learning/
    │   ├── Interviews/
    │   ├── Work/
    │   ├── AI/
    │   ├── DevOps/
    │   ├── Security/
    │   ├── Post-Quantum/
    │   ├── English/
    │   └── Completed/
    ├── 02-Business/
    │   ├── TECHTARIS/
    │   ├── Clients/
    │   ├── Operations/
    │   └── Finance/
    ├── 03-Personal/
    │   ├── Tasks/
    │   ├── Finance/
    │   ├── Health/
    │   └── Home/
    ├── 04-Templates/
    └── 99-Archive/
```

Use the `vault` folder as your Obsidian vault.

---

# 5. Docker Compose

Create `docker-compose.yml`:

```yaml
services:
  postgres:
    image: postgres:16
    container_name: learning-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

  metabase:
    image: metabase/metabase:latest
    container_name: learning-metabase
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
    ports:
      - "3000:3000"
    volumes:
      - ./data/metabase:/metabase-data
    environment:
      MB_DB_FILE: /metabase-data/metabase.db

  backup:
    image: postgres:16
    container_name: learning-backup
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      PGPASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ./data/backups:/backups
      - ./scripts:/scripts:ro
    entrypoint: ["/bin/bash", "-c"]
    command:
      - |
        while true; do
          /scripts/backup.sh
          sleep 86400
        done
```

---

# 6. Environment File

Create `.env`:

```env
POSTGRES_DB=learning_system
POSTGRES_USER=learning_admin
POSTGRES_PASSWORD=change_this_password
```

Do not commit `.env` to Git.

Create `.gitignore`:

```gitignore
.env
data/postgres/
data/metabase/
data/backups/
```

---

# 7. Initial Database Schema

Create `database/init.sql`:

```sql
CREATE TABLE IF NOT EXISTS domains (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO domains (name)
VALUES ('Learning'), ('Business'), ('Personal')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS learning_topics (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    priority INTEGER DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
    status VARCHAR(30) DEFAULT 'Planned',
    target_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS study_sessions (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES learning_topics(id) ON DELETE SET NULL,
    session_date DATE NOT NULL DEFAULT CURRENT_DATE,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    session_type VARCHAR(50),
    focus_score INTEGER CHECK (focus_score BETWEEN 1 AND 5),
    confidence_before INTEGER CHECK (confidence_before BETWEEN 1 AND 5),
    confidence_after INTEGER CHECK (confidence_after BETWEEN 1 AND 5),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS interview_questions (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(150),
    category VARCHAR(100),
    question TEXT NOT NULL,
    answer_summary TEXT,
    confidence_score INTEGER DEFAULT 1 CHECK (confidence_score BETWEEN 1 AND 5),
    last_practiced DATE,
    next_review DATE,
    status VARCHAR(30) DEFAULT 'Open'
);

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER REFERENCES domains(id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    priority INTEGER DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
    status VARCHAR(30) DEFAULT 'Open',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS weekly_reviews (
    id SERIAL PRIMARY KEY,
    week_start DATE NOT NULL,
    wins TEXT,
    blockers TEXT,
    lessons_learned TEXT,
    next_week_focus TEXT,
    learning_score INTEGER CHECK (learning_score BETWEEN 1 AND 10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

# 8. Daily Backup Process

Create `scripts/backup.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/learning_system_${TIMESTAMP}.sql.gz"

mkdir -p "${BACKUP_DIR}"

pg_dump \
  -h postgres \
  -U learning_admin \
  -d learning_system \
  | gzip > "${BACKUP_FILE}"

find "${BACKUP_DIR}" \
  -type f \
  -name "*.sql.gz" \
  -mtime +30 \
  -delete

echo "Backup created: ${BACKUP_FILE}"
```

Make it executable:

```bash
chmod +x scripts/backup.sh
```

This process:

- Creates one backup every 24 hours.
- Stores backups in `data/backups`.
- Retains backups for 30 days.
- Removes older backups automatically.

For better protection, periodically copy the backup folder to:

- An encrypted external drive.
- A second local computer.
- An encrypted private cloud location.

---

# 9. Restore Process

Create `scripts/restore.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /backups/backup-file.sql.gz"
  exit 1
fi

BACKUP_FILE="$1"

gunzip -c "${BACKUP_FILE}" | psql \
  -h postgres \
  -U learning_admin \
  -d learning_system

echo "Restore completed from ${BACKUP_FILE}"
```

Example:

```bash
docker exec -it learning-backup \
  /scripts/restore.sh \
  /backups/learning_system_2026-08-02_08-00-00.sql.gz
```

---

# 10. Starting the System

Run:

```bash
docker compose up -d
```

Check services:

```bash
docker compose ps
```

Open Metabase:

```text
http://localhost:3000
```

Connect Metabase to PostgreSQL:

```text
Host: postgres
Port: 5432
Database: learning_system
Username: learning_admin
Password: value from .env
```

---

# 11. Obsidian Note Structure

## Daily Learning Note

Create a daily note using this template:

```markdown
# Daily Learning - {{date}}

## Main Priority

- Topic:
- Interview role:
- Desired outcome:

## Study Sessions

### Session 1

- Start:
- End:
- Duration:
- Topic:
- Activity:
- Focus score: /5
- Confidence before: /5
- Confidence after: /5

## Questions Practiced

1.
2.
3.

## What I Learned

-

## What I Could Not Explain Clearly

-

## Next Action

-
```

## Topic Note

```markdown
# Topic: {{title}}

## Category

Interview / Work / AI / DevOps / Security / English / Other

## Why This Matters

-

## Learning Objective

-

## Core Concepts

-

## Practical Example

-

## Interview Questions

-

## Weak Areas

-

## Next Review

-
```

## Interview Question Note

```markdown
# Interview Question

## Role

-

## Category

Behavioral / System Design / Coding / AI / DevOps / Security

## Question

-

## Short Answer

-

## Detailed Answer

-

## STAR Structure

### Situation

-

### Task

-

### Action

-

### Result

-

## Confidence

1 / 2 / 3 / 4 / 5

## Last Practiced

-

## Next Review

-
```

## Weekly Review

```markdown
# Weekly Learning Review

## Wins

-

## Topics Completed

-

## Total Study Time

-

## Strongest Improvement

-

## Weakest Area

-

## Interview Questions Practiced

-

## Blockers

-

## Next Week Priority

1.
2.
3.

## Weekly Score

- Focus: /10
- Consistency: /10
- Confidence: /10
- Interview readiness: /10
```

---

# 12. Learning Workflow

Use this simple cycle:

```text
Plan → Learn → Practice → Test → Review → Improve
```

## Step 1: Plan

At the start of each week:

- Select one primary interview role.
- Select three high-priority topics.
- Define one practical result for each topic.
- Limit active learning topics to five.

## Step 2: Learn

For each topic:

- Read documentation.
- Watch one focused lesson.
- Take concise notes.
- Build a small example.
- Explain the concept in your own words.

## Step 3: Practice

Practice using:

- Interview questions.
- Coding exercises.
- System-design diagrams.
- Verbal explanations.
- Mock interviews.
- English technical speaking.

## Step 4: Test

Test your knowledge without notes:

- Explain the topic in two minutes.
- Answer three interview questions.
- Build a small example.
- Compare your result with trusted documentation.
- Record confidence before and after.

## Step 5: Review

Use spaced review intervals:

```text
Day 1
Day 3
Day 7
Day 14
Day 30
```

## Step 6: Improve

At the end of each week:

- Remove low-value activities.
- Identify repeated weaknesses.
- Increase practice for weak topics.
- Move completed topics to the archive.
- Select next week's focus.

---

# 13. Interview-First Study Model

Use the following categories:

| Category | Suggested Weight |
|---|---:|
| Behavioral answers | 20% |
| System design | 20% |
| Coding and algorithms | 15% |
| AI engineering | 15% |
| DevOps and cloud | 15% |
| Security and reliability | 10% |
| English communication | 5% |

Example weekly target:

```text
Monday: Behavioral + English
Tuesday: AI Engineering
Wednesday: DevOps + Cloud
Thursday: System Design
Friday: Coding + Security
Saturday: Mock Interview
Sunday: Weekly Review
```

---

# 14. Data Entry Process

For the first version, keep data entry simple.

After each study session, insert one row into `study_sessions`.

Example:

```sql
INSERT INTO study_sessions (
    topic_id,
    duration_minutes,
    session_type,
    focus_score,
    confidence_before,
    confidence_after,
    notes
)
VALUES (
    1,
    60,
    'Interview Practice',
    4,
    2,
    4,
    'Practiced production incident and challenging project answers.'
);
```

Later, create a simple web form or use n8n to enter data without SQL.

---

# 15. Recommended Dashboard

Create a Metabase dashboard named:

```text
Learning Command Center
```

Add these cards:

## Daily Study Time

```sql
SELECT
    session_date,
    SUM(duration_minutes) AS total_minutes
FROM study_sessions
GROUP BY session_date
ORDER BY session_date;
```

Graph:

- Line chart.
- X-axis: date.
- Y-axis: study minutes.

## Weekly Study Time

```sql
SELECT
    DATE_TRUNC('week', session_date) AS week,
    SUM(duration_minutes) AS total_minutes
FROM study_sessions
GROUP BY week
ORDER BY week;
```

Graph:

- Bar chart.

## Confidence Improvement

```sql
SELECT
    session_date,
    AVG(confidence_after - confidence_before) AS average_improvement
FROM study_sessions
GROUP BY session_date
ORDER BY session_date;
```

Graph:

- Line chart.

## Study Time by Type

```sql
SELECT
    session_type,
    SUM(duration_minutes) AS total_minutes
FROM study_sessions
GROUP BY session_type
ORDER BY total_minutes DESC;
```

Graph:

- Pie or bar chart.

## Interview Readiness

```sql
SELECT
    category,
    AVG(confidence_score) AS average_confidence,
    COUNT(*) AS total_questions
FROM interview_questions
GROUP BY category
ORDER BY average_confidence;
```

Graph:

- Horizontal bar chart.

## Open Questions Requiring Review

```sql
SELECT
    category,
    question,
    confidence_score,
    next_review
FROM interview_questions
WHERE status <> 'Completed'
  AND (
    next_review IS NULL
    OR next_review <= CURRENT_DATE
  )
ORDER BY confidence_score, next_review;
```

Display:

- Table.

---

# 16. Core Learning Metrics

Track only useful metrics.

## Consistency

```text
Number of study days per week
```

Target:

```text
5 or more days
```

## Time

```text
Total focused study minutes
```

Initial target:

```text
300 to 600 minutes per week
```

## Confidence Improvement

```text
Confidence after - confidence before
```

## Interview Coverage

```text
Questions practiced by category
```

## Retention

```text
Questions answered correctly after 7 or 30 days
```

## Output

```text
Projects, diagrams, written answers, demos, or explanations completed
```

Avoid measuring only hours. The main goal is improvement and usable output.

---

# 17. Separation Rules

## Learning

Contains:

- Study plans.
- Interview preparation.
- Technical topics.
- Practice questions.
- Research.
- Certifications.
- Learning projects.

## Business

Contains:

- TECHTARIS operations.
- Client projects.
- Sales.
- CRM.
- Payments.
- Business documentation.
- Business finances.

## Personal

Contains:

- Appointments.
- Home tasks.
- Personal finances.
- Family commitments.
- Personal goals.

Do not mix business tasks inside learning notes.

Instead, link them:

```markdown
Related business project: [[TECHTARIS Payment System]]
Learning topic: [[Stripe Integration Security]]
```

---

# 18. Priority System

Use five priority levels:

```text
P1 - Critical
P2 - High
P3 - Normal
P4 - Low
P5 - Someday
```

For the current phase:

```text
P1: Interview preparation
P2: Current Microsoft work learning
P3: TECHTARIS learning
P4: General technology learning
P5: Optional exploration
```

Limit daily work to:

```text
1 main learning goal
2 supporting tasks
1 review task
```

---

# 19. Daily Process

## Morning

1. Open the Learning Dashboard.
2. Choose one interview topic.
3. Select one measurable result.
4. Schedule one or two focused sessions.

## During Study

1. Start a timer.
2. Study one topic only.
3. Take concise notes.
4. Practice without notes.
5. Record confidence.

## End of Day

1. Record session duration.
2. Record what improved.
3. Record what remains unclear.
4. Schedule the next review.
5. Confirm that the backup completed.

---

# 20. Weekly Process

Every Sunday:

1. Review total study time.
2. Review confidence changes.
3. Identify the weakest category.
4. Review missed study days.
5. Choose next week's interview role.
6. Select three priority topics.
7. Archive completed work.
8. Confirm backups are valid.

---

# 21. Scaling the System

## Phase 1 — Simple Foundation

- Obsidian notes.
- PostgreSQL.
- Metabase.
- Daily backup.
- Manual session entry.

## Phase 2 — Simple Automation

Add n8n for:

- Daily study reminder.
- Weekly summary.
- Automatic review scheduling.
- Backup verification.
- Dashboard refresh notifications.

## Phase 3 — Local AI Assistance

Use local LLMs for:

- Generate quizzes.
- Review interview answers.
- Create flashcards.
- Summarize notes.
- Detect weak topics.
- Generate weekly study plans.

## Phase 4 — Advanced Learning Analytics

Add:

- Retention scores.
- Topic dependency maps.
- Knowledge graphs.
- Skill-gap analysis.
- Role-based interview readiness.
- Adaptive study recommendations.

---

# 22. Recommended First Interview Categories

Create these first:

```text
Behavioral
Production Incidents
Challenging Projects
System Design
Azure
DevOps
Service Fabric
Observability
Security
AI Engineering
RAG and Agentic AI
Coding
English Communication
```

Create at least five questions for each high-priority category.

---

# 23. Initial 14-Day Setup Plan

## Days 1-2

- Create folder structure.
- Install Docker Desktop.
- Create Docker Compose files.
- Start PostgreSQL and Metabase.

## Days 3-4

- Open the Obsidian vault.
- Add templates.
- Add current interview notes.
- Create the first ten interview questions.

## Days 5-7

- Record daily sessions.
- Build the first dashboard.
- Test backup generation.
- Test one restore.

## Week 2

- Track consistency.
- Practice interview answers.
- Review confidence metrics.
- Adjust the system.
- Add work and business learning topics only after the interview workflow is stable.

---

# 24. Minimum Viable System

Do not build too much at the beginning.

The first usable version only needs:

```text
Obsidian
PostgreSQL
Metabase
Daily backup
Three note templates
Five dashboard cards
One weekly review
```

The system is successful when it helps you:

- Know what to study next.
- Practice consistently.
- See weak areas.
- Improve interview confidence.
- Avoid mixing learning with business and personal tasks.
- Keep all data stored locally.
- Recover data from a backup.
