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

- `server.py` is the MCP server program.
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
└── server.py
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

## 6. Create `server.py`

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Calculator")


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

- `FastMCP("Calculator")` creates an MCP server instance.
- `@mcp.tool()` registers the decorated function as a tool.
- Type hints such as `a: int` describe expected inputs.
- The docstring describes the tool to clients.
- `return a + b` performs the actual Python operation.
- `mcp.run()` starts the server using the SDK's default stdio transport.

## 7. Run the server

With the virtual environment activated:

```bash
python server.py
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

The SDK's development workflow and CLI can change between versions. Check the current [MCP Python SDK documentation](https://github.com/modelcontextprotocol/python-sdk) for the supported Inspector command. In SDK versions that provide the `mcp dev` command, try:

```bash
mcp dev server.py
```

The development command may launch Inspector for you. If your SDK workflow instead asks you to launch Inspector separately, follow the current [MCP Inspector instructions](https://github.com/modelcontextprotocol/inspector).

In the Inspector UI:

1. Connect to the Calculator server.
2. Open **Tools**.
3. Confirm `add`, `subtract`, and `multiply` are listed.
4. Test `add` with `a = 10`, `b = 20`; expect `30`.
5. Test `subtract` with `a = 10`, `b = 3`; expect `7`.
6. Test `multiply` with `a = 4`, `b = 5`; expect `20`.

**Important:** If you launch the server through `mcp dev`, do not separately start another copy of `server.py` unless the Inspector workflow explicitly asks you to. The client/development tool generally launches the server process.

### What does `mcp dev server.py` do?

```bash
mcp dev server.py
```

This is a **development command** provided by MCP Python SDK versions that support it. It helps you develop and test the MCP server defined in `server.py`, commonly by launching a development workflow with MCP Inspector.

In practical terms, the development workflow can:

1. Load or launch your `server.py` MCP server.
2. Open or help you open MCP Inspector.
3. Let you connect to the server and discover its tools.
4. Let you enter arguments and invoke tools—for example, call `add` with `a = 10` and `b = 20`.
5. Show the tool result returned by the server.

**Important differences:**

| Command | What it does |
|---|---|
| `python server.py` | Runs your server program directly. With stdio transport, it waits for an MCP client and usually does not open a browser. |
| `mcp dev server.py` | Starts the SDK's development/testing workflow, which may launch Inspector to help you test the server. |
| `npx ...` | Runs a Node package command; MCP Inspector can be launched this way in workflows that call for it. |

The exact behavior and command availability depend on the installed MCP SDK version. If `mcp dev server.py` is not recognized or fails, check the current [MCP Python SDK documentation](https://github.com/modelcontextprotocol/python-sdk) and [MCP Inspector instructions](https://github.com/modelcontextprotocol/inspector). Do not assume every SDK version supports the same command.

**Remember:** `mcp dev server.py` does not automatically add an LLM to your project. It helps you test the MCP server and its tools.

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

Check the SDK documentation for the current development/Inspector workflow and confirm the virtual environment is active. Also verify that `node`, `npm`, and `npx` return version numbers.

## 12. Exercises

1. Add a `divide(a: float, b: float)` tool.
2. Handle division by zero clearly.
3. Add a `power(a: float, b: float)` tool.
4. Explain what `@mcp.tool()` does.

## 13. Recap

- `FastMCP` creates the server.
- `@mcp.tool()` exposes a Python function as an MCP tool.
- Type hints and docstrings help describe the tool.
- A client is needed to interact with a stdio server.
- Node.js/npm provides `npx`, which can be used to launch MCP Inspector.

**Next: Level 4 — MCP Tools in Depth.**
