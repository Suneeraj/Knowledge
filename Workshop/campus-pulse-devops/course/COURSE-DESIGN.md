# Campus Pulse: DevOps from Zero

## Course description

This two-day, instructor-led workshop takes third-year engineering students through one continuous project: **Linux → Git → testing → containers → CI/CD → deployment → logs and monitoring**. Teams of two or three operate a small Flask service, investigate controlled failures, and finish by demonstrating an end-to-end change. The balance is approximately 30% explanation and 70% practice.

## Audience and prerequisites

Students need basic programming knowledge, a GitHub account, a modern browser, and willingness to use a terminal. No Linux, Docker, CI/CD, or cloud experience is assumed. The class supports 80 students (27–40 teams), one lead instructor, and ideally four teaching assistants.

## Measurable learning outcomes

By the end, students can define DevOps, CI, CD, containers, automation, and feedback loops; use Linux files, permissions, processes, ports, and logs; collaborate through branches and pull requests; run automated tests; build and troubleshoot a container; create and diagnose a GitHub Actions pipeline; deploy with a health check and rollback; identify safe secret handling; interpret basic logs and metrics; and demonstrate a complete workflow.

## Environment and architecture

GitHub Codespaces is the primary lab environment. Each team uses an Ubuntu 24.04 container with Python 3.12, Docker-in-Docker, Git, GitHub CLI, and port 8080 forwarding. The free alternative is a preconfigured Ubuntu 24.04 VM using Docker Engine—Docker Desktop and paid cloud accounts are not required.

```text
browser/curl → forwarded host port 8080 → Docker container → Gunicorn → Flask
                       │                       │
                       └── GitHub Actions ─────┴── tests, image, GHCR
```

## Detailed timetable

No conceptual segment exceeds 25 minutes; each is followed by a question, demonstration, or lab.

### Day 1 — Foundations to containers

| Time | Topic and objective | Method/activity | Files/tools | Expected output |
|---|---|---|---|---|
| 09:00–09:20 | Welcome, pre-assessment, workflow | Quiz and pair discussion | `assessments/PRE-ASSESSMENT.md` | Baseline score |
| 09:20–09:50 | DevOps, feedback loops, CI/CD | Mini-lecture + map the project flow | Slides 1–8 | Team workflow sketch |
| 09:50–10:25 | Filesystem/navigation | L01 challenge | Bash, `find`, `tree` | Checkpoint PASS |
| 10:25–10:40 | Break | — | — | — |
| 10:40–10:53 | Text streams | Demo: stdin/stdout/stderr | Bash | One pipeline |
| 10:53–11:20 | Pipes and logs | L02 incident | `grep`, `awk`, `sort` | Six evidence-based answers |
| 11:20–11:28 | Users and permissions | Permission-card question | `ls -l` | Decode `rwx` |
| 11:28–11:50 | Least privilege | L03 | `chmod`, `stat` | Secure runnable script |
| 11:50–12:20 | Processes, ports, HTTP/DNS | L04 | `ps`, `ss`, `curl`, `dig` | Port incident resolved |
| 12:20–12:45 | Env vars, packages, services/logs | L05 | Flask, `journalctl` | Healthy configured app |
| 12:45–13:30 | Lunch | — | — | — |
| 13:30–13:50 | Git objects and collaboration | Live branch/merge demo | Git/GitHub | Visual commit graph |
| 13:50–14:28 | Branch/PR workflow | L06 team lab | Git, `gh` | Reviewed PR |
| 14:28–14:48 | Testing feedback | L07 | pytest | Green tests + new cases |
| 14:48–15:03 | Break | — | — | — |
| 15:03–15:23 | Container concepts | Image/layer/process demo | Docker | Explain image vs container |
| 15:23–15:53 | Dockerfile creation | L08 | Dockerfile | Built image |
| 15:53–16:18 | Container lifecycle | L09 | Docker, curl | Healthy container |
| 16:18–16:43 | Troubleshooting | L10 | inspect/logs | Root-cause notes |
| 16:43–17:00 | Retrieval practice and exit ticket | Team quiz | `course/DAILY-REVIEW.md` | Day 1 evidence |

