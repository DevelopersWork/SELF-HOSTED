#!/bin/bash

# Check if docker.io package is installed
if ! dpkg -l | grep -q docker.io; then
  # Stop existing Portainer containers
  echo "Docker is not installed. Installing..."

  # Update package lists
  apt-get update || { echo "Failed to update package lists."; exit 1; }

  # Install Docker
  apt-get install -y docker.io || { echo "Failed to install Docker."; exit 1; }
else
  echo "Docker is already installed."
fi

# Get current user's UID and GID
PUID=$(id -u) # User ID for container processes to avoid permission issues
PGID=$(id -g) # Group ID for container processes to avoid permission issues

# Data and Volumes Configuration
DOCKER_VOLUME_DIR="/home/docker"

# Check if directory exists and has correct ownership
if [ ! -d "$DOCKER_VOLUME_DIR" ] || ! [ "$(stat -c %u "$DOCKER_VOLUME_DIR")" = "$PUID" ] || ! [ "$(stat -c %g "$DOCKER_VOLUME_DIR")" = "$PGID" ]; then
  echo "Creating/updating directory and permissions..."

  # Create directory if it doesn't exist
  mkdir -p "$DOCKER_VOLUME_DIR"

  # Set directory permissions 
  chown -R "$PUID:$PGID" "$DOCKER_VOLUME_DIR"
else
  echo "Directory exists and with required ownership."
fi

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

# Function to display a simple progress bar
function show_progress() {
    local message="$1"
    echo -ne "$message\r"  # Print message without newline
    for i in {1..10}; do
        sleep 0.1  # Simulate some work (adjust sleep time as needed)
        echo -ne "#\r"  # Update the progress bar
    done
    echo "Done" # Print final message with newline
}

# Stop existing Portainer containers
echo "Checking for existing Portainer containers..."
stop_containers_with_image_base "portainer/portainer-ce"

# Create Portainer Volume
show_progress "Creating Portainer volume..."
docker volume create "$PORTAINER_NAME" || { echo "Failed to create Portainer volume."; exit 1; }

# Run Portainer Container
show_progress "Running Portainer container..."
docker run -d -u "$PUID:$PGID" -p 29000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/etc/timezone:/etc/timezone:ro" \
  -v "$PORTAINER_NAME:/data" \
  --name "$PORTAINER_NAME" \
  --restart=always \
  --cpus="0.2" \
  --memory="256m" \
  portainer/portainer-ce:2.20.2 || { echo "Failed to start Portainer container."; exit 1; }


# Stop existing Dockge containers
echo "Checking for existing Dockge containers..."
stop_containers_with_image_base "louislam/dockge"

# Create Dockge Volume
show_progress "Creating Dockge volume..."
docker volume create "$DOCKGE_NAME" || { echo "Failed to create Dockge volume."; exit 1; }

# Run Dockge Container
show_progress "Running Dockge container..."
docker run -d -u "$PUID:$PGID" -p 25001:5001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "/etc/timezone:/etc/timezone:ro" \
  -v "$DOCKER_VOLUME_DIR/stacks:/opt/stacks/" \
  -v "$DOCKGE_NAME:/app/data" \
  --name "$DOCKGE_NAME" \
  --restart="unless-stopped" \
  --cpus="0.2" \
  --memory="256m" \
  louislam/dockge:1.4.2 || { echo "Failed to start Dockge container."; exit 1; }
