"""Shared pytest fixtures for the ILE API test suite.

These tests are intentionally database-free: unit tests exercise pure
logic (SM-2 scheduling, Pydantic schemas) and route tests use FastAPI's
TestClient with the database/auth dependencies overridden. This keeps CI
fast and lets the suite run without a live Postgres.
"""

from __future__ import annotations

import uuid

import pytest
from fastapi.testclient import TestClient

from app.db import get_db
from app.deps import get_current_user_id
from app.main import app

TEST_USER_ID = uuid.UUID("00000000-0000-0000-0000-000000000001")


class _FakeResult:
    """Minimal stand-in for a SQLAlchemy Result (supports .scalar())."""

    def scalar(self) -> int:
        return 1


class FakeSession:
    """A no-op DB session sufficient for routes that only run SELECT 1."""

    def execute(self, *_args, **_kwargs) -> _FakeResult:
        return _FakeResult()

    def commit(self) -> None:  # pragma: no cover - trivial
        pass

    def rollback(self) -> None:  # pragma: no cover - trivial
        pass

    def close(self) -> None:  # pragma: no cover - trivial
        pass


@pytest.fixture
def client() -> TestClient:
    """TestClient with DB and auth dependencies overridden (no real DB)."""

    def _override_db():
        yield FakeSession()

    def _override_user():
        return TEST_USER_ID

    app.dependency_overrides[get_db] = _override_db
    app.dependency_overrides[get_current_user_id] = _override_user
    try:
        yield TestClient(app)
    finally:
        app.dependency_overrides.clear()
