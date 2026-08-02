"""Application configuration loaded from environment variables."""

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    # Postgres
    postgres_host: str = "postgres"
    postgres_port: int = 5432
    postgres_db: str = "ile"
    postgres_user: str = "ile_admin"
    postgres_password: str = "change_this_password"

    # API
    api_secret_key: str = "dev-secret-change-me"
    api_access_token_minutes: int = 1440
    api_single_user_mode: bool = True
    api_log_level: str = "info"

    # Ollama (local LLM)
    ollama_host: str = "ollama"
    ollama_port: int = 11434
    ollama_chat_model: str = "llama3.1:8b"
    ollama_embed_model: str = "nomic-embed-text"

    # Vault
    vault_path: str = "/vault"

    # Fixed owner id used in single-user mode
    owner_user_id: str = "00000000-0000-0000-0000-000000000001"

    @property
    def database_url(self) -> str:
        return (
            f"postgresql+psycopg://{self.postgres_user}:{self.postgres_password}"
            f"@{self.postgres_host}:{self.postgres_port}/{self.postgres_db}"
        )

    @property
    def ollama_url(self) -> str:
        return f"http://{self.ollama_host}:{self.ollama_port}"


@lru_cache
def get_settings() -> Settings:
    return Settings()
