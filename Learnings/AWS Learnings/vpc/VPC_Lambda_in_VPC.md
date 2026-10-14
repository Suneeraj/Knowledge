# Chapter: AWS VPC and Lambda Inside a VPC

**Level:** Beginner  
**Estimated reading time:** 25–30 minutes  
**Topics:** VPC, CIDR, public/private subnets, Internet Gateway, NAT Gateway, route tables, security groups, IAM roles, Lambda networking, and VPC endpoints.

---

## 1. What Is a VPC?

A **Virtual Private Cloud (VPC)** is a logically isolated network in AWS. You choose its IP address range and create subnets to organize resources such as Lambda functions, EC2 instances, and databases.

Think of a VPC as a private neighbourhood:

- **VPC:** the neighbourhood.
- **Subnet:** a zone or group of addresses inside the neighbourhood.
- **Route table:** a map that tells network traffic where to go.
- **Internet Gateway (IGW):** a connection between the VPC and the internet.
- **NAT Gateway:** allows resources in private subnets to initiate outbound internet connections.
- **Security group:** a virtual firewall attached to network interfaces/resources.

## 2. What Is a CIDR Block?

CIDR describes a range of IP addresses.

Examples:

| CIDR | Approximate number of addresses | Example use |
|---|---:|---|
| `10.0.0.0/16` | 65,536 | A VPC address range |
| `10.0.1.0/24` | 256 | A subnet address range |

The `/16` or `/24` suffix determines the size of the network. Subnet CIDR ranges must fit inside the VPC CIDR and must not overlap with one another.

## 3. Public Subnet vs Private Subnet

### Public subnet

A subnet is considered public when its route table has a route to an Internet Gateway. `map_public_ip_on_launch = true` requests automatic public IPv4 assignment for supported resources launched in the subnet; it does **not**, by itself, make a subnet public.

### Private subnet

A private subnet does not have a direct route to an Internet Gateway. It can use a NAT Gateway for outbound internet access, or VPC endpoints to reach supported AWS services privately.

| Feature | Public subnet | Private subnet |
|---|---|---|
| Typical route to internet | Through IGW | Through NAT Gateway for outbound access, if configured |
| Common examples | NAT Gateway, public-facing resources | Lambda, application backends, databases |
| Direct inbound internet access | Possible only when routing, public addressing, security rules, and service configuration allow it | Not provided by a direct IGW route |

## 4. Network Diagram

```text
                         Internet
                            ^
                            |
                      Internet Gateway
                            |
                 +-----------------------+
                 |          VPC          |
                 |                       |
                 |   Public Subnet       |
                 |   +---------------+   |
                 |   |  NAT Gateway  |   |
                 |   +---------------+   |
                 |          ^            |
                 |          |             |
                 |   Private Route Table |
                 |          ^             |
                 |   Private Subnet      |
                 |   +---------------+   |
                 |   | Lambda + SG   |   |
                 |   +---------------+   |
                 |          |             |
                 |    VPC Endpoints       |
                 |       |        |       |
                 +-------|--------|-------+
                         v        v
                        S3    Supported AWS APIs
```

**Traffic summary:**

- Lambda → external API: private route table → NAT Gateway → Internet Gateway → internet.
- Lambda → S3: S3 Gateway Endpoint, when configured in the relevant route table.
- Lambda → an AWS API through an Interface Endpoint: Lambda → endpoint network interface (ENI) → AWS service, where that endpoint is supported.

---

## 5. Terraform Project Structure

Create a folder named `aws-lambda-vpc`:

```text
aws-lambda-vpc/
├── main.tf
├── variables.tf
├── outputs.tf
└── lambda/
    ├── lambda_function.py
    └── zip_lambda.sh
```

- `main.tf`: AWS resources and networking.
- `variables.tf`: configurable values such as region and CIDR ranges.
- `outputs.tf`: useful values printed after deployment.
- `lambda/lambda_function.py`: sample Lambda code.
- `lambda/zip_lambda.sh`: optional helper script to package the Lambda code.

