"""Application configuration loaded from environment variables.

Every setting has a safe default for local development, except SECRET_KEY,
which must be provided when APP_ENV=production.
"""
import os

VALID_LOG_LEVELS = {"DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"}
DEV_SECRET_KEY = "dev-only-insecure-key"


class ConfigError(Exception):
    """Raised when required configuration is missing or invalid."""


def load_config(env=None):
    """Build the configuration dictionary from a mapping of environment variables."""
    env = os.environ if env is None else env

    config = {
        "APP_NAME": env.get("APP_NAME", "Campus Pulse"),
        "APP_ENV": env.get("APP_ENV", "development").lower(),
        "APP_PORT": env.get("APP_PORT", "8080"),
        "LOG_LEVEL": env.get("LOG_LEVEL", "INFO").upper(),
        "APP_VERSION": env.get("APP_VERSION", "1.0.0"),
        "SECRET_KEY": env.get("SECRET_KEY", ""),
    }

    try:
        port = int(config["APP_PORT"])
    except ValueError:
        raise ConfigError(f"APP_PORT must be a number, got '{config['APP_PORT']}'")
    if not 1 <= port <= 65535:
        raise ConfigError(f"APP_PORT must be between 1 and 65535, got {port}")
    config["APP_PORT"] = port

    if config["LOG_LEVEL"] not in VALID_LOG_LEVELS:
        raise ConfigError(
            f"LOG_LEVEL must be one of {sorted(VALID_LOG_LEVELS)}, got '{config['LOG_LEVEL']}'"
        )

    if not config["SECRET_KEY"]:
        if config["APP_ENV"] == "production":
            raise ConfigError("SECRET_KEY is required when APP_ENV=production")
        config["SECRET_KEY"] = DEV_SECRET_KEY

    return config
