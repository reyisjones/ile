"""SQLAlchemy ORM models (core subset exposed through the API).

The full relational schema lives in database/init/001_schema.sql. These
models mirror the tables the API actively reads/writes. Tables not mapped
here are still queryable via the analytics views.
"""

from __future__ import annotations

import uuid
from datetime import date, datetime

from sqlalchemy import (
    Boolean,
    Date,
    DateTime,
    ForeignKey,
    Integer,
    Numeric,
    String,
    Text,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base


def _uuid() -> uuid.UUID:
    return uuid.uuid4()


class Topic(Base):
    __tablename__ = "topics"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    slug: Mapped[str | None] = mapped_column(String(220))
    category: Mapped[str | None] = mapped_column(String(100))
    domain_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    priority: Mapped[int] = mapped_column(Integer, default=3)
    status: Mapped[str] = mapped_column(String(30), default="Planned")
    maturity_level: Mapped[int] = mapped_column(Integer, default=0)
    why_it_matters: Mapped[str | None] = mapped_column(Text)
    primary_ikigai: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    vault_path: Mapped[str | None] = mapped_column(Text)
    target_date: Mapped[date | None] = mapped_column(Date)
    xp_total: Mapped[int] = mapped_column(Integer, default=0)
    retention_state: Mapped[str] = mapped_column(String(20), default="New")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))


class StudySession(Base):
    __tablename__ = "study_sessions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    topic_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    session_date: Mapped[date] = mapped_column(Date, default=date.today)
    duration_minutes: Mapped[int] = mapped_column(Integer, nullable=False)
    session_type: Mapped[str | None] = mapped_column(String(50))
    focus_score: Mapped[int | None] = mapped_column(Integer)
    confidence_before: Mapped[int | None] = mapped_column(Integer)
    confidence_after: Mapped[int | None] = mapped_column(Integer)
    notes: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class XpRule(Base):
    __tablename__ = "xp_rules"

    activity: Mapped[str] = mapped_column(String(40), primary_key=True)
    points: Mapped[int] = mapped_column(Integer, nullable=False)
    description: Mapped[str | None] = mapped_column(Text)


class XpEvent(Base):
    __tablename__ = "xp_events"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    topic_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    activity: Mapped[str] = mapped_column(String(40), ForeignKey("xp_rules.activity"))
    points: Mapped[int] = mapped_column(Integer, nullable=False)
    source: Mapped[str] = mapped_column(String(40), default="manual")
    ref_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class InterviewQuestion(Base):
    __tablename__ = "interview_questions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    role_name: Mapped[str | None] = mapped_column(String(150))
    category: Mapped[str | None] = mapped_column(String(100))
    question: Mapped[str] = mapped_column(Text, nullable=False)
    short_answer: Mapped[str | None] = mapped_column(Text)
    detailed_answer: Mapped[str | None] = mapped_column(Text)
    star_situation: Mapped[str | None] = mapped_column(Text)
    star_task: Mapped[str | None] = mapped_column(Text)
    star_action: Mapped[str | None] = mapped_column(Text)
    star_result: Mapped[str | None] = mapped_column(Text)
    confidence_score: Mapped[int] = mapped_column(Integer, default=1)
    last_practiced: Mapped[date | None] = mapped_column(Date)
    next_review: Mapped[date | None] = mapped_column(Date)
    status: Mapped[str] = mapped_column(String(30), default="Open")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class ReviewSchedule(Base):
    __tablename__ = "review_schedule"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    entity_type: Mapped[str] = mapped_column(String(20), nullable=False)
    entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    interval_days: Mapped[int] = mapped_column(Integer, default=1)
    ease_factor: Mapped[float] = mapped_column(Numeric(4, 2), default=2.50)
    repetitions: Mapped[int] = mapped_column(Integer, default=0)
    last_reviewed: Mapped[date | None] = mapped_column(Date)
    next_review: Mapped[date] = mapped_column(Date, default=date.today)
    retention: Mapped[str] = mapped_column(String(20), default="New")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class Validation(Base):
    __tablename__ = "validations"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    topic_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    level: Mapped[int] = mapped_column(Integer, nullable=False)
    method: Mapped[str] = mapped_column(String(40), nullable=False)
    score_pct: Mapped[int | None] = mapped_column(Integer)
    passed: Mapped[bool | None] = mapped_column(Boolean)
    artifact_url: Mapped[str | None] = mapped_column(Text)
    evaluated_by: Mapped[str] = mapped_column(String(20), default="self")
    feedback: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class AiInteraction(Base):
    __tablename__ = "ai_interactions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=_uuid)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    kind: Mapped[str] = mapped_column(String(30), nullable=False)
    model: Mapped[str | None] = mapped_column(String(80))
    topic_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True))
    prompt: Mapped[str | None] = mapped_column(Text)
    response: Mapped[str | None] = mapped_column(Text)
    tokens_in: Mapped[int | None] = mapped_column(Integer)
    tokens_out: Mapped[int | None] = mapped_column(Integer)
    latency_ms: Mapped[int | None] = mapped_column(Integer)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
