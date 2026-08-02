"""Topic CRUD — the learning unit tied to IKIGAI alignment."""

import uuid

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user_id
from app.models import Topic
from app.schemas import TopicCreate, TopicOut, TopicUpdate

router = APIRouter(prefix="/topics", tags=["topics"])


@router.get("", response_model=list[TopicOut])
def list_topics(
    status: str | None = Query(default=None),
    category: str | None = Query(default=None),
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    stmt = select(Topic).where(Topic.user_id == user_id)
    if status:
        stmt = stmt.where(Topic.status == status)
    if category:
        stmt = stmt.where(Topic.category == category)
    stmt = stmt.order_by(Topic.priority, Topic.title)
    return db.scalars(stmt).all()


@router.post("", response_model=TopicOut, status_code=201)
def create_topic(
    payload: TopicCreate,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    topic = Topic(user_id=user_id, **payload.model_dump())
    db.add(topic)
    db.flush()
    db.refresh(topic)
    return topic


@router.get("/{topic_id}", response_model=TopicOut)
def get_topic(
    topic_id: uuid.UUID,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    topic = db.get(Topic, topic_id)
    if not topic or topic.user_id != user_id:
        raise HTTPException(404, "Topic not found")
    return topic


@router.patch("/{topic_id}", response_model=TopicOut)
def update_topic(
    topic_id: uuid.UUID,
    payload: TopicUpdate,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    topic = db.get(Topic, topic_id)
    if not topic or topic.user_id != user_id:
        raise HTTPException(404, "Topic not found")
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(topic, key, value)
    db.flush()
    db.refresh(topic)
    return topic


@router.delete("/{topic_id}", status_code=204)
def delete_topic(
    topic_id: uuid.UUID,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    topic = db.get(Topic, topic_id)
    if not topic or topic.user_id != user_id:
        raise HTTPException(404, "Topic not found")
    db.delete(topic)
