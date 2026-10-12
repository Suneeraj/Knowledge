# L11: Shell Scripting: A Health-Check Script

| | |
|---|---|
| **Duration** | 30 minutes |
| **Day / time** | Day 2, 09:25–09:55 |
| **Learning objective** | Write a Bash script that uses arguments with defaults, variables, a loop, an `if` statement and **exit codes**, so that other tools (CI, deploy scripts) can rely on it. |

## Scenario

Today you will build a CI pipeline and a deploy script. Both need to answer one question automatically: **"is the app healthy, yes or no?"** Computers read that answer from the **exit code**, not from text on the screen. The starter script always reports success, even when the app is down, which is the most dangerous kind of script.

## Prerequisites

- Day 1 completed. The `campus-pulse` container is running: `docker start campus-pulse` if needed.

## Starting files

| File | Purpose |
|---|---|
| `labs/L11-shell-scripting/my-healthcheck.sh` | Starter script to improve |

## Key ideas

| Concept | Example |
|---|---|
| Shebang: which interpreter runs the file | `#!/usr/bin/env bash` |
| Variable | `URL="http://localhost:8080/health"` then `"${URL}"` (always quote) |
| Argument with a default | `URL="${1:-http://localhost:8080/health}"` |
| Exit code of the last command | `$?`: `0` = success, anything else = failure |
| `if` on a command's success | `if curl --fail --silent "${URL}"; then ...; else ...; fi` |
| Loop | `for ((i = 1; i <= ATTEMPTS; i++)); do ...; done` |
| Leave with a status | `exit 0` / `exit 1` |
| Safer scripts | `set -u` (using an unset variable is an error) |

## Steps

### Step 1: Prove the starter is broken

```bash
cd "$REPO"
bash labs/L11-shell-scripting/my-healthcheck.sh
echo "exit code: $?"
docker stop campus-pulse
bash labs/L11-shell-scripting/my-healthcheck.sh
echo "exit code: $?"
docker start campus-pulse
```

Expected output: the second run prints `curl: (7) Failed to connect...` and then **`exit code: 0`**. The script lies, because the exit code comes from the last command, `echo`, which succeeded.

### Step 2: Exit codes in practice

```bash
true;  echo $?
false; echo $?
curl -s http://localhost:8080/nope > /dev/null; echo $?
curl -s --fail http://localhost:8080/nope > /dev/null; echo $?
ls /nope 2> /dev/null && echo "worked" || echo "failed"
```

**Why `--fail`:** without it, `curl` returns 0 even for an HTTP 404 or 500 response, because it did talk to the server. With `--fail`, HTTP errors count as failure (exit code 22).

### Step 3: Make the script executable and run it directly

```bash
chmod +x labs/L11-shell-scripting/my-healthcheck.sh
./labs/L11-shell-scripting/my-healthcheck.sh
```

(Remember L03: `x` permission plus the shebang let you run it with `./`.)

### Step 4: Improve the script, one requirement at a time

Edit `labs/L11-shell-scripting/my-healthcheck.sh` so that it:

1. Has `set -u` under the shebang.
2. Takes three optional arguments with defaults: `URL` (`http://localhost:8080/health`), `ATTEMPTS` (`5`) and `DELAY` in seconds (`2`).
3. Tries up to `ATTEMPTS` times with `curl --fail --silent --max-time 3`, sleeping `DELAY` seconds between tries.
4. On success prints `HEALTHY: <response body>` and **exits 0** immediately.
5. After the last failed attempt, prints `UNHEALTHY: <URL> after <ATTEMPTS> attempts` to **stderr** (`>&2`) and **exits 1**.
6. Prints a timestamp on each attempt using `$(date +%H:%M:%S)`.

Test after **each** requirement; don't write everything and hope.

### Step 5: Test both paths

```bash
./labs/L11-shell-scripting/my-healthcheck.sh; echo "exit: $?"
./labs/L11-shell-scripting/my-healthcheck.sh http://localhost:8099/health 3 1; echo "exit: $?"
./labs/L11-shell-scripting/my-healthcheck.sh http://localhost:8080/nope 2 1; echo "exit: $?"
./labs/L11-shell-scripting/my-healthcheck.sh && echo "deploy can continue"
```

Expected output, roughly:

```
[09:41:02] attempt 1/5
HEALTHY: {"status":"ok","uptime_seconds":812.4,"version":"1.0.0"}
exit: 0
[09:41:03] attempt 1/3
[09:41:04] attempt 2/3
[09:41:05] attempt 3/3
UNHEALTHY: http://localhost:8099/health after 3 attempts
exit: 1
```

### Step 6: Compare with the course's script

```bash
diff labs/L11-shell-scripting/my-healthcheck.sh scripts/healthcheck.sh
```

`scripts/healthcheck.sh` is what CI and `deploy.sh` will use later. Different code can meet the same requirements; what matters is the **behaviour** (the exit codes).

## Student tasks

1. All six requirements in Step 4 are met.
2. The script exits **0** for a healthy URL and **1** for an unreachable one (Step 5).
3. Commit it on a branch, open a PR, get it reviewed and merged.

## Verification

With `campus-pulse` running on port 8080:

```bash
bash scripts/checkpoint.sh L11
```

Expected output: `CHECKPOINT L11: PASS`.

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| `URL = "..."` | `URL: command not found` | No spaces around `=` in Bash |
| `if [ curl ... ]` | Always true or a syntax error | `if curl ...; then`: test the command directly |
| `exit 1` inside the loop | Gives up after one attempt | Only `exit 1` **after** the loop |
| Unquoted `$URL` | Breaks on URLs with `&` or spaces | `"${URL}"` |
| Windows line endings (`\r`) | `bash: $'\r': command not found` | `sed -i 's/\r$//' FILE` (the repo's `.gitattributes` prevents this) |

## Troubleshooting

- **See every line as it runs:** `bash -x labs/L11-shell-scripting/my-healthcheck.sh`
- **Check syntax without running:** `bash -n labs/L11-shell-scripting/my-healthcheck.sh`
- **Lint it:** `sudo apt-get install -y shellcheck && shellcheck labs/L11-shell-scripting/my-healthcheck.sh`

## Extension challenge

1. Add a fourth argument: the expected `version` string. Fail (exit 2) if `/health` reports a different version. Use `jq -r .version`.
2. Write `labs/L11-shell-scripting/status-report.sh` that prints the container's state, its health, the last 3 log lines and the request counts from `/metrics`.
3. Add a `--help` option that prints usage and exits 0.

## Instructor solution

See `solutions/L11-shell-scripting.md` and `reference/labs/L11-shell-scripting/my-healthcheck.sh` in the instructor repository.
