#!/bin/bash

# Ensure script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run with sudo."
  exit 1
fi

# Get the docker user's UID and GID after user creation
DOCKER_USER=$(getent passwd docker | cut -d: -f3) # User ID of the "docker" user
DOCKER_GROUP=$(getent group docker | cut -d: -f3) # Group ID of the "docker" group

echo "Docker User ID: $DOCKER_USER"
echo "Docker Group ID: $DOCKER_GROUP"

# Data and Volumes Configuration
DOCKER_VOLUME_DIR="/home/docker"

# Check if directory exists and has correct ownership
if [ ! -d "$DOCKER_VOLUME_DIR" ] || ! [ "$(stat -c %u "$DOCKER_VOLUME_DIR")" = "$DOCKER_USER" ] || ! [ "$(stat -c %g "$DOCKER_VOLUME_DIR")" = "$DOCKER_GROUP" ]; then
  echo "Creating/updating directory and permissions..."

  # Create directory if it doesn't exist
  mkdir -p "$DOCKER_VOLUME_DIR"

  # Set directory permissions 
  chown -R "$DOCKER_USER:$DOCKER_GROUP" "$DOCKER_VOLUME_DIR"
fi
