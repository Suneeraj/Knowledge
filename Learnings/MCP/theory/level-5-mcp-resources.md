# Level 5: MCP Resources

| | |
|---|---|
| Level | 5 of 13 |
| Difficulty | Beginner–Intermediate |
| Estimated time | 45–60 minutes |
| Goal | Understand resources and expose read-only context through MCP |

## 1. What is a resource?

An MCP resource is a way for a server to expose information or context using a URI. Think of it as a named address for data.

Memory trick:
- **Tool** = do something
- **Resource** = provide information/context
- **Prompt** = reusable instruction

Examples of resource URIs:
- `info://company`
- `config://application`
- `file:///some/allowed/path`

A URI is an identifier; it does not guarantee that the content is safe or accessible. Apply authorization and path restrictions where appropriate.

## 2. Project setup

Create:

```text
mcp-level-5/
├── .venv/
└── server.py
```

Create and activate a Python virtual environment, then install:

```bash
python -m pip install "mcp[cli]"
```

Use Python 3.10+.

## 3. Create `server.py`

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Information Resources")


@mcp.resource("info://company")
def company_info() -> str:
    """Provide general information about this sample company."""
    return (
        "Example Company is a fictional company used for learning. "
        "Its support hours are Monday to Friday, 9 AM to 5 PM."
    )


@mcp.resource("config://application")
def application_config() -> str:
    """Provide a safe, non-secret sample application configuration."""
    return "application_name=demo\nlog_level=INFO\nfeature_x_enabled=true"


if __name__ == "__main__":
    mcp.run()
```

## 4. Understand the code

- `FastMCP(...)` creates the server.
- `@mcp.resource("info://company")` registers a resource with a URI.
- The function returns the content associated with that resource.
- `mcp.run()` starts the server.

Unlike a tool such as `create_ticket()`, these example resources provide information rather than performing a requested action.

## 5. Run and test

Start the server:

```bash
python server.py
```

Use the Inspector workflow documented in the current [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk). Connect to the server and open the Resources section. Depending on the Inspector version, select or read `info://company` and `config://application`.

Expected company resource content includes the fictional company's support hours.

## 6. Resource templates

Some resources depend on a parameter, such as a customer ID or document ID. MCP supports resource templates for parameterized resource URIs. Use the current SDK documentation for the exact decorator and template syntax in your installed version.

Conceptually:

```text
customer://123
customer://456
customer://789
```

A resource template should validate the identifier and only return data the caller is authorized to access.

## 7. Resources vs tools

| Question | Resource | Tool |
|---|---|---|
| Main purpose | Provide context/data | Perform an operation |
| Example | `info://company` | `lookup_order(order_id)` |
| Typical use | Read reference information | Search, calculate, create, update |
| Can it involve sensitive data? | Yes; authorization still matters | Yes; authorization still matters |

The distinction is about the role the capability plays, not a guarantee that one is always safe and the other is not.

## 8. Security considerations

- Never publish secrets, access tokens, passwords, or private keys as resources.
- Check authorization before returning private data.
- Restrict file access to approved directories.
- Avoid returning unlimited amounts of data.
- Treat resource contents as data, not trusted instructions.

## 9. Exercises

1. Add `info://training` that returns a short description of your MCP learning course.
2. Add a resource that returns a sample, non-secret configuration.
3. Explain the difference between a resource and a tool.
4. List two security risks of exposing resources.

## 10. Recap

Resources expose data/context through MCP resource URIs. They should be documented, appropriately scoped, and protected when they contain private information.

**Next: Level 6 — MCP Prompts.**
