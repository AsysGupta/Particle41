
# Terraform Infrastructure Deployment Guide

This repository contains Terraform configurations to deploy infrastructure for the project. The infrastructure is organized into several root modules, each with corresponding reusable modules in the `modules` directory.

## Folder Structure

```
terraform/
├── alb/
├── bootstrap/
├── ecr/
├── ecs/
├── network/
├── modules/
│   ├── alb/
│   ├── bootstrap/
│   ├── ecr/
│   ├── ecs/
│   ├── network/
```

## Prerequisites

- **Terraform** installed (version >= 1.5.0)
- **AWS CLI** configured with appropriate credentials and permissions
- An AWS account with permissions to create S3 buckets, DynamoDB tables, VPCs, ALBs, ECR repositories, ECS clusters, and other required resources

## Deployment Steps

### Step 1: Deploy the Bootstrap Module

The `bootstrap` module sets up an S3 bucket and DynamoDB table to serve as the Terraform backend for state management.

1. **Navigate to the bootstrap directory**:
   ```bash
   cd bootstrap
   ```

2. **Comment out the backend block** in the Terraform configuration:
   - Open the `main.tf` in the `bootstrap` directory.
   - Comment out the `terraform { backend "s3" {} }` block to disable the backend temporarily:
     ```hcl
     # terraform {
     #   backend "s3" {}
     # }
     ```

3. **Create and configure `backend.config.hcl`**:
   - In the `bootstrap` directory, create a file named `backend.config.hcl`.
   - Add the following configuration, replacing the dummy values with your desired values:
     ```hcl
     bucket         = "<your-unique-bucket-name>"
     key            = "<your-state-file-path>"
     region         = "<your-aws-region>"
     dynamodb_table = "<your-dynamodb-table-name>"
     encrypt        = true
     ```

4. **Create and configure `terraform.tfvars`**:
   - In the `bootstrap` directory, create a file named `terraform.tfvars`.
   - Add the following variables, replacing the dummy values with your desired values (ensure they match the `backend.config.hcl` values where applicable):
     ```hcl
     aws_region          = "<your-aws-region>"
     bucket_name         = "<your-unique-bucket-name>"
     dynamodb_table_name = "<your-dynamodb-table-name>"
     ```

5. **Initialize Terraform**:
   - Run the following command to initialize the Terraform working directory:
     ```bash
     terraform init
     ```

6. **Apply the bootstrap module**:
   - Execute the following command to create the S3 bucket and DynamoDB table:
     ```bash
     terraform apply
     ```
   - Review the plan and type `yes` to confirm.

7. **Migrate the state to the S3 backend**:
   - After the S3 bucket and DynamoDB table are created, re-enable the backend by uncommenting the `terraform { backend "s3" {} }` block in the `main.tf` file.
   - Run the following command to initialize Terraform with the backend configuration:
     ```bash
     terraform init -backend-config=backend.config.hcl
     ```
   - When prompted to migrate the existing local state file to the S3 backend, type `yes`.

### Step 2: Deploy the Network Module

The `network` module creates a VPC, subnets, and associated networking resources.

1. **Navigate to the network directory**:
   ```bash
   cd network
   ```

2. **Update `backend.config.hcl`**:
   - Create or update the `backend.config.hcl` file with the following, ensuring the `key` is unique for this module:
     ```hcl
     bucket         = "<your-unique-bucket-name>"
     key            = "<your-project>/network/terraform.tfstate"
     region         = "<your-aws-region>"
     dynamodb_table = "<your-dynamodb-table-name>"
     encrypt        = true
     ```

3. **Create and configure `terraform.tfvars`**:
   - Create a `terraform.tfvars` file with the following variables:
     ```hcl
     aws_region           = "<your-aws-region>"
     vpc_cidr             = "192.168.0.0/16"
     vpc_name             = "<your-vpc-name>"
     public_subnet_cidrs  = ["192.168.1.0/24", "192.168.2.0/24"]
     private_subnet_cidrs = ["192.168.3.0/24", "192.168.4.0/24"]
     availability_zones   = ["<your-region>a", "<your-region>b"]
     ```

