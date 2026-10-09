# L15: Campus Pulse End-to-End Capstone

**Duration:** 100 minutes. **Team size:** 2–3. **Deliverable:** a five-minute live demonstration backed by repository evidence.

## Challenge

Fork or clone the assigned repository. Create a feature branch and add `GET /ready`, returning JSON with `status`, `environment`, and `version`. Add or update automated tests. Commit, push, and open a pull request. The instructor then assigns one controlled CI fault (wrong expectation, invalid YAML indentation, wrong workflow path, or mismatched container port). Diagnose it from evidence, correct it, and obtain green CI. Build a versioned container, run/deploy it, verify `/health` and `/ready`, inspect application and pipeline logs, then explain the workflow.

## Required evidence and commands

```bash
git switch -c feature/readiness
pytest -v
git add app tests
git commit -m "feat: add readiness endpoint"
git push -u origin feature/readiness
gh pr create --fill
gh pr checks --watch
docker build -t campus-pulse:capstone .
SECRET_KEY=capstone-training-only APP_ENV=production docker run -d --name capstone -p 8080:8080 campus-pulse:capstone
bash scripts/healthcheck.sh http://localhost:8080/health
curl -fsS http://localhost:8080/ready | jq .
docker logs --tail 30 capstone
```

Submit the PR URL, green run URL, commit SHA, test output, image tag, health/readiness output, relevant logs, and an incident note containing symptom, evidence, root cause, fix, and prevention. Remove the lab container afterward: `docker rm -f capstone`.

## Verification, pitfalls, and extension

The result has both endpoints returning HTTP 200, all tests passing, a reviewed PR, green CI, a non-root container, and correlated logs. Do not work on `main`, weaken tests, commit secrets, use `continue-on-error`, or claim success from a container that was never health-checked. If blocked, inspect the first failing step and reproduce it locally. Extension: add a readiness metric or documentation without extending the time box.

## 100-point rubric

| Area | Points | Full-credit evidence |
|---|---:|---|
| Linux exercises | 20 | Safe commands, process/port/log evidence, clear incident note |
| Git collaboration | 15 | Feature branch, focused commits, reviewed PR, resolved feedback |
| Containers | 20 | Reproducible build, non-root runtime, correct port/config, healthy run |
| CI/CD pipeline | 25 | Tests/lint/build/smoke test, diagnosed failure, green rerun, no secret leak |
| Capstone demonstration | 20 | Five-minute coherent demo, both endpoints, logs, role sharing, accurate explanation |

Performance bands: 90–100 excellent, 75–89 competent, 60–74 developing, below 60 incomplete. Critical safety deductions may apply for exposing a real secret or destructive commands outside the lab scope.

## Instructor solution

Add a `/ready` route mirroring configuration fields, test its status and JSON keys, follow the normal branch/PR workflow, repair the assigned fault rather than bypassing it, build the supplied Dockerfile, and run the exact verification commands above. Award points only for observable evidence, not narration alone.
