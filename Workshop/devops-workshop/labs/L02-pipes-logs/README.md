# L02: Pipes, Redirection and Log Analysis

| | |
|---|---|
| **Duration** | 25 minutes |
| **Day / time** | Day 1, 10:50–11:20 |
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

```

| Command | Why |
|---|---|
| `>` | create or overwrite the file |
| `>>` | add to the end of the file |
| `2>` | redirect only error messages |
| `> file 2>&1` | send errors to the same place as normal output |


## Student tasks


```
total number of requests
number of requests with a 500 status
Print the unique IP addresses
```


## Extension challenge

 Group and count how many times each specific endpoint was requested.
