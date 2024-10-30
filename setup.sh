#!/bin/bash
# setup.sh

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
scripts=("01-dependencies.sh" "02-user-setup.sh" "03-storage-setup.sh" "04-setup-stacks.sh" "05-setup-container-management.sh")

# Check if scripts exist
for script in "${scripts[@]}"; do
  [ -f "$SCRIPTS_PATH/$script" ] || { echo "Error: Script $script not found in $SCRIPTS_PATH" >&2; exit 1; }
done

# Run scripts 01, 02, and 03 as root
for script in "${scripts[@]:0:3}"; do 
  sudo /bin/bash "$SCRIPTS_PATH/$script" "$SCRIPTS_PATH" "$ENV_FILE" || { echo "Error running $script" >&2; exit 1; }
  echo "Script $script completed successfully."
done

# Get the docker user's UID and GID after user creation
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(getent group "$DOCKER_GROUP" | cut -d: -f3)
echo "Docker User ID: $DOCKER_PUID"
echo "Docker Group ID: $DOCKER_GUID"

# Create alias for running commands as the docker user
AS_DOCKER_USER="sudo -u $DOCKER_USER /bin/bash"

# Create a temporary directory for the docker user (in /tmp for better security)
TEMP_DIR=$($AS_DOCKER_USER -c "mktemp -d") || { echo "Failed to create temporary directory for the docker user in /tmp." >&2; exit 1; }

# Copy the repository to the temporary directory and with owner as the docker user
sudo cp -r "." "$TEMP_DIR/"
sudo chown -R "$DOCKER_USER":"$DOCKER_GROUP" "$TEMP_DIR"

# Run scripts 04 and 05 as the 'docker' user
for script in "${scripts[@]:3:2}"; do  
  $AS_DOCKER_USER "$TEMP_DIR/$SCRIPTS_DIR/$script" "$TEMP_DIR/$SCRIPTS_DIR" "$TEMP_DIR/$ENV_FILE" || { echo "Error running $script"; exit 1; }
  echo "Script $script completed successfully."
done

# Run script 06 as the 'docker' user for each stack
for stack in "${STACKS[@]}"; do  
  $AS_DOCKER_USER "$TEMP_DIR/$SCRIPTS_DIR/${scripts[5]}" "$TEMP_DIR/$SCRIPTS_DIR" "$TEMP_DIR/$ENV_FILE" "$stack" || { echo "Error running ${scripts[5]} for $stack"; exit 1; }
done
echo "Script ${scripts[5]} completed successfully."

# Clean up - remove the temporary directory
sudo rm -rf "$TEMP_DIR"
