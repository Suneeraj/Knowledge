"""HTTP endpoints for Campus Pulse."""
import time

from flask import Blueprint, Response, current_app, jsonify

bp = Blueprint("main", __name__)


@bp.get("/")
def home():
    """Home endpoint: a friendly message plus some configuration details."""
    return jsonify(
        app=current_app.config["APP_NAME"],
        message="Welcome to Campus Pulse!",
        environment=current_app.config["APP_ENV"],
        version=current_app.config["APP_VERSION"],
    )


@bp.get("/health")
def health():
    """Health check used by Docker, CI smoke tests and the deploy script."""
    uptime = round(time.time() - current_app.config["STARTED_AT"], 1)
    return jsonify(
        status="ok",
        version=current_app.config["APP_VERSION"],
        uptime_seconds=uptime,
    )


@bp.get("/metrics")
def metrics():
    """Request counters in the Prometheus text format."""
    lines = [
        "# HELP campus_pulse_requests_total Total HTTP requests by path and status.",
        "# TYPE campus_pulse_requests_total counter",
    ]
    for (path, status), count in sorted(current_app.config["REQUEST_COUNTS"].items()):
        lines.append(f'campus_pulse_requests_total{{path="{path}",status="{status}"}} {count}')

    uptime = round(time.time() - current_app.config["STARTED_AT"], 1)
    lines += [
        "# HELP campus_pulse_uptime_seconds Seconds since the app started.",
        "# TYPE campus_pulse_uptime_seconds gauge",
        f"campus_pulse_uptime_seconds {uptime}",
    ]
    return Response("\n".join(lines) + "\n", mimetype="text/plain")
