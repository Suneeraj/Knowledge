# Level 12 — Docker and AWS Deployment

## Goal
Package an MCP server in a repeatable container and deploy it in AWS with controlled networking, identity, logging, and updates.

## 1. Before deployment

Confirm these requirements with the team:

- Which AI client will connect, and which transport does it support?
- Is the server local to the client or remotely hosted?
- Which tools and AWS actions are needed?
- Which users/tenants may access it?
- What availability, latency, logging, and retention requirements apply?
- Where should secrets live, and who owns operations?

A container alone does not make an MCP server remotely accessible. The server must use a compatible network transport and be deployed behind appropriate networking and authentication.

## 2. Example Dockerfile

Adapt the command and file names to your project and pinned SDK version. This is a teaching example, not a complete production hardening recipe.

```dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY server.py .
RUN useradd --create-home --uid 10001 appuser
USER appuser

CMD ["python", "server.py"]
```

Example `requirements.txt`:

```text
mcp[cli]
boto3
```

For real projects, pin reviewed dependency versions and keep a reproducible lock or requirements file. Choose a Python version supported by your selected dependencies.

## 3. Build and run locally

```bash
docker build -t aws-mcp-demo:dev .
docker run --rm aws-mcp-demo:dev
```

If using AWS locally, provide credentials through a safe, approved mechanism. Avoid baking credentials into the image or passing secrets in a Dockerfile. A stdio server may not be reachable as a network service; use the transport and command appropriate for your client.

## 4. AWS hosting options

Common choices include:

- **Amazon ECS with Fargate:** managed container runtime without managing EC2 hosts.
- **Amazon ECS on EC2:** more control over the underlying hosts, with additional operations.
- **Amazon EKS:** useful when the organization already runs Kubernetes and needs its ecosystem.
- **EC2:** full host control, but you manage more operating-system and service operations.

Choose based on client connectivity, network needs, scaling, operational skills, and cost. Do not assume Lambda is automatically suitable for every MCP transport or long-running session; validate the server model and invocation pattern first.

## 5. A typical AWS design

```text
AI client
   │ HTTPS + supported authentication
   ▼
Load balancer / private ingress (as appropriate)
   ▼
MCP container service (for example, ECS Fargate)
   │ task role with least privilege
   ├── AWS APIs (EC2, S3, Lambda, CloudWatch)
   ├── CloudWatch logs/metrics
   └── Secrets Manager or Parameter Store when needed
```

Use private subnets where practical. Add NAT or VPC endpoints only for the egress paths the task actually needs. Security groups should allow only required traffic. The task role is for the application; the task execution role is used by ECS for tasks such as pulling images and writing logs.

## 6. Deployment checklist

1. Pin dependencies and build the image in CI.
2. Scan dependencies and the container image.
3. Push the image to Amazon ECR.
4. Define a task/service with CPU, memory, port, health checks, and log configuration.
5. Attach a least-privilege task role.
6. Configure secrets without embedding them in the image.
7. Configure ingress, TLS, authentication, and authorization.
8. Deploy to a test environment and run end-to-end tests.
9. Monitor errors, latency, restarts, and AWS API failures.
10. Define rollback, patching, and image-retention procedures.

## Lab: Deploy a read-only AWS MCP service

1. Containerize a read-only tool from Level 9.
2. Run the container locally and test it with the intended transport.
3. Build and push the image to ECR.
4. Deploy a test service to ECS Fargate in a controlled network.
5. Attach a task role containing only the required read actions.
6. Configure logs and a health check.
7. Connect from the intended client using the supported HTTP transport and authentication.
8. Test denied operations, invalid inputs, container restart, and rollback.
9. Record the architecture and operational runbook.

## Troubleshooting

- Image pull fails: check ECR permissions, image URI, network path, and execution role.
- AWS API access denied: inspect the task role and policy layers.
- Service is unhealthy: check port, bind address, health check path, logs, and security groups.
- Client cannot connect: verify ingress, TLS, endpoint path, auth, and supported transport.
- Secrets missing: verify secret references and runtime permissions; do not rebuild secrets into the image.
- High costs: review CPU/memory sizing, minimum task count, logging volume, NAT use, and idle resources.

## Interview questions

1. What is the difference between an ECS task role and task execution role?
2. Why should credentials not be baked into a Docker image?
3. Does a container automatically provide remote MCP connectivity?
4. Why use ECR?
5. When might ECS Fargate be simpler than EC2?

## Quiz

1. Store AWS access keys in the Dockerfile? (A) Yes (B) No
2. The task role authorizes application AWS API calls. (A) True (B) False
3. ECR is primarily used as a: (A) Container image registry (B) Database
4. Is every MCP server automatically suitable for Lambda? (A) Yes (B) No

### Answer key
1. B — Keep secrets outside the image.
2. A — The task role is the runtime identity for application permissions.
3. A — ECR stores container images.
4. B — Runtime and transport requirements must fit the execution model.
