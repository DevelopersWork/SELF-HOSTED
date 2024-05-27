#!/bin/bash
# 03-storage-setup.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Ensure script is running as root user (or with sudo)
check_user 0

# Get the docker user's UID and GID
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(getent group "$DOCKER_GROUP" | cut -d: -f3)

create_dir_if_not_exists "$DOCKER_PATH" "$DOCKER_PUID" "$DOCKER_GUID"
create_dir_if_not_exists "$DOCKER_CONTAINER_PATH" "$DOCKER_PUID" "$DOCKER_GUID"
create_dir_if_not_exists "$DOCKER_STACKS_PATH" "$DOCKER_PUID" "$DOCKER_GUID"
create_dir_if_not_exists "$DOCKER_STORAGE_PATH" "$DOCKER_PUID" "$DOCKER_GUID"
