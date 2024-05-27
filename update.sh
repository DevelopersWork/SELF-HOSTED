#!/bin/bash

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="./.env"
[ -f "$ENV_FILE" ] || { echo "Usage: $0 <environment_file>"; exit 1; }

# Source the environment file to load variables
source "$ENV_FILE" || { echo "Failed to source environment file."; exit 1; }

SCRIPTS_PATH="$(dirname "$(realpath "$0")")/$SCRIPTS_DIR"

# Array of scripts to run
scripts=("06-setup-stacks.sh")

# Get the docker user's UID and GID after user creation
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(id -g "$DOCKER_USER")
echo "Docker User ID: $DOCKER_PUID"
echo "Docker Group ID: $DOCKER_GUID"

# Create alias for running commands as the docker user
AS_DOCKER_USER="sudo -u $DOCKER_USER /bin/bash"

# Create a temporary directory for the docker user
TEMP_DIR=$($AS_DOCKER_USER -c "mktemp -d") || { echo "Failed to create temporary directory for the docker user."; exit 1; }

# Copy the repository to the temporary directory and with owner as the docker user
sudo cp -r "." "$TEMP_DIR/"
sudo chown -R "$DOCKER_USER":"$DOCKER_GROUP" "$TEMP_DIR"

# Run script 06 as the 'docker' user for each stack
for stack in "${STACKS[@]}"; do  
  $AS_DOCKER_USER "$TEMP_DIR/$SCRIPTS_DIR/${scripts[5]}" "$TEMP_DIR/$SCRIPTS_DIR" "$TEMP_DIR/$ENV_FILE" "$stack" || { echo "Error running ${scripts[5]} for $stack"; exit 1; }
done
echo "Script ${scripts[5]} completed successfully."

# Clean up - remove the temporary directory
sudo rm -rf "$TEMP_DIR"
