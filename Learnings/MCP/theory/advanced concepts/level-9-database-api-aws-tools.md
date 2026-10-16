# Level 9 — Database, API and AWS Tools

## Goal
Build MCP tools that safely connect an AI application to databases, REST APIs, and AWS services. An MCP server is the adapter: MCP defines how the client discovers and calls tools; your code still uses the target system's SDK or API.

## 1. The request flow

```text
User → AI application / MCP client → MCP tool call → Your MCP server
     → Boto3 / HTTP client / database driver → Target system
     ← validated result ← MCP server ← API/database response
```

The model does not receive AWS credentials directly. Credentials and permissions belong to the server's runtime environment.

## 2. Design tools around one clear task

Good tool names describe an action and its scope:

- `list_ec2_instances` — read-only inventory
- `get_lambda_function` — metadata for one named function
- `get_cloudwatch_errors` — bounded log query
- `list_s3_buckets` — account-level inventory
- `lookup_customer` — a carefully authorized database lookup
- `get_ticket` — retrieve one ticket from a REST API

Avoid one giant tool such as `run_any_aws_command`. Narrow tools are easier to validate, secure, test, and explain to users.

## 3. AWS example using Boto3

Install dependencies in a virtual environment:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install boto3 "mcp[cli]"
```

A simplified FastMCP example (adjust imports and run commands to the MCP SDK version pinned by your project):

```python
import boto3
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("aws-readonly-demo")

@mcp.tool()
def list_s3_buckets() -> list[str]:
    """List S3 bucket names available to this server's AWS identity."""
    s3 = boto3.client("s3")
    response = s3.list_buckets()
    return [bucket["Name"] for bucket in response.get("Buckets", [])]

if __name__ == "__main__":
    mcp.run()
```

This example requires valid AWS credentials and permission for `s3:ListAllMyBuckets`. Use a dedicated role or profile with only the permissions needed. Do not hard-code access keys in code or JSON configuration.

## 4. REST API and database patterns

For REST APIs, use an HTTP client with explicit timeouts, authentication, pagination, status-code handling, and a response-size limit. Keep API tokens in a secret store or protected environment variables. Never return authorization headers or secret fields to the model.

For databases:

- Use parameterized queries, never string-concatenate user input into SQL.
- Start with read-only database credentials.
- Restrict tables and columns; enforce tenant/user authorization in server code.
- Limit rows and query duration; avoid exposing raw connection strings.

Illustrative parameterized SQL:

```python
cursor.execute(
    "SELECT status FROM tickets WHERE ticket_id = %s",
    (ticket_id,),
)
```

Placeholder syntax varies by database driver.

## 5. Result design

Return concise, structured results. Include only fields the client needs. For large results, support filters, pagination, and limits. Handle expected errors in a useful way without returning stack traces, secrets, or full internal responses.

## Lab: Build an AWS inventory tool

1. Create and activate a virtual environment.
2. Install the MCP SDK/CLI and `boto3`.
3. Configure credentials using an approved AWS profile or role; never paste keys into source code.
4. Create `list_s3_buckets` or `list_ec2_instances` as a read-only tool.
5. Grant only the required IAM action(s).
6. Run the server using the command documented for your pinned SDK version.
7. Connect an MCP-compatible client or Inspector and call the tool.
8. Test with missing credentials and insufficient permissions.
9. Confirm the output contains no secrets and no unintended account data.

## Troubleshooting

- `NoCredentialsError`: check the active profile/role and environment; do not add keys to source code.
- `AccessDenied`: inspect the IAM identity policy, resource policy, permission boundary, SCP, and region where relevant.
- Wrong region: configure the intended AWS Region explicitly.
- Timeout or huge output: add bounded queries, pagination, and timeouts.
- Tool not discovered: check server startup logs, tool decorator, and client connection configuration.

## Interview questions

1. **Why use Boto3 inside an MCP server?** MCP standardizes tool discovery/calls; Boto3 calls AWS APIs.
2. **Why avoid a generic `execute_aws_cli` tool?** It can grant overly broad capabilities and is harder to validate and audit.
3. **How should secrets be managed?** Use workload roles or approved credential providers and a secret manager where needed; never commit secrets.
4. **How do you protect database queries?** Parameterized statements, read-only credentials, scoped access, and limits.
5. **What should a tool return?** Minimal, relevant, bounded, non-sensitive data with clear errors.

## Quiz

1. MCP replaces Boto3. (A) True (B) False
2. Which is safer for SQL? (A) String concatenation (B) Parameterized query
3. Should AWS keys be hard-coded in a server? (A) Yes (B) No
4. Why limit results? (A) Reduce exposure and resource use (B) Make tools harder to use

### Answer key
1. B — MCP is the interaction protocol; Boto3 remains the AWS SDK.
2. B — Parameters help prevent SQL injection.
3. B — Use approved credential providers or roles.
4. A — Limits reduce cost, latency, and accidental data exposure.
