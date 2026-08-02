"""Spaced-repetition scheduling using a simplified SM-2 algorithm.

Recall quality (q) is 0..5. q < 3 counts as a lapse and resets the
repetition count. Retention labels are derived from q for dashboards.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, timedelta

# Fixed review ladder used as a floor for early repetitions.
LADDER = [1, 3, 7, 14, 30, 90]


@dataclass
class ScheduleState:
    interval_days: int
    ease_factor: float
    repetitions: int
    next_review: date
    retention: str


def _retention_label(quality: int) -> str:
    if quality >= 5:
        return "Excellent"
    if quality == 4:
        return "Good"
    if quality == 3:
        return "InReview"
    if quality >= 1:
        return "Weak"
    return "Forgotten"


def schedule_next(
    *,
    quality: int,
    interval_days: int,
    ease_factor: float,
    repetitions: int,
    today: date | None = None,
) -> ScheduleState:
    """Return the next scheduling state given a recall quality (0..5)."""
    today = today or date.today()
    quality = max(0, min(5, quality))

    if quality < 3:
        # Lapse: relearn from the start of the ladder.
        repetitions = 0
        interval = LADDER[0]
    else:
        repetitions += 1
        if repetitions <= len(LADDER):
            interval = LADDER[repetitions - 1]
        else:
            interval = round(interval_days * ease_factor)

    # SM-2 ease-factor update, clamped to a sane floor.
    ease_factor = max(
        1.3,
        ease_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)),
    )

    return ScheduleState(
        interval_days=interval,
        ease_factor=round(ease_factor, 2),
        repetitions=repetitions,
        next_review=today + timedelta(days=interval),
        retention=_retention_label(quality),
    )