### Day 2 — Automation to delivery

| Time | Topic and objective | Method/activity | Files/tools | Expected output |
|---|---|---|---|---|
| 09:00–09:15 | Day 1 retrieval | Quiz + explain to partner | Review sheet | Corrected answers |
| 09:15–09:45 | Shell automation | L11 | Bash | Retrying health-check |
| 09:45–10:05 | YAML fundamentals | YAML clinic | `yamllint` | Six diagnoses |
| 10:05–10:25 | CI/CD and Actions model | Workflow diagram + runner demo | GitHub Actions | Job/step explanation |
| 10:25–10:40 | Break | — | — | — |
| 10:40–11:20 | Build CI pipeline | L12 | Actions, pytest, Docker | Green workflow |
| 11:20–11:55 | Diagnose failed pipeline | L13 | Actions logs | Fixed workflow |
| 11:55–12:10 | Secrets/DevSecOps | Spot-the-leak activity | A2 cards | Safe remediation |
| 12:10–12:30 | Kubernetes concepts only | Instructor demo: Pod/Deployment/Service | `kubectl` screenshots | Concept map; no cluster lab |
| 12:30–13:15 | Lunch | — | — | — |
| 13:15–13:35 | Deployment, health, rollback | Blue/green sketch + failure question | Docker | Rollback decision |
| 13:35–14:15 | Deploy and recover | L14 | deploy scripts | SUCCESS/ROLLBACK history |
| 14:15–14:35 | Logs, metrics, traces | A3 correlation activity | `/metrics`, JSON logs | Incident timeline |
| 14:35–14:50 | Break | — | — | — |
| 14:50–16:30 | Final capstone | Team challenge | Full repository | PR, CI, image, demo |
| 16:30–16:50 | Post-assessment and feedback | Individual quiz/form | `assessments/` | Scores and feedback |
| 16:50–17:00 | Roadmap and close | Commit-to-one-next-step | Roadmap below | Personal action |

## Preparation checklists

### Instructor (one week before)

- Create a template repository and test a fresh Codespace and Ubuntu VM.
- Confirm GitHub Actions and package permissions are enabled; pre-pull `python:3.12-slim` on VMs.
- Create teams and repository access; assign one TA per 8–10 teams.
- Run `pytest`, `flake8`, `yamllint`, Docker build, smoke test, and all incident/reset scripts.
- Print backup quiz/cheat sheets and prepare a local repository archive for network failure.
- Never distribute a real secret; use only training values.

### Students (before class)

- Create and verify a GitHub account; enable two-factor authentication.
- Join the assigned repository and confirm Codespaces access.
- Bring a laptop, charger, browser, and stable internet connection.
- Complete the short pre-assessment without researching answers.
- VM users: install Ubuntu 24.04 and run `bash scripts/setup-vm.sh` before class.

## Repository map and deliverables

`app/` and `tests/` hold the service and tests; `.github/workflows/` holds CI; `scripts/` holds environment, health, deploy, rollback, reset, and checkpoint automation; `labs/` holds student exercises; `solutions/` holds instructor solutions; `capstone/` holds the final challenge; `course/`, `instructor/`, and `assessments/` hold teaching materials.

The 15 numbered labs/activities cover navigation, log analysis, permissions, process/port diagnosis, configuration, Git collaboration, testing, Dockerfile creation, container operation, broken containers, shell scripting, GitHub Actions, failed pipelines, deployment/rollback, and the capstone. Short YAML, secrets, and observability activities reinforce the major labs.

## Suggested learning roadmap

Week 1: repeat the workshop without notes and add one endpoint. Week 2: learn Git rebase and protected branches. Week 3: study Docker networking, volumes, and Compose. Week 4: add code coverage and dependency scanning. Weeks 5–6: deploy to a free/local Kubernetes environment such as kind, then learn Deployments, Services, ConfigMaps, and Secrets. Continue with Linux administration, one cloud free tier only when available without payment, infrastructure as code, and an observability stack.
