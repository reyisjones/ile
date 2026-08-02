"""Auth dependencies.

In single-user mode (default for local personal use) the owner id is
injected automatically. When API_SINGLE_USER_MODE=false, a valid Bearer
JWT is required. This keeps the MVP frictionless while leaving a clean
path to multi-user SaaS.
"""

import uuid

from fastapi import Depends, Header, HTTPException, status
from jose import JWTError, jwt

from app.config import get_settings

settings = get_settings()
ALGORITHM = "HS256"


def get_current_user_id(authorization: str | None = Header(default=None)) -> uuid.UUID:
    if settings.api_single_user_mode:
        return uuid.UUID(settings.owner_user_id)

    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Missing bearer token")

    token = authorization.split(" ", 1)[1]
    try:
        payload = jwt.decode(token, settings.api_secret_key, algorithms=[ALGORITHM])
        return uuid.UUID(payload["sub"])
    except (JWTError, KeyError, ValueError) as exc:  # noqa: PERF203
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid token") from exc


CurrentUser = Depends(get_current_user_id)
