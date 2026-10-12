"""Structured (JSON) logging to standard output.

Containers and CI systems collect whatever an application prints to stdout,
so the app writes one JSON object per line there instead of to a log file.
"""
import json
import logging
import sys
from datetime import datetime, timezone

LOGGER_NAME = "campus_pulse"
EXTRA_FIELDS = ("request_id", "method", "path", "status", "duration_ms", "event")


class JsonFormatter(logging.Formatter):
    """Format each log record as a single line of JSON."""

    def format(self, record):
        entry = {
            "timestamp": datetime.now(timezone.utc).isoformat(timespec="milliseconds"),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }
        for field in EXTRA_FIELDS:
            value = getattr(record, field, None)
            if value is not None:
                entry[field] = value
        if record.exc_info:
            entry["exception"] = self.formatException(record.exc_info)
        return json.dumps(entry)


def setup_logging(level):
    """Configure and return the application logger."""
    logger = logging.getLogger(LOGGER_NAME)
    logger.setLevel(level)
    logger.handlers.clear()
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(JsonFormatter())
    logger.addHandler(handler)
    logger.propagate = False
    return logger
