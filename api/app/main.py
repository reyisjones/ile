"""ILE API — application entrypoint.

Local-first Learning Operating System backend. Wires together routers
for topics, sessions, XP, interview prep, validation, retention, the
local AI assistant, and analytics.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import get_settings
from app.routers import (
    ai,
    analytics,
    health,
    interview,
    retention,
    sessions,
    topics,
    validations,
    xp,
)

settings = get_settings()

app = FastAPI(
    title="ILE — IKIGAI Learning Engine API",
    version="0.1.0",
    description="Local-first Learning Operating System backend.",
)

# Permissive CORS for local dev; tighten for multi-user deployments.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

for module in (
    health,
    topics,
    sessions,
    xp,
    interview,
    validations,
    retention,
    ai,
    analytics,
):
    app.include_router(module.router)


@app.get("/", tags=["system"])
def root() -> dict:
    return {
        "name": "ILE — IKIGAI Learning Engine",
        "version": app.version,
        "single_user_mode": settings.api_single_user_mode,
        "docs": "/docs",
    }
