# Level 3: Build Your First MCP Server with Python

| | |
|---|---|
| Level | 3 of 13 |
| Difficulty | Beginner |
| Estimated time | 45–60 minutes |
| Goal | Build and test an MCP server that exposes Python functions as tools |

## 1. What you will build

A calculator MCP server with three tools:

- `add(a, b)`
- `subtract(a, b)`
- `multiply(a, b)`

An MCP server exposes capabilities to an MCP client. It does not automatically include an LLM or chat interface.

### What is an MCP server?

**MCP** stands for **Model Context Protocol**. It is a standard way for an AI application or other MCP client to discover and use capabilities provided by another program.

An **MCP server** is a program that exposes capabilities—such as tools, resources, or prompts—to an MCP client through the MCP protocol.

In this tutorial:

- `a.py` is the MCP server program.
- `add`, `subtract`, and `multiply` are tools exposed by the server.
- An MCP client, such as MCP Inspector, connects to the server and can discover and call those tools.
- The server runs the Python function and returns its result to the client.
- The MCP server does **not** automatically include an LLM or a chat interface.

**Simple analogy:** The MCP server is like a restaurant kitchen that offers specific services. The MCP client is the waiter that sends an order and brings the result back. The client does not need to know how the kitchen performs the task internally.

## 2. Architecture

```text
MCP Inspector / MCP Client
          |
          | MCP protocol over stdio
          v
    Python MCP Server
      |     |      |
     add  subtract multiply
```

## 3. Prerequisites

- Python 3.10 or newer
- Node.js and npm (needed to launch MCP Inspector using `npx`)
- A terminal or PowerShell
- Basic Python knowledge
- Internet access for installing packages

Check Python:

**Windows**
```powershell
py --version
```

**Linux/macOS**
```bash
python3 --version
```

## 4. Create the project

```text
mcp-level-3/
├── .venv/
└── a.py
```

**Windows PowerShell**
```powershell
mkdir mcp-level-3
cd mcp-level-3
py -m venv .venv
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks activation, use Command Prompt:
```bat
.venv\Scripts\activate.bat
```

**Linux/macOS**
```bash
mkdir mcp-level-3
cd mcp-level-3
python3 -m venv .venv
source .venv/bin/activate
```

## 5. Install the MCP SDK

```bash
python -m pip install --upgrade pip
python -m pip install "mcp[cli]"
```

### Why do we use quotes in `mcp[cli]`?

```bash
python -m pip install "mcp[cli]"
```

- **`mcp`**: The Python package for the Model Context Protocol (MCP) SDK.
- **`[cli]`**: Specifies an optional dependency group that installs additional command-line tools used for MCP development.
- **Double quotes (`" "`)**: Protect the square brackets from being interpreted specially by certain shells, such as Zsh.

**Can we install it without quotes?**

Yes, in some shells. However, using quotes is recommended for compatibility across different environments.

```bash
# Recommended
python -m pip install "mcp[cli]"

# Also valid in Bash and Zsh
python -m pip install 'mcp[cli]'
```

**Note:** In Windows Command Prompt (CMD), the command may also work without quotes. Using quotes is a safe, consistent practice.

Check the installation:
```bash
python -m pip show mcp
```

Official references:
- [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk)
- [MCP documentation](https://modelcontextprotocol.io/)

## 6. Create `a.py`

**SDK version note:** This code uses the MCP Python SDK 2.x API. In SDK 2.x, `FastMCP` was renamed to `MCPServer`, and the import path is `mcp.server.mcpserver`. Use `from mcp.server.mcpserver import MCPServer`.


```python
from mcp.server.mcpserver import MCPServer

mcp = MCPServer("Calculator")


