# Instructor Guide

## Facilitation model

Use a repeating loop: explain for 10–20 minutes, demonstrate one observable action, let teams predict the result, run the lab, then debrief from evidence. Ask “What did you observe?” before “What did you change?” Never reveal an incident answer until teams show two diagnostic commands. With 80 students, number teams, use a shared help queue, and assign each TA 8–10 teams.

Pair roles rotate each lab: driver types, navigator reads and predicts, investigator records evidence. In teams of three, the observer checks safety and time. Use 5-, 10-, and 2-minute warnings. A team finishes only after its checkpoint and incident note are visible.

## Before students arrive

Follow `course/COURSE-DESIGN.md`; verify a fresh environment, tests, Docker build, CI permissions, port forwarding, and lab scripts. Keep a zipped repository and pre-pulled base image for network disruption. Open the timetable, answer key, help queue, and a clean demo Codespace. Never demonstrate with personal tokens or production credentials.

## Demonstrations

1. **Feedback loop:** make a one-character test failure, run pytest, fix, rerun.
2. **Linux streams:** pipe a log through `grep`, `awk`, `sort`, and `uniq -c` one stage at a time.
3. **Processes/HTTP:** start a server, locate its PID and port, make a request, send SIGTERM.
4. **Git graph:** two branches, a PR review, and a small conflict.
5. **Container layers:** build twice, point out cache hits, inspect user and command.
6. **CI runner:** trace event → job → step → exit code; show a skipped publish job on a PR.
7. **Kubernetes (10 minutes):** show a static diagram or pre-recorded `kubectl get deploy,pod,svc`; explain desired replicas and self-healing. Do not turn it into a cluster lab.
8. **Observability:** send a known request ID and locate it in logs and metrics.

## Incident facilitation

Ask teams to state symptom, evidence, hypothesis, experiment, result, fix, and prevention. Nudge in layers: identify the boundary; name the command that observes it; compare actual with expected. For port failures, move from process → listening socket → mapping → HTTP. For CI, start at the first red step. For containers, use `docker ps -a`, `logs`, `inspect`, then reproduce the command.

## Timing and contingencies

If behind, keep L01, L03, L06, L07, L08–L10, L12–L14, and capstone; shorten extensions and instructor demos. If GitHub is unavailable, run lint/test/build locally and simulate PR review with `git diff`; preserve commits for later push. If Docker registry access fails, use the local image and assess build/smoke evidence. Never remove health verification merely to save time.

## Assessment and inclusion

Use pre-assessment only for grouping, not grades. Practical checkpoints are formative. Grade the capstone with its 100-point rubric, whose categories directly implement the required 20/15/20/25/20 weighting. Invite students to explain verbally if typing speed is a barrier, but still require team artifacts. Use command history and incident notes as evidence, not memorization.

## Debrief prompts

- Which command changed state, and which only observed it?
- What was the earliest reliable signal of failure?
- How did automation shorten the feedback loop?
- What would make this change safe to deploy repeatedly?
- Where could a secret leak, and how would we respond?

End with the post-assessment, feedback form, and one next step from the roadmap.
