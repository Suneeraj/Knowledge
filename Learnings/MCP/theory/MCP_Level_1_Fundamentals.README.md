# MCP Level 1 Fundamentals

*Beginner tutorial — Model Context Protocol*

**Goal:** Understand MCP from first principles before writing code. By the end of this lesson, you should be able to explain MCP, its architecture, and the difference between hosts, clients, servers, tools, resources, and prompts.

## 1. What is MCP?

MCP stands for **Model Context Protocol**. It is an open protocol that standardizes how AI applications connect to external data and capabilities such as tools, APIs, databases, files, and cloud services.

A simple mental model:

```text
AI Application → MCP Client → MCP Protocol → MCP Server → External System
```

## 2. Why was MCP needed?

An AI application may need to access AWS, GitHub, Jira, databases, S3, or internal APIs. Without a common protocol, every application can build its own custom integrations. MCP provides a standardized approach for exposing and consuming these capabilities.

## 3. MCP is not an LLM

MCP does not replace GPT, Claude, Gemini, Llama, or another language model. The LLM provides reasoning and generation, while MCP provides a standardized way for the AI application to interact with external capabilities.

**Mental model:** LLM = brain; MCP = communication mechanism; MCP server = gateway to capabilities.

## 4. MCP architecture

The four terms to know first are Host, Client, Server, and Protocol.

- **MCP Host:** The AI application that coordinates the model and MCP clients.
- **MCP Client:** The component that communicates with an MCP server.
- **MCP Server:** A program that exposes capabilities through MCP.
- **MCP Protocol:** The standardized communication mechanism between MCP clients and servers.

## 5. MCP Host

The host is the AI application that the user interacts with. It coordinates the LLM and one or more MCP clients.

## 6. MCP Client

The MCP client is the component responsible for communicating with an MCP server. A host can connect to multiple MCP servers through MCP clients.

## 7. MCP Server

An MCP server is a program that exposes capabilities to an AI application. For example, an AWS MCP server might expose tools for listing EC2 instances, reading S3 objects, or querying CloudWatch.

An MCP server does not necessarily mean a cloud server. It can run locally as a process on your computer.

## 8. The three major MCP primitives

MCP servers can expose tools, resources, and prompts. Each serves a different purpose: actions, information, or reusable guidance.

## 9. Tools

A tool allows an AI application to invoke an operation. Examples include `get_weather()`, `query_database()`, `create_ticket()`, `send_email()`, and `list_ec2_instances()`.

Conceptual flow:

```text
LLM → MCP Client → Tool → External System → Result → LLM
```

## 10. Resources

A resource represents information or context that can be accessed through MCP. Examples include `customer://123`, `file://report.pdf`, `database://schema`, and `config://application`.

## 11. Prompts

Prompts are reusable prompt templates or instructions exposed through an MCP server. They can provide a structured way to guide an AI workflow.

## 12. MCP vs REST API

REST APIs commonly expose HTTP endpoints such as `GET /customers/123`. MCP is designed specifically around AI applications interacting with context and capabilities, including standardized discovery and invocation of tools.

```text
REST: Client → HTTP request → API → Response
MCP:  AI Application → MCP Client → MCP Server → Tool/Resource → Result
```

## 13. MCP vs function or tool calling

Function calling allows a model to request that an application execute a function. MCP goes further by defining a standardized ecosystem and protocol for exposing, discovering, and using capabilities across AI applications.

## 14. Complete example: AWS

Imagine an AWS MCP server exposing `list_ec2_instances()`, `list_s3_buckets()`, and `get_lambda_functions()`. A user asks, “Show me my running EC2 instances.”

```text
User → LLM → MCP Client → AWS MCP Server → list_ec2_instances
     → AWS EC2 API → Results → MCP Client → LLM → User
```

## 15. Local vs remote MCP servers

MCP servers can run locally as processes or remotely over a network. Later levels will cover transports such as stdio and Streamable HTTP, authentication, Docker, and AWS deployment.

## 16. MCP mental model

- **HOST** = AI application
- **CLIENT** = talks to MCP server
- **SERVER** = exposes capabilities
- **TOOL** = action
- **RESOURCE** = data
- **PROMPT** = instruction

## 17. Interview questions

**What does MCP stand for?**

Model Context Protocol.

**Why do we need MCP?**

To standardize how AI applications connect to external data and capabilities.

**What is an MCP Host?**

The AI application that coordinates the model and MCP clients.

**What is an MCP Client?**

The component that communicates with MCP servers.

**What is an MCP Server?**

A program that exposes capabilities through MCP.

**What is the difference between a Tool and a Resource?**

A Tool performs an operation; a Resource provides data or context.

**What is an MCP Prompt?**

A reusable prompt template or instruction exposed through an MCP server.

**Is MCP an LLM?**

No. MCP is a protocol used by AI applications to connect to capabilities.

**Is an MCP server necessarily a cloud server?**

No. It can also run locally as a process.

## 18. Level 1 practice

Try answering these without looking back:

1. What does MCP stand for?
2. Why do we need MCP?
3. What is an MCP Host?
4. What is an MCP Client?
5. What is an MCP Server?
6. What is the difference between a Tool and a Resource?
7. What is an MCP Prompt?
8. Is MCP an LLM?
9. Is an MCP server necessarily a cloud server?
10. Can you draw the MCP architecture from memory?

## 19. One diagram to memorize

```text
USER
  ↓
MCP HOST (AI Application + LLM)
  ↓
MCP CLIENT
  ↓ MCP
MCP SERVER
  ├── TOOLS
  ├── RESOURCES
  └── PROMPTS
  ↓
AWS / DATABASE / API / FILES
```

**Next level:** MCP Architecture — Host vs Client vs Server in greater depth, JSON-RPC, initialization, capability negotiation, tool discovery, invocation, and transports.

## 20. MCP server in simple words

“An MCP server exposes capabilities” means the MCP server makes certain things available for the AI to use.

For example, an AWS MCP server could make these capabilities available:

```text
MCP Server
   ├── List EC2 instances
   ├── Read S3 files
   ├── Get Lambda functions
   └── Check CloudWatch metrics
```

The AI can then say, “I need to know what EC2 instances are running.” The MCP server provides the capability to do that.

Think of it like a restaurant:

- **MCP Server** = restaurant
- **Capabilities** = things the restaurant can provide
- **Tool** = a specific item or action you can request

```text
Restaurant (MCP Server)
   ├── Pizza  ← capability
   ├── Burger ← capability
   └── Pasta  ← capability
```

So “exposes capabilities” means “makes functions, actions, or data available for the AI to use.” In MCP specifically:

- **Tool** → capability to perform an action
- **Resource** → capability to access information
- **Prompt** → capability to use a predefined instruction

| Primitive | Purpose | Memory trick |
|---|---|---|
| Tool | Executable capability or action | DO |
| Resource | Data or context made available through MCP | READ |
| Prompt | Reusable prompt template or instruction | GUIDE |
