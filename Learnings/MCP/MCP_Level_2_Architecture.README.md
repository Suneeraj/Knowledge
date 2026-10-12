# MCP Level 2 Architecture

*Beginner tutorial — From concepts to request flow*

**Goal:** Understand how an MCP Host, Client, Server, protocol, tools, resources, prompts, JSON-RPC, initialization, capability negotiation, and transports fit together.

## 1. Remember Level 1

- **MCP** = Model Context Protocol
- **Host** = AI application
- **Client** = communicates with MCP server
- **Server** = exposes capabilities
- **Tool** = action
- **Resource** = data
- **Prompt** = instruction

## 2. Complete MCP architecture

```text
USER
  ↓
MCP HOST
  ├── LLM
  └── MCP CLIENT
          ↓
      MCP PROTOCOL
          ↓
      MCP SERVER
       ├── Tools
       ├── Resources
       └── Prompts
          ↓
      AWS / Database / API / Files
```

## 3. Host

The MCP Host is the AI application that the user interacts with. It coordinates the LLM and MCP clients.

**Mental model:** The host is the application in which the AI experience lives.

## 4. Client

The MCP Client is the component inside the host that communicates with MCP servers.

```text
Client → MCP Server
```

**Memory trick:** Client communicates; server provides.

## 5. Server

An MCP Server is a program that exposes capabilities to an AI application.

Example AWS MCP server tools:

- `list_ec2_instances`
- `list_s3_buckets`
- `get_lambda_functions`

An MCP server does not necessarily mean a cloud server. It can run locally as a process on your computer.

## 6. MCP Protocol

The MCP protocol defines the standardized way that an MCP client and server communicate.

Conceptually:

```text
Client: “What capabilities do you provide?”
Server: “I provide these tools/resources/prompts.”
```

The protocol also defines how requests, responses, notifications, and capabilities are communicated.

## 7. JSON-RPC

MCP uses JSON-RPC 2.0 for its protocol messages. A JSON-RPC request conceptually contains:

- `id` → identifies the request
- `method` → what operation is requested
- `params` → input to the operation

You do not need to master JSON-RPC internals yet; understand it as the structured message format used for MCP communication.

## 8. Tool discovery

An MCP server can expose a list of tools and describe how each tool should be used. The client can discover these tools instead of having every integration hard-code the tool list.

Example:

```text
AWS MCP Server
  ├── list_ec2_instances
  ├── get_ec2_instance
  ├── list_s3_buckets
  └── get_lambda_functions
```

## 9. Tool schema

A tool description can include its name, description, and input schema. For example, `get_customer` might require `customer_id` as a string.

```text
Tool: get_customer
Description: Get customer details
Input: customer_id → string
```

## 10. Initialization

When an MCP client connects to a server, they first establish the MCP session rather than immediately calling tools.

Conceptual flow:

```text
Client → Initialize → Server
Client ← Server information ← Server
Client → Initialized → Server
```

Then normal MCP communication can begin.

## 11. Capability negotiation

During initialization, client and server exchange information about the capabilities they support. This allows each side to understand what functionality is available for the session.

## 12. Complete tool-call flow

1. The user asks: “List my running EC2 instances.”
2. The host passes the request into the AI/LLM workflow.
3. The LLM determines that EC2 information is needed.
4. The AI application selects an appropriate MCP tool.
5. The MCP client sends a tool-call request to the MCP server.
6. The MCP server executes the tool implementation.
7. The tool may call the AWS EC2 API.
8. The server returns the result through MCP.
9. The client makes the result available to the AI workflow.
10. The LLM uses the result to formulate the final answer.

## 13. Transport

Transport answers: “How does the MCP client communicate with the MCP server?”

Two important transports you will encounter are:

- **stdio** — commonly used when the MCP server is a local process.
- **Streamable HTTP** — used for MCP communication over HTTP, including remote deployments.

## 14. Local MCP example

A local MCP server can be a Python process running on your computer:

```text
AI Application
    ↓ stdio
Local MCP Server
    ↓
Local files / APIs
```

## 15. Remote MCP example

A remote MCP server can be deployed in a cloud environment:

```text
AI Application
    ↓ HTTPS / Streamable HTTP
Remote MCP Server
    ↓
AWS / Database / Internal APIs
```

## 16. Client vs Server

- **MCP Client:** Uses or communicates with capabilities.
- **MCP Server:** Provides capabilities.

## 17. Host vs Client

The host and client are not the same thing. The host is the complete AI application; the MCP client is the communication component inside the host.

```text
Host = AI application
Client = MCP communication component inside the host
```

## 18. Server vs Tool

The MCP server is the provider or container for capabilities. Individual tools are the specific actions it exposes.

```text
AWS MCP Server
  ├── list_ec2_instances()
  ├── list_s3_buckets()
  └── list_lambda_functions()
```

## 19. Important: MCP server does not mean cloud server

An MCP server is software implementing the MCP server role. It can simply be a Python program running locally. It does not have to be an EC2 instance or other cloud server.

## 20. Level 2 cheat sheet

- **HOST** = complete AI application
- **CLIENT** = communicates with MCP server
- **SERVER** = provides capabilities
- **TOOL** = action
- **RESOURCE** = data or context
- **PROMPT** = reusable instruction
- **PROTOCOL** = rules for communication
- **JSON-RPC 2.0** = structured message format used by MCP
- **TRANSPORT** = mechanism carrying communication, such as stdio or Streamable HTTP

## 21. Interview questions

**What is the difference between an MCP Host and Client?**

The Host is the complete AI application. The Client is the component inside the Host that communicates with MCP servers.

**What does an MCP server do?**

It exposes capabilities such as tools, resources, and prompts to an MCP client.

**How does an MCP client communicate with a server?**

Through the MCP protocol using a supported transport.

**What is JSON-RPC?**

A lightweight structured messaging protocol. MCP uses JSON-RPC 2.0 for its protocol messages.

**What is tool discovery?**

The process by which a client learns what tools an MCP server provides and their descriptions and input schemas.

**What happens during initialization?**

The client and server establish the MCP session and exchange protocol and capability information before normal communication.

**What is transport?**

The mechanism used to carry MCP communication between client and server, such as stdio or Streamable HTTP.

## 22. Test yourself

1. Who receives the user's request?
2. Who decides that an EC2 tool is needed?
3. Who communicates with the MCP server?
4. Who provides the EC2 tool?
5. Who actually calls the AWS API?
6. Who returns the result to the AI workflow?

## 23. One diagram to memorize

```text
USER
  ↓
HOST (AI Application + LLM)
  ↓
MCP CLIENT
  ↓ MCP / JSON-RPC
MCP SERVER
  ├── TOOLS
  ├── RESOURCES
  └── PROMPTS
  ↓
AWS / DATABASE / API / FILES
```

**Next:** Level 3 — Build Your First MCP Server. You will install the Python MCP SDK, create `server.py`, build your first tool, run the server, test it, and understand the code line by line.

| Component | Simple meaning | Memory trick |
|---|---|---|
| MCP Client | Uses or communicates with capabilities | Client consumes |
| MCP Server | Provides capabilities | Server provides |