@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two integers."""
    return a + b


@mcp.tool()
def subtract(a: int, b: int) -> int:
    """Subtract b from a."""
    return a - b


@mcp.tool()
def multiply(a: int, b: int) -> int:
    """Multiply two integers."""
    return a * b


if __name__ == "__main__":
    mcp.run()
```

### Understand the code

- `MCPServer("Calculator")` creates an MCP server instance in the MCP Python SDK 2.x.
- `@mcp.tool()` registers the decorated function as a tool.
- Type hints such as `a: int` describe expected inputs.
- The docstring describes the tool to clients.
- `return a + b` performs the actual Python operation.
- `mcp.run()` starts the server using the SDK's default stdio transport.

## 7. Run the server

With the virtual environment activated:

```bash
python a.py
```

A stdio server may appear to do nothing because it waits for messages from an MCP client. It does not automatically open a web page. Stop it with `Ctrl+C`.

## 8. Install Node.js and verify `npx` (required for MCP Inspector)

MCP Inspector can be launched with `npx`. `npx` is included with npm, which is normally installed alongside Node.js.

### Windows

1. Open the official Node.js website: https://nodejs.org/
2. Download the **LTS** version for Windows.
3. Run the installer and keep the option to add Node.js to `PATH` enabled.
4. Finish installation. Close and reopen PowerShell or Command Prompt.

### macOS

1. Open https://nodejs.org/
2. Download and install the **LTS** version for macOS, or use your preferred trusted package manager.
3. Open a new terminal after installation.

### Linux

Use the installation instructions for your Linux distribution from the official site: https://nodejs.org/en/download

Avoid mixing multiple Node.js installation methods unless you know how their `PATH` settings interact.

### Verify Node.js, npm, and npx

Open a **new** terminal and run:

```bash
node --version
npm --version
npx --version
```

Each command should print a version number. If a command is not recognized, restart the terminal and check that Node.js was added to your `PATH`.

## 9. Test with MCP Inspector

There are two ways to test your MCP server:

- **Option A — `mcp dev a.py`:** Use the SDK's development command when it is available and configured correctly.
- **Option B — launch Inspector with `npx`:** Use this alternative if the development workflow fails or you want to configure the server manually.

### Option A: Try `mcp dev a.py`

From the project folder, with the same Python environment active that has the MCP SDK installed, run:

```bash
mcp dev a.py
```

If the command starts successfully, follow the Inspector URL/instructions shown in the terminal. You generally do not need to start `python a.py` separately because the development workflow launches the server for testing.

Check the CLI commands available in your installation with:

```bash
mcp --help
```

If `dev` is listed, the CLI recognizes that command. However, the command can still fail if its configured server launch command depends on a tool that is not installed or available on `PATH`.

### Option B: Launch MCP Inspector using `npx` (alternative)

Use this option if `mcp dev a.py` does not work, or if you want to create a server entry manually in Inspector.

**Prerequisites:** Node.js and npm installed, with `node`, `npm`, and `npx` available in your terminal.

1. Open a terminal in your project folder.
2. Start Inspector:

   ```bash
   npx @modelcontextprotocol/inspector
   ```

3. Open the local URL printed in the terminal. It is commonly `http://localhost:6274`.
4. In Inspector, open **Servers** and choose **Add Servers**.
5. Add a new server and enter the following configuration. Field names may vary slightly by Inspector version.

   | Field | Example value |
   |---|---|
   | Server ID | `my-calculator` |
   | Transport | `STDIO` |
   | Command | Full path to your Python executable, including `python.exe` on Windows |
   | Arguments | `a.py` |
   | Working directory | Absolute path to the folder containing `a.py` |

   **Windows example:**

   ```text
   Command:
   C:\Users\your-user\AppData\Local\Programs\Python\Python313\python.exe

   Arguments:
   a.py

   Working directory:
   C:\Users\your-user\OneDrive\Desktop\tutorial
   ```

   Replace the example paths with the paths on your computer. The working directory is the **folder**, not the full path to `a.py`.

6. Save the server configuration and connect.
7. Open **Tools** and confirm that `add`, `subtract`, and `multiply` are listed.
8. Test `add` with `a = 10`, `b = 20`; expect `30`.
9. Test `subtract` with `a = 10`, `b = 3`; expect `7`.
10. Test `multiply` with `a = 4`, `b = 5`; expect `20`.

### Why did the `uv` command fail?

In this walkthrough, the failed Inspector entry was configured to run:

```bash
uv run --with mcp==2.3.0 mcp run a.py
```

The console error was:

```text
'uv' is not recognized as an internal or external command
```

This means Windows could not find the `uv` executable. The command uses **uv**, a separate Python package/environment tool; installing the MCP SDK with `pip` does not install `uv`.

Because this project uses `pip`, you can avoid `uv` by configuring Inspector to launch Python directly, as shown in Option B. You do **not** need to install `uv` just to use MCP Inspector.

### If Inspector reports `spawn python ENOENT`

This means Inspector could not find the `python` executable in its environment. On Windows, use the **absolute path to `python.exe`** in the Command field instead of just `python`.

To find the Python path, run this in Git Bash:

```bash
which python
```

If it returns a path such as:

```text
/c/Users/your-user/AppData/Local/Programs/Python/Python313/python
```

use the corresponding Windows executable path in Inspector:

```text
C:\Users\your-user\AppData\Local\Programs\Python\Python313\python.exe
```

Also verify that this Python environment has the MCP SDK installed:

```bash
python -m pip show mcp
```

### Important differences

| Command | What it does |
|---|---|
| `python a.py` | Runs the server program directly. With stdio transport, it waits for an MCP client and usually does not open a browser. |
| `mcp dev a.py` | Starts the MCP SDK's development/testing workflow when supported and correctly configured. |
| `npx @modelcontextprotocol/inspector` | Launches the Inspector UI. You can add a STDIO server entry that launches Python and `a.py`. |

**Remember:** MCP Inspector is a testing tool. It does not automatically add an LLM or chat interface to your project.

## 10. What happens behind the scenes?

1. The client connects and initializes the MCP session.
2. The client discovers available tools.
3. The client requests a tool call with a name and arguments.
4. The server runs the Python function.
5. The server returns the result to the client.

The MCP server executes the function; the LLM does not execute Python code by itself.

## 11. Troubleshooting

**`ModuleNotFoundError: No module named 'mcp'`**

```bash
python -m pip install "mcp[cli]"
```

Ensure you install and run with the same Python environment.

**`python` is not recognized on Windows**

Try `py` and use the virtual environment's Python executable.

**`node` or `npx` is not recognized**

Install the Node.js LTS version, close and reopen the terminal, and run the version checks again.

**The server appears idle**

That is normal for stdio. Connect with an MCP client or Inspector.

**Inspector command fails**

Try the manual `npx @modelcontextprotocol/inspector` workflow in Section 9. If Inspector reports `spawn python ENOENT`, configure the server with the absolute path to `python.exe`. If the console says `uv` is not recognized, remove the `uv`-based launch configuration and use the Python-based configuration instead.

## 12. Exercises

1. Add a `divide(a: float, b: float)` tool.
2. Handle division by zero clearly.
3. Add a `power(a: float, b: float)` tool.
4. Explain what `@mcp.tool()` does.

## 13. Recap

- `MCPServer` creates the server in MCP Python SDK 2.x.
- `@mcp.tool()` exposes a Python function as an MCP tool.
- Type hints and docstrings help describe the tool.
- A client is needed to interact with a stdio server.
- Node.js/npm provides `npx`, which can be used to launch MCP Inspector.

**Next: Level 4 — MCP Tools in Depth.**