## 6. Terraform: Create the VPC and Subnets

### `variables.tf`

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "az1" {
  type    = string
  default = "ap-south-1a"
}
```

Variables let you change values without editing every resource.

### `main.tf` — Provider, VPC, and subnets

```hcl
provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az1

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az1

  tags = {
    Name = "private-subnet"
  }
}
```

**What the important lines mean:**

- `vpc_id = aws_vpc.main.id`: creates the subnet inside this VPC.
- `cidr_block`: assigns the subnet's IP range.
- `availability_zone`: chooses the Availability Zone.
- `map_public_ip_on_launch = true`: requests public IPv4 assignment for supported resources launched in the public subnet. A Lambda function attached to a VPC uses VPC network interfaces and does not become internet-accessible simply because this setting is enabled.

## 7. Internet Gateway and Public Route Table

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

- An **Internet Gateway** attaches to the VPC.
- `0.0.0.0/0` means any IPv4 destination not matched by a more specific route.
- The route sends that traffic through the IGW.
- The association makes the public subnet use this route table.

The subnet is public because its route table has a route to the IGW. Public IP assignment alone is not enough.

## 8. NAT Gateway and Private Route Table

```hcl
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
```

A NAT Gateway is placed in a public subnet and uses an Elastic IP. The private subnet's default route sends outbound IPv4 traffic through it.

**Important:** A NAT Gateway allows connections initiated from the private subnet to reach external destinations. It does not allow unsolicited inbound internet connections to the Lambda function. NAT Gateways incur charges, so remove lab resources when you finish.

## 9. Security Group for Lambda

```hcl
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Security group for Lambda in the VPC"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}
```

- A security group is a stateful virtual firewall.
- `egress` controls outbound connections.
- `protocol = "-1"` means all protocols, not just HTTPS.
- For a more restrictive setup, allow only required destinations and ports, such as TCP port `443` for HTTPS, while ensuring the rules match the actual network path and endpoint requirements.
- No ingress rule is required when the Lambda does not need inbound connections; security groups deny inbound traffic by default when no ingress rules allow it.

For example, an HTTPS-only egress rule can be written as:

```hcl
egress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

This example is for illustration. Endpoint security groups, DNS, and other dependencies may require additional carefully scoped rules.

## 10. IAM Role for Lambda

A Lambda function needs an execution role. The trust policy allows the Lambda service to assume the role; permissions attached to the role determine what the function can do.

```hcl
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

The managed `AWSLambdaBasicExecutionRole` policy allows basic CloudWatch Logs operations. A Lambda attached to a VPC also needs permissions for the Lambda service to manage its network interfaces; the standard managed `AWSLambdaVPCAccessExecutionRole` policy is commonly used for this purpose. Add only the AWS service permissions required by the function, such as narrowly scoped S3 or QuickSight API actions.

## 11. Lambda Function Inside the Private Subnet

### `lambda/lambda_function.py`

```python
def lambda_handler(event, context):
    return {
        "message": "Lambda inside VPC working successfully!"
    }
```

### Terraform resource

Package the code as `lambda/lambda_function.zip` before applying this configuration.

```hcl
resource "aws_lambda_function" "demo" {
  function_name = "demo-lambda-vpc"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "${path.module}/lambda/lambda_function.zip"

  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]
}
```

`vpc_config` attaches the function to the selected subnets and security groups. For a production deployment, use a currently supported Python runtime and configure the appropriate Lambda VPC permissions. The Lambda's ability to access the internet or AWS APIs depends on routing, endpoints, DNS, security groups, IAM permissions, and the destination service—not just on `vpc_config`.

## 12. Terraform Outputs

### `outputs.tf`

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "lambda_function_name" {
  value = aws_lambda_function.demo.function_name
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
```

Outputs display useful resource identifiers after Terraform applies the configuration.

## 13. VPC Endpoints: Private Access to AWS Services

