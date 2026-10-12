# L13: Diagnose a Failed Pipeline

**Duration:** 35 minutes  
**Objective:** Use the first meaningful CI error to locate and repair a workflow-path, YAML, test, or smoke-test failure.

## Scenario, prerequisites, and starting point

Release candidate CI is red. Work on a branch after L12. The instructor assigns one fault without naming it: rename the workflow outside `.github/workflows`, introduce one indentation error, change a test expectation, or change the container host port to `8081:8080` while leaving the health URL on 8080.

## Investigation

```bash
git status --short
find .github -maxdepth 3 -type f -print
yamllint .github/workflows/ci.yml
pytest -q
gh run list --limit 5
gh run view --log-failed
git diff origin/main...HEAD
```

Read from top to bottom and fix only the first root cause. A missing run usually means the event or path is wrong; an immediate parse failure points to YAML; an assertion shows expected versus actual; a timeout after `docker run` points to process, port, configuration, or health URL.

## Student tasks and expected result

Record symptom, failing job/step, evidence, root cause, smallest fix, and prevention in `~/incident-notes.md`. Commit the fix, push it, and watch the rerun become green. Do not add `continue-on-error`, remove a test, or bypass the health check.

## Verification

```bash
bash scripts/checkpoint.sh L13
gh pr checks --watch
```

## Common mistakes, troubleshooting, and extension

- Debugging the last error instead of the first often wastes time.
- A workflow file on your laptop cannot run until committed and pushed.
- Re-run unchanged jobs only for transient infrastructure failure, not code failure.
- If logs are unclear, reproduce the exact command locally.

Extension: add `if: failure()` artifact/log collection. Instructor solution: restore the path `.github/workflows/ci.yml`, validate YAML, repair the expectation or port mapping, then push one focused commit.
