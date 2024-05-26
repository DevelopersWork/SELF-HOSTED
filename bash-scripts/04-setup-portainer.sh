#!/bin/bash

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Get the docker user's UID and GID
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(id -g "$DOCKER_USER")

# Ensure script is running as docker user
check_user $DOCKER_PUID
# Ensure script is running as docker group
check_user $DOCKER_GUID

# Data and Volumes Configuration
PORTAINER_VOLUME_PATH="$DOCKER_CONTAINER_PATH/portainer"

# Create the Portainer volume directory
# Set permissions on the Portainer volume directory
echo "Creating Portainer volume directory at $PORTAINER_VOLUME_PATH..."
create_dir_if_not_exists "$PORTAINER_VOLUME_PATH"

# Remove existing Portainer containers (using the improved function)
remove_containers_with_image_base "portainer/portainer-ce"

# Run Portainer Container (with explicit image tag)
echo "Running Portainer container (version 2.20.3)..."
docker run -d \
    -u "$DOCKER_PUID:$DOCKER_GUID" \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PORTAINER_VOLUME_PATH:/data" \
    --name portainer \
    --restart="unless-stopped" \
    --cpus="0.2" \
    --memory="256m" \
    portainer/portainer-ce:2.20.3 || { echo "Failed to start Portainer container."; exit 1; }
