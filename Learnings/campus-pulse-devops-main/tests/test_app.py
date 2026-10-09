"""Automated tests for Campus Pulse."""
import pytest

from app import create_app
from app.config import ConfigError, load_config


def test_home_returns_welcome_message(client):
    response = client.get("/")

    assert response.status_code == 200
    body = response.get_json()
    assert body["message"] == "Welcome to Campus Pulse!"
    assert body["app"] == "Campus Pulse Test"
    assert body["environment"] == "testing"


def test_health_reports_ok_and_version(client):
    response = client.get("/health")

    assert response.status_code == 200
    body = response.get_json()
    assert body["status"] == "ok"
    assert body["version"] == "9.9.9-test"


def test_request_id_is_echoed_back(client):
    response = client.get("/health", headers={"X-Request-ID": "trace-abc-123"})

    assert response.headers["X-Request-ID"] == "trace-abc-123"


def test_request_id_is_generated_when_missing(client):
    response = client.get("/health")

    assert len(response.headers["X-Request-ID"]) == 32


def test_metrics_count_requests(client):
    client.get("/")
    client.get("/")

    response = client.get("/metrics")

    assert response.status_code == 200
    assert 'campus_pulse_requests_total{path="/",status="200"} 2' in response.get_data(as_text=True)


def test_unknown_path_returns_404(client):
    assert client.get("/does-not-exist").status_code == 404


def test_production_requires_secret_key():
    with pytest.raises(ConfigError, match="SECRET_KEY"):
        create_app({"APP_ENV": "production"})


def test_production_starts_with_secret_key():
    app = create_app({"APP_ENV": "production", "SECRET_KEY": "a-real-secret", "LOG_LEVEL": "WARNING"})

    assert app.config["SECRET_KEY"] == "a-real-secret"


def test_invalid_port_is_rejected():
    with pytest.raises(ConfigError, match="APP_PORT"):
        load_config({"APP_PORT": "eighty"})


def test_defaults_are_used_when_env_is_empty():
    config = load_config({})

    assert config["APP_PORT"] == 8080
    assert config["APP_ENV"] == "development"
    assert config["LOG_LEVEL"] == "INFO"
