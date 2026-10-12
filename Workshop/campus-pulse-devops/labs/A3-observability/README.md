# A3: Logs, Metrics, and Traces

**Duration:** 20 minutes. **Objective:** Use telemetry to answer “what happened, how much, and to which request?”

## Activity

With Campus Pulse running:

```bash
curl -H 'X-Request-ID: team-incident-42' http://localhost:8080/health
curl http://localhost:8080/does-not-exist
curl http://localhost:8080/metrics
docker logs campus-pulse 2>&1 | tee /tmp/campus.log | bash scripts/log-report.sh
grep team-incident-42 /tmp/campus.log | jq .
```

Logs are discrete events, metrics are numeric trends, and traces connect work across services. This single-service app uses a request ID as trace-like correlation, not a full distributed trace.

## Tasks and solution

Identify request counts by path/status, uptime, the log for `team-incident-42`, and the slowest request. Expected: `/metrics` contains Prometheus text and the JSON log contains the same request ID. If `jq` rejects a line, remember Gunicorn may emit non-JSON lines; `log-report.sh` filters them. Extension: describe one latency histogram and one alert you would add, including a threshold and time window.
