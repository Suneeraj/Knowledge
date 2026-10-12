# L12: Create a GitHub Actions CI Workflow

**Duration:** 40 minutes  
**Objective:** Create CI that lints and tests the application, builds and smoke-tests its image, and publishes only trusted `main` builds.

## Scenario and prerequisites

A regression reached the shared branch because checks existed only on one laptop. Your team must make the repository perform the same checks on every pull request. Complete L07–L09, have a GitHub remote, and know that YAML spaces define structure.

## Starting files

Use `.github/workflows/ci.yml` as the reference implementation. For the write-it-yourself experience, move it temporarily to `/tmp/ci.solution.yml` and create it from the job outline below. The six deliberately invalid examples in `yaml-clinic/` teach tabs, indentation, colons, quoting, and duplicate keys.

## Commands and tasks

```bash
yamllint labs/L12-github-actions/yaml-clinic/*.yml
mkdir -p .github/workflows
yamllint .github/workflows/ci.yml
git add .github/workflows/ci.yml
git commit -m "ci: test and build Campus Pulse"
git push -u origin HEAD
gh pr create --fill
gh pr checks --watch
```

`yamllint` validates structure locally; `git push` triggers the event; `gh pr checks` follows remote jobs. Your workflow must run on pushes and PRs to `main`, use Python 3.12, install `requirements-dev.txt`, run flake8/yamllint/pytest, build an image, start it with production configuration, call `scripts/healthcheck.sh`, print logs on failure, and publish to GHCR only on a push to `main`.

Expected final output is a GitHub check suite with green `test` and `container` jobs. The `publish` job is skipped on a PR—this is expected.

## Verification

```bash
bash scripts/checkpoint.sh L12
gh run list --limit 3
```

## Common mistakes and troubleshooting

- Workflow not listed: the file must be under `.github/workflows/` and pushed.
- “mapping values” error: inspect the cited line; use spaces, never tabs.
- Smoke test fails: open the container step and failure log; confirm port 8080 and `SECRET_KEY`.
- Package push denied: repository Actions permissions must allow package writes; PRs from forks do not receive write tokens.
- Do not print secrets or place them in YAML. Use `${{ secrets.NAME }}` and pass only to the step that needs it.

## Extension and instructor solution

Add concurrency cancellation and cache pip downloads. The supplied `.github/workflows/ci.yml` is the instructor solution. Explain why `needs: test` stops a bad build from progressing.
