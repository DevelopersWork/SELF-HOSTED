#!/bin/bash

# Ensure script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi

# Constants
PACKAGE_MANAGER="sudo apt-get"  # You can make this configurable if needed

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install a package
install_package() {
    echo "Installing $1..."
    $PACKAGE_MANAGER update || { echo "Failed to update package lists."; exit 1; }
    $PACKAGE_MANAGER install -y "$1" || { echo "Failed to install $1."; exit 1; }
    echo "$1 installation complete."
}

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker is not installed. Do you want to install it? (y/n)"
    read -r answer

    if [[ $answer = [Yy] ]]; then
        install_package "docker.io"
    else
        echo "Exiting script without installing Docker."
        exit 1
    fi
fi
