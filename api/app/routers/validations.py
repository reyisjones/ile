"""Knowledge validation (Levels 1-4). Passing L4 promotes topic maturity."""

import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id
from app.models import Topic, Validation
from app.schemas import ValidationCreate, ValidationOut

router = APIRouter(prefix="/validations", tags=["validation"])

# level -> maturity floor when a validation passes
LEVEL_TO_MATURITY = {1: 1, 2: 2, 3: 3, 4: 4}


@router.get("", response_model=list[ValidationOut])
def list_validations(
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    stmt = (
        select(Validation)
        .where(Validation.user_id == user_id)
        .order_by(Validation.created_at.desc())
    )
    return db.scalars(stmt).all()


@router.post("", response_model=ValidationOut, status_code=201)
def create_validation(
    payload: ValidationCreate,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    topic = db.get(Topic, payload.topic_id)
    if not topic or topic.user_id != user_id:
        raise HTTPException(404, "Topic not found")

    validation = Validation(user_id=user_id, **payload.model_dump())
    db.add(validation)

    # Promote maturity when a validation passes.
    if payload.passed:
        floor = LEVEL_TO_MATURITY.get(payload.level, 0)
        if topic.maturity_level < floor:
            topic.maturity_level = floor

    db.flush()
    db.refresh(validation)
    return validation
