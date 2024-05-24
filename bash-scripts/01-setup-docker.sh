#!/bin/bash

# Ensure script is running as root (or with sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run with sudo."
  exit 1
fi

# Check if the docker command is available
if ! command -v docker &> /dev/null; then
  echo "Docker is not available. Do you want to install it? (y/n)"
  read -r answer

  if [[ $answer = [Yy] ]]; then
    echo "Installing Docker..."
    sudo apt-get update || { echo "Failed to update package lists."; exit 1; }
    sudo apt-get install -y docker.io || { echo "Failed to install Docker."; exit 1; }
    echo "Docker installation complete."
  else
    echo "Exiting script without installing Docker."
    exit 1  
  fi
fi

# Check if docker group exists
if ! getent group docker &> /dev/null; then
  echo "Docker group does not exist. Do you want to create it? (y/n)"
  read -r answer

  if [[ $answer = [Yy] ]]; then
    sudo groupadd docker || { echo "Failed to create docker group."; exit 1; }
    echo "Docker group created."
  else
    echo "Exiting script without creating docker group."
    exit 1  
  fi
fi

# Check if docker user exists
if ! getent passwd docker &> /dev/null; then
  echo "Docker user does not exist. Do you want to create it? (y/n)"
  read -r answer

  if [[ $answer = [Yy] ]]; then
    sudo useradd -M -d /nonexistent -s /usr/sbin/nologin -r -g docker docker || { echo "Failed to create docker user."; exit 1; }
    echo "Docker user created."
  else
    echo "Exiting script without creating docker user."
    exit 1  
  fi
fi
