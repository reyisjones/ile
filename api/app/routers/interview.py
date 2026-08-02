"""Interview question bank."""

import uuid

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id
from app.models import InterviewQuestion
from app.schemas import InterviewQuestionCreate, InterviewQuestionOut

router = APIRouter(prefix="/interview", tags=["interview"])


@router.get("/questions", response_model=list[InterviewQuestionOut])
def list_questions(
    category: str | None = Query(default=None),
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    stmt = select(InterviewQuestion).where(InterviewQuestion.user_id == user_id)
    if category:
        stmt = stmt.where(InterviewQuestion.category == category)
    stmt = stmt.order_by(InterviewQuestion.confidence_score, InterviewQuestion.category)
    return db.scalars(stmt).all()


@router.post("/questions", response_model=InterviewQuestionOut, status_code=201)
def create_question(
    payload: InterviewQuestionCreate,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    q = InterviewQuestion(user_id=user_id, **payload.model_dump())
    db.add(q)
    db.flush()
    db.refresh(q)
    return q
