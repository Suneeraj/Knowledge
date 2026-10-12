#!/usr/bin/env bash
set -uo pipefail

LAB="${1:-}"
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; exit 1; }
exists() { [[ -e "$1" ]] || fail "missing $1"; }

case "$LAB" in
  L01)
    ROOT="$HOME/labs/L01/campus-server"; exists "$ROOT/answer.txt"
    grep -qx 'FEEDBACK-LOOP' "$ROOT/answer.txt" || fail 'secret word is incorrect'
    [[ ! -d "$ROOT/logs" && -d "$ROOT/archive/2026-10" ]] || fail 'logs were not archived'
    [[ -z "$(find "$ROOT" -name '*.tmp' -print -quit)" ]] || fail 'a .tmp file remains'
    ;;
  L02)
    FILE="$HOME/labs/L02/answers.txt"; exists "$FILE"
    EXPECTED=$(awk '{total++; if ($9>=500) bad++; ip[$1]++; if($9==200) path[$7]++; split($4,t,":"); minute[t[2]":"t[3]]++} END {for(i in ip){unique++; if(ip[i]>maxi){maxi=ip[i];topip=i}} for(p in path)if(path[p]>maxp){maxp=path[p];topp=p} for(m in minute)if(minute[m]>maxm){maxm=minute[m];topm=m} print "Q1="total"\nQ2="bad"\nQ3="topip"\nQ4="topp"\nQ5="topm"\nQ6="unique}' "$HOME/labs/L02/access.log")
    [[ "$(sort "$FILE")" == "$(printf '%s\n' "$EXPECTED" | sort)" ]] || fail 'one or more answers are incorrect'
    ;;
  L03) [[ -x "$HOME/labs/L03/deploy-tools/backup.sh" ]] || fail 'backup.sh is not executable'; [[ "$(stat -c %a "$HOME/labs/L03/deploy-tools/db-password.txt")" == 600 ]] || fail 'secret permissions must be 600' ;;
  L04) ! ss -ltn 2>/dev/null | grep -q ':8080 ' || fail 'port 8080 is still occupied' ;;
  L05) curl -fsS http://localhost:8080/health >/dev/null || fail 'application is not healthy on port 8080' ;;
  L06) git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail 'not in a Git repository'; git log -1 --format=%s | grep -q . || fail 'no commit found' ;;
  L07) python -m pytest -q || fail 'tests fail' ;;
  L08) exists Dockerfile; exists .dockerignore; docker build -q -t campus-pulse:checkpoint . >/dev/null || fail 'image build failed' ;;
  L09) curl -fsS http://localhost:8080/health >/dev/null || fail 'container health endpoint unavailable' ;;
  L10) docker build -q -t campus-pulse:local . >/dev/null || fail 'fixed image does not build' ;;
  L11) [[ -x labs/L11-shell-scripting/my-healthcheck.sh ]] || fail 'script is not executable'; bash -n labs/L11-shell-scripting/my-healthcheck.sh || fail 'shell syntax error' ;;
  L12|L13) exists .github/workflows/ci.yml; yamllint .github/workflows/ci.yml || fail 'workflow YAML is invalid' ;;
  L14) exists .deploy/history.log; grep -Eq 'SUCCESS|ROLLBACK' .deploy/history.log || fail 'no successful deployment recorded' ;;
  *) echo 'Usage: bash scripts/checkpoint.sh L01..L14' >&2; exit 2 ;;
esac
pass "CHECKPOINT $LAB"
