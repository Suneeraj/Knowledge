# Level 7: Build an MCP Client

| | |
|---|---|
| Level | 7 of 13 |
| Difficulty | Intermediate |
| Estimated time | 60–90 minutes |
| Goal | Write a Python client that connects to your MCP server, discovers tools, and calls one |

## 1. What does an MCP client do?

The MCP client connects to an MCP server and communicates with it using the MCP protocol. It can initialize a session, discover tools, and request tool calls.

In earlier levels, you built the server. In this level, you build a small client.

## 2. Project layout

Keep the server and client in one project for this exercise:

```text
mcp-level-7/
├── .venv/
├── server.py
└── client.py
```

Create and activate a Python virtual environment, then install:

```bash
python -m pip install "mcp[cli]"
```

Use Python 3.10+.

## 3. Create `server.py`

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Calculator")


@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two integers."""
    return a + b


@mcp.tool()
def multiply(a: int, b: int) -> int:
    """Multiply two integers."""
    return a * b


if __name__ == "__main__":
    mcp.run()
```

## 4. Create `client.py`

The Python SDK client API can evolve. This example uses the common stdio-client pattern in the official SDK; check the installed version's [Python SDK documentation](https://github.com/modelcontextprotocol/python-sdk) if imports or method signatures differ.

```python
import asyncio
import sys

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client


async def main():
    server_params = StdioServerParameters(
        command=sys.executable,
        args=["server.py"],
    )

    async with stdio_client(server_params) as (read_stream, write_stream):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()

            tools_result = await session.list_tools()
            print("Available tools:")
            for tool in tools_result.tools:
                print(f"- {tool.name}: {tool.description}")

            result = await session.call_tool(
                "add",
                arguments={"a": 10, "b": 20},
            )
            print("Tool result:")
            print(result)


if __name__ == "__main__":
    asyncio.run(main())
```

## 5. Understand the client

- `StdioServerParameters` describes how to start the server process.
- `sys.executable` uses the same Python interpreter running the client.
- `stdio_client(...)` launches/connects to the local server over stdio.
- `ClientSession(...)` manages MCP communication.
- `session.initialize()` performs the initialization handshake.
- `session.list_tools()` discovers the available tools.
- `session.call_tool(...)` requests execution of a named tool.

The server process is launched by the client in this example; you do not need to start `server.py` in a separate terminal.

## 6. Run the client

From the project folder, with the virtual environment active:

```bash
python client.py
```

You should see the tools `add` and `multiply` listed, followed by a tool result containing the answer `30` for `add(10, 20)`.

The precise formatting of the result may vary by SDK version.

## 7. Troubleshooting

**Server file not found:** Run `client.py` from the project folder or adjust `args` to point to the server file.

**`No module named mcp`:** Activate the virtual environment and install `mcp[cli]` there.

**Imports or API methods differ:** Consult the current SDK documentation and examples for your installed version.

**No output or connection failure:** Check for Python syntax errors in `server.py`, confirm the server can start, and ensure stdout is not being used for unrelated debug prints in a stdio server. Send diagnostics to stderr or use proper logging.

## 8. Exercises

1. Call `multiply` with `a = 6`, `b = 7`.
2. Print only the tool names.
3. Try calling a nonexistent tool and inspect the error.
4. Explain the difference between `list_tools()` and `call_tool()`.

## 9. Recap

You now have both sides:
- Server: exposes tools.
- Client: connects, discovers tools, and requests calls.

**Next: Level 8 — Connect MCP to an LLM.**
