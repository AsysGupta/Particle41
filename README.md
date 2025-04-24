
# Particle41 Project

Welcome to the Particle41 project! This repository contains a Flask-based web application and Terraform configurations to deploy a scalable, cloud-native infrastructure on AWS. The application, a simple visitor info service, returns the current timestamp and client IP address in JSON format. The infrastructure includes a VPC, Application Load Balancer (ALB), ECS cluster, and optional ECR repository, all managed via Terraform.

## Table of Contents
- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Deploy the Infrastructure](#deploy-the-infrastructure)
  - [Deploy the Application](#deploy-the-application)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Particle41 project consists of two main components:
1. **Flask Visitor Info Application**:
   - A lightweight Python Flask web service that responds to HTTP requests at the root endpoint (`/`) with a JSON object containing the current timestamp and the client's IP address.
   - Containerized using Docker for portability and ease of deployment.
   - Can be deployed locally or on AWS ECS with an ALB for scalability.

2. **Terraform Infrastructure**:
   - Deploys a complete AWS infrastructure, including:
     - An S3 bucket and DynamoDB table for Terraform state management (`bootstrap` module).
     - A VPC with public and private subnets (`network` module).
     - An Application Load Balancer (`alb` module).
     - An optional ECR repository for storing Docker images (`ecr` module).
     - An ECS cluster running the Flask application (`ecs` module).
   - Uses modular Terraform configurations for reusability and maintainability.

The application is ideal for learning about containerized microservices, AWS infrastructure as code, and CI/CD integration.

## Repository Structure
```
Particle41/
├── app/
│   ├── app.py              # Flask application code
│   ├── Dockerfile          # Docker configuration
│   ├── requirements.txt    # Python dependencies
│   ├── README.md           # Application-specific documentation
├── terraform/
│   ├── alb/                # ALB module
│   ├── bootstrap/          # Backend setup (S3, DynamoDB)
│   ├── ecr/                # ECR module (optional)
│   ├── ecs/                # ECS cluster module
│   ├── network/            # VPC and networking module
│   ├── modules/            # Reusable Terraform modules
│   ├── README.md           # Terraform-specific documentation
├── README.md               # This file (project overview)
```

- `app/`: Contains the Flask application and Docker configuration.
- `terraform/`: Contains Terraform configurations for AWS infrastructure.
- `README.md`: Top-level documentation for the entire project.

## Prerequisites
To use this project, you need:
- **Docker**: For building and running the application container. [Install Docker](https://docs.docker.com/get-docker/).
- **Terraform**: For deploying the AWS infrastructure (version >= 1.5.0). [Install Terraform](https://www.terraform.io/downloads.html).
- **AWS CLI**: Configured with credentials for deploying to AWS. [Install AWS CLI](https://aws.amazon.com/cli/).
- **Git**: To clone the repository (optional). [Install Git](https://git-scm.com/downloads).
- An AWS account with permissions to create S3, DynamoDB, VPC, ALB, ECS, and ECR resources.
- A Docker Hub account (optional, for pushing images to Docker Hub) or AWS ECR access (for pushing images to ECR).

## Getting Started

### Deploy the Infrastructure
The Terraform configurations in the `terraform/` directory deploy the necessary AWS infrastructure. Follow these steps:

1. **Navigate to the Terraform documentation**:
   - Detailed instructions are provided in `terraform/README.md`.
   - Start by deploying the `bootstrap` module to set up the S3 and DynamoDB backend for Terraform state management.

2. **Deploy the modules in order**:
   - `bootstrap`: Sets up the Terraform backend.
   - `network`: Creates the VPC and subnets.
   - `alb`: Deploys the Application Load Balancer.
   - `ecr` (optional): Creates an ECR repository for storing Docker images.
   - `ecs`: Deploys the ECS cluster and runs the application.

3. **Key steps for each module**:
   - Update `backend.config.hcl` with a unique `key` for each module (e.g., `<project>/<module>/terraform.tfstate`).
   - Configure `terraform.tfvars` with your AWS resource details (e.g., subnet IDs, VPC ID).
   - Run `terraform init -backend-config=backend.config.hcl` and `terraform apply` for each module.
   - Refer to `terraform/README.md` for detailed instructions and variable configurations.

### Deploy the Application
The Flask application in the `app/` directory can be run locally or deployed to ECS. Follow these steps:

1. **Navigate to the application documentation**:
   - Detailed instructions are provided in `app/README.md`.

2. **Build and push the Docker image**:
   - Build the Docker image locally:
     ```bash
     cd app
     docker build -t simple-time-service .
     ```
   - Push the image to Docker Hub or AWS ECR (see `app/README.md` for detailed steps).
     - For Docker Hub: Tag and push to `<your-dockerhub-username>/simple-time-service:v1`.
     - For ECR: Tag and push to `<aws-account-id>.dkr.ecr.<region>.amazonaws.com/simple-time-service-app-ecr:v1`.

3. **Run locally (optional)**:
   - Test the application locally:
     ```bash
     docker run -d -p 5000:5000 --name flask-app simple-time-service
     ```
   - Access at `http://localhost:5000`.

4. **Deploy to ECS**:
   - Update the `ecs` module’s `terraform.tfvars` with the Docker image URL (from Docker Hub or ECR).
   - Apply the `ecs` module to deploy the application to the ECS cluster, integrated with the ALB.
   - Refer to `terraform/README.md` for ECS-specific configuration.

## Accessing the Application
- **Local Deployment**:
  - Access the application at `http://localhost:5000` if running locally.
  - The response will be a JSON object like:
    ```json
    {
      "timestamp": "2025-04-24 21:42:56",
      "ip": "192.168.1.100"
    }
    ```

- **ECS Deployment**:
  - Retrieve the ALB DNS name from the AWS Console or Terraform outputs.
  - Access the application at `http://<alb-dns-name>`.
  - Ensure security groups and firewall rules allow traffic on port `80` (ALB listener port).

- **Command Line**:
  - Use `curl` to test:
    ```bash
    curl http://<alb-dns-name>  # or http://localhost:5000 for local
    ```

## Troubleshooting
- **Infrastructure Issues**:
  - **Terraform errors**: Check `terraform/README.md` for module-specific troubleshooting, such as state file conflicts or missing resource IDs.
  - **AWS permissions**: Ensure your AWS credentials have permissions for S3, DynamoDB, VPC, ALB, ECS, and ECR.
  - **Resource not found**: Verify resource IDs in `terraform.tfvars` (e.g., subnet IDs, VPC ID) match your AWS environment.

- **Application Issues**:
  - **Docker build fails**: Ensure `app/requirements.txt` and `app/Dockerfile` are correct. See `app/README.md` for details.
  - **Cannot access application**: Check if port `5000` (local) or `80` (ALB) is open. Verify ECS service and ALB target group health in AWS.
  - **ECR/Docker Hub push fails**: Confirm login credentials and repository existence.

- **General**:
  - Check container logs: `docker logs flask-app` (local) or ECS task logs in AWS.
  - Review Terraform plans (`terraform plan`) before applying to avoid misconfigurations.
  - Consult `app/README.md` and `terraform/README.md` for module-specific troubleshooting.

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a branch for your feature or bug fix (`git checkout -b feature/your-feature`).
3. Make changes and test thoroughly (e.g., build Docker image, apply Terraform).
4. Submit a pull request with a clear description.

Ensure code follows PEP 8 for Python and Terraform best practices (e.g., modular design, documentation).

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

---
