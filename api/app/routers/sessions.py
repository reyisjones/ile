"""Study sessions — the raw signal for analytics."""

import uuid

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id
from app.models import StudySession
from app.schemas import SessionCreate, SessionOut

router = APIRouter(prefix="/sessions", tags=["sessions"])


@router.get("", response_model=list[SessionOut])
def list_sessions(
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    stmt = (
        select(StudySession)
        .where(StudySession.user_id == user_id)
        .order_by(StudySession.session_date.desc())
        .limit(200)
    )
    return db.scalars(stmt).all()


@router.post("", response_model=SessionOut, status_code=201)
def create_session(
    payload: SessionCreate,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    data = payload.model_dump(exclude_unset=True)
    session = StudySession(user_id=user_id, **data)
    db.add(session)
    db.flush()
    db.refresh(session)
    return session
