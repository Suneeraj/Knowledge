# Level 8: Connect MCP to an LLM

| | |
|---|---|
| Level | 8 of 13 |
| Difficulty | Intermediate |
| Estimated time | 90–120 minutes |
| Goal | Understand and implement the bridge between an LLM tool-calling workflow and MCP tools |

## 1. What you will build

At Level 7, the client called an MCP tool directly. At Level 8, the goal is to understand the extra layer needed when a model decides which tool to use.

```text
User question
     |
     v
LLM / AI application
     |
     | model requests a tool
     v
Application maps request to MCP tool
     |
     v
MCP Client -> MCP Server -> Python function
     |
     v
Tool result -> LLM -> final response
```

**Important:** MCP does not itself provide an LLM. You need an AI model/API and application logic that connects model tool calls to MCP calls.

## 2. Prerequisites

- Completed Levels 3 and 7
- Basic Python and async concepts
- Access to an LLM provider/API that supports tool calling, or a local model/runtime with equivalent support
- Provider API key if using a hosted model

Do not commit API keys to GitHub. Use environment variables or a secret manager.

## 3. Separate the responsibilities

The model does not directly connect to the MCP server in a typical application flow.

1. The application sends the user question and available tool descriptions to the model.
2. The model may return a request to call a tool.
3. The application validates the requested tool and arguments.
4. The application calls the MCP server using its MCP client.
5. The application sends the tool result back to the model.
6. The model generates a user-facing answer.

The exact API format depends on the LLM provider. MCP is the standard interface to the MCP server; model-provider tool calling is a separate interface that the application bridges.

## 4. Recommended first experiment: use MCP Inspector and an AI host

Before writing a full model integration, connect the calculator server from Level 3 to an MCP-compatible AI host that supports custom MCP servers.

1. Configure the host according to its current official documentation.
2. Point it at your `server.py` using the appropriate local/stdio configuration.
3. Ask: `What is 10 plus 20?`
4. Confirm the host chooses the `add` tool.
5. Confirm the result is returned and used in the final response.

Host configuration varies by product and version. Follow that host's current documentation rather than copying a configuration from an unrelated version.

## 5. The application bridge: pseudocode

The core integration logic looks like this:

```python
# Conceptual pseudocode — not a complete provider-specific program.

question = "What is 10 plus 20?"

# 1. Ask the model with descriptions of tools available through MCP.
model_response = ask_llm(
    question=question,
    tool_definitions=tools_discovered_from_mcp,
)

# 2. If the model requests a tool, validate its name and arguments.
if model_response.requests_tool:
    tool_name = validate_allowed_tool(model_response.tool_name)
    arguments = validate_arguments(model_response.arguments)

    # 3. Call the MCP tool.
    tool_result = await mcp_session.call_tool(
        tool_name,
        arguments=arguments,
    )

    # 4. Send the tool result back to the model.
    final_response = ask_llm_with_tool_result(
        question,
        model_response,
        tool_result,
    )
else:
    final_response = model_response.text
```

This shows the architecture, not a drop-in SDK implementation. A real implementation must use the selected model provider's current API and correctly handle its tool-call/result format.

## 6. Why tool schemas matter

The model needs understandable tool descriptions and input schemas to choose an appropriate tool and supply arguments. For example:

```text
Tool: add
Description: Add two integers.
Inputs:
  a: integer
  b: integer
```

Descriptions should be clear and specific. The application must still validate requests rather than blindly trusting the model.

## 7. Safety rules

- Expose only the tools needed for the task.
- Validate tool names and arguments.
- Use least-privilege credentials.
- Require user confirmation for consequential actions where appropriate.
- Do not allow model output to trigger arbitrary shell commands.
- Treat tool results and external content as untrusted data.
- Never place provider keys or AWS credentials in prompts or source control.
- Log safely; avoid recording sensitive data unnecessarily.

## 8. Common integration errors

**The model never calls a tool:** Check whether tool definitions were sent in the provider-specific format and whether the model supports tool calling.

**The model asks for the wrong arguments:** Improve descriptions and schemas, and validate arguments in application code.

**MCP call fails:** Test the tool independently with the MCP Inspector or Level 7 client.

**The final answer ignores the result:** Ensure the tool result is sent back to the model using the provider's required tool-result format.

**API key error:** Check the environment variable and provider setup. Do not print the key.

## 9. Exercises

1. Draw the flow from user question to final answer, including both LLM and MCP.
2. Explain why MCP is not the LLM.
3. Describe what the application does between a model tool request and an MCP tool call.
4. Add a confirmation step before a hypothetical tool that changes infrastructure.
5. Explain why tool names and arguments must be validated.

## 10. Recap

MCP standardizes communication with the server. The AI application connects that interface to an LLM's tool-calling workflow. The application remains responsible for model-provider integration, validation, permissions, and safe execution.

**Next: Level 9 — Connect MCP to real systems such as AWS, databases, and APIs.**
