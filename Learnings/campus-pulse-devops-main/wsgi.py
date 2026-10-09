"""Entry point for running Campus Pulse.

- In a container, gunicorn imports `app` from this file.
- Locally, `python wsgi.py` starts Flask's development server.
"""
import json
import sys

from app import create_app
from app.config import ConfigError

try:
    app = create_app()
except ConfigError as error:
    print(json.dumps({"level": "CRITICAL", "message": f"Configuration error: {error}"}), file=sys.stderr)
    sys.exit(1)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=app.config["APP_PORT"])
