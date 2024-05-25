#!/bin/bash

# Constants (for clarity and maintainability)
DOCKER_USER="docker"
DOCKER_GROUP="docker"
SCRIPTS_DIR="bash-scripts"
SCRIPTS_PATH="$(dirname "$(realpath "$0")")/bash-scripts"
DOCKER_PATH="/home/docker"
DOCKER_CONTAINER_PATH="$DOCKER_PATH/containers"
DOCKER_STACKS_PATH="$DOCKER_PATH/stacks"
DOCKER_STORAGE_PATH="$DOCKER_PATH/storage"
DOCKER_TEMP_PATH="$DOCKER_PATH/tmp"

# Create a temporary env file
ENV_FILE=$(mktemp)
echo "DOCKER_USER=$DOCKER_USER" >> "$ENV_FILE"
echo "DOCKER_GROUP=$DOCKER_GROUP" >> "$ENV_FILE"
echo "DOCKER_PATH=$DOCKER_PATH" >> "$ENV_FILE"
echo "DOCKER_CONTAINER_PATH=$DOCKER_CONTAINER_PATH" >> "$ENV_FILE"
echo "DOCKER_STACKS_PATH=$DOCKER_STACKS_PATH" >> "$ENV_FILE"
echo "DOCKER_STORAGE_PATH=$DOCKER_STORAGE_PATH" >> "$ENV_FILE"
echo "DOCKER_TEMP_PATH=$DOCKER_TEMP_PATH" >> "$ENV_FILE"

# Array of scripts to run
scripts=("01-dependencies.sh" "02-user-setup.sh" "03-storage-setup.sh" "04-setup-portainer.sh" "05-setup-dockge.sh")

# Check if scripts exist
for script in "${scripts[@]}"; do
  [ -f "$SCRIPTS_PATH/$script" ] || { echo "Error: Script $script not found in $SCRIPTS_PATH"; exit 1; }
done

# Run scripts 01, 02, and 03 as root
for script in "${scripts[@]:0:3}"; do  # Run the first two scripts as root
  sudo /bin/bash "$SCRIPTS_PATH/$script" "$ENV_FILE" || { echo "Error running $script"; exit 1; }
  echo "Script $script completed successfully."
done

# Get the docker user's UID and GID after user creation
DOCKER_UID=$(id -u "$DOCKER_USER")
DOCKER_GID=$(id -g "$DOCKER_USER")
echo "DOCKER_UID=$DOCKER_UID" >> "$ENV_FILE"
echo "DOCKER_GID=$DOCKER_GID" >> "$ENV_FILE"
echo "Docker User ID: $DOCKER_UID"
echo "Docker Group ID: $DOCKER_GID"

# Ensure docker user has read access to the env file
sudo chown "$DOCKER_USER" "$ENV_FILE" || { 
  echo "Failed to grant access to environment file for docker user."
  exit 1
}

# Create a temporary directory for the scripts under the docker user's home
DOCKER_SCRIPTS_PATH="$DOCKER_TEMP_PATH/$SCRIPTS_DIR"
sudo rm -r "$DOCKER_SCRIPTS_PATH"
sudo cp -r "$SCRIPTS_PATH" "$DOCKER_TEMP_PATH/"
sudo chown -R "$DOCKER_USER":"$DOCKER_GROUP" "$DOCKER_SCRIPTS_PATH"

# Run scripts 04 and 05 as the 'docker' user
for script in "${scripts[@]:3}"; do  # Run the remaining scripts as docker user
  sudo -u "$DOCKER_USER" /bin/bash "$DOCKER_SCRIPTS_PATH/$script" "$ENV_FILE" || { echo "Error running $script"; exit 1; }
  echo "Script $script completed successfully."
done

# Remove the temporary file
sudo rm "$ENV_FILE"
