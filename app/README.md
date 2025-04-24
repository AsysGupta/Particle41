# Flask Visitor Info Application

This is a simple Flask-based web application that returns the current timestamp and the visitor's IP address in JSON format when accessed. The application is containerized using Docker for easy deployment and portability.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup and Deployment](#setup-and-deployment)
  - [Step 1: Clone the Repository](#step-1-clone-the-repository)
  - [Step 2: Create requirements.txt](#step-2-create-requirementstxt)
  - [Step 3: Build the Docker Image](#step-3-build-the-docker-image)
  - [Step 4: Push the Docker Image](#step-4-push-the-docker-image)
  - [Step 5: Run the Docker Container](#step-5-run-the-docker-container)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Flask Visitor Info Application is a lightweight web service built with Python and Flask. When a user accesses the root endpoint (`/`), the application responds with a JSON object containing:
- **Timestamp**: The current date and time in the format `YYYY-MM-DD HH:MM:SS`.
- **IP Address**: The IP address of the client making the request.

The application is packaged in a Docker container, making it easy to deploy on any system with Docker installed. It listens on port `5000` and can be accessed via a web browser or tools like `curl`.

## Prerequisites
To deploy and run this application, you need:
- **Docker**: Installed and running on your system. [Install Docker](https://docs.docker.com/get-docker/).
- **Git**: To clone the repository (optional). [Install Git](https://git-scm.com/downloads).
- **AWS CLI** (optional, for ECR): Configured with credentials if pushing to AWS ECR.
- A Docker Hub account (for pushing to Docker Hub) or AWS account with ECR access (for pushing to ECR).
- A basic understanding of Docker and command-line operations.

## Project Structure
```
├── app.py              # Flask application code
├── Dockerfile          # Docker configuration file
├── requirements.txt    # Python dependencies
└── README.md           # This file
```

- `app.py`: Contains the Flask application logic.
- `Dockerfile`: Defines the Docker image for the application.
- `requirements.txt`: Lists the Python dependencies (e.g., Flask).
- `README.md`: Documentation for the project.

## Setup and Deployment

Follow these steps to deploy the application.

### Step 1: Clone the Repository
If you have Git installed, clone the repository to your local machine:
```bash
git clone https://github.com/AsysGupta/Particle41.git
cd Particle41
```
Alternatively, download the project files manually and navigate to the project directory in your terminal.

### Step 2: Create requirements.txt
Create a file named `requirements.txt` in the project directory with the following content:
```
Flask==2.0.3
Werkzeug==2.0.3
```
This specifies the Flask dependency required for the application.

### Step 3: Build the Docker Image
Build the Docker image using the provided `Dockerfile`. Run the following command in the project directory:
```bash
docker build -t simple-time-service .
```
- `-t simple-time-service`: Names the image `simple-time-service`.
- `.`: Specifies the current directory as the build context.

This command pulls the `python:3.9-slim` base image, installs the dependencies from `requirements.txt`, and copies the application code into the image.

### Step 4: Push the Docker Image
You can push the Docker image to either **Docker Hub** or **AWS ECR** for use in deployments, such as with ECS.

#### Option 1: Push to Docker Hub
1. **Log in to Docker Hub**:
   ```bash
   docker login
   ```
   Enter your Docker Hub username and password when prompted.

2. **Tag the image**:
   Replace `<your-dockerhub-username>` with your Docker Hub username and `v1` with your desired version tag:
   ```bash
   docker tag simple-time-service <your-dockerhub-username>/simple-time-service:v1
   ```

3. **Push the image**:
   ```bash
   docker push <your-dockerhub-username>/simple-time-service:v1
   ```
   This makes the image available on Docker Hub for use in deployments (e.g., ECS).

#### Option 2: Push to AWS ECR
1. **Log in to AWS ECR**:
   Ensure the AWS CLI is configured with appropriate credentials. Replace `<aws-account-id>` and `<region>` with your AWS account ID and region (e.g., `ap-south-1`):
   ```bash
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<region>.amazonaws.com
   ```

2. **Tag the image**:
   Replace `<aws-account-id>` and `<region>` with your AWS account ID and region, and ensure the repository `simple-time-service-app-ecr` exists in ECR (created via the `ecr` Terraform module):
   ```bash
   docker tag simple-time-service <aws-account-id>.dkr.ecr.<region>.amazonaws.com/simple-time-service-app-ecr:v1
   ```

3. **Push the image**:
   ```bash
   docker push <aws-account-id>.dkr.ecr.<region>.amazonaws.com/simple-time-service-app-ecr:v1
   ```
   This makes the image available in ECR for use with ECS.

**Note**: If using ECS with the Terraform configurations in the `ecs` module, ensure the `image` field in `terraform.tfvars` matches the pushed image (e.g., `<your-dockerhub-username>/simple-time-service:v1` for Docker Hub or `<aws-account-id>.dkr.ecr.<region>.amazonaws.com/simple-time-service-app-ecr:v1` for ECR).

### Step 5: Run the Docker Container
Run the Docker container locally from the built image to test it:
```bash
docker run -d -p 5000:5000 --name flask-app simple-time-service
```
- `-d`: Runs the container in detached mode (in the background).
- `-p 5000:5000`: Maps port `5000` on the host to port `5000` in the container.
- `--name flask-app`: Names the container `flask-app`.
- `simple-time-service`: Specifies the image to use.

Alternatively, deploy the image to ECS using the Terraform `ecs` module, as described in the Terraform README, to run it in a managed cluster.

## Accessing the Application
Once the container is running, you can access the application in the following ways:

1. **Web Browser** (local deployment):
   - Open a browser and navigate to `http://localhost:5000`.
   - You should see a JSON response like:
     ```json
     {
       "timestamp": "2025-04-16 12:34:56",
       "ip": "192.168.1.100"
     }
     ```

2. **Command Line (using curl)**:
   - Run the following command:
     ```bash
     curl http://localhost:5000
     ```
   - The output will be similar to the JSON response above.

3. **ECS Deployment**:
   - If deployed via the `ecs` Terraform module, access the application using the ALB DNS name (retrievable from the AWS Console or Terraform outputs). For example:
     ```bash
     curl http://<alb-dns-name>
     ```
   - Ensure the ALB is configured to route traffic to the ECS service on port `5000`.

4. **On a Remote Server**:
   - If running on a remote server, replace `localhost` with the server's IP address or domain name (e.g., `http://<server-ip>:5000`).
   - Ensure port `5000` is open in your server's firewall settings.

## Troubleshooting
- **Port Conflict**:
  - If port `5000` is already in use, map a different host port. For example:
    ```bash
    docker run -d -p 8080:5000 --name flask-app simple-time-service
    ```
    Then access the application at `http://localhost:8080`.

- **Container Not Running**:
  - Check the container status:
    ```bash
    docker ps -a
    ```
  - View logs for errors:
    ```bash
    docker logs flask-app
    ```

- **Docker Image Build Fails**:
  - Ensure `requirements.txt` exists and contains valid dependencies.
  - Verify that the `Dockerfile` and `app.py` are in the correct directory.

- **Cannot Access Application**:
  - Ensure the container is running (`docker ps`).
  - Check if port `5000` is open and not blocked by a firewall.
  - If using a cloud provider, configure security groups or firewall rules to allow traffic on port `5000`.
  - For ECS, verify the ALB, target group, and ECS service are correctly configured.

- **ECR Push Fails**:
  - Ensure the ECR repository exists and the AWS CLI is configured with the correct credentials.
  - Verify the login command uses the correct region and account ID.

- **Docker Hub Push Fails**:
  - Ensure you are logged in to Docker Hub (`docker login`).
  - Verify the image tag matches your Docker Hub username.

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and test thoroughly.
4. Submit a pull request with a clear description of your changes.

Please ensure your code follows PEP 8 style guidelines and includes appropriate comments.

## License
This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

---