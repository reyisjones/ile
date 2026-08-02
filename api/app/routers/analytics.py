"""Analytics passthrough over SQL views (same data Metabase renders)."""

import uuid

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id

router = APIRouter(prefix="/analytics", tags=["analytics"])


def _rows(db: Session, view: str, user_id: uuid.UUID) -> list[dict]:
    result = db.execute(text(f"SELECT * FROM {view} WHERE user_id = :uid"), {"uid": str(user_id)})
    return [dict(r._mapping) for r in result]


@router.get("/ikigai-distribution")
def ikigai_distribution(
    db: Session = Depends(get_db), user_id: uuid.UUID = Depends(get_current_user_id)
):
    return _rows(db, "v_ikigai_distribution", user_id)


@router.get("/interview-readiness")
def interview_readiness(
    db: Session = Depends(get_db), user_id: uuid.UUID = Depends(get_current_user_id)
):
    return _rows(db, "v_interview_readiness", user_id)


@router.get("/retention-overview")
def retention_overview(
    db: Session = Depends(get_db), user_id: uuid.UUID = Depends(get_current_user_id)
):
    return _rows(db, "v_retention_overview", user_id)


@router.get("/learning-roi")
def learning_roi(db: Session = Depends(get_db), user_id: uuid.UUID = Depends(get_current_user_id)):
    rows = _rows(db, "v_learning_roi", user_id)
    return rows[0] if rows else {}


@router.get("/weekly-study")
def weekly_study(db: Session = Depends(get_db), user_id: uuid.UUID = Depends(get_current_user_id)):
    return _rows(db, "v_weekly_study_time", user_id)


@router.get("/topic-xp")
def topic_xp(db: Session = Depends(get_db), user_id: uuid.UUID = Depends(get_current_user_id)):
    return _rows(db, "v_topic_xp", user_id)
