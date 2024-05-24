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

# Function to create and set permissions on a directory
create_docker_dir() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
    fi
    # Change ownership only if necessary
    if ! [ "$(stat -c %u "$dir_path")" = "$DOCKER_UID" ] || ! [ "$(stat -c %g "$dir_path")" = "$DOCKER_GID" ]; then
        chown "$DOCKER_UID:$DOCKER_GID" "$dir_path" || { 
            echo "Failed to set ownership for $dir_path"; exit 1; 
        }
    fi
}

# Create Docker directories
create_docker_dir "$DOCKER_CONTAINER_DIR"
create_docker_dir "$DOCKER_STACKS_DIR"
create_docker_dir "$DOCKER_STORAGE_DIR"
