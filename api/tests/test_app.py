"""Route/wiring tests using TestClient with overridden dependencies."""

from __future__ import annotations


def test_root_reports_service_metadata(client):
    resp = client.get("/")
    assert resp.status_code == 200
    body = resp.json()
    assert body["name"].startswith("ILE")
    assert body["version"] == "0.1.0"
    assert "single_user_mode" in body
    assert body["docs"] == "/docs"


def test_health_is_ok(client):
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}


def test_ready_uses_db_dependency(client):
    # The FakeSession returns for SELECT 1, so /ready should report connected.
    resp = client.get("/ready")
    assert resp.status_code == 200
    assert resp.json()["status"] == "ready"


def test_openapi_schema_is_served(client):
    resp = client.get("/openapi.json")
    assert resp.status_code == 200
    schema = resp.json()
    assert schema["info"]["title"].startswith("ILE")
    # A few expected routes should be registered.
    assert "/topics" in schema["paths"]
    assert "/health" in schema["paths"]
