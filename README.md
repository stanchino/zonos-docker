# zonos-docker

[![Docker Build](https://github.com/stanchino/zonos-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/stanchino/zonos-docker/actions/workflows/docker-build.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/stanchino/zonos.svg)](https://hub.docker.com/r/stanchino/zonos)
[![Docker Stars](https://img.shields.io/docker/stars/stanchino/zonos.svg)](https://hub.docker.com/r/stanchino/zonos)

A Docker container for deploying the [Zonos-v0.1](https://github.com/Zyphra/Zonos) open-weight text-to-speech model. This container provides a ready-to-use environment with CUDA support, Python dependencies managed by `uv`, and a secure SSH server for remote access.

## Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [RunPod Deployment](#runpod-deployment)
  - [Setting up on RunPod](#setting-up-on-runpod)
  - [Accessing Your RunPod Deployment](#accessing-your-runpod-deployment)
  - [Monitoring](#monitoring)
  - [Cost Optimization](#cost-optimization)
- [Building from Source](#building-from-source)
- [Docker Hub](#docker-hub)
- [SSH Access](#ssh-access)
- [Environment Variables](#environment-variables)
- [Security Notes](#security-notes)
- [Continuous Integration](#continuous-integration)
- [License](#license)
- [Contributing](#contributing)

## Features

- CUDA-enabled environment for GPU acceleration
- Python environment managed by `uv` package manager
- Secure SSH access with public key authentication
- Gradio web interface exposed on port 7860
- Built-in development environment with gcc compiler
- Automated weekly builds with GitHub Actions

## Prerequisites

- Docker installed on your system
- NVIDIA GPU with compatible drivers
- NVIDIA Container Toolkit installed

## Quick Start

Pull the image from Docker Hub:
```bash
docker pull stanchino/zonos:latest
```

Run the container:
```bash
docker run -it --gpus=all \
  -p 22:22 -p 7860:7860 \
  -e PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" \
  stanchino/zonos:latest
```

This will:
1. Start the Gradio interface accessible at `http://localhost:7860`
2. Enable SSH access on port 22 using your public key

## RunPod Deployment

This Docker image is compatible with RunPod and can be easily deployed on their GPU cloud platform.

### Setting up on RunPod

1. Log in to [RunPod](https://www.runpod.io/)

2. Create a new pod with the following settings:
   - Container Image: `stanchino/zonos:latest`
   - Select a GPU type based on your needs (minimum 6GB VRAM)
   - Container Disk: At least 20GB recommended
   - Expose HTTP Ports: `7860` (for Gradio interface)
   - Volume Size: 10GB+ recommended

3. Add your SSH public key:
   - In the "Environment Variables" section, add:
     ```
     PUBLIC_KEY=your-ssh-public-key-here
     ```
   - Replace `your-ssh-public-key-here` with the contents of your `~/.ssh/id_rsa.pub`

4. Start the pod

### Accessing Your RunPod Deployment

1. **Gradio Interface**
   - Access via the "Connect" button in RunPod UI
   - Or use the direct URL: `https://[pod-id]-7860.proxy.runpod.net`

2. **SSH Access**
   - Get your pod's IP and SSH port from RunPod dashboard
   - Connect using:
     ```bash
     ssh -i ~/.ssh/id_rsa root@[pod-ip] -p [ssh-port]
     ```

### Monitoring

- View container logs directly in RunPod dashboard
- All Gradio interface output is redirected to container logs
- SSH server status and connection attempts are also logged

### Cost Optimization

- Use Spot instances for non-critical workloads
- Stop the pod when not in use
- Consider using RunPod's serverless API for production deployments

## Building from Source

1. Clone this repository:
```bash
git clone https://github.com/stanchino/zonos-docker.git
cd zonos-docker
```

2. Build the Docker image:
```bash
docker build -t zonos .
```

3. Run the container:
```bash
docker run -it --gpus=all \
  -p 22:22 -p 7860:7860 \
  -e PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" \
  zonos
```

## Docker Hub

This image is available on Docker Hub at [stanchino/zonos](https://hub.docker.com/r/stanchino/zonos). The repository is linked to this GitHub repository for automated builds.

Build tags:
- `latest`: Latest build from the main branch
- `YYYYMMDD`: Weekly builds tagged with date
- `YYYYMMDD-[sha]`: Builds triggered by commits

## SSH Access

The container runs an SSH server for remote access. Authentication is handled via public key only (password authentication is disabled for security).

To connect:
```bash
ssh -i ~/.ssh/id_rsa root@localhost
```

## Environment Variables

- `PUBLIC_KEY`: Your SSH public key for authentication (required for SSH access)

## Security Notes

- Only public key authentication is allowed (password authentication is disabled)
- The SSH server is configured with secure defaults
- Root login is restricted to public key authentication only

## Continuous Integration

The Docker image is automatically built and pushed to Docker Hub:
- Daily builds everyday at midnight UTC
- On every push to main that changes Dockerfile or start.sh
- Images are tagged with:
  - `latest` for the most recent build from main
  - Date-based tags (YYYYMMDD) for weekly builds
  - Commit SHA with date prefix for push-triggered builds

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
