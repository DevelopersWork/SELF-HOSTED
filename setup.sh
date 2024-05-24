#!/bin/bash

# Constants (for clarity and maintainability)
DOCKER_USER="docker"
DOCKER_GROUP="docker"
SCRIPTS_DIR="$(dirname "$(realpath "$0")")/bash-scripts"
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

# Array of scripts to run
scripts=("01-dependencies.sh" "02-user-setup.sh" "03-storage-setup.sh" "04-setup-portainer.sh" "05-setup-dockge.sh")

# Check if scripts exist
for script in "${scripts[@]}"; do
    [ -f "$SCRIPTS_DIR/$script" ] || { echo "Error: Script $script not found in $SCRIPTS_DIR"; exit 1; }
done

# Run scripts 01 and 02 as root
for script in "${scripts[@]:0:2}"; do  # Run the first two scripts as root
    sudo /bin/bash "$SCRIPTS_DIR/$script" "$ENV_FILE" || { echo "Error running $script"; exit 1; }
    echo "Script $script completed successfully."
done

# Get the docker user's UID and GID after user creation
DOCKER_UID=$(id -u "$DOCKER_USER")
DOCKER_GID=$(id -g "$DOCKER_USER")
echo "DOCKER_UID=$DOCKER_UID" >> "$ENV_FILE"
echo "DOCKER_GID=$DOCKER_GID" >> "$ENV_FILE"
echo "Docker User ID: $DOCKER_UID"
echo "Docker Group ID: $DOCKER_GID"

# Get current user's group name
CURRENT_USER_GROUP=$(id -gn)
# Add docker user to the current user's group temporarily
sudo usermod -aG "$CURRENT_USER_GROUP" "$DOCKER_USER" || {
  echo "Failed to temporarily add docker user to current user's group." 
  exit 1
}
# Ensure docker user has read access to the env file
chown "$DOCKER_USER" "$ENV_FILE" || { 
    echo "Failed to grant access to environment file for docker user."
    exit 1
}

# Run scripts 03, 04, and 05 as the 'docker' user
for script in "${scripts[@]:2}"; do  # Run the remaining scripts as docker user
    sudo -u "$DOCKER_USER" /bin/bash "$SCRIPTS_DIR/$script" "$ENV_FILE" || { echo "Error running $script"; exit 1; }
    echo "Script $script completed successfully."
done

# Remove the 'docker' user from the current user's group
sudo gpasswd -d "$DOCKER_USER" "$CURRENT_USER_GROUP"

# Remove the temporary file
rm "$ENV_FILE"
