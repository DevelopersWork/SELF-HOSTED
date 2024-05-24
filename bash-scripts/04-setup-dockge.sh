#!/bin/bash

# Get docker user and group information (ensuring they exist)
PUID=$(getent passwd docker | cut -d: -f3) || { echo "Docker user not found."; exit 1; }
PGID=$(getent group docker | cut -d: -f3) || { echo "Docker group not found."; exit 1; }

# Ensure script is running as docker, exit if not 
if [ "$(id -u)" -ne "$PUID" ] || [ "$(id -g)" -ne "$PGID" ]; then
  echo "This script must be run as the 'docker' user."
  exit 1
fi

# Source the utils.sh script to import the function
# Assuming utils.sh is in the bash-scripts directory relative to this script
source ./bash-scripts/utils.sh || { echo "Failed to source utils.sh"; exit 1; } 

# Data and Volumes Configuration
DOCKER_VOLUME_DIR="/home/docker"

# Get current timestamp
timestamp=$(date +%s)

# Define volume and container names with timestamps
DOCKGE_NAME="dockge-$timestamp"

# Stop existing Dockge containers
echo "Checking for existing Dockge containers..."
stop_containers_with_image_base "louislam/dockge"

# Create Dockge Volume
echo "Creating Dockge volume..."
docker volume create "$DOCKGE_NAME" || { echo "Failed to create Dockge volume."; exit 1; }

# Run Dockge Container
echo "Running Dockge container..."
docker run -d -u "$PUID:$PGID" -p 5001:5001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/etc/timezone:/etc/timezone:ro" \
  -v "$DOCKER_VOLUME_DIR/stacks:/opt/stacks/" \
  -v "$DOCKGE_NAME:/app/data" \
  --name "$DOCKGE_NAME" \
  --restart="unless-stopped" \
  --cpus="0.2" \
  --memory="256m" \
  louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
