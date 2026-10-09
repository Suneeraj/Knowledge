"""Campus Pulse: a small Flask app used to practise the DevOps workflow."""
import time
import uuid

from flask import Flask, g, request

from app.config import load_config
from app.logging_setup import setup_logging
from app.routes import bp


def create_app(env=None):
    """Create and configure the Flask application.

    `env` is a mapping of environment variables; tests pass their own,
    and the real server uses os.environ.
    """
    config = load_config(env)

    app = Flask(__name__)
    app.config.update(config)
    app.config["STARTED_AT"] = time.time()
    app.config["REQUEST_COUNTS"] = {}

    logger = setup_logging(config["LOG_LEVEL"])
    app.logger.handlers = logger.handlers
    app.logger.setLevel(config["LOG_LEVEL"])

    @app.before_request
    def start_request():
        g.start_time = time.perf_counter()
        g.request_id = request.headers.get("X-Request-ID") or uuid.uuid4().hex

    @app.after_request
    def finish_request(response):
        duration_ms = round((time.perf_counter() - g.start_time) * 1000, 2)
        response.headers["X-Request-ID"] = g.request_id

        key = (request.path, response.status_code)
        counts = app.config["REQUEST_COUNTS"]
        counts[key] = counts.get(key, 0) + 1

        logger.info(
            "request completed",
            extra={
                "event": "http_request",
                "request_id": g.request_id,
                "method": request.method,
                "path": request.path,
                "status": response.status_code,
                "duration_ms": duration_ms,
            },
        )
        return response

    app.register_blueprint(bp)

    logger.info(
        f"{config['APP_NAME']} {config['APP_VERSION']} configured "
        f"(env={config['APP_ENV']}, port={config['APP_PORT']})",
        extra={"event": "startup"},
    )
    return app
