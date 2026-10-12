# L07: Write and Run Automated Tests

| | |
|---|---|
| **Duration** | 20 minutes |
| **Day / time** | Day 1, 14:45–15:05 |
| **Learning objective** | Run a pytest test suite, read a failing test's output to find the cause, and write new tests that use the Arrange–Act–Assert pattern. |
| **Troubleshooting scenario** | T05: failing automated test |

## Scenario

A teammate "just tidied up some punctuation" and now the test suite is red. The product owner confirms the official greeting is exactly **`Welcome to Campus Pulse!`**. Find out what broke, using the test output, fix it, then add two new tests so that this kind of thing is caught again in the future.

## Prerequisites

- L05 completed. The virtual environment is active: your prompt starts with `(.venv)`. If not, run `source .venv/bin/activate`.

## Starting files

| File | Purpose |
|---|---|
| `tests/conftest.py` | **Fixtures**: a test app (`app`) and an HTTP test client (`client`) shared by all tests |
| `tests/test_app.py` | 10 existing tests |
| `pytest.ini` | Tells pytest where tests live |
| `labs/L07-testing/start-incident.sh` | Starts the incident |

## Key ideas

- An **automated test** is code that checks other code. A computer runs it in seconds, every time, and never gets bored.
- pytest finds functions named `test_*` in files named `test_*.py` and runs each one.
- Each test follows **Arrange → Act → Assert**: set up, do the thing, then check the result.
- Red (failing) is useful: it means a test caught a change **before** users did.

```python
def test_health_reports_ok_and_version(client):   # Arrange: pytest supplies `client`
    response = client.get("/health")               # Act
    assert response.status_code == 200             # Assert
```

## Steps

### Step 1: Run the tests while they are green

```bash
cd "$REPO"
pytest
pytest -v
```

Expected output:

```
tests/test_app.py::test_home_returns_welcome_message PASSED     [ 10%]
...
============================== 10 passed in 0.12s ==============================
```

| Command | Why |
|---|---|
| `pytest` | run every test; one dot per passing test |
| `pytest -v` | **v**erbose: one line per test, with its name |

### Step 2: Start the incident and read the failure

```bash
bash labs/L07-testing/start-incident.sh
pytest
```

Expected output (part of it):

```
FAILED tests/test_app.py::test_home_returns_welcome_message - AssertionError: assert 'Welcome to Campus Pulse.' == 'Welcome to Campus Pulse!'
```

Read pytest's detailed output from the top:

1. **Which test** failed? Look at the `FAILED` line.
2. **Which line** of the test? It is marked with `>`.
3. **Expected vs actual**: pytest shows both values and highlights the difference with `-`/`+`.

Then find **where in the code** the actual value comes from, and **what changed**:

```bash
grep -rn "Welcome to Campus Pulse" app/ tests/
git status
git diff
```

`git diff` shows uncommitted changes, which is the fastest way to answer "what changed since it last worked?".

### Step 3: Decide: fix the code or the test?

The test encodes the **requirement** (the product owner wants `!`). The code changed by accident. So **fix the code**, not the test. Then:

```bash
pytest -v
git status          # app/routes.py should no longer be listed as modified
```

### Step 4: Useful pytest options

```bash
pytest -k health -v              # only tests whose name contains "health"
pytest -x                        # stop at the first failure
pytest tests/test_app.py::test_invalid_port_is_rejected -v
pytest --collect-only -q         # list tests without running them
```

### Step 5: Write two new tests

Open `tests/test_app.py` and add these two tests at the end of the file, completing the parts marked with `...`:

**Test 1:** the home page should use `APP_NAME` from the environment.

```python
def test_home_uses_app_name_from_environment():
    app = create_app({"APP_NAME": "Team Rocket Pulse", "LOG_LEVEL": "WARNING"})
    client = app.test_client()

    response = client.get("/")

    assert response.get_json()["app"] == ...
```

**Test 2:** an invalid `LOG_LEVEL` should be rejected with a `ConfigError` whose message mentions `LOG_LEVEL`. Write it yourself, using `test_invalid_port_is_rejected` as your model.

Run:

```bash
pytest -v
```

Expected output: `12 passed`.

**Prove your tests can fail:** temporarily change the expected value in Test 1 to `"Wrong Name"`, run `pytest`, see it fail, then change it back. A test that can never fail is useless.

### Step 6: Check style

```bash
flake8 app tests wsgi.py
```

No output means no problems. The CI pipeline you build tomorrow runs this same command.

## Student tasks

1. Diagnose and fix the failing test by correcting the **code**.
2. Add the two new tests (12 tests in total, all passing).
3. `flake8` reports no problems.
4. Commit your tests on a branch `add-tests`, push, open a PR and get it reviewed and merged (L06 practice).
5. Write the incident note.

## Verification

```bash
bash scripts/checkpoint.sh L07
```

Expected output: `CHECKPOINT L07: PASS`.

## Common mistakes

| Mistake | Fix |
|---|---|
| "Fixing" the test to expect `.` | The test was right. Tests encode requirements, so change the code. |
| New test function not named `test_...` | pytest silently ignores it. Check `pytest --collect-only -q`. |
| `ModuleNotFoundError: No module named 'flask'` | The virtual environment isn't active: `source .venv/bin/activate` |
| Two tests with the same function name | Python keeps only the last one, so the count stays at 11 |
| `flake8: E302 expected 2 blank lines` | Leave two blank lines between test functions |

## Troubleshooting

- **Many tests fail, not just one**: you may have a syntax error. Look for `SyntaxError` or `IndentationError` at the top of the output.
- **`NameError: name 'ConfigError' is not defined`**: it is already imported at the top of `tests/test_app.py`. Check you did not delete the import lines.
- **Reset the app code:** `bash scripts/reset-lab.sh L07` (this does not touch your tests).

## Extension challenge

1. Use `@pytest.mark.parametrize` to test that the ports `"0"`, `"70000"` and `"abc"` are all rejected, in **one** test function.
2. Write a test proving that `/metrics` counts a 404 response (`status="404"`).
3. Write a test that the `X-Request-ID` header is different on two consecutive requests.

## Instructor solution

See `solutions/L07-testing.md` in the instructor repository.
