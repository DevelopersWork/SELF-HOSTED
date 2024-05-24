#!/bin/bash

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="$1"
[ -f "$ENV_FILE" ] || { echo "Usage: $0 <environment_file>"; exit 1; }

# Source the environment file to load variables
source "$ENV_FILE" || { echo "Failed to source environment file."; exit 1; }

# Ensure script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run with sudo."
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
create_docker_dir "$DOCKER_TEMP_DIR"
