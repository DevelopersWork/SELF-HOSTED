#!/bin/bash

DOCKER_USER="docker"
DOCKER_GROUP="docker"

SCRIPTS_DIR="$(dirname "$(realpath "$0")")/bash-scripts"  # Get the absolute path of the script's directory
DOCKER_DIR="/home/docker"
DOCKER_CONTAINER_DIR="$DOCKER_DIR/containers"
DOCKER_STACKS_DIR="$DOCKER_DIR/stacks"
DOCKER_STORAGE_DIR="$DOCKER_DIR/storage"

# Create a temporary env file
ENV_FILE=$(mktemp)
echo "DOCKER_USER=$DOCKER_USER" >> "$ENV_FILE"
echo "DOCKER_GROUP=$DOCKER_GROUP" >> "$ENV_FILE"
echo "DOCKER_DIR=$DOCKER_DIR" >> "$ENV_FILE"
echo "DOCKER_CONTAINER_DIR=$DOCKER_CONTAINER_DIR" >> "$ENV_FILE"
echo "DOCKER_STACKS_DIR=$DOCKER_STACKS_DIR" >> "$ENV_FILE"
echo "DOCKER_STORAGE_DIR=$DOCKER_STORAGE_DIR" >> "$ENV_FILE"

# Check if the scripts exist
for script in "01-dependencies.sh" "02-user-setup.sh" "03-storage-setup.sh" "04-setup-portainer.sh" "05-setup-dockge.sh"; do
  if [ ! -f "$SCRIPTS_DIR/$script" ]; then
    echo "Error: Script $script not found in $SCRIPTS_DIR"
    exit 1
  fi
done

# Run scripts 01 as sudo (or root)
sudo /bin/bash "$SCRIPTS_DIR/01-dependencies.sh" "$ENV_FILE" || { echo "Error running 01-dependencies.sh"; exit 1; }
echo "Script 01-dependencies.sh completed successfully."

# Run scripts 02 as sudo (or root)
sudo /bin/bash "$SCRIPTS_DIR/02-user-setup.sh" "$ENV_FILE" || { echo "Error running 02-user-setup.sh"; exit 1; }
echo "Script 02-user-setup.sh completed successfully."

# Get the docker user's UID and GID after user creation
DOCKER_UID=$(getent passwd $DOCKER_USER | cut -d: -f3) # User ID of the "docker" user
DOCKER_GID=$(getent group $DOCKER_GROUP | cut -d: -f3) # Group ID of the "docker" group

echo "DOCKER_UID=$DOCKER_UID" >> "$ENV_FILE"
echo "DOCKER_GID=$DOCKER_GID" >> "$ENV_FILE"

echo "Docker User ID: $DOCKER_USER"
echo "Docker Group ID: $DOCKER_GROUP"

# Run scripts 03, 04 and 05 as non-root
sudo -u docker /bin/bash "$SCRIPTS_DIR/02-user-setup.sh" "$ENV_FILE" || { echo "Error running 02-user-setup.sh"; exit 1; }
echo "Script 02-user-setup.sh completed successfully."

sudo -u docker /bin/bash "$SCRIPTS_DIR/03-setup-portainer.sh" "$ENV_FILE" || { echo "Error running 03-setup-portainer.sh"; exit 1; }
echo "Script 03-setup-portainer.sh completed successfully."

sudo -u docker /bin/bash "$SCRIPTS_DIR/04-setup-dockge.sh" "$ENV_FILE" || { echo "Error running 04-setup-dockge.sh"; exit 1; }
echo "Script 04-setup-dockge.sh completed successfully."

# Remove the temporary file
rm "$ENV_FILE"
