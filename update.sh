#!/bin/bash
# update.sh

# Get the environment file path and exit if not provided or not a regular file
ENV_FILE="./.env"  # Global .env file

# Source the environment file (exit if it fails or doesn't exist)
source "$ENV_FILE" || {
  echo "Warning: .env file not found or failed to source." >&2
  ENV_FILE="./.env_TEMPLATE"
  source "$ENV_FILE" || {
    exit 1
  }
}

SCRIPTS_PATH="$(dirname "$(realpath "$0")")/$SCRIPTS_DIR"

# Array of scripts to run
scripts=("04-setup-stacks.sh")

# Create alias for running commands as the docker user
AS_DOCKER_USER="sudo -u $DOCKER_USER /bin/bash"

# Create a temporary directory for the docker user (in /tmp for better security)
TEMP_DIR=$($AS_DOCKER_USER -c "mktemp -d") || { echo "Failed to create temporary directory for the docker user in /tmp." >&2; exit 1; }

# Copy the repository to the temporary directory and with owner as the docker user
sudo cp -r "." "$TEMP_DIR/"
sudo chown -R "$DOCKER_USER":"$DOCKER_GROUP" "$TEMP_DIR"

# Run script 06 as the 'docker' user for each stack
for stack in "${STACKS[@]}"; do  
  $AS_DOCKER_USER "$TEMP_DIR/$SCRIPTS_DIR/${scripts[0]}" "$TEMP_DIR/$SCRIPTS_DIR" "$TEMP_DIR/$ENV_FILE" "$stack" || { echo "Error running ${scripts[0]} for $stack"; exit 1; }
done
echo "Script ${scripts[0]} completed successfully."

# Clean up - remove the temporary directory
sudo rm -rf "$TEMP_DIR"
