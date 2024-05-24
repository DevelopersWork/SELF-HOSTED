#!/bin/bash

# Get docker user and group information (ensuring they exist)
PUID=$(getent passwd docker | cut -d: -f3) || { echo "Docker user not found."; exit 1; }
PGID=$(getent group docker | cut -d: -f3) || { echo "Docker group not found."; exit 1; }

# Ensure script is running as docker, exit if not 
if [ "$(id -g)" -ne "$PGID" ]; then
  echo "This script must be run as the 'docker' group."
  exit 1
fi

# Function to stop containers with a specific image base (ignoring tag)
function stop_containers_with_image_base() {
  local image_base=$1
  container_ids=$(docker ps --no-trunc | grep "$image_base" | awk '{ print $1 }')

  if [ -n "$container_ids" ]; then
    echo "Stopping existing containers with image base: $image_base"
    docker stop $container_ids
  fi
} 

# Data and Volumes Configuration
DOCKER_DIR="/home/docker"

# Get current timestamp
timestamp=$(date +%s)

# Define volume with timestamps
DOCKGE_VOLUME="dockge-$timestamp"

# Stop existing Dockge containers
echo "Checking for existing Dockge containers..."
stop_containers_with_image_base "louislam/dockge"

# Run Dockge Container
echo "Running Dockge container..."
docker run -d -u "$PUID:$PGID" -p 5001:5001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/etc/timezone:/etc/timezone:ro" \
  -v "$DOCKER_DIR/stacks:/opt/stacks/:rw" \
  -v "$DOCKER_DIR/volumes/dockge:/app/data/:rw" \
  --name "dockge" \
  --restart="unless-stopped" \
  --cpus="0.2" \
  --memory="256m" \
  louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
