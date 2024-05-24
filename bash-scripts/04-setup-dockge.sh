#!/bin/bash

# Get docker user and group information (ensuring they exist)
PUID=$(getent passwd docker | cut -d: -f3) || { echo "Docker user not found."; exit 1; }
PGID=$(getent group docker | cut -d: -f3) || { echo "Docker group not found."; exit 1; }

# Ensure script is running as the 'docker' user
if [ "$(id -u)" -ne "$PUID" ] || [ "$(id -g)" -ne "$PGID" ]; then
  echo "This script must be run as the 'docker' user."
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

# Stop existing Dockge containers
echo "Checking for existing Dockge containers..."
stop_containers_with_image_base "louislam/dockge"

# Data and Volumes Configuration
DOCKGE_VOLUME_PATH="/home/docker/volumes/dockge"

# Create the Dockge volume directory
echo "Creating Dockge volume directory..."
mkdir -p "$DOCKGE_VOLUME_PATH" || { echo "Failed to create Dockge volume directory."; exit 1; }

# Set permissions on the Dockge volume directory
chown -R "$PUID:$PGID" "$DOCKGE_VOLUME_PATH" 

# Run Dockge Container
echo "Running Dockge container..."
docker run -d -u "$PUID:$PGID" -p 5001:5001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/etc/timezone:/etc/timezone:ro" \
  -v "$STACKS_DIR:/opt/stacks/:rw" \
  -v "$DOCKGE_VOLUME_PATH:/app/data/:rw" \
  --name dockge \
  --restart="unless-stopped" \
  --cpus="0.2" \
  --memory="256m" \
  louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