4. **Initialize Terraform**:
   - Run:
     ```bash
     terraform init -backend-config=backend.config.hcl
     ```

5. **Apply the network module**:
   - Run:
     ```bash
     terraform apply
     ```
   - Review the plan and type `yes` to confirm.

### Step 3: Deploy the ALB Module

The `alb` module deploys an Application Load Balancer.

1. **Navigate to the alb directory**:
   ```bash
   cd alb
   ```

2. **Update `backend.config.hcl`**:
   - Create or update the `backend.config.hcl` file with a unique `key`:
     ```hcl
     bucket         = "<your-unique-bucket-name>"
     key            = "<your-project>/alb/terraform.tfstate"
     region         = "<your-aws-region>"
     dynamodb_table = "<your-dynamodb-table-name>"
     encrypt        = true
     ```

3. **Create and configure `terraform.tfvars`**:
   - Create a `terraform.tfvars` file with the following, replacing placeholder values with your actual resource IDs:
     ```hcl
     aws_region                 = "<your-aws-region>"
     lb_name                    = "<your-alb-name>"
     internal                   = false
     security_groups            = ["<your-security-group-id>"]
     subnets                    = ["<your-public-subnet-id-1>", "<your-public-subnet-id-2>"]
     enable_deletion_protection = false
     vpc_id                     = "<your-vpc-id>"
     target_group_name          = "<your-target-group-name>"
     target_port                = 5000
     target_protocol            = "HTTP"
     target_type                = "ip"
     health_check_path          = "/"
     listener_port              = 80
     listener_protocol          = "HTTP"
     ```

4. **Initialize Terraform**:
   - Run:
     ```bash
     terraform init -backend-config=backend.config.hcl
     ```

5. **Apply the alb module**:
   - Run:
     ```bash
     terraform apply
     ```
   - Review the plan and type `yes` to confirm.

### Step 4: Deploy the ECR Module (Optional)

The `ecr` module creates an Elastic Container Registry repository. This is optional, as you can use Docker Hub instead.

1. **Navigate to the ecr directory**:
   ```bash
   cd ecr
   ```

2. **Update `backend.config.hcl`**:
   - Create or update the `backend.config.hcl` file with a unique `key`:
     ```hcl
     bucket         = "<your-unique-bucket-name>"
     key            = "<your-project>/ecr/terraform.tfstate"
     region         = "<your-aws-region>"
     dynamodb_table = "<your-dynamodb-table-name>"
     encrypt        = true
     ```

3. **Create and configure `terraform.tfvars`**:
   - Create a `terraform.tfvars` file with the following:
     ```hcl
     aws_region           = "<your-aws-region>"
     repo_name            = "<your-ecr-repo-name>"
     scan_on_push         = true
     image_tag_mutability = "IMMUTABLE"
     encryption_type      = "AES256"

     lifecycle_policy = {
       rules = [
         {
           rulePriority = 1
           description  = "Expire untagged images older than 14 days"
           selection = {
             tagStatus   = "untagged"
             countType   = "sinceImagePushed"
             countUnit   = "days"
             countNumber = 14
           }
           action = {
             type = "expire"
           }
         }
       ]
     }

     repository_policy = {
       Version = "2008-10-17"
       Statement = [
         {
           Sid       = "AllowPull"
           Effect    = "Allow"
           Principal = "*"
           Action = [
             "ecr:GetDownloadUrlForLayer",
             "ecr:BatchGetImage",
             "ecr:BatchCheckLayerAvailability"
           ]
         }
       ]
     }

     tags = {
       Environment = "dev"
       Application = "<your-app-name>"
     }
     ```

4. **Initialize Terraform**:
   - Run:
     ```bash
     terraform init -backend-config=backend.config.hcl
     ```

5. **Apply the ecr module**:
   - Run:
     ```bash
     terraform apply
     ```
   - Review the plan and type `yes` to confirm.

