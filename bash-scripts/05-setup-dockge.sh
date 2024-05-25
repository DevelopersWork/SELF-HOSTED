#!/bin/bash

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="$1"
[ -f "$ENV_FILE" ] || { echo "Usage: $0 <environment_file>"; exit 1; }

# Source the environment file to load variables
source "$ENV_FILE" || { echo "Failed to source environment file."; exit 1; }

# Get the docker user's UID and GID
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(id -g "$DOCKER_USER")

# Ensure script is running as the 'docker' user
if [ -z "$DOCKER_PUID" ] || [ -z "$DOCKER_GUID" ]; then
    echo "ERROR: DOCKER_PUID or DOCKER_GUID is not set. Please check your environment variables."
    exit 1
elif [ "$(id -u)" -ne "$DOCKER_PUID" ] || [ "$(id -g)" -ne "$DOCKER_GUID" ]; then
    echo "This script must be run as the 'docker' user."
    exit 1
fi

# Function to remove containers with a specific image base (ignoring tag)
remove_containers_with_image_base() {
    local image_base=$1
    local container_ids=$(docker container ls -a | grep "$image_base" | awk '{ print $1 }') # Filter by ancestor

    if [ -n "$container_ids" ]; then
        echo "Removing existing containers with image base: $image_base"
        docker container rm -f $container_ids # Force removal
    fi
}

# Data and Volumes Configuration
DOCKGE_VOLUME_PATH="$DOCKER_CONTAINER_PATH/dockge"

# Create the Dockge volume directory
echo "Creating Dockge volume directory at $DOCKGE_VOLUME_PATH..."
mkdir -p "$DOCKGE_VOLUME_PATH" || { echo "Failed to create Dockge volume directory."; exit 1; }

# Set permissions on the Dockge volume directory
chown -R "$DOCKER_PUID:$DOCKER_GUID" "$DOCKGE_VOLUME_PATH" 

# Remove existing Dockge containers (using the improved function)
remove_containers_with_image_base "louislam/dockge"

# Run Dockge Container (with explicit image tag)
echo "Running Dockge container (version 1.4.2)..."
docker run -d \
    -u "$DOCKER_PUID:$DOCKER_GUID" \
    -p 5001:5001 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$DOCKER_STACKS_PATH:/opt/stacks/:rw" \
    -v "$DOCKGE_VOLUME_PATH:/app/data/:rw" \
    --name dockge \
    --restart="unless-stopped" \
    --cpus="0.2" \
    --memory="256m" \
    louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
