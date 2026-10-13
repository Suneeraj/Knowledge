# Level 4: MCP Tools in Depth

| | |
|---|---|
| Level | 4 of 13 |
| Difficulty | Beginner–Intermediate |
| Estimated time | 60 minutes |
| Goal | Design tools with clear schemas, validation, errors, and safe behavior |

## 1. What is a tool?

An MCP tool is an operation that an MCP client can ask a server to execute. Examples include looking up an order, calculating a total, or listing EC2 instances.

A useful tool has:
- A clear name
- A clear description
- Typed input parameters
- Predictable output
- Validation and understandable errors
- Appropriate safeguards for actions that change data

## 2. Project setup

Create a folder:

```text
mcp-level-4/
├── .venv/
└── server.py
```

Create and activate a virtual environment as in Level 3, then install:

```bash
python -m pip install "mcp[cli]"
```

## 3. Example server

Create `server.py`:

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Math Tools")


@mcp.tool()
def calculate_total(price: float, quantity: int) -> dict:
    """Calculate the total cost for a price and quantity.

    Args:
        price: Unit price. Must be zero or greater.
        quantity: Number of units. Must be zero or greater.
    """
    if price < 0:
        raise ValueError("price must be zero or greater")
    if quantity < 0:
        raise ValueError("quantity must be zero or greater")

    total = price * quantity
    return {
        "price": price,
        "quantity": quantity,
        "total": round(total, 2),
    }


@mcp.tool()
def divide(numerator: float, denominator: float) -> float:
    """Divide numerator by denominator."""
    if denominator == 0:
        raise ValueError("denominator cannot be zero")
    return numerator / denominator


if __name__ == "__main__":
    mcp.run()
```

## 4. Tool schemas

The SDK uses type hints and function metadata to describe a tool's input schema to clients.

For example:

```python
def calculate_total(price: float, quantity: int) -> dict:
    ...
```

communicates that `price` is a number and `quantity` is an integer. The docstring explains their meaning.

**Good descriptions are specific.** Prefer `Find an order by its order ID` over `Gets data`.

## 5. Validation

Do not rely only on the model or client to provide valid input. Validate important business rules inside the tool.

Examples:
- Quantity cannot be negative.
- A denominator cannot be zero.
- An identifier must be in the expected format.
- A requested file must be inside an allowed directory.

Type hints describe expected data types; they do not replace all business validation.

## 6. Error handling

Raise a clear exception when the request cannot be completed:

```python
if denominator == 0:
    raise ValueError("denominator cannot be zero")
```

The MCP SDK/client will represent tool failures according to its protocol behavior. Avoid returning fake success values for failures. Do not expose passwords, tokens, secret keys, or sensitive internal stack traces in error messages.

For expected business failures, choose a consistent approach and document it. For unexpected failures, log enough diagnostic information securely and return a safe, understandable error.

## 7. Async tools

When a tool needs to wait for asynchronous I/O and the library supports async operations, it can be declared with `async def`. For example:

```python
@mcp.tool()
async def get_status() -> str:
    """Return a sample service status."""
    return "available"
```

This example is intentionally simple. Use asynchronous libraries for actual async network or database operations; adding `async` alone does not make blocking work non-blocking.

## 8. Run and test

```bash
python server.py
```

Use the MCP Inspector workflow documented by the current [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk) to connect and test:
- `calculate_total(price=12.5, quantity=4)` → total `50.0`
- `divide(numerator=10, denominator=2)` → `5.0`
- `divide(numerator=10, denominator=0)` → clear error

## 9. Safe tool design

For tools that read data:
- Return only information the user is authorized to access.
- Limit result size.
- Validate filters and identifiers.

For tools that change data:
- Use least-privilege credentials.
- Consider confirmation for consequential actions.
- Make operations auditable.
- Avoid exposing arbitrary shell execution or unrestricted database queries.

## 10. Exercises

1. Add `apply_discount(price, percentage)` with validation that percentage is between 0 and 100.
2. Add a tool description that clearly states units and expected inputs.
3. Decide what error should be returned when an ID does not exist.
4. Explain why a type hint alone is not complete validation.

## 11. Recap

A strong tool is easy to discover, has a clear schema, validates input, handles errors safely, and does only the work its name and description promise.

**Next: Level 5 — MCP Resources.**
