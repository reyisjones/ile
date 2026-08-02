"""Pydantic request/response schemas."""

from __future__ import annotations

import uuid
from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field


class ORMModel(BaseModel):
    model_config = ConfigDict(from_attributes=True)


# ---- Topics ----
class TopicCreate(BaseModel):
    title: str
    category: str | None = None
    priority: int = Field(default=3, ge=1, le=5)
    status: str = "Planned"
    maturity_level: int = Field(default=0, ge=0, le=5)
    why_it_matters: str | None = None
    primary_ikigai: uuid.UUID | None = None
    vault_path: str | None = None
    target_date: date | None = None


class TopicUpdate(BaseModel):
    title: str | None = None
    category: str | None = None
    priority: int | None = Field(default=None, ge=1, le=5)
    status: str | None = None
    maturity_level: int | None = Field(default=None, ge=0, le=5)
    why_it_matters: str | None = None
    primary_ikigai: uuid.UUID | None = None
    retention_state: str | None = None
    target_date: date | None = None


class TopicOut(ORMModel):
    id: uuid.UUID
    title: str
    category: str | None
    priority: int
    status: str
    maturity_level: int
    why_it_matters: str | None
    primary_ikigai: uuid.UUID | None
    xp_total: int
    retention_state: str
    target_date: date | None
    created_at: datetime


# ---- Study sessions ----
class SessionCreate(BaseModel):
    topic_id: uuid.UUID | None = None
    session_date: date | None = None
    duration_minutes: int = Field(gt=0)
    session_type: str | None = None
    focus_score: int | None = Field(default=None, ge=1, le=5)
    confidence_before: int | None = Field(default=None, ge=1, le=5)
    confidence_after: int | None = Field(default=None, ge=1, le=5)
    notes: str | None = None


class SessionOut(ORMModel):
    id: uuid.UUID
    topic_id: uuid.UUID | None
    session_date: date
    duration_minutes: int
    session_type: str | None
    focus_score: int | None
    confidence_before: int | None
    confidence_after: int | None
    notes: str | None


# ---- XP ----
class XpEventCreate(BaseModel):
    topic_id: uuid.UUID | None = None
    activity: str
    source: str = "manual"


class XpEventOut(ORMModel):
    id: uuid.UUID
    topic_id: uuid.UUID | None
    activity: str
    points: int
    source: str
    created_at: datetime


# ---- Interview ----
class InterviewQuestionCreate(BaseModel):
    role_name: str | None = None
    category: str | None = None
    question: str
    short_answer: str | None = None
    detailed_answer: str | None = None
    confidence_score: int = Field(default=1, ge=1, le=5)


class InterviewQuestionOut(ORMModel):
    id: uuid.UUID
    role_name: str | None
    category: str | None
    question: str
    short_answer: str | None
    confidence_score: int
    next_review: date | None
    status: str


# ---- Validation ----
class ValidationCreate(BaseModel):
    topic_id: uuid.UUID
    level: int = Field(ge=1, le=4)
    method: str
    score_pct: int | None = Field(default=None, ge=0, le=100)
    passed: bool | None = None
    artifact_url: str | None = None
    evaluated_by: str = "self"
    feedback: str | None = None


class ValidationOut(ORMModel):
    id: uuid.UUID
    topic_id: uuid.UUID | None
    level: int
    method: str
    score_pct: int | None
    passed: bool | None
    evaluated_by: str
    created_at: datetime


# ---- Retention ----
class ReviewGrade(BaseModel):
    quality: int = Field(ge=0, le=5, description="SM-2 recall quality (0-5)")


class ReviewScheduleOut(ORMModel):
    id: uuid.UUID
    entity_type: str
    entity_id: uuid.UUID
    interval_days: int
    repetitions: int
    next_review: date
    retention: str


# ---- AI ----
class CoachRequest(BaseModel):
    kind: str = Field(description="coach | quiz | summarize | extract | interview")
    prompt: str
    topic_id: uuid.UUID | None = None


class CoachResponse(BaseModel):
    kind: str
    model: str
    response: str
    latency_ms: int
