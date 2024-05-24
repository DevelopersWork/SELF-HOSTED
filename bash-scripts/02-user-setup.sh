#!/bin/bash

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="$1"
[ -f "$ENV_FILE" ] || { echo "Usage: $0 <environment_file>"; exit 1; }

# Source the environment file to load variables
source "$ENV_FILE" || { echo "Failed to source environment file."; exit 1; }

# Ensure script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run with sudo."
  exit 1
fi

# Check if docker group exists and create if needed
if ! getent group "$DOCKER_GROUP" &> /dev/null; then
    echo "Creating Docker group..."
    groupadd "$DOCKER_GROUP" || { echo "Failed to create docker group."; exit 1; }
fi

# Check if docker user exists and create if needed
if ! getent passwd "$DOCKER_USER" &> /dev/null; then
    echo "Creating Docker user..."
    useradd -M -d "$DOCKER_DIR" -s /usr/sbin/nologin -r -g "$DOCKER_GROUP" "$DOCKER_USER" || {
        echo "Failed to create docker user."; exit 1; 
    }

    # Create the base Docker directory and set permissions
    mkdir -p "$DOCKER_DIR"
    chown "$DOCKER_USER":"$DOCKER_GROUP" "$DOCKER_DIR"
fi

# Ensure the docker user is in the docker group
if ! id -nG "$DOCKER_USER" | grep -qw "$DOCKER_GROUP"; then
    echo "Adding $DOCKER_USER to $CURRENT_USER_GROUP..."
    usermod -aG "$CURRENT_USER_GROUP" "$DOCKER_USER"
    echo "Adding $DOCKER_USER to $DOCKER_GROUP..."
    usermod -aG "$DOCKER_GROUP" "$DOCKER_USER" || { echo "Failed to add user to group."; exit 1; }
fi
