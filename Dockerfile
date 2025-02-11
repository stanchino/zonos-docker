FROM ubuntu:24.04

# Install system dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gcc \
    python3 \
    python3-dev \
    python3-venv \
    espeak-ng \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Install CUDA toolkit (assuming the host has NVIDIA drivers)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nvidia-cuda-toolkit \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir /var/run/sshd && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Set up working directory
WORKDIR /workspace

# Copy Zonos code
COPY Zonos /workspace

# Set up Python environment
ENV VIRTUAL_ENV=/workspace/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install uv and project dependencies
RUN . "$VIRTUAL_ENV/bin/activate" && \
    pip install -U uv && \
    uv sync && \
    uv sync --extra compile

# Copy and set up startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports
EXPOSE 22 7860

# Set the startup command
CMD ["/start.sh"]