#!/bin/bash

# Source the utils.sh script to import the function
# Assuming utils.sh is in the same directory as this script
source bash-scripts/utils.sh || { echo "Failed to source utils.sh"; exit 1; } 

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

PUID=$(id -u docker)
GUID=$(id -g docker)

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
