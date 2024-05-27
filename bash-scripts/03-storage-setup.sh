#!/bin/bash
# bash-scripts/03-storage-setup.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Ensure script is running as root user (or with sudo)
check_user 0

create_dir_if_not_exists "$DOCKER_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$DOCKER_CONTAINER_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$DOCKER_STACKS_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$DOCKER_STORAGE_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
