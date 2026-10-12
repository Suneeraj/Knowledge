"""Shared pytest fixtures."""
import pytest

from app import create_app

TEST_ENV = {
    "APP_NAME": "Campus Pulse Test",
    "APP_ENV": "testing",
    "APP_VERSION": "9.9.9-test",
    "LOG_LEVEL": "WARNING",
}


@pytest.fixture
def app():
    return create_app(TEST_ENV)


@pytest.fixture
def client(app):
    return app.test_client()
