# Level 6: MCP Prompts

| | |
|---|---|
| Level | 6 of 13 |
| Difficulty | Beginner–Intermediate |
| Estimated time | 45–60 minutes |
| Goal | Create reusable prompt templates exposed by an MCP server |

## 1. What is an MCP prompt?

An MCP prompt is a reusable prompt template that a client can discover and present to a user or workflow. It helps standardize common tasks.

Memory trick:
- Tool = action
- Resource = data/context
- Prompt = reusable instructions

For example, a team might reuse a prompt for:
- Summarizing an incident
- Reviewing a pull request
- Explaining a log excerpt
- Drafting a customer-support response

A prompt template does not itself guarantee that an LLM will run. The host/client workflow determines how the prompt is used.

## 2. Project setup

Create:

```text
mcp-level-6/
├── .venv/
└── server.py
```

Create and activate a virtual environment, then install:

```bash
python -m pip install "mcp[cli]"
```

Use Python 3.10+.

## 3. Create `server.py`

The official Python SDK provides a prompt decorator. Example:

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Team Prompts")


@mcp.prompt()
def summarize_incident(
    incident_title: str,
    incident_notes: str,
) -> str:
    """Create a reusable prompt for summarizing an incident."""
    return f"""
You are helping prepare an incident summary.

Incident title:
{incident_title}

Incident notes:
{incident_notes}

Please provide:
1. A concise summary
2. Customer or service impact
3. Known facts versus unknowns
4. Follow-up actions
Do not invent missing facts.
""".strip()


if __name__ == "__main__":
    mcp.run()
```

## 4. Understand the code

- `@mcp.prompt()` registers a prompt template.
- `incident_title` and `incident_notes` are inputs to the template.
- The function returns prompt text.
- The prompt instructs the model to distinguish known facts from unknowns.

Do not place secrets or confidential information in reusable prompts. Be careful when interpolating untrusted user content; the prompt should not treat supplied notes as trusted instructions.

## 5. Run and test

```bash
python server.py
```

Use the Inspector workflow described in the current [MCP Python SDK documentation](https://github.com/modelcontextprotocol/python-sdk). Connect to the server, open the Prompts section, choose `summarize_incident`, and provide sample inputs.

Example inputs:
- `incident_title`: `Checkout latency`
- `incident_notes`: `Latency increased at 10:05. Investigation is ongoing. Root cause is not confirmed.`

Review the generated prompt text. The template should not invent a root cause.

## 6. Prompt vs tool vs resource

| Primitive | Example | Purpose |
|---|---|---|
| Tool | `get_incident(id)` | Retrieve or act on incident data |
| Resource | `incident://123` | Expose incident context |
| Prompt | `summarize_incident(...)` | Provide a reusable instruction template |

A workflow might retrieve data through a tool or resource, then use a prompt template to guide an LLM in analyzing it.

## 7. Good prompt design

- State the task clearly.
- Define the expected output structure.
- Tell the model not to invent missing facts.
- Separate user-provided data from instructions.
- Avoid putting secrets in prompt templates.
- Keep templates focused on one task.

## 8. Exercises

1. Create a `review_pull_request` prompt with inputs for title and change summary.
2. Ask it to list potential risks, tests to run, and open questions.
3. Explain why a prompt template is not the same as a tool.
4. Add an instruction not to invent details missing from the supplied notes.

## 9. Recap

MCP prompts provide reusable instruction templates. They help make common AI workflows consistent, but the host/LLM is responsible for using the prompt in an actual model interaction.

**Next: Level 7 — Build an MCP Client.**
