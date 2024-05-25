#!/bin/bash

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="$1"
[ -f "$ENV_FILE" ] || { echo "Usage: $0 <environment_file>"; exit 1; }

# Source the environment file to load variables
source "$ENV_FILE" || { echo "Failed to source environment file."; exit 1; }

# Ensure script is running as the 'docker' user
if [ "$(id -u)" -ne "$DOCKER_UID" ] || [ "$(id -g)" -ne "$DOCKER_GID" ]; then
    echo "This script must be run as the 'docker' user."
    exit 1
fi

# Function to remove containers with a specific image base (ignoring tag)
remove_containers_with_image_base() {
    local image_base=$1
    local container_ids=$(docker container ls -a | grep "$image_base" | awk '{ print $1 }') 

    if [ -n "$container_ids" ]; then
        echo "Removing existing containers with image base: $image_base"
        docker container rm -f $container_ids # Force removal
    fi
}

# Data and Volumes Configuration
PORTAINER_VOLUME_PATH="$DOCKER_CONTAINER_PATH/portainer"

# Create the Portainer volume directory
echo "Creating Portainer volume directory at $PORTAINER_VOLUME_PATH..."
mkdir -p "$PORTAINER_VOLUME_PATH" || { echo "Failed to create Portainer volume directory."; exit 1; }

# Set permissions on the Portainer volume directory
chown -R "$DOCKER_UID:$DOCKER_GID" "$PORTAINER_VOLUME_PATH" 

# Remove existing Portainer containers (using the improved function)
remove_containers_with_image_base "portainer/portainer-ce"

# Run Portainer Container (with explicit image tag)
echo "Running Portainer container (version 2.20.3)..."
docker run -d \
    -u "$DOCKER_UID:$DOCKER_GID" \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PORTAINER_VOLUME_PATH:/data" \
    --name portainer \
    --restart="unless-stopped" \
    --cpus="0.2" \
    --memory="256m" \
    portainer/portainer-ce:2.20.3 || { echo "Failed to start Portainer container."; exit 1; }
