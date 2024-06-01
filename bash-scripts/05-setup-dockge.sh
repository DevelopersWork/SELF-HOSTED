#!/bin/bash
# bash-scripts/05-setup-dockge.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Get the docker user's UID and GID
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(getent group "$DOCKER_GROUP" | cut -d: -f3)

# Ensure script is running as docker user
check_user $DOCKER_PUID
# Ensure script is running as docker group
check_group $DOCKER_GUID

# Data and Volumes Configuration
DOCKGE_VOLUME_PATH="$DOCKER_CONTAINER_PATH/dockge"

# Create the Dockge volume directory
# Set permissions on the Dockge volume directory
echo "Creating Portainer volume directory at $DOCKGE_VOLUME_PATH..."
create_dir_if_not_exists "$DOCKGE_VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

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
    --restart unless-stopped \
    --cpus="0.3" \
    --memory="256m" \
    louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
