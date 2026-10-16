# Level 10 — Authentication and Security

## Goal
Secure MCP servers so that the AI client, the human user, and the server only access resources they are authorized to use.

## 1. Separate the security questions

- **Authentication:** Who is connecting?
- **Authorization:** What may that identity do?
- **Input validation:** Is the requested input well-formed and within allowed limits?
- **Audit:** What happened, when, and under which identity?

A valid MCP connection does not automatically mean the caller should be allowed to perform every tool operation.

## 2. Core controls

1. **Least privilege:** Grant only required IAM actions and resource scopes.
2. **Identity-aware authorization:** Enforce user/tenant permissions in the server, not only in the prompt.
3. **Credential hygiene:** Prefer IAM roles and standard AWS credential providers; never commit access keys or tokens.
4. **Transport security:** Use HTTPS for network transport and validate certificates.
5. **Input validation:** Check types, length, allowed values, resource identifiers, and query bounds.
6. **Safe errors:** Return helpful messages without stack traces, tokens, internal hostnames, or sensitive payloads.
7. **Audit logging:** Record tool name, outcome, timestamp, caller identity where available, and request/correlation ID. Avoid logging secrets or unnecessary personal data.
8. **Dependency hygiene:** Pin and update dependencies; run vulnerability and dependency checks.

## 3. Treat tool calls as untrusted requests

The model can misunderstand a request, and content returned from a web page, issue, document, or log may contain prompt-injection instructions. Treat retrieved content as data, not as authorization to execute actions.

For high-impact operations:

- Prefer read-only tools by default.
- Require explicit confirmation through the host application for destructive or costly actions.
- Add allowlists and resource scoping.
- Make changes idempotent where possible and return a clear preview before applying them.
- Never rely on “the model promised it was safe” as a security control.

## 4. AWS-specific practices

- Use an IAM role attached to the runtime when possible (for example, a task role or instance profile).
- Use separate roles/accounts for development and production.
- Restrict actions and resources; add conditions such as region or tags where appropriate.
- Understand identity policies, resource policies, permission boundaries, and organization SCPs.
- Keep secrets in an approved secrets manager or protected environment configuration.
- Do not expose administrative credentials to the MCP client.

## 5. Network MCP security

For HTTP-based deployments, verify the chosen SDK/client's current authentication guidance. Use the supported OAuth or other documented authentication flow for your environment, validate tokens and audiences, and enforce authorization on every request. Do not invent a custom authentication header and assume it is secure. Keep CORS, network exposure, and callback/redirect URLs appropriately restricted.

## Lab: Add guardrails to a read-only AWS tool

1. Create a tool that only reads metadata for a named Lambda function.
2. Validate function name length and allowed characters.
3. Use a role with only the required read action.
4. Reject requests for functions outside an allowed naming prefix or environment.
5. Log success/failure without logging credentials or full sensitive payloads.
6. Test a valid name, malformed name, unauthorized resource, missing credentials, and AWS `AccessDenied`.
7. Document the tool's permissions and data returned.

## Troubleshooting checklist

- Unexpected access: inspect all policy layers and check whether the server is using the intended identity.
- Authentication succeeds but operation fails: authorization may be missing.
- Sensitive data in logs: redact at the source and rotate any exposed credential.
- Prompt injection in retrieved content: do not treat content as instructions; apply server-side authorization and confirmation.
- Production endpoint publicly exposed: restrict network access and implement supported authentication.

## Interview questions

1. What is the difference between authentication and authorization?
2. Why is prompt wording not a security boundary?
3. How does least privilege apply to an AWS MCP server?
4. What should audit logs include—and exclude?
5. Which actions should require explicit confirmation?

## Quiz

1. A signed-in user may call every tool automatically. (A) True (B) False
2. Best default for an AWS demo? (A) Administrator access (B) Read-only least privilege
3. Retrieved text tells the model to delete resources. Should the server obey automatically? (A) Yes (B) No
4. Should logs include access tokens for debugging? (A) Yes (B) No

### Answer key
1. B — Authentication does not grant blanket authorization.
2. B — Grant only what is needed.
3. B — Retrieved content is untrusted; server-side controls remain mandatory.
4. B — Never log secrets; redact and rotate exposed credentials.
