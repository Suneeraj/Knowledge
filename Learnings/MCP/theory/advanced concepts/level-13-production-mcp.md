# Level 13 — Production MCP

## Goal
Move from a working demo to a supportable, secure, observable service that can be operated by a real team.

## 1. Production readiness areas

- **Reliability:** timeouts, bounded retries, graceful shutdown, health checks, and clear failure behavior.
- **Security:** least privilege, authentication, authorization, secret handling, input validation, and safe defaults.
- **Observability:** structured logs, metrics, traces/correlation IDs, dashboards, and actionable alerts.
- **Testing:** unit, integration, authorization, failure-mode, compatibility, and end-to-end tests.
- **Performance:** concurrency limits, pagination, response-size caps, connection pooling, and rate limiting.
- **Operations:** deployment pipeline, rollback, dependency updates, incident runbook, ownership, and cost monitoring.
- **Compatibility:** pin supported SDK/client versions and test upgrades before production rollout.

## 2. Error handling principles

Distinguish expected errors (invalid input, not found, access denied, rate limit) from unexpected internal failures. Return a concise, actionable message without secrets or internal stack traces. Log diagnostic details securely on the server, with redaction.

Retries should be bounded and used only where appropriate. Avoid retrying non-idempotent operations blindly. Use exponential backoff with jitter for transient rate limits or service errors when suitable.

## 3. Observability

Useful fields for structured logs include:

- timestamp and severity
- service and environment
- tool name
- request/correlation ID
- duration and outcome
- caller identity or tenant identifier only where appropriate and safe
- target service and sanitized error category

Avoid logging access tokens, credentials, full sensitive records, or raw prompts unless explicitly approved and protected. Define metrics such as tool-call count, success/failure rate, latency percentiles, throttling, timeouts, and container restarts.

## 4. Test strategy

1. **Unit tests:** validate input rules and result shaping without calling real AWS.
2. **Integration tests:** call a sandbox account or mock service with controlled permissions.
3. **Authorization tests:** prove that disallowed users/resources/actions are rejected.
4. **Failure tests:** missing credentials, timeout, throttling, malformed data, and service outage.
5. **Transport tests:** client connection, server restart, invalid messages, and network failures.
6. **Regression tests:** run against the exact SDK and client versions planned for release.
7. **End-to-end tests:** validate a real client → MCP server → target API path in a non-production environment.

## 5. Release and change management

- Pin dependencies and review release notes before upgrades.
- Build and scan immutable container images in CI.
- Keep development, test, and production environments separate.
- Use staged deployment or canary rollout where supported.
- Maintain a tested rollback path.
- Document tool schemas, permissions, data handling, service owner, and escalation path.

## 6. Example production acceptance checklist

- [ ] Every tool has a clear description and bounded input schema.
- [ ] Authorization is enforced on the server for each operation.
- [ ] Read-only access is the default where possible.
- [ ] Secrets are not in source, logs, or images.
- [ ] Network transport is authenticated and encrypted where applicable.
- [ ] Timeouts, limits, and safe error handling are implemented.
- [ ] Logs and metrics support incident diagnosis.
- [ ] Tests cover allowed and denied behavior.
- [ ] Dependencies and container image are reviewed/scanned.
- [ ] Rollback and incident procedures are documented.
- [ ] A human confirmation path exists for destructive/high-impact actions.

## Capstone lab: Deliver a team-ready AWS MCP integration

**Scenario:** A team wants its AI client to inspect EC2 inventory, Lambda metadata, and CloudWatch errors in one AWS account.

1. Write a short requirements document: users, tools, read/write scope, regions, data sensitivity, and expected usage.
2. Select an existing AWS MCP server or build a narrow custom server.
3. Implement three read-only tools with input validation, limits, and safe errors.
4. Assign a dedicated IAM role with only required permissions.
5. Select stdio or supported HTTP transport based on the client and deployment topology.
6. Write unit and integration tests, including unauthorized access and AWS throttling.
7. Add structured logs, latency/error metrics, and alerts.
8. Containerize and deploy to a non-production environment if remote hosting is required.
9. Connect the team's client and test end-to-end.
10. Deliver a README, architecture diagram, IAM permission list, setup instructions, test results, known limitations, and rollback/runbook.

## Troubleshooting production issues

- Intermittent failures: inspect timeout, throttling, dependency health, retries, and connection limits.
- Slow tool calls: measure each downstream API, reduce result size, paginate, and inspect concurrency.
- Unexpected actions: audit tool exposure, server-side authorization, client configuration, and confirmation flow.
- SDK upgrade breaks: pin versions, compare release notes, and run compatibility tests in staging.
- Hard-to-debug incidents: add correlation IDs, structured logs, and safe diagnostic details.
- Cost spikes: review call volume, retry loops, log ingestion, container sizing, and downstream API use.

## Interview questions

1. What distinguishes a demo MCP server from a production-ready one?
2. Which metrics would you monitor?
3. Why are bounded retries important?
4. How would you test that a user cannot access another tenant's data?
5. What belongs in a runbook?
6. How do you safely upgrade an MCP SDK?

## Quiz

1. Is “it worked once locally” enough for production? (A) Yes (B) No
2. Should every failure be retried forever? (A) Yes (B) No
3. Name two useful metrics for MCP tools.
4. Should authorization tests include denied operations? (A) Yes (B) No
5. What should you do before an SDK upgrade?

### Answer key
1. B — Production needs repeatable tests, security, monitoring, and operations.
2. B — Retries must be bounded and appropriate to the operation.
3. Examples: latency, error rate, throttling, timeout count, tool-call volume.
4. A — Negative tests prove access controls work.
5. Review release notes, pin versions, test in staging, and keep a rollback path.
