"""Unit tests for the SM-2 spaced-repetition scheduler."""

from __future__ import annotations

from datetime import date, timedelta

from app.services.retention import LADDER, schedule_next


def test_first_successful_review_uses_ladder_start():
    today = date(2026, 1, 1)
    state = schedule_next(quality=5, interval_days=0, ease_factor=2.5, repetitions=0, today=today)
    assert state.repetitions == 1
    assert state.interval_days == LADDER[0]  # 1 day
    assert state.next_review == today + timedelta(days=LADDER[0])
    assert state.retention == "Excellent"


def test_ladder_progression_follows_fixed_floor():
    today = date(2026, 1, 1)
    intervals = []
    reps = 0
    interval = 0
    ef = 2.5
    for _ in range(len(LADDER)):
        state = schedule_next(
            quality=4, interval_days=interval, ease_factor=ef, repetitions=reps, today=today
        )
        intervals.append(state.interval_days)
        reps, interval, ef = state.repetitions, state.interval_days, state.ease_factor
    assert intervals == LADDER


def test_lapse_resets_repetitions_and_interval():
    today = date(2026, 1, 1)
    state = schedule_next(quality=1, interval_days=90, ease_factor=2.5, repetitions=5, today=today)
    assert state.repetitions == 0
    assert state.interval_days == LADDER[0]
    assert state.retention == "Weak"


def test_quality_zero_is_forgotten():
    state = schedule_next(quality=0, interval_days=30, ease_factor=2.5, repetitions=3)
    assert state.retention == "Forgotten"
    assert state.repetitions == 0


def test_ease_factor_never_below_floor():
    # Repeated poor-but-passing recalls should not drop EF below 1.3.
    ef = 2.5
    reps = 0
    interval = 0
    for _ in range(10):
        state = schedule_next(quality=3, interval_days=interval, ease_factor=ef, repetitions=reps)
        ef, reps, interval = state.ease_factor, state.repetitions, state.interval_days
    assert ef >= 1.3


def test_quality_is_clamped_to_valid_range():
    high = schedule_next(quality=99, interval_days=0, ease_factor=2.5, repetitions=0)
    low = schedule_next(quality=-5, interval_days=10, ease_factor=2.5, repetitions=2)
    assert high.retention == "Excellent"
    assert low.retention == "Forgotten"
    assert low.repetitions == 0


def test_interval_grows_by_ease_factor_after_ladder():
    today = date(2026, 1, 1)
    # After exhausting the ladder, interval = round(prev_interval * ease_factor),
    # using the ease factor as it was *before* this review's update.
    state = schedule_next(
        quality=5,
        interval_days=90,
        ease_factor=2.0,
        repetitions=len(LADDER),
        today=today,
    )
    assert state.interval_days == round(90 * 2.0)  # 180
    assert state.repetitions == len(LADDER) + 1
