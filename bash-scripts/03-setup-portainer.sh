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

# Get current timestamp
timestamp=$(date +%s)

# Define volume name with timestamps
PORTAINER_VOLUME="portainer-$timestamp"

# Stop existing Portainer containers
echo "Checking for existing Portainer containers..."
stop_containers_with_image_base "portainer/portainer-ce"

# Create Portainer Volume
echo "Creating Portainer volume..."
docker volume create "$PORTAINER_VOLUME" || { echo "Failed to create Portainer volume."; exit 1; }

# Run Portainer Container
echo "Running Portainer container..."
docker run -d -u "$PUID:$PGID" -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/etc/timezone:/etc/timezone:ro" \
  -v "$PORTAINER_VOLUME:/data" \
  --name "portainer" \
  --restart=always \
  --cpus="0.2" \
  --memory="256m" \
  portainer/portainer-ce:2.20.2 || { echo "Failed to start Portainer container."; exit 1; }
