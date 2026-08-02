-- =====================================================================
-- ILE — IKIGAI Learning Engine
-- 001_schema.sql — Core relational schema (system of record)
--
-- Conventions:
--   * UUID primary keys (multi-tenant / SaaS ready)
--   * Every user-owned row carries user_id for future row-level security
--   * updated_at maintained by trigger
--   * Enums modeled as CHECK constraints (portable, easy to evolve)
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pg_trgm";     -- fuzzy search on titles
CREATE EXTENSION IF NOT EXISTS "citext";      -- case-insensitive email

-- ---------------------------------------------------------------------
-- Shared updated_at trigger
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- 1. IDENTITY & DOMAINS
-- =====================================================================

CREATE TABLE users (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email         CITEXT,
    display_name  VARCHAR(120) NOT NULL,
    password_hash TEXT,                       -- null in single-user mode
    role          VARCHAR(20) NOT NULL DEFAULT 'owner'
                    CHECK (role IN ('owner','member','coach','admin')),
    timezone      VARCHAR(64) NOT NULL DEFAULT 'UTC',
    settings      JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX users_email_key ON users (email) WHERE email IS NOT NULL;

-- Top-level life domains: Learning / Business / Personal
CREATE TABLE domains (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       VARCHAR(50) UNIQUE NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0
);

-- IKIGAI dimensions: Passion / Mission / Profession / Vocation
CREATE TABLE ikigai_dimensions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(30) UNIQUE NOT NULL,
    description TEXT,
    color_hex   VARCHAR(7) NOT NULL DEFAULT '#4C6EF5'
);

-- Learning maturity levels (0 Discovered → 5 Expert)
CREATE TABLE maturity_levels (
    level       INTEGER PRIMARY KEY CHECK (level BETWEEN 0 AND 5),
    name        VARCHAR(30) NOT NULL,
    description TEXT
);

-- =====================================================================
-- 2. LEARNING CORE — Topics, Skills, Sessions
-- =====================================================================

CREATE TABLE topics (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           VARCHAR(200) NOT NULL,
    slug            VARCHAR(220),
    category        VARCHAR(100),               -- Interview / Work / AI / DevOps ...
    domain_id       UUID REFERENCES domains(id),
    priority        INTEGER NOT NULL DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
    status          VARCHAR(30) NOT NULL DEFAULT 'Planned'
                      CHECK (status IN ('Planned','Learning','Practicing','Applied','Teaching','Completed','Archived')),
    maturity_level  INTEGER NOT NULL DEFAULT 0 REFERENCES maturity_levels(level),
    -- Why am I learning this? (IKIGAI narrative)
    why_it_matters  TEXT,
    primary_ikigai  UUID REFERENCES ikigai_dimensions(id),
    vault_path      TEXT,                       -- link to Obsidian note
    target_date     DATE,
    xp_total        INTEGER NOT NULL DEFAULT 0,
    retention_state VARCHAR(20) NOT NULL DEFAULT 'New'
                      CHECK (retention_state IN ('New','Excellent','Good','Weak','Forgotten','InReview')),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at    TIMESTAMPTZ
);
CREATE INDEX topics_user_idx ON topics (user_id);
CREATE INDEX topics_status_idx ON topics (status);
CREATE INDEX topics_title_trgm ON topics USING gin (title gin_trgm_ops);
CREATE TRIGGER trg_topics_updated BEFORE UPDATE ON topics
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Per-topic IKIGAI alignment scorecard (1..5 stars per dimension)
CREATE TABLE topic_ikigai_alignment (
    topic_id     UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    dimension_id UUID NOT NULL REFERENCES ikigai_dimensions(id) ON DELETE CASCADE,
    stars        INTEGER NOT NULL DEFAULT 0 CHECK (stars BETWEEN 0 AND 5),
    PRIMARY KEY (topic_id, dimension_id)
);

