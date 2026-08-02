"""XP / achievement ledger. Points come from the xp_rules table."""

import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id
from app.models import XpEvent, XpRule
from app.schemas import XpEventCreate, XpEventOut

router = APIRouter(prefix="/xp", tags=["xp"])


@router.post("/events", response_model=XpEventOut, status_code=201)
def add_xp(
    payload: XpEventCreate,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    rule = db.get(XpRule, payload.activity)
    if not rule:
        raise HTTPException(400, f"Unknown activity '{payload.activity}'")
    event = XpEvent(
        user_id=user_id,
        topic_id=payload.topic_id,
        activity=payload.activity,
        points=rule.points,
        source=payload.source,
    )
    db.add(event)
    db.flush()
    db.refresh(event)
    return event


@router.get("/total")
def xp_total(
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    total = db.scalar(
        select(func.coalesce(func.sum(XpEvent.points), 0)).where(XpEvent.user_id == user_id)
    )
    return {"user_id": str(user_id), "xp_total": int(total or 0)}
