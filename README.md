# zonos-docker

[![Docker Build](https://github.com/stanchino/zonos-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/stanchino/zonos-docker/actions/workflows/docker-build.yml)

A Docker container for deploying the [Zonos-v0.1](https://github.com/Zyphra/Zonos) open-weight text-to-speech model. This container provides a ready-to-use environment with CUDA support, Python dependencies managed by `uv`, and a secure SSH server for remote access.

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
- Weekly builds every Sunday at midnight UTC
- On every push to main that changes Dockerfile or start.sh
- Images are tagged with:
  - `latest` for the most recent build from main
  - Date-based tags (YYYYMMDD) for weekly builds
  - Commit SHA with date prefix for push-triggered builds

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
