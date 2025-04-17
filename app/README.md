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
  - [Step 4: Run the Docker Container](#step-4-run-the-docker-container)
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
git clone <repository-url>
cd <repository-directory>
```
Alternatively, download the project files manually and navigate to the project directory in your terminal.

### Step 2: Create requirements.txt
Create a file named `requirements.txt` in the project directory with the following content:
```
Flask==2.0.1
```
This specifies the Flask dependency required for the application.

### Step 3: Build the Docker Image
Build the Docker image using the provided `Dockerfile`. Run the following command in the project directory:
```bash
docker build -t flask-visitor-info .
```
- `-t flask-visitor-info`: Names the image `flask-visitor-info`.
- `.`: Specifies the current directory as the build context.

This command pulls the `python:3.9-slim` base image, installs the dependencies from `requirements.txt`, and copies the application code into the image.

### Step 4: Run the Docker Container
Run the Docker container from the built image:
```bash
docker run -d -p 5000:5000 --name flask-app flask-visitor-info
```
- `-d`: Runs the container in detached mode (in the background).
- `-p 5000:5000`: Maps port `5000` on the host to port `5000` in the container.
- `--name flask-app`: Names the container `flask-app`.
- `flask-visitor-info`: Specifies the image to use.

The application is now running and accessible.

## Accessing the Application
Once the container is running, you can access the application in the following ways:

1. **Web Browser**:
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

3. **On a Remote Server**:
   - If deploying on a remote server, replace `localhost` with the server's IP address or domain name (e.g., `http://<server-ip>:5000`).
   - Ensure port `5000` is open in your server's firewall settings.

## Troubleshooting
- **Port Conflict**:
  - If port `5000` is already in use, you can map a different host port. For example:
    ```bash
    docker run -d -p 8080:5000 --name flask-app flask-visitor-info
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

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and test thoroughly.
4. Submit a pull request with a clear description of your changes.

Please ensure your code follows PEP 8 style guidelines and includes appropriate comments.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

This README provides a clear and comprehensive guide to understanding, deploying, and accessing the Flask Visitor Info Application. If you have any questions or need further assistance, feel free to open an issue in the repository.