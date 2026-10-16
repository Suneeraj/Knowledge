## Quick MCP Transport Comparison

| Feature | stdio | Streamable HTTP |
|---|---|---|
| Communication | Standard input/output | HTTP requests and responses |
| Host required? | No | Yes |
| Port required? | No | Yes |
| Endpoint URL | Not required | Required |
| Typical usage | Local MCP server | Local or remote network-accessible server |
| Client starts server? | Usually yes | Not necessarily; server can run independently |
| Multiple clients | Typically one client per process | Can support multiple clients, depending on implementation |
| HTTPS required? | No | Recommended for remote production deployments |
| Authentication | Usually controlled through local process access | Configure authentication and authorization as needed |
| AWS integration | Yes, using local credentials or an approved role | Yes, using the server's approved AWS credentials or role |
| Example | Local calculator server | AI application connecting to an AWS-hosted MCP server |

### Which transport should you choose?

- **Choose stdio** for local development and desktop applications that launch MCP servers as subprocesses.
- **Choose Streamable HTTP** when an AI application needs to connect to a server over a network.
- **Use HTTPS** for remote production deployments, along with appropriate authentication, authorization, and network security.

**Remember:** AWS integration does not automatically require HTTP. The transport depends on where the MCP client and server run and how they need to communicate.
