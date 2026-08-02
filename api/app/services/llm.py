"""Thin client for a local Ollama LLM runtime.

Kept intentionally minimal and dependency-light. If Ollama is not running
(the `ai` compose profile is off), calls raise a clear 503 upstream.
"""

from __future__ import annotations

import time

import httpx

from app.config import get_settings

settings = get_settings()

SYSTEM_PROMPTS = {
    "coach": (
        "You are a focused learning coach. Give concise, actionable guidance. "
        "Tie advice back to the learner's goals and IKIGAI alignment when relevant."
    ),
    "quiz": (
        "You are a quiz generator. Produce clear questions with answers and short "
        "explanations. Prefer a mix of recall and applied questions."
    ),
    "summarize": "You summarize study notes into crisp, structured bullet points.",
    "extract": (
        "You extract key concepts, entities, and relationships from notes as a "
        "compact knowledge outline suitable for a knowledge graph."
    ),
    "interview": (
        "You are a rigorous but fair technical interviewer. Ask one question at a "
        "time, then evaluate answers with specific, constructive feedback."
    ),
}


class LLMUnavailable(RuntimeError):
    pass


def generate(kind: str, prompt: str, *, model: str | None = None) -> tuple[str, int]:
    """Return (response_text, latency_ms). Raises LLMUnavailable on failure."""
    model = model or settings.ollama_chat_model
    system = SYSTEM_PROMPTS.get(kind, SYSTEM_PROMPTS["coach"])
    payload = {
        "model": model,
        "prompt": prompt,
        "system": system,
        "stream": False,
    }
    started = time.perf_counter()
    try:
        with httpx.Client(timeout=120) as client:
            resp = client.post(f"{settings.ollama_url}/api/generate", json=payload)
            resp.raise_for_status()
            data = resp.json()
    except (httpx.HTTPError, ValueError) as exc:
        raise LLMUnavailable(str(exc)) from exc

    latency_ms = int((time.perf_counter() - started) * 1000)
    return data.get("response", "").strip(), latency_ms