-- Skills — reusable competencies, independent of a single topic
CREATE TABLE skills (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name           VARCHAR(150) NOT NULL,
    category       VARCHAR(100),
    current_level  INTEGER NOT NULL DEFAULT 0 CHECK (current_level BETWEEN 0 AND 5),
    target_level   INTEGER NOT NULL DEFAULT 3 CHECK (target_level BETWEEN 0 AND 5),
    confidence     INTEGER NOT NULL DEFAULT 1 CHECK (confidence BETWEEN 1 AND 5),
    last_assessed  DATE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, name)
);
CREATE TRIGGER trg_skills_updated BEFORE UPDATE ON skills
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Study / practice sessions
CREATE TABLE study_sessions (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic_id          UUID REFERENCES topics(id) ON DELETE SET NULL,
    session_date      DATE NOT NULL DEFAULT CURRENT_DATE,
    duration_minutes  INTEGER NOT NULL CHECK (duration_minutes > 0),
    session_type      VARCHAR(50),              -- Read / Notes / Lab / Quiz / Practice ...
    focus_score       INTEGER CHECK (focus_score BETWEEN 1 AND 5),
    confidence_before INTEGER CHECK (confidence_before BETWEEN 1 AND 5),
    confidence_after  INTEGER CHECK (confidence_after BETWEEN 1 AND 5),
    notes             TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX sessions_user_date_idx ON study_sessions (user_id, session_date);
CREATE INDEX sessions_topic_idx ON study_sessions (topic_id);

-- =====================================================================
-- 3. ACHIEVEMENT / XP SYSTEM
-- =====================================================================

-- Point rules: Read=1, Notes=2, Lab=5, Quiz=5, Presentation=10, Teach=15, Project=20
CREATE TABLE xp_rules (
    activity   VARCHAR(40) PRIMARY KEY,
    points     INTEGER NOT NULL,
    description TEXT
);

-- Immutable ledger of XP-earning events
CREATE TABLE xp_events (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic_id   UUID REFERENCES topics(id) ON DELETE SET NULL,
    activity   VARCHAR(40) NOT NULL REFERENCES xp_rules(activity),
    points     INTEGER NOT NULL,
    source     VARCHAR(40) NOT NULL DEFAULT 'manual', -- manual / session / exam / automation
    ref_id     UUID,                                   -- optional link to session/exam
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX xp_events_user_idx ON xp_events (user_id, created_at);

-- Badge / achievement definitions and unlocks
CREATE TABLE achievements (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code        VARCHAR(60) UNIQUE NOT NULL,
    name        VARCHAR(120) NOT NULL,
    description TEXT,
    icon        VARCHAR(60),
    criteria    JSONB NOT NULL DEFAULT '{}'::jsonb  -- machine-checkable rule
);

CREATE TABLE user_achievements (
    user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    unlocked_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, achievement_id)
);

-- Keep topics.xp_total in sync with the ledger
CREATE OR REPLACE FUNCTION apply_xp_to_topic()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.topic_id IS NOT NULL THEN
        UPDATE topics SET xp_total = xp_total + NEW.points WHERE id = NEW.topic_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_xp_topic AFTER INSERT ON xp_events
    FOR EACH ROW EXECUTE FUNCTION apply_xp_to_topic();

-- =====================================================================
-- 4. VALIDATION & EXAM ENGINE
-- =====================================================================

-- A validation is one attempt to prove knowledge at a given level.
-- Level 1 Recall / 2 Interview / 3 Practical / 4 Teaching
CREATE TABLE validations (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic_id      UUID REFERENCES topics(id) ON DELETE CASCADE,
    level         INTEGER NOT NULL CHECK (level BETWEEN 1 AND 4),
    method        VARCHAR(40) NOT NULL,          -- recall / interview / practical / teaching
    score_pct     INTEGER CHECK (score_pct BETWEEN 0 AND 100),
    passed        BOOLEAN,
    artifact_url  TEXT,                          -- project link, blog, video, presentation
    evaluated_by  VARCHAR(20) NOT NULL DEFAULT 'self'
                    CHECK (evaluated_by IN ('self','ai','peer','coach')),
    feedback      TEXT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX validations_topic_idx ON validations (topic_id, level);

-- Quizzes generated (by AI or authored) for a topic
CREATE TABLE quizzes (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic_id    UUID REFERENCES topics(id) ON DELETE CASCADE,
    title       VARCHAR(200) NOT NULL,
    generated_by VARCHAR(20) NOT NULL DEFAULT 'manual'
                    CHECK (generated_by IN ('manual','ai')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE quiz_questions (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id       UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    prompt        TEXT NOT NULL,
    question_type VARCHAR(20) NOT NULL DEFAULT 'mcq'
                    CHECK (question_type IN ('mcq','short','code','truefalse')),
    options       JSONB,                          -- for mcq
    correct_answer TEXT,
    explanation   TEXT,
    difficulty    INTEGER CHECK (difficulty BETWEEN 1 AND 5)
);

CREATE TABLE quiz_attempts (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id     UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    score_pct   INTEGER CHECK (score_pct BETWEEN 0 AND 100),
    detail      JSONB,                            -- per-question results
    taken_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =====================================================================
-- 5. INTERVIEW PREPARATION
-- =====================================================================

CREATE TABLE interview_questions (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_name        VARCHAR(150),
    category         VARCHAR(100),   -- Behavioral / System Design / AI / DevOps / Security ...
    question         TEXT NOT NULL,
    short_answer     TEXT,
    detailed_answer  TEXT,
    star_situation   TEXT,
    star_task        TEXT,
    star_action      TEXT,
    star_result      TEXT,
    confidence_score INTEGER NOT NULL DEFAULT 1 CHECK (confidence_score BETWEEN 1 AND 5),
    last_practiced   DATE,
    next_review      DATE,
    status           VARCHAR(30) NOT NULL DEFAULT 'Open'
                       CHECK (status IN ('Open','InProgress','Completed')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX iq_user_cat_idx ON interview_questions (user_id, category);
CREATE TRIGGER trg_iq_updated BEFORE UPDATE ON interview_questions
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Mock interview simulations (AI or self driven)
CREATE TABLE interview_simulations (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_name     VARCHAR(150),
    category      VARCHAR(100),
    mode          VARCHAR(20) NOT NULL DEFAULT 'ai'
                    CHECK (mode IN ('ai','self','peer')),
    overall_score INTEGER CHECK (overall_score BETWEEN 0 AND 100),
    transcript    JSONB,
    feedback      TEXT,
    started_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at      TIMESTAMPTZ
);

-- Interview readiness per category (0..100)
CREATE TABLE interview_readiness (
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category    VARCHAR(100) NOT NULL,
    score       INTEGER NOT NULL DEFAULT 0 CHECK (score BETWEEN 0 AND 100),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, category)
);

-- =====================================================================
-- 6. RETENTION ENGINE (spaced repetition)
-- =====================================================================

-- Review schedule for any reviewable entity (topic or interview question)
CREATE TABLE review_schedule (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    entity_type   VARCHAR(20) NOT NULL CHECK (entity_type IN ('topic','question')),
    entity_id     UUID NOT NULL,
    interval_days INTEGER NOT NULL DEFAULT 1,     -- 1,3,7,14,30,90
    ease_factor   NUMERIC(4,2) NOT NULL DEFAULT 2.50,
    repetitions   INTEGER NOT NULL DEFAULT 0,
    last_reviewed DATE,
    next_review   DATE NOT NULL DEFAULT CURRENT_DATE,
    retention     VARCHAR(20) NOT NULL DEFAULT 'New'
                    CHECK (retention IN ('New','Excellent','Good','Weak','Forgotten','InReview')),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (entity_type, entity_id)
);
CREATE INDEX review_due_idx ON review_schedule (user_id, next_review);

CREATE TABLE review_logs (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schedule_id   UUID NOT NULL REFERENCES review_schedule(id) ON DELETE CASCADE,
    quality       INTEGER NOT NULL CHECK (quality BETWEEN 0 AND 5), -- SM-2 recall quality
    reviewed_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =====================================================================
-- 7. GOALS, CAREER, CERTIFICATIONS, BUSINESS
-- =====================================================================

CREATE TABLE goals (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    domain_id    UUID REFERENCES domains(id),
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    horizon      VARCHAR(20) NOT NULL DEFAULT 'quarter'
                   CHECK (horizon IN ('week','month','quarter','year','life')),
    primary_ikigai UUID REFERENCES ikigai_dimensions(id),
    target_date  DATE,
    progress_pct INTEGER NOT NULL DEFAULT 0 CHECK (progress_pct BETWEEN 0 AND 100),
    status       VARCHAR(20) NOT NULL DEFAULT 'Active'
                   CHECK (status IN ('Active','Done','Paused','Dropped')),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TRIGGER trg_goals_updated BEFORE UPDATE ON goals
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE career_paths (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title        VARCHAR(150) NOT NULL,          -- e.g. "AI Engineering Lead"
    description  TEXT,
    target_date  DATE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE career_milestones (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    career_path_id UUID NOT NULL REFERENCES career_paths(id) ON DELETE CASCADE,
    title          VARCHAR(200) NOT NULL,
    sort_order     INTEGER NOT NULL DEFAULT 0,
    status         VARCHAR(20) NOT NULL DEFAULT 'Pending'
                     CHECK (status IN ('Pending','InProgress','Done')),
    target_date    DATE
);

CREATE TABLE certifications (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name         VARCHAR(200) NOT NULL,
    provider     VARCHAR(120),
    status       VARCHAR(20) NOT NULL DEFAULT 'Planned'
                   CHECK (status IN ('Planned','Studying','Scheduled','Passed','Expired')),
    exam_date    DATE,
    obtained_at  DATE,
    expires_at   DATE,
    credential_url TEXT
);

CREATE TABLE projects (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    domain_id    UUID REFERENCES domains(id),
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    status       VARCHAR(20) NOT NULL DEFAULT 'Idea'
                   CHECK (status IN ('Idea','Active','Shipped','Archived')),
    repo_url     TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE business_initiatives (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title        VARCHAR(200) NOT NULL,          -- TECHTARIS initiatives
    description  TEXT,
    stage        VARCHAR(30) NOT NULL DEFAULT 'Idea'
                   CHECK (stage IN ('Idea','Validation','Build','Launch','Growth')),
    primary_ikigai UUID REFERENCES ikigai_dimensions(id),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =====================================================================
-- 8. TASKS & REVIEWS
-- =====================================================================

CREATE TABLE tasks (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    domain_id    UUID REFERENCES domains(id),
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    priority     INTEGER NOT NULL DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
    status       VARCHAR(30) NOT NULL DEFAULT 'Open'
                   CHECK (status IN ('Open','InProgress','Blocked','Done')),
    due_date     DATE,
    linked_topic UUID REFERENCES topics(id) ON DELETE SET NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ
);
CREATE INDEX tasks_user_status_idx ON tasks (user_id, status);

CREATE TABLE weekly_reviews (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    week_start        DATE NOT NULL,
    wins              TEXT,
    blockers          TEXT,
    lessons_learned   TEXT,
    next_week_focus   TEXT,
    focus_score       INTEGER CHECK (focus_score BETWEEN 1 AND 10),
    consistency_score INTEGER CHECK (consistency_score BETWEEN 1 AND 10),
    confidence_score  INTEGER CHECK (confidence_score BETWEEN 1 AND 10),
    interview_score   INTEGER CHECK (interview_score BETWEEN 1 AND 10),
    ikigai_alignment  INTEGER CHECK (ikigai_alignment BETWEEN 0 AND 100),
    overall_grade     VARCHAR(2),
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, week_start)
);

-- =====================================================================
-- 9. KNOWLEDGE GRAPH (generic typed edges over all entities)
-- =====================================================================

-- Any entity in the system can be a node; edges are typed relationships.
-- entity_type values: topic, skill, project, goal, career_path,
--   certification, business_initiative, ikigai_dimension, interview_question
CREATE TABLE kg_edges (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    source_type  VARCHAR(30) NOT NULL,
    source_id    UUID NOT NULL,
    relation     VARCHAR(40) NOT NULL,   -- requires / advances / teaches / applies / aligns_with / depends_on / relates_to
    target_type  VARCHAR(30) NOT NULL,
    target_id    UUID NOT NULL,
    weight       NUMERIC(4,2) NOT NULL DEFAULT 1.0,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (source_type, source_id, relation, target_type, target_id)
);
CREATE INDEX kg_source_idx ON kg_edges (source_type, source_id);
CREATE INDEX kg_target_idx ON kg_edges (target_type, target_id);

-- =====================================================================
-- 10. AI INTERACTIONS (local LLM audit trail)
-- =====================================================================

CREATE TABLE ai_interactions (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    kind         VARCHAR(30) NOT NULL,   -- coach / quiz / summarize / extract / interview
    model        VARCHAR(80),
    topic_id     UUID REFERENCES topics(id) ON DELETE SET NULL,
    prompt       TEXT,
    response     TEXT,
    tokens_in    INTEGER,
    tokens_out   INTEGER,
    latency_ms   INTEGER,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ai_user_kind_idx ON ai_interactions (user_id, kind, created_at);
