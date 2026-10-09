# Instructor Solutions

- **L01:** secret `FEEDBACK-LOOP`; archive logs, remove all `.tmp`, copy notice, normalize spaced filename. Exact ERROR count is derived by `grep -h 'ERROR' ... | wc -l`.
- **L02:** derive answers from the supplied log with `awk`; `scripts/checkpoint.sh L02` independently computes the expected values.
- **L03:** `chmod u+x backup.sh`; `chmod 600 db-password.txt`; explain least privilege.
- **L04:** locate the known lab PID/socket with `ps`, `pgrep`, `ss`, or `lsof`; send SIGTERM; start the intended service on 8080. Do not kill unrelated processes.
- **L05:** correct the port/environment, supply a training-only production secret, and use stdout/journal evidence.
- **L06:** branch, focused commit, push, PR, peer review, resolve any conflict, merge, sync.
- **L07:** punctuation change caused the expected-string failure; restore behavior or update the requirement only with product approval, then add edge/config tests.
- **L08:** root `Dockerfile` and `.dockerignore` are canonical solutions; dependency-first layers, non-root UID 10001, port 8080, health check, `wsgi:app`.
- **L09:** map `8080:8080`, verify health, logs, configuration, inspect, stop/remove cleanly.
- **L10:** Incident A has inconsistent port/runtime command; compare `docker ps -a`, logs, inspect, and the canonical Dockerfile. Incident B excludes required `requirements.txt`; remove the over-broad ignore.
- **L11:** use strict mode, configurable URL/attempts/delay, `curl --fail --max-time`, loop, useful output, and exit 1 after exhaustion; compare `scripts/healthcheck.sh`.
- **L12:** `.github/workflows/ci.yml` is canonical. PRs run tests/build/smoke; only pushes to main publish.
- **L13:** restore the required path, validate indentation, correct behavior/test mismatch, or align mapping and health URL. Never suppress failure.
- **A2:** rotate exposed secrets, remove them from distribution/history with coordination, audit, then prevent recurrence.
- **L14:** deploy good image, attempt broken image, observe health failure and logs, confirm automatic rollback and history.
- **A3:** query `/metrics`, filter JSON logs, and correlate `X-Request-ID`; distinguish logs, metrics, and full traces.
- **L15:** implement `/ready`, tests, branch/PR/CI/image/deploy/log evidence; grade using `capstone/README.md`.

When a lab README gives a more specific expected result, it is authoritative. Reset with `scripts/reset-lab.sh`; verify with `scripts/checkpoint.sh`.
