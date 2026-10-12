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

## 2. Architecture

```text
MCP Inspector / MCP Client
          |
          | MCP protocol
          v
   Python MCP Server
      |    |    |
     add subtract multiply
```

## 3. Prerequisites

- Python 3.10 or newer
- A terminal or PowerShell
- Basic Python knowledge

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

## 8. Test with MCP Inspector

The SDK's development workflow and CLI can change between versions. Check the current [MCP Python SDK documentation](https://github.com/modelcontextprotocol/python-sdk) for the supported Inspector command. In SDK versions that provide the `mcp dev` command, try:

```bash
mcp dev server.py
```

In the Inspector UI:

1. Connect to the Calculator server.
2. Open **Tools**.
3. Confirm `add`, `subtract`, and `multiply` are listed.
4. Test `add` with `a = 10`, `b = 20`; expect `30`.
5. Test `subtract` with `a = 10`, `b = 3`; expect `7`.
6. Test `multiply` with `a = 4`, `b = 5`; expect `20`.

## 9. What happens behind the scenes?

1. The client connects and initializes the MCP session.
2. The client discovers available tools.
3. The client requests a tool call with a name and arguments.
4. The server runs the Python function.
5. The server returns the result to the client.

The MCP server executes the function; the LLM does not execute Python code by itself.

## 10. Troubleshooting

**`ModuleNotFoundError: No module named 'mcp'`**

```bash
python -m pip install "mcp[cli]"
```

Ensure you install and run with the same Python environment.

**`python` is not recognized on Windows**

Try `py` and use the virtual environment's Python executable.

**The server appears idle**

That is normal for stdio. Connect with an MCP client or Inspector.

**Inspector command fails**

Check the SDK documentation for the current development/Inspector workflow and confirm the virtual environment is active.

## 11. Exercises

1. Add a `divide(a: float, b: float)` tool.
2. Handle division by zero clearly.
3. Add a `power(a: float, b: float)` tool.
4. Explain what `@mcp.tool()` does.

## 12. Recap

- `FastMCP` creates the server.
- `@mcp.tool()` exposes a Python function as an MCP tool.
- Type hints and docstrings help describe the tool.
- A client is needed to interact with a stdio server.

**Next: Level 4 — MCP Tools in Depth.**
