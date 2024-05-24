#!/bin/bash

SCRIPTS_DIR="$(dirname "$(realpath "$0")")/bash-scripts"  # Get the absolute path of the script's directory
DOCKER_DIR="/home/docker"
DOCKER_CONTAINER_DIR="$DOCKER_DIR/containers"
DOCKER_STACKS_DIR="$DOCKER_DIR/stacks"
DOCKER_STORAGE_DIR="$DOCKER_DIR/storage"

# Check if the scripts exist
for script in "01-setup-docker.sh" "02-configure-docker.sh" "03-setup-portainer.sh" "04-setup-dockge.sh"; do
  if [ ! -f "$SCRIPTS_DIR/$script" ]; then
    echo "Error: Script $script not found in $SCRIPTS_DIR"
    exit 1
  fi
done

# Run scripts 01 as sudo (or root)
sudo /bin/bash -c "$SCRIPTS_DIR/01-setup-docker.sh" || { echo "Error running 01-setup-docker.sh"; exit 1; }
echo "Script 01-setup-docker.sh completed successfully."

# Get the docker user's UID and GID after user creation
DOCKER_USER=$(getent passwd docker | cut -d: -f3) # User ID of the "docker" user
DOCKER_GROUP=$(getent group docker | cut -d: -f3) # Group ID of the "docker" group

echo "Docker User ID: $DOCKER_USER"
echo "Docker Group ID: $DOCKER_GROUP"

# Run scripts 02, 03 and 04 as non-root
sudo -u docker /bin/bash -c "$SCRIPTS_DIR/02-configure-docker.sh" || { echo "Error running 02-configure-docker.sh"; exit 1; }
echo "Script 02-configure-docker.sh completed successfully."

sudo -u docker /bin/bash -c "$SCRIPTS_DIR/03-setup-portainer.sh" || { echo "Error running 03-setup-portainer.sh"; exit 1; }
echo "Script 03-setup-portainer.sh completed successfully."

sudo -u docker /bin/bash -c "$SCRIPTS_DIR/04-setup-dockge.sh" || { echo "Error running 04-setup-dockge.sh"; exit 1; }
echo "Script 04-setup-dockge.sh completed successfully."