A VPC endpoint provides a private network path to supported AWS services without requiring the traffic to use a public internet route.

### Gateway endpoint

Gateway endpoints are used for **Amazon S3 and DynamoDB**. They add routes to selected route tables and do not create endpoint network interfaces. Gateway endpoints have no additional endpoint charge.

Example S3 endpoint:

```hcl
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-south-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
}
```

The endpoint must be associated with the route table used by the Lambda subnet. S3 bucket policies, endpoint policies, IAM permissions, and DNS/request configuration can still affect access.

### Interface endpoint

Interface endpoints create endpoint network interfaces (ENIs) in selected subnets. They are used for many AWS service APIs. They generally have hourly and data-processing charges, and require suitable endpoint security-group rules.

Illustrative example based on the source material:

```hcl
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-south-1.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.lambda_sg.id]
  private_dns_enabled = true
}
```

**Endpoint security-group reminder:** The security group attached to an interface endpoint must allow inbound traffic on the required port (commonly TCP `443`) from the Lambda's security group. The Lambda security group must permit the corresponding outbound traffic. A security group attached to the endpoint is not automatically configured correctly merely because it is the same group as Lambda's.

### QuickSight endpoint caution

The source material gives this illustrative configuration:

```hcl
resource "aws_vpc_endpoint" "quicksight" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.ap-south-1.quicksight"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.lambda_sg.id]
  private_dns_enabled = true
}
```

Do not assume that a private VPC endpoint is available for every QuickSight API in every region. Check the current AWS PrivateLink/service endpoint documentation for the exact service name and region before deploying this resource. If a supported endpoint is unavailable for the API you need, the Lambda may require NAT-based outbound connectivity instead. Network connectivity also does not grant API permissions; IAM authorization is still required.

### Endpoint comparison

| Endpoint type | Common services | How it works |
|---|---|---|
| Gateway | S3, DynamoDB | Adds routes to selected route tables |
| Interface | Many AWS service APIs, such as STS and CloudWatch APIs where supported | Creates private endpoint ENIs in subnets |

---

## 14. Why Did Lambda Stop Accessing S3 or QuickSight After Moving Into a VPC?

A Lambda function outside a customer VPC can use the AWS service's public endpoints through the Lambda-managed network. When attached to a VPC, its network access follows the VPC subnets' routing and security configuration.

Use this troubleshooting checklist:

1. **Check subnet selection:** confirm the Lambda is attached to the intended private subnets.
2. **Check the route table:** confirm the private subnet is associated with the expected route table.
3. **Check outbound internet access:** if the function calls an external API or a public AWS API that has no usable VPC endpoint, confirm the route to a NAT Gateway and the NAT subnet's route to the IGW.
4. **Check S3 access:** create an S3 Gateway Endpoint and associate it with the route table used by the Lambda subnet, or use an appropriate NAT route.
5. **Check interface endpoint support:** confirm the exact service and region support the endpoint you intend to create.
6. **Check security groups:** allow the required outbound connection from Lambda and inbound connection to interface endpoints, typically TCP `443`.
7. **Check IAM:** verify that the Lambda role has the required API permissions.
8. **Check resource policies:** review S3 bucket policies, endpoint policies, and any service-specific policies.
9. **Check DNS:** confirm VPC DNS support/hostnames and endpoint private DNS settings are appropriate.
10. **Read the error:** distinguish timeout/network errors from `AccessDenied` or authentication errors. A timeout often points to connectivity; an authorization error usually points to IAM or resource policy.

### Common traffic paths

```text
Lambda in private subnet
    |
    +---- S3 request --------> S3 Gateway Endpoint ----> S3
    |
    +---- Supported AWS API -> Interface Endpoint -----> AWS service
    |
    +---- External API ------> NAT Gateway -> IGW ------> Internet
```

---

## 15. Deploy the Lab

### Prerequisites

- An AWS account with permission to create VPC, subnet, route, NAT Gateway, Elastic IP, security group, IAM role, and Lambda resources.
- Terraform installed.
- AWS credentials configured using an approved method.
- The Lambda ZIP file available at the path configured in `filename`.

### Commands

Run these commands from the `aws-lambda-vpc/` directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the plan before typing `yes` at the apply confirmation prompt.

To test the Lambda, open the AWS Lambda console, choose `demo-lambda-vpc`, create a test event, and run the test. The expected response is:

```json
{
  "message": "Lambda inside VPC working successfully!"
}
```

### Verify the setup

- [ ] VPC exists with the expected CIDR.
- [ ] Public and private subnets exist.
- [ ] IGW is attached to the VPC.
- [ ] Public route table sends `0.0.0.0/0` to the IGW.
- [ ] NAT Gateway is in the public subnet and is available.
- [ ] Private route table sends `0.0.0.0/0` to the NAT Gateway if outbound internet is needed.
- [ ] Lambda uses the private subnet and intended security group.
- [ ] Lambda execution role has logging, VPC network-interface, and service permissions as required.
- [ ] S3 Gateway Endpoint is associated with the correct route table if used.
- [ ] Interface endpoint service name, subnets, DNS, and security-group rules are correct if used.
- [ ] Lambda test succeeds.

## 16. Hands-on Lab Tasks

### Lab 1 — Create a VPC

1. Create the project folder and Terraform files.
2. Add the AWS provider, VPC, and subnet resources.
3. Run `terraform init`, `terraform validate`, and `terraform plan`.
4. Apply the configuration and confirm the VPC/subnets in the AWS console.

**Expected result:** a VPC with one public and one private subnet.

### Lab 2 — Configure routing

1. Attach an Internet Gateway to the VPC.
2. Create a public route table with `0.0.0.0/0` pointing to the IGW.
3. Associate the public subnet with the public route table.
4. Create a NAT Gateway in the public subnet and allocate an Elastic IP.
5. Create a private route table with a default route to the NAT Gateway.
6. Associate the private subnet with the private route table.

**Expected result:** private-subnet resources can initiate outbound IPv4 internet connections through NAT, assuming security and other configuration is correct.

### Lab 3 — Deploy Lambda into the VPC

1. Create the Lambda execution role and attach the required policies.
2. Create the Lambda ZIP package.
3. Configure `vpc_config` with the private subnet and Lambda security group.
4. Apply Terraform.
5. Test the function in the Lambda console.

**Expected result:** the function executes from the VPC configuration and returns the sample message.

### Lab 4 — Add private S3 access

1. Create an S3 Gateway Endpoint for the correct region.
2. Associate it with the private route table used by Lambda.
3. Ensure the Lambda role and bucket policy permit the intended operation.
4. Test the S3 call from Lambda.

**Expected result:** S3 traffic can use the gateway endpoint without relying on the NAT Gateway route.

### Lab 5 — Troubleshoot an AWS API call

1. Identify the API and region used by the Lambda.
2. Confirm whether an Interface Endpoint is supported for that API.
3. If supported, configure endpoint subnets, DNS, and endpoint security-group inbound rules.
4. Verify Lambda egress rules and IAM permissions.
5. Run the Lambda and inspect CloudWatch Logs.

**Expected result:** you can identify whether a failure is caused by networking, endpoint support, DNS, or permissions.

## 17. Clean Up to Avoid Charges

NAT Gateways, Elastic IPs, and Interface Endpoints can incur charges. When you have finished the lab, destroy the Terraform-managed resources:

```bash
terraform destroy
```

Review the resources Terraform plans to delete, then confirm. Do not run this in a shared or production workspace unless you are certain the resources are safe to remove.

## 18. Interview Questions and Answers

**1. What is a VPC?**  
A logically isolated network in AWS where you define IP ranges, subnets, routes, and network controls.

**2. What is CIDR?**  
A notation that represents an IP address range, such as `10.0.0.0/16`.

**3. What makes a subnet public?**  
A route table associated with the subnet has a route to an Internet Gateway. Public IP assignment alone does not make it public.

**4. What is the purpose of an Internet Gateway?**  
It enables communication between a VPC and the internet when routing and public addressing/security configuration allow it.

**5. What does a NAT Gateway do?**  
It lets resources in private subnets initiate outbound connections to external IPv4 destinations without accepting unsolicited inbound connections.

**6. Why does a Lambda function need VPC configuration?**  
To connect to resources reachable through a specified VPC, such as private databases or internal services.

**7. Why can a Lambda lose internet access after being attached to a VPC?**  
Its selected subnets may not have a working route to a NAT Gateway, or required routing/security/DNS settings may be missing.

**8. What is a route table?**  
A set of rules that directs network traffic to destinations.

**9. What does `0.0.0.0/0` mean?**  
All IPv4 destinations, unless a more specific route takes precedence.

**10. What does `protocol = "-1"` mean in a security group rule?**  
It means all protocols. It is broader than allowing only TCP/443.

**11. Why use an S3 Gateway Endpoint?**  
It provides a private route to S3 from selected route tables without requiring an internet/NAT path for that traffic.

**12. What is an Interface Endpoint?**  
A private endpoint that creates network interfaces in selected subnets for supported AWS service APIs.

**13. Does a VPC endpoint grant IAM access?**  
No. Network connectivity and IAM/resource-policy authorization are separate.

**14. Why might S3 return `AccessDenied` even when the endpoint exists?**  
The Lambda role, bucket policy, or endpoint policy may not permit the requested operation.

**15. Why might an AWS API request time out?**  
Possible causes include missing routes, blocked security-group traffic, DNS issues, or an unavailable/incorrect endpoint configuration.

## 19. Quick Quiz

Choose the best answer before checking the key.

1. Which component connects a VPC to the internet?
   - A. NAT Gateway
   - B. Internet Gateway
   - C. Security Group
   - D. IAM Role

2. Which resource usually provides outbound internet access to a private subnet?
   - A. Internet Gateway directly
   - B. NAT Gateway
   - C. S3 bucket
   - D. IAM policy

3. What does `0.0.0.0/0` represent?
   - A. One IP address
   - B. All IPv4 destinations
   - C. All private IPv4 addresses only
   - D. A security group

4. Which endpoint type is used for S3 in this chapter?
   - A. Gateway
   - B. Interface only
   - C. Internet Gateway
   - D. NAT endpoint

5. Does creating a VPC endpoint automatically grant permission to access a service?
   - A. Yes
   - B. No

6. What does `protocol = "-1"` mean in a security group rule?
   - A. HTTPS only
   - B. TCP only
   - C. All protocols
   - D. No traffic

### Answer key

1. **B** — Internet Gateway  
2. **B** — NAT Gateway  
3. **B** — All IPv4 destinations  
4. **A** — Gateway  
5. **B** — IAM and resource policies still apply  
6. **C** — All protocols  

---

## 20. Final Recap

- **VPC:** your isolated AWS network.
- **CIDR:** defines the IP address range.
- **Public subnet:** has a route to an Internet Gateway.
- **Private subnet:** does not have a direct route to an Internet Gateway.
- **Route table:** directs traffic.
- **NAT Gateway:** allows outbound internet connections from private subnets.
- **Security group:** controls allowed inbound and outbound network traffic.
- **IAM role:** grants the Lambda permissions to call AWS APIs.
- **S3 Gateway Endpoint:** routes supported S3 traffic privately through a route table.
- **Interface Endpoint:** creates private network interfaces for supported AWS service APIs.
- **Lambda VPC configuration:** attaches the function to selected subnets and security groups; it does not by itself provide internet access.

**One-line memory aid:** A VPC is the network, subnets divide it, route tables direct traffic, an IGW connects public routes to the internet, NAT provides outbound internet access for private subnets, and endpoints provide private paths to supported AWS services.
