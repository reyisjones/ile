-- =====================================================================
-- ILE — 003_seed.sql
-- Reference data + a single-user owner + example content.
-- Safe to re-run (ON CONFLICT DO NOTHING where relevant).
-- =====================================================================

-- ---- Domains ----
INSERT INTO domains (name, sort_order) VALUES
    ('Learning', 1), ('Business', 2), ('Personal', 3)
ON CONFLICT (name) DO NOTHING;

-- ---- IKIGAI dimensions ----
INSERT INTO ikigai_dimensions (name, description, color_hex) VALUES
    ('Passion',    'What you love',            '#E64980'),
    ('Mission',    'What the world needs',     '#12B886'),
    ('Profession', 'What you are paid for',    '#4C6EF5'),
    ('Vocation',   'What you are good at + can be paid for', '#F59F00')
ON CONFLICT (name) DO NOTHING;

-- ---- Maturity levels ----
INSERT INTO maturity_levels (level, name, description) VALUES
    (0, 'Discovered', 'Aware the topic exists'),
    (1, 'Learning',   'Actively studying fundamentals'),
    (2, 'Practicing', 'Hands-on exercises and labs'),
    (3, 'Applied',    'Used in a real project or task'),
    (4, 'Teaching',   'Able to teach / present it'),
    (5, 'Expert',     'Deep, durable mastery')
ON CONFLICT (level) DO NOTHING;

-- ---- XP rules (from the achievement system) ----
INSERT INTO xp_rules (activity, points, description) VALUES
    ('Read',         1,  'Read documentation / article'),
    ('Notes',        2,  'Wrote structured notes'),
    ('Lab',          5,  'Completed a hands-on lab'),
    ('Quiz',         5,  'Passed a quiz'),
    ('Presentation', 10, 'Delivered a presentation'),
    ('Teach',        15, 'Taught someone else'),
    ('Project',      20, 'Built a project')
ON CONFLICT (activity) DO NOTHING;

-- ---- Achievements (sample catalog) ----
INSERT INTO achievements (code, name, description, icon, criteria) VALUES
    ('first_steps',   'First Steps',      'Log your first study session', '🌱', '{"sessions":1}'),
    ('week_streak',   '7-Day Streak',     'Study 7 days in a row',        '🔥', '{"streak_days":7}'),
    ('teacher',       'The Teacher',      'Pass a Level 4 teaching validation', '🎓', '{"validation_level":4}'),
    ('interview_ready','Interview Ready', 'Reach 80+ readiness in 3 categories', '🎯', '{"ready_categories":3,"min_score":80}'),
    ('centurion',     'Centurion',        'Earn 100 XP in a single week',  '💯', '{"weekly_xp":100}'),
    ('ikigai_balance','IKIGAI Balance',   'Log learning across all 4 dimensions in a week', '⚖️', '{"dimensions":4}')
ON CONFLICT (code) DO NOTHING;

-- ---- Owner user (single-user mode) ----
INSERT INTO users (id, email, display_name, role, timezone)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'owner@localhost',
    'Owner',
    'owner',
    'UTC'
)
ON CONFLICT (id) DO NOTHING;

-- ---- Example topics mapped to IKIGAI (from source docs) ----
WITH u AS (SELECT '00000000-0000-0000-0000-000000000001'::uuid AS uid),
     d AS (SELECT id AS learning_id FROM domains WHERE name='Learning'),
     prof AS (SELECT id FROM ikigai_dimensions WHERE name='Profession'),
     pass AS (SELECT id FROM ikigai_dimensions WHERE name='Passion'),
     miss AS (SELECT id FROM ikigai_dimensions WHERE name='Mission'),
     voc  AS (SELECT id FROM ikigai_dimensions WHERE name='Vocation')
INSERT INTO topics (user_id, title, category, domain_id, priority, status, maturity_level, why_it_matters, primary_ikigai)
SELECT u.uid, x.title, x.category, d.learning_id, x.priority, x.status, x.mlevel, x.why, x.dim
FROM u, d,
LATERAL (
    VALUES
      ('Agentic AI',                'AI',        1, 'Practicing', 3, 'Core to becoming an AI Engineering Lead.', (SELECT id FROM ikigai_dimensions WHERE name='Profession')),
      ('Azure Architecture',        'Cloud',     2, 'Applied',    4, 'Foundation for current work and consulting.', (SELECT id FROM ikigai_dimensions WHERE name='Profession')),
      ('AI Consulting',             'Business',  2, 'Learning',   1, 'Enables TECHTARIS vocation.', (SELECT id FROM ikigai_dimensions WHERE name='Vocation')),
      ('AI Education',              'Teaching',  3, 'Learning',   1, 'Serves the mission of teaching others.', (SELECT id FROM ikigai_dimensions WHERE name='Mission')),
      ('Post Quantum Cryptography', 'Security',  3, 'Learning',   2, 'Passion + long-term mission relevance.', (SELECT id FROM ikigai_dimensions WHERE name='Passion')),
      ('Interview Preparation',     'Interview', 1, 'Practicing', 2, 'Immediate professional priority.', (SELECT id FROM ikigai_dimensions WHERE name='Profession'))
) AS x(title, category, priority, status, mlevel, why, dim)
ON CONFLICT DO NOTHING;

-- ---- Interview readiness starter categories ----
INSERT INTO interview_readiness (user_id, category, score)
SELECT '00000000-0000-0000-0000-000000000001'::uuid, cat, 0
FROM (VALUES
    ('Behavioral'),('System Design'),('Coding'),('AI Engineering'),
    ('DevOps & Cloud'),('Security'),('Leadership'),('English Communication')
) AS c(cat)
ON CONFLICT (user_id, category) DO NOTHING;
