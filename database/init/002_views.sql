-- =====================================================================
-- ILE — 002_views.sql
-- Analytics views consumed by Metabase dashboards.
-- All views are user-agnostic; filter by user_id in Metabase or via RLS.
-- =====================================================================

-- ---- Daily study time ----
CREATE OR REPLACE VIEW v_daily_study_time AS
SELECT
    user_id,
    session_date,
    SUM(duration_minutes) AS total_minutes,
    COUNT(*)              AS session_count
FROM study_sessions
GROUP BY user_id, session_date;

-- ---- Weekly study time ----
CREATE OR REPLACE VIEW v_weekly_study_time AS
SELECT
    user_id,
    date_trunc('week', session_date)::date AS week_start,
    SUM(duration_minutes) AS total_minutes,
    COUNT(DISTINCT session_date) AS active_days
FROM study_sessions
GROUP BY user_id, date_trunc('week', session_date);

-- ---- Confidence improvement per day ----
CREATE OR REPLACE VIEW v_confidence_improvement AS
SELECT
    user_id,
    session_date,
    AVG(confidence_after - confidence_before) AS avg_improvement
FROM study_sessions
WHERE confidence_after IS NOT NULL AND confidence_before IS NOT NULL
GROUP BY user_id, session_date;

-- ---- Study time by type ----
CREATE OR REPLACE VIEW v_study_by_type AS
SELECT
    user_id,
    COALESCE(session_type,'Unspecified') AS session_type,
    SUM(duration_minutes) AS total_minutes
FROM study_sessions
GROUP BY user_id, COALESCE(session_type,'Unspecified');

-- ---- Interview readiness by category ----
CREATE OR REPLACE VIEW v_interview_readiness AS
SELECT
    user_id,
    category,
    ROUND(AVG(confidence_score)::numeric, 2) AS avg_confidence,
    COUNT(*)                                 AS total_questions,
    SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) AS completed
FROM interview_questions
GROUP BY user_id, category;

-- ---- Questions due for review ----
CREATE OR REPLACE VIEW v_questions_due AS
SELECT
    user_id, category, question, confidence_score, next_review
FROM interview_questions
WHERE status <> 'Completed'
  AND (next_review IS NULL OR next_review <= CURRENT_DATE);

-- ---- IKIGAI learning distribution (minutes per dimension) ----
CREATE OR REPLACE VIEW v_ikigai_distribution AS
SELECT
    s.user_id,
    d.name AS ikigai_dimension,
    SUM(s.duration_minutes) AS total_minutes,
    COUNT(DISTINCT t.id)    AS topic_count
FROM study_sessions s
JOIN topics t              ON t.id = s.topic_id
JOIN ikigai_dimensions d   ON d.id = t.primary_ikigai
GROUP BY s.user_id, d.name;

-- ---- Topic XP leaderboard ----
CREATE OR REPLACE VIEW v_topic_xp AS
SELECT
    user_id, id AS topic_id, title, category, maturity_level, xp_total,
    status, retention_state
FROM topics
ORDER BY xp_total DESC;

-- ---- Retention overview ----
CREATE OR REPLACE VIEW v_retention_overview AS
SELECT
    user_id,
    retention,
    COUNT(*) AS entity_count
FROM review_schedule
GROUP BY user_id, retention;

-- ---- Reviews due today ----
CREATE OR REPLACE VIEW v_reviews_due AS
SELECT user_id, entity_type, entity_id, interval_days, next_review, retention
FROM review_schedule
WHERE next_review <= CURRENT_DATE;

-- ---- Learning ROI summary ----
CREATE OR REPLACE VIEW v_learning_roi AS
SELECT
    u.id AS user_id,
    COALESCE((SELECT SUM(duration_minutes) FROM study_sessions s WHERE s.user_id=u.id),0)/60.0 AS hours_invested,
    (SELECT COUNT(*) FROM projects p WHERE p.user_id=u.id AND p.status='Shipped')             AS projects_shipped,
    (SELECT COUNT(*) FROM certifications c WHERE c.user_id=u.id AND c.status='Passed')         AS certifications,
    (SELECT COUNT(*) FROM validations v WHERE v.user_id=u.id AND v.passed IS TRUE)             AS validations_passed,
    (SELECT COUNT(*) FROM business_initiatives b WHERE b.user_id=u.id)                         AS business_initiatives
FROM users u;

-- ---- Weekly XP earned ----
CREATE OR REPLACE VIEW v_weekly_xp AS
SELECT
    user_id,
    date_trunc('week', created_at)::date AS week_start,
    SUM(points) AS xp_earned
FROM xp_events
GROUP BY user_id, date_trunc('week', created_at);

-- ---- Skill matrix (current vs target gap) ----
CREATE OR REPLACE VIEW v_skill_matrix AS
SELECT
    user_id, name, category, current_level, target_level,
    (target_level - current_level) AS gap, confidence, last_assessed
FROM skills;
