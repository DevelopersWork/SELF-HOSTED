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
    echo "ERROR: DOCKER_USER is not set. Please check your environment variables."
    exit 1
elif [ "$(id -u)" -ne "$DOCKER_PUID" ] || [ "$(id -g)" -ne "$DOCKER_GUID" ]; then
    echo "This script must be run as the '$DOCKER_USER' user."
    exit 1
fi

# TODO