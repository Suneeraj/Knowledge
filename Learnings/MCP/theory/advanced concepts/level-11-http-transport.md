# Level 11 — HTTP Transport

## Goal
Understand how MCP clients and servers communicate across a network, and when to use a local process versus an HTTP endpoint.

## 1. The two common connection styles

### stdio
The client launches the server as a local process and exchanges protocol messages over standard input/output. This is common for local developer tools. Do not print debug logs to stdout if stdout is reserved for protocol messages; use stderr or a logger configured appropriately.

### Streamable HTTP
The client connects to a server over HTTP using the MCP transport supported by the SDK. This is useful when the server runs as a separate service or needs to be accessed remotely. Follow the current MCP specification and SDK documentation; older tutorials may refer to the legacy HTTP+SSE transport.

## 2. Choose a transport

| Situation | Typical choice | Considerations |
|---|---|---|
| Local tool used by one developer | stdio | Client launches process; local environment and process lifecycle matter |
| Shared service in a controlled network | Streamable HTTP | Authentication, HTTPS, network access, concurrency, and operations matter |
| Hosted multi-user service | Streamable HTTP | Per-user authorization, isolation, rate limits, monitoring, and deployment design are essential |

The transport does not define which AWS actions a user may perform. Authorization must still be enforced.

## 3. HTTP deployment checklist

- Use the transport supported by both client and server versions.
- Put the service behind HTTPS in production.
- Authenticate callers using a documented flow.
- Authorize every tool call; do not rely on network location alone.
- Set request size, timeout, and concurrency limits.
- Return appropriate HTTP errors without leaking internals.
- Consider health checks, structured logs, tracing, and graceful shutdown.
- Avoid exposing development Inspector endpoints to the public internet.

## 4. Configuration example

A client configuration for a local stdio server often has a command and arguments. A remote HTTP server is configured differently and depends on the client application. Do not copy a stdio `command` configuration into an HTTP client and expect it to work. Consult the target client's current configuration format.

Example conceptual endpoint (not a complete deployment):

```text
https://mcp.example.internal/mcp
```

Use your actual deployed endpoint and the authentication options supported by your client/server.

## Lab: Compare local and network transport

1. Run your Level 3 calculator server locally using the command documented for your pinned SDK.
2. Connect a compatible client using stdio and call `add`.
3. Create a separate test configuration for Streamable HTTP using the SDK's current server transport instructions.
4. Test from a client in the permitted network.
5. Verify unauthorized requests fail and HTTPS certificate validation is enabled.
6. Test server restart, timeout, and invalid requests.
7. Write down which transport your target AI application supports.

## Troubleshooting

- Client cannot start stdio server: verify executable, working directory, Python environment, arguments, and permissions.
- JSON/protocol parse errors: ensure stdout is not polluted with debug prints.
- HTTP 401/403: check authentication versus authorization.
- HTTP 404: verify endpoint path and reverse-proxy routing.
- Connection timeout: check DNS, firewall, security groups, load balancer, and service health.
- Works locally but not remotely: check bind address, routing, TLS, and network controls.

## Interview questions

1. When is stdio a good choice?
2. Why is HTTP useful for a shared server?
3. Why should protocol stdout not contain arbitrary logs?
4. Does HTTPS replace authorization?
5. What is the risk of exposing a development server publicly?

## Quiz

1. stdio normally uses a local process. (A) True (B) False
2. HTTPS means all tool calls are authorized. (A) True (B) False
3. Which transport is suited to a remote hosted service? (A) Streamable HTTP (B) Only stdio
4. Where should stdio server debug logs normally go? (A) Protocol stdout (B) stderr or configured logging

### Answer key
1. A — The client typically launches a local process.
2. B — Encryption does not grant permission.
3. A — Subject to client/server support and correct security controls.
4. B — Keep protocol output separate from diagnostics.