### Step 5: Deploy the ECS Module

The `ecs` module deploys an ECS cluster and service, integrated with the ALB.

1. **Navigate to the ecs directory**:
   ```bash
   cd ecs
   ```

2. **Update `backend.config.hcl`**:
   - Create or update the `backend.config.hcl` file with a unique `key`:
     ```hcl
     bucket         = "<your-unique-bucket-name>"
     key            = "<your-project>/ecs/terraform.tfstate"
     region         = "<your-aws-region>"
     dynamodb_table = "<your-dynamodb-table-name>"
     encrypt        = true
     ```

3. **Create and configure `terraform.tfvars`**:
   - Create a `terraform.tfvars` file with the following, replacing placeholder values with your actual resource IDs:
     ```hcl
     region = "<your-aws-region>"

     repo_name    = "<your-ecr-repo-name>"
     scan_on_push = true

     cluster_name       = "<your-ecs-cluster-name>"
     family             = "<your-task-family-name>"
     execution_role_arn = "<your-ecs-execution-role-arn>"
     task_role_arn      = "<your-ecs-task-role-arn>"

     container_name = "<your-container-name>"
     image          = "<your-container-image>"
     container_port = 5000
     cpu            = 512
     memory         = 1024

     container_environment = [
       {
         name  = "env"
         value = "dev"
       }
     ]

     service_name     = "<your-service-name>"
     desired_count    = 1
     subnets          = ["<your-subnet-id-1>", "<your-subnet-id-2>"]
     security_groups  = ["<your-security-group-id>"]
     assign_public_ip = true

     load_balancer = {
       target_group_arn = "<your-target-group-arn>"
       container_name   = "<your-container-name>"
       container_port   = 5000
     }

     tags = {
       env   = "dev"
       Owner = "<your-name>"
     }
     ```

4. **Initialize Terraform**:
   - Run:
     ```bash
     terraform init -backend-config=backend.config.hcl
     ```

5. **Apply the ecs module**:
   - Run:
     ```bash
     terraform apply
     ```
   - Review the plan and type `yes` to confirm.

6. **Access the application**:
   - Once deployed, the ECS service will be accessible via the ALB's DNS name (if the same ALB target group is used). Retrieve the ALB DNS name from the AWS Console or Terraform output and browse to it.

### Notes

- **Backend Configuration**: For each module, ensure the `key` in `backend.config.hcl` is unique (e.g., `<your-project>/<module>/terraform.tfstate`) to avoid state file conflicts.
- **Resource Dependencies**: Replace placeholder values in `terraform.tfvars` (e.g., subnet IDs, VPC ID, security group IDs, ARNs) with the actual values from your AWS account or previous module outputs.
- **ECR vs. Docker Hub**: The `ecr` module is optional. If using Docker Hub, update the `image` field in the `ecs` module’s `terraform.tfvars` with the appropriate Docker Hub image.
- Always review the Terraform plan (`terraform plan`) before applying changes to avoid unintended modifications.

## Cleanup

To destroy the infrastructure:

1. Navigate to each module directory in reverse order of dependency (e.g., `ecs`, `ecr`, `alb`, `network`, then `bootstrap`).
2. Run:
   ```bash
   terraform destroy
   ```
3. Confirm by typing `yes`.

**Warning**: Destroying the `bootstrap` module will delete the S3 bucket and DynamoDB table, which may affect state files for other modules. Ensure all other modules are destroyed first.

## Troubleshooting

- **Permission errors**: Verify your AWS credentials have the necessary permissions.
- **State file conflicts**: Ensure the `key` in `backend.config.hcl` is unique for each module.
- **Backend initialization issues**: Double-check the values in `backend.config.hcl` and ensure the S3 bucket and DynamoDB table exist.
- **Resource not found**: Ensure resource IDs (e.g., subnet IDs, VPC ID) in `terraform.tfvars` are correct and exist in your AWS account.

For further assistance, refer to the [Terraform documentation](https://www.terraform.io/docs) or contact the infrastructure team.
