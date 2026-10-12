# Campus Pulse Lab Manual

Work through the labs in order. Each lab folder contains a `README.md` with every command you need.

## How every lab works

1. Open a terminal in your Codespace (or VM). `cd "$REPO"` always takes you back to the repository root.
2. Read the **Scenario** first. Most labs start with something broken on purpose.
3. Type the commands yourself rather than copy-pasting; you learn the shape of them faster.
4. **Investigate before you fix.** When something fails, collect evidence (error text, logs, `ls -l`, `ss`, `docker logs`) and write down the root cause before changing anything.
5. Finish with the checkpoint and show the `PASS` line to your TA:

```bash
bash scripts/checkpoint.sh L01
```

6. Stuck after 10 minutes? Raise your hand. Want to start again? `bash scripts/reset-lab.sh L01`

> **Honour rule:** some labs contain `start-incident.sh` or `setup.sh` scripts that break things on purpose.
> Do not read them before you have diagnosed the problem. Reading the script is not the skill you are being assessed on.

## Incident notes

For each incident, add a short note to `~/incident-notes.md` (outside the repo):

```
## L03: backup.sh will not run
Symptom:    ./backup.sh: Permission denied
Evidence:   ls -l backup.sh shows -rw-r--r-- (no x bit)
Root cause: the script is not executable
Fix:        chmod u+x backup.sh
Prevention: commit scripts with the executable bit set (git update-index --chmod=+x)
```

TAs will ask to see these notes. They count toward your lab marks.

## Lab list

| Lab | Title | Day | Time | Folder |
|-----|-------|-----|------|--------|
| L01 | Linux navigation and file management challenge | 1 | 35 min | `labs/L01-linux-navigation` |
| L02 | Pipes, redirection and log analysis | 1 | 27 min | `labs/L02-pipes-logs` |
| L03 | Permissions troubleshooting | 1 | 22 min | `labs/L03-permissions` |
| L04 | Process and port investigation | 1 | 30 min | `labs/L04-processes-ports` |
| L05 | Environment variables, packages and logs | 1 | 25 min | `labs/L05-env-config` |
| L06 | Git branches and pull requests | 1 | 38 min | `labs/L06-git-collaboration` |
| L07 | Write and run automated tests | 1 | 20 min | `labs/L07-testing` |
| L08 | Write a Dockerfile | 1 | 30 min | `labs/L08-dockerfile` |
| L09 | Build and run the container | 1 | 25 min | `labs/L09-build-run` |
| L10 | Diagnose a broken container | 1 | 25 min | `labs/L10-broken-container` |
| L11 | Shell scripting: a health-check script | 2 | 30 min | `labs/L11-shell-scripting` |
| A1  | YAML clinic (activity) | 2 | 20 min | `labs/L12-github-actions/yaml-clinic` |
| L12 | Create a GitHub Actions CI workflow | 2 | 40 min | `labs/L12-github-actions` |
| L13 | Diagnose a failed pipeline | 2 | 35 min | `labs/L13-broken-pipeline` |
| A2  | Secrets and "spot the leak" (activity) | 2 | 15 min | `labs/A2-secrets` |
| L14 | Deploy, health check and rollback | 2 | 40 min | `labs/L14-deploy-rollback` |
| A3  | Logs, metrics and traces (activity) | 2 | 20 min | `labs/A3-observability` |
| L15 | Capstone | 2 | 100 min | `capstone/` |

Instructor solutions are consolidated in `solutions/INSTRUCTOR-SOLUTIONS.md`. The completed repository
also contains reference Docker and CI files; follow each lab's starting-file note when teaching the
from-scratch exercise.
