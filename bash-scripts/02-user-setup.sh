#!/bin/bash

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Ensure script is running as root user (or with sudo)
check_user 0

# Check if docker group exists and create if needed
if ! getent group "$DOCKER_GROUP" &> /dev/null; then
    echo "Creating Docker group..."
    groupadd "$DOCKER_GROUP" || { echo "Failed to create docker group."; exit 1; }
fi

# Check if docker user exists and create if needed
if ! getent passwd "$DOCKER_USER" &> /dev/null; then
    echo "Creating Docker user..."
    useradd -M -d "$DOCKER_PATH" -s /usr/sbin/nologin -r -g "$DOCKER_GROUP" "$DOCKER_USER" || {
        echo "Failed to create docker user."; exit 1; 
    }
fi

# Ensure the docker user is in the docker group
if ! id -nG "$DOCKER_USER" | grep -qw "$DOCKER_GROUP"; then
    echo "Adding $DOCKER_USER to $DOCKER_GROUP..."
    usermod -aG "$DOCKER_GROUP" "$DOCKER_USER" || { echo "Failed to add user to group."; exit 1; }
fi

echo "Docker User ID: $DOCKER_PUID"
echo "Docker Group ID: $DOCKER_GUID"
