# Campus Pulse image, as modified by the "performance tuning" contractor.
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_PORT=5000

WORKDIR /app
RUN useradd --create-home --uid 10001 appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ app/
COPY wsgi.py .

USER appuser
EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:' + os.environ.get('APP_PORT', '8080') + '/health', timeout=2)"

CMD ["sh", "-c", "exec gunicorn --bind 0.0.0.0:${APP_PORT} --workers 1 --threads 4 app:wsgi"]
