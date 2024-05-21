#!/bin/bash

# Get current user's UID and GID
PUID=$(id -u) # User ID for container processes to avoid permission issues
PGID=$(id -g) # Group ID for container processes to avoid permission issues

# Data and Volumes Configuration
DATA_DIR="/home/docker"
VOLUMES_DIR="$DATA_DIR/volumes"
STACKS_DIR="$DATA_DIR/stacks"
LIB_DIR="$DATA_DIR/lib"
PORTAINER_VOLUME_PATH="$VOLUMES_DIR/portainer"
DOCKGE_VOLUME_PATH="$VOLUMES_DIR/dockge"

# Create directories
mkdir -p "$VOLUMES_DIR" "$STACKS_DIR" "$LIB_DIR" "$PORTAINER_VOLUME_PATH" "$DOCKGE_VOLUME_PATH"

# Set directory permissions
chown -R "$PUID:$PGID" "$VOLUMES_DIR" "$STACKS_DIR" "$LIB_DIR"

apt-get update && apt-get install docker.io
# Configure Docker daemon to use the specified storage directory
# This ensures that Docker images and containers are stored in the desired location
echo "{ \"data-root\": \"$LIB_DIR\" }" > /etc/docker/daemon.json  
# Restart Docker service to apply the change
systemctl restart docker

# Get current timestamp
timestamp=$(date +%s)

# Define volume and container names with timestamps
PORTAINER_NAME="portainer-$timestamp"
DOCKGE_NAME="dockge-$timestamp"

# Function to stop containers with a specific image base (ignoring tag)
function stop_containers_with_image_base() {
  local image_base=$1
  container_ids=$(docker ps --no-trunc | grep "$image_base" | awk '{ print $1 }')

  if [ -n "$container_ids" ]; then
    echo "Stopping existing containers with image base: $image_base"
    docker stop $container_ids
  fi
}


# Stop existing Portainer containers
stop_containers_with_image_base "portainer/portainer-ce"

# Create Portainer Volume
docker volume create \
  --driver local \
  --opt type=none \
  --opt device="$PORTAINER_VOLUME_PATH" \
  --opt o=bind \
  "$PORTAINER_NAME" || { echo "Failed to create Portainer volume."; exit 1; }

# Run Portainer Container
docker run -d -u "$PUID:$PGID" -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PORTAINER_NAME:/data" \
  --name "$PORTAINER_NAME" \
  --restart=always \
  --cpus="0.2" \
  --memory="256m" \
  portainer/portainer-ce:2.20.2 || { echo "Failed to start Portainer container."; exit 1; }


# Stop existing Dockge containers
stop_containers_with_image_base "louislam/dockge"

# Create Dockge Volume
docker volume create \
  --driver local \
  --opt type=none \
  --opt device="$DOCKGE_VOLUME_PATH" \
  --opt o=bind \
  "$DOCKGE_NAME" || { echo "Failed to create Dockge volume."; exit 1; }

# Run Dockge Container
docker run -d -u "$PUID:$PGID" -p 5001:5001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$STACKS_DIR:/opt/stacks" \
  -v "$DOCKGE_NAME:/app/data" \
  --name "$DOCKGE_NAME" \
  --restart="unless-stopped" \
  --cpus="0.2" \
  --memory="256m" \
  louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
