# AWS Terraform Infrastructure & CI/CD — Cloud Project

## 1. Project Description

This project provisions a secure, highly available, multi-tier AWS infrastructure using Terraform.

It deploys a containerized web application behind an Application Load Balancer (ALB), with application instances running in private subnets, an Amazon RDS PostgreSQL database, and CI/CD automation using GitHub Actions.

The infrastructure is modular, reproducible, and designed to support separate development, testing, and production environments.

## 2. Architecture

The architecture consists of the following components:

- **Networking:** Amazon VPC (`10.20.0.0/16`) distributed across two Availability Zones, with two public subnets, two private application subnets, and two private database subnets.
- **Security:** Security Groups enforcing controlled communication between the ALB, application instances, and database.
- **Private connectivity:** VPC Endpoints for Amazon ECR and Amazon S3, allowing private application instances to retrieve container images without a NAT Gateway.
- **Compute:** EC2 Launch Template and Auto Scaling Group running Docker containers.
- **Load Balancing:** Application Load Balancer distributing incoming HTTP requests across application instances.
- **Container Registry:** Amazon Elastic Container Registry (ECR) storing the Docker application image.
- **Database:** Amazon RDS for PostgreSQL deployed in private database subnets using a Single-AZ configuration.
- **Storage:** Amazon S3 for application storage and Terraform remote state.
- **Infrastructure as Code:** Terraform modules and environment-specific configurations.
- **CI/CD:** GitHub Actions workflows for Docker image publication and Terraform validation and planning.

## 3. Technologies Used

| Category | Technologies |
|---|---|
| Cloud Provider | AWS |
| Infrastructure as Code | Terraform |
| Networking | VPC, Subnets, Route Tables, Internet Gateway |
| Security | Security Groups, IAM, S3 Public Access Block |
| Compute | EC2, Launch Template, Auto Scaling Group |
| Load Balancing | Application Load Balancer |
| Database | Amazon RDS PostgreSQL |
| Containerization | Docker |
| Container Registry | Amazon ECR |
| Storage | Amazon S3 |
| CI/CD | GitHub Actions |
| Version Control | Git, GitHub |

## 4. Prerequisites

- Terraform >= 1.10.0
- AWS CLI v2
- Git
- An AWS account with the required permissions
- Docker (only if building the application image locally)

The project was developed using AWS Academy Learner Lab.

## 5. Authentication and AWS Academy Limitations

This project was developed using AWS Academy Learner Lab, which applies Service Control Policies (SCPs) that restrict certain IAM operations.

The following implementation decisions account for these restrictions:

