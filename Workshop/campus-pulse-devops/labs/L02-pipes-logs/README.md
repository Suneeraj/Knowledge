# L02: Pipes, Redirection and Log Analysis

| | |
|---|---|
| **Duration** | 27 minutes |
| **Day / time** | Day 1, 10:53–11:20 |
| **Learning objective** | Chain small commands with pipes (`\|`) and send output to files with redirection (`>`, `>>`, `2>`) to answer questions about a real-format web server log. |

## Scenario

Yesterday morning, between 10:00 and 11:00, students complained that Campus Pulse was "broken". The only evidence is the web server's access log. Your manager wants five facts by lunchtime, with no spreadsheet and no Python, just the shell.

## Prerequisites

- L01 completed (`cd`, `ls`, `cat`, `head` and `tail`).

## Starting files

| File | Purpose |
|---|---|
| `labs/L02-pipes-logs/data/access.log` | 785 lines of web server access log (Apache "combined" format) |
| `labs/L02-pipes-logs/setup.sh` | Copies the log to `~/labs/L02/access.log` |

## Key ideas

- A **pipe** `A | B` sends the output of command A into the input of command B.
- `> file` **overwrites** a file with a command's output. `>> file` **appends** to it.
- Programs write normal output to **stdout** (stream 1) and errors to **stderr** (stream 2). `2> file` captures errors, and `> file 2>&1` captures both.
- Each small tool does one job: `grep` filters lines, `cut` and `awk` pick columns, `sort` orders, `uniq -c` counts duplicates, `wc -l` counts lines.

## Anatomy of one log line

```
10.0.2.31 - - [07/Oct/2026:10:00:03 +0000] "GET / HTTP/1.1" 200 968 "-" "curl/8.5.0"
    $1    $2 $3          $4            $5     $6  $7   $8    $9  $10
```

`awk` splits on spaces, so `$1` is the client IP, `$7` the path, and `$9` the HTTP status code.

## Steps

### Step 1: Set up and take a first look

```bash
bash labs/L02-pipes-logs/setup.sh
cd ~/labs/L02
head -n 5 access.log
wc -l access.log
```

Expected output: five log lines, then `<number> access.log`.

### Step 2: Filter with grep

```bash
grep "/health" access.log | head -n 3
grep -c "/health" access.log
grep -v "/health" access.log | wc -l
```

| Command | Why |
|---|---|
| `grep PATTERN` | keep only lines containing PATTERN |
| `grep -c` | count matching lines instead of printing them |
| `grep -v` | invert: keep lines that do **not** match |

### Step 3: Pick columns with awk and cut

```bash
awk '{print $1}' access.log | head -n 3
awk '{print $9}' access.log | sort | uniq -c
awk '$9 == 404 {print $7}' access.log | sort | uniq -c | sort -rn
```

Expected output of the second command: one line per status code (`200`, `302`, `304`, `404`, `500`, `503`) with a count in front.

| Command | Why |
|---|---|
| `awk '{print $1}'` | print column 1 of every line |
| `awk '$9 == 404 {...}'` | only lines where column 9 equals 404 |
| `sort \| uniq -c` | `uniq` only merges **adjacent** duplicates, so always `sort` first |
| `sort -rn` | sort **n**umerically, **r**everse (largest first) |

### Step 4: Redirection

```bash
grep '" 503 ' access.log > errors-503.txt
wc -l errors-503.txt
grep '" 500 ' access.log >> errors-503.txt
wc -l errors-503.txt
ls /does-not-exist
ls /does-not-exist 2> ls-error.txt
cat ls-error.txt
ls /does-not-exist > all-output.txt 2>&1
grep '" 404 ' access.log | tee errors-404.txt | wc -l
```

| Command | Why |
|---|---|
| `>` | create or overwrite the file |
| `>>` | add to the end of the file |
| `2>` | redirect only error messages |
| `> file 2>&1` | send errors to the same place as normal output |
| `tee FILE` | save a copy to FILE **and** pass it down the pipe |

## Student tasks

Create `~/labs/L02/answers.txt` with exactly these six lines, filling in the values from your commands:

```
Q1=total number of requests
Q2=number of requests with a 5xx status (500-599)
Q3=the IP address that made the most requests
Q4=the most requested path among responses with status 200
Q5=the busiest minute, in HH:MM format
Q6=number of different (unique) IP addresses
```

For example, if the answer to Q1 were 123, the first line would be `Q1=123`. Write values only, with no spaces and no counts in front.

Hints:

- Q2: `awk '$9 >= 500'`
- Q5: the time looks like `[07/Oct/2026:10:42:17`. Try `cut -d: -f2,3` and look at what comes out.
- Q6: `sort -u` keeps one copy of each line.

Then answer in `~/incident-notes.md`: **what happened at the busiest minute, and who is `203.0.113.42`?** Use evidence from the log.

## Verification

```bash
cd "$REPO"
bash scripts/checkpoint.sh L02
```

Expected output: `Q1 ... PASS` through `Q6 ... PASS`, then `CHECKPOINT L02: PASS`.

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| `uniq -c` without `sort` first | The same IP appears several times | `sort \| uniq -c` |
| `sort -r` instead of `sort -rn` | `9` sorts above `45` | Add `-n` for numeric |
| `grep 500 access.log` | Also matches sizes like `1500` and times like `10:50:00` | Match the status column with `awk '$9 >= 500'` |
| Writing `Q3= 203.0.113.42` or `Q3=95 203.0.113.42` | Checkpoint FAIL | Value only, no spaces |
| `>` when you meant `>>` | Earlier content disappears | Use `>>` to append |

## Troubleshooting

- **The command just hangs**: you probably forgot the file name, so the command is waiting for keyboard input. Press `Ctrl+C`.
- **Checkpoint says the answers file is missing**: run `ls ~/labs/L02` and check the file is named exactly `answers.txt`.
- **Want to check one answer?** Re-run the pipeline and add `| head -n 3` to see the top three, not just the first.

## Extension challenge

1. Which path produced the most 5xx errors? (one pipeline)
2. Draw a text histogram of requests per minute between 10:40 and 10:45. Hint: `uniq -c` piped into `awk '{printf "%s %s\n", $2, substr("##########...", 1, $1)}'`.
3. List the user agents used by `203.0.113.42`. Hint: `awk -F'"' '{print $6}'` splits on double quotes instead of spaces.

## Instructor solution

See `solutions/L02-pipes-logs.md` in the instructor repository.
