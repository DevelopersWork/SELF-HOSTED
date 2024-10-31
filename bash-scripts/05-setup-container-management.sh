#!/bin/bash
# bash-scripts/04-setup-container-management.sh

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

# Drop existing containers
remove_containers_with_image_base "portainer/portainer-ce"
remove_containers_with_image_base "louislam/dockge"

# Run Containers
docker compose -f "$DOCKER_STACKS_PATH/container-management/docker-compose.yml" up -d || { echo "Failed to start container."; exit 1; }
