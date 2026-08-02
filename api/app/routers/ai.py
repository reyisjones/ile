"""Local AI assistant endpoints (coach, quiz, summarize, extract, interview)."""

import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.config import get_settings
from app.db import get_db
from app.deps import get_current_user_id
from app.models import AiInteraction
from app.schemas import CoachRequest, CoachResponse
from app.services.llm import LLMUnavailable, generate

router = APIRouter(prefix="/ai", tags=["ai"])
settings = get_settings()

ALLOWED_KINDS = {"coach", "quiz", "summarize", "extract", "interview"}


@router.post("/generate", response_model=CoachResponse)
def ai_generate(
    payload: CoachRequest,
    db: Session = Depends(get_db),
    user_id: uuid.UUID = Depends(get_current_user_id),
):
    if payload.kind not in ALLOWED_KINDS:
        raise HTTPException(400, f"kind must be one of {sorted(ALLOWED_KINDS)}")
    try:
        text, latency_ms = generate(payload.kind, payload.prompt)
    except LLMUnavailable as exc:
        raise HTTPException(503, f"Local LLM unavailable: {exc}") from exc

    db.add(
        AiInteraction(
            user_id=user_id,
            kind=payload.kind,
            model=settings.ollama_chat_model,
            topic_id=payload.topic_id,
            prompt=payload.prompt,
            response=text,
            latency_ms=latency_ms,
        )
    )
    return CoachResponse(
        kind=payload.kind,
        model=settings.ollama_chat_model,
        response=text,
        latency_ms=latency_ms,
    )
