#!/bin/bash
# bash-scripts/01-dependencies.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Ensure script is running as root user (or with sudo)
check_user 0

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker is not installed. Do you want to install it? (y/n)"
    read -r answer

    if [[ $answer = [Yy] ]]; then
        install_package "$PACKAGE_MANAGER" "docker.io"
    else
        echo "Exiting script without installing Docker."
        exit 1
    fi
fi