1. **EC2 authentication:** Application instances use the pre-existing `LabInstanceProfile`.
2. **GitHub Actions authentication:** Temporary AWS Learner Lab credentials are stored as encrypted GitHub Actions Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_SESSION_TOKEN`
   - `AWS_REGION`
3. **Local authentication:** Local Terraform operations require valid AWS Learner Lab credentials configured through the AWS CLI.
4. **IAM restrictions:** Custom IAM role and OIDC provider creation are restricted by the Learner Lab SCP.

Temporary credentials must be refreshed when they expire.

## 6. Repository Structure

```text
terraform-cloud-project/
│
├── .github/
│   └── workflows/
│       ├── publish-image.yml
│       └── terraform.yml
│
├── app/
│   └── Dockerfile
│
├── bootstrap/
│   └── state-backend/
│
├── docs/
│   ├── architecture/
│   ├── screenshots/
│   └── cost-estimate/
│
├── environments/
│   ├── dev/
│   ├── test/
│   └── prod/
│
├── modules/
│   ├── network/
│   ├── security/
│   ├── endpoints/
│   ├── load-balancer/
│   ├── compute/
│   ├── database/
│   └── storage/
│
├── .gitignore
├── README.md
└── LICENSE
```

## 7. Terraform Remote State

Terraform state is stored remotely in an Amazon S3 bucket:

`cloud-project-tfstate-201679117202`

The backend configuration uses:

- Remote state storage in Amazon S3.
- Server-side encryption using AES-256.
- S3 bucket versioning.
- Native S3 state locking using `use_lockfile = true`.
- Separate state keys for each environment.

State key structure:

| Environment | State key |
|---|---|
| Development | `dev/terraform.tfstate` |
| Testing | `test/terraform.tfstate` |
| Production | `prod/terraform.tfstate` |

The backend bucket is managed separately through the bootstrap Terraform configuration and must be preserved when destroying an application environment.

## 8. How to Deploy

### 8.1 Clone the repository

```bash
git clone <REPOSITORY_URL>
cd terraform-cloud-project
```

### 8.2 Configure AWS authentication

Authenticate using valid AWS Learner Lab credentials:

```bash
aws configure
```

For temporary session credentials, configure the session token as well.

Verify the identity:

```bash
aws sts get-caller-identity
```

### 8.3 Initialize Terraform

Navigate to the development environment:

```bash
cd environments/dev
```

Initialize the remote backend:

```bash
terraform init
```

### 8.4 Configure variables

Create a local `terraform.tfvars` file containing the required sensitive variables.

Example:

```hcl
db_password = "YOUR_DATABASE_PASSWORD"
```

Keep sensitive values out of Git.

### 8.5 Review and deploy

Format the Terraform configuration:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Review the infrastructure plan:

```bash
terraform plan -var-file="dev.tfvars"
```

Deploy only after reviewing the plan and confirming that the AWS account and credentials are correct:

```bash
terraform apply -var-file="dev.tfvars"
```

## 9. CI/CD Pipeline

GitHub Actions is used to automate the application image publication and Terraform validation process.

### 9.1 Docker Image Publication

Workflow: `.github/workflows/publish-image.yml`

The workflow:

1. Checks out the Git repository.
2. Authenticates with Amazon ECR.
3. Builds the Docker image from the application source.
4. Tags the image.
5. Pushes the image to the ECR repository.

The application image is stored in:

`cloud-project-dev-app`

### 9.2 Terraform CI/CD

Workflow: `.github/workflows/terraform.yml`

The Terraform workflow is designed to execute on Pull Requests and pushes to the main branch.

Its validation stages include:

1. Repository checkout.
2. AWS authentication.
3. Terraform installation.
4. `terraform fmt -check -recursive`.
5. `terraform init`.
6. `terraform validate`.
7. `terraform plan`.
8. Generation and publication of a readable Terraform plan artifact.

Infrastructure deployment must remain controlled. Test and production deployments should require manual approval and protected GitHub Environments.

## 10. Security Implementation

The project implements several security controls:

- Application instances are deployed in private subnets.
- Application ingress is restricted to the ALB Security Group.
- Database ingress is restricted to the application Security Group.
- RDS is not publicly accessible.
- S3 public access is blocked.
- S3 server-side encryption is enabled.
- Terraform remote state encryption and versioning are enabled.
- IAM permissions use the existing Learner Lab role and instance profile where required.
- AWS credentials are stored in GitHub Secrets rather than committed to the repository.
- Private connectivity to ECR and S3 avoids requiring a NAT Gateway.

### Learner Lab Limitations

AWS Academy restrictions prevent certain IAM operations, including custom OIDC provider creation.

Consequently, temporary AWS credentials are used for GitHub Actions authentication.

S3 Object Lock configuration is also subject to the Learner Lab's SCP restrictions. The project uses the supported S3 security configurations without claiming that Object Lock is enabled.

## 11. Testing and Validation

The infrastructure was validated through the following tests:

| Test | Expected result |
|---|---|
| Terraform formatting | No formatting differences |
| Terraform validation | Successful validation |
| Terraform plan | Readable infrastructure plan |
| Application access | Web application accessible through the ALB |
| Load balancing | Requests distributed across application instances |
| High availability | Application remains accessible after one instance fails |
| Auto Scaling | ASG replaces an unhealthy or terminated instance |
| Database security | RDS is not publicly accessible |
| Storage security | S3 public access is blocked |
| Remote state | Terraform state stored in the S3 backend |
| Cleanup | Test infrastructure successfully destroyed |

Screenshots and test evidence are stored under `docs/screenshots/`.

## 12. Cost Optimization

The architecture includes several decisions intended to reduce AWS costs:

- **No NAT Gateway:** Private application instances use VPC Endpoints to access ECR and S3.
- **Single-AZ RDS:** Reduces database deployment costs compared with Multi-AZ.
- **Small EC2 instances:** Uses appropriately sized instances for the development environment.
- **Infrastructure cleanup:** Test infrastructure is destroyed after validation to prevent unnecessary ongoing charges.
- **Remote state preservation:** The Terraform backend is maintained separately from the application infrastructure.

**Important cost considerations:**

- ECR interface endpoints (`ecr.api` and `ecr.dkr`) incur hourly and data-processing charges.
- The S3 Gateway Endpoint does not incur an hourly endpoint charge.
- EC2, EBS, RDS, and ALB resources can generate charges while deployed.
- S3 storage and requests may also generate charges.

The cost estimate should be reviewed against the AWS region and actual resource usage.

## 13. Known Limitations

- AWS Academy Learner Lab restricts certain IAM operations through SCPs.
- GitHub OIDC authentication cannot be configured without permission to create the required IAM identity provider and role.
- Temporary credentials must be refreshed when they expire.
- The development environment uses a cost-conscious Single-AZ database configuration.
- Test and production environments are maintained as separate Terraform configurations and state targets; they are not necessarily deployed continuously.

## 14. Conclusion

This project demonstrates the design and implementation of a modular AWS cloud infrastructure using Terraform and GitHub Actions.

It combines cloud networking, private application hosting, containerization, load balancing, Auto Scaling, managed database services, remote state management, and automated infrastructure validation.

The implementation also demonstrates practical cloud engineering considerations, including least-privilege access, private connectivity, cost optimization, infrastructure lifecycle management, and the constraints of an AWS Academy environment.