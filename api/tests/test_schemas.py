"""Unit tests for Pydantic request schemas (validation boundaries)."""

from __future__ import annotations

import uuid

import pytest
from pydantic import ValidationError

from app.schemas import SessionCreate, TopicCreate, TopicUpdate


def test_topic_create_defaults():
    topic = TopicCreate(title="Agentic AI")
    assert topic.priority == 3
    assert topic.status == "Planned"
    assert topic.maturity_level == 0


def test_topic_priority_bounds_enforced():
    with pytest.raises(ValidationError):
        TopicCreate(title="x", priority=0)
    with pytest.raises(ValidationError):
        TopicCreate(title="x", priority=6)


def test_topic_maturity_bounds_enforced():
    with pytest.raises(ValidationError):
        TopicCreate(title="x", maturity_level=6)


def test_topic_accepts_optional_ikigai_uuid():
    tid = uuid.uuid4()
    topic = TopicCreate(title="x", primary_ikigai=tid)
    assert topic.primary_ikigai == tid


def test_topic_update_is_fully_optional():
    # An empty update is valid; nothing is required.
    update = TopicUpdate()
    assert update.model_dump(exclude_unset=True) == {}


def test_session_requires_positive_duration():
    with pytest.raises(ValidationError):
        SessionCreate(duration_minutes=0)
    ok = SessionCreate(duration_minutes=25)
    assert ok.duration_minutes == 25


def test_session_confidence_bounds():
    with pytest.raises(ValidationError):
        SessionCreate(duration_minutes=10, confidence_after=6)
    ok = SessionCreate(duration_minutes=10, confidence_before=2, confidence_after=4)
    assert ok.confidence_after == 4
