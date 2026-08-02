"""Spaced-repetition retention engine."""

import uuid
from datetime import date

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id
from app.models import ReviewSchedule
from app.schemas import ReviewGrade, ReviewScheduleOut
from app.services.retention import schedule_next

router = APIRouter(prefix="/retention", tags=["retention"])


@router.get("/due", response_model=list[ReviewScheduleOut])
def due_reviews(
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    stmt = (
        select(ReviewSchedule)
        .where(ReviewSchedule.user_id == user_id)
        .where(ReviewSchedule.next_review <= date.today())
        .order_by(ReviewSchedule.next_review)
    )
    return db.scalars(stmt).all()


@router.post("/{entity_type}/{entity_id}/track", response_model=ReviewScheduleOut, status_code=201)
def track_entity(
    entity_type: str,
    entity_id: uuid.UUID,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    if entity_type not in ("topic", "question"):
        raise HTTPException(400, "entity_type must be 'topic' or 'question'")
    existing = db.scalar(
        select(ReviewSchedule).where(
            ReviewSchedule.entity_type == entity_type,
            ReviewSchedule.entity_id == entity_id,
        )
    )
    if existing:
        return existing
    sched = ReviewSchedule(user_id=user_id, entity_type=entity_type, entity_id=entity_id)
    db.add(sched)
    db.flush()
    db.refresh(sched)
    return sched


@router.post("/{schedule_id}/grade", response_model=ReviewScheduleOut)
def grade_review(
    schedule_id: uuid.UUID,
    grade: ReviewGrade,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    sched = db.get(ReviewSchedule, schedule_id)
    if not sched or sched.user_id != user_id:
        raise HTTPException(404, "Schedule not found")

    state = schedule_next(
        quality=grade.quality,
        interval_days=sched.interval_days,
        ease_factor=float(sched.ease_factor),
        repetitions=sched.repetitions,
    )
    sched.interval_days = state.interval_days
    sched.ease_factor = state.ease_factor
    sched.repetitions = state.repetitions
    sched.next_review = state.next_review
    sched.retention = state.retention
    sched.last_reviewed = date.today()
    db.flush()
    db.refresh(sched)
    return sched
