#!/bin/bash

# Configure SSH key if provided
if [ ! -z "$PUBLIC_KEY" ]; then
    echo "$PUBLIC_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

# Start SSH server
service ssh start

# Start Gradio interface with output redirection
cd /workspace
echo "Starting Gradio interface..."
exec uv run gradio_interface.py 2>&1 | tee /dev/stdout
