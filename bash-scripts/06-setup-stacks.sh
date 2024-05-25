#!/bin/bash

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="$1"
[ -f "$ENV_FILE" ] || { echo "Usage: $0 <environment_file>"; exit 1; }

# Source the environment file to load variables
source "$ENV_FILE" || { echo "Failed to source environment file."; exit 1; }

# Ensure script is running as the 'docker' user
if [ -z "$DOCKER_PUID" ] || [ -z "$DOCKER_GUID" ]; then
    echo "ERROR: DOCKER_PUID or DOCKER_GUID is not set. Please check your environment variables."
    exit 1
elif [ "$(id -u)" -ne "$DOCKER_PUID" ] || [ "$(id -g)" -ne "$DOCKER_GUID" ]; then
    echo "This script must be run as the 'docker' user."
    exit 1
fi

# TODO