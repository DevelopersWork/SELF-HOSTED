#!/bin/bash
# update.sh

# Check if the .env file exists and source it
# prioritizing .env over .env_TEMPLATE
ENV_FILE="./.env"
if [[ -f $ENV_FILE ]]; then
  source $ENV_FILE
else
  echo "Warning: $ENV_FILE not found."
  # Check if the .env_TEMPLATE file exists and source it
  ENV_FILE="./.env_TEMPLATE"
  source $ENV_FILE || {
    echo "Error: No environment file found. Exiting." >&2
    exit 1
  }
fi

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

# Run scripts 04 as the 'docker' user
for script in "${scripts[@]:0:1}"; do  
  $AS_DOCKER_USER "$TEMP_DIR/$SCRIPTS_DIR/$script" "$TEMP_DIR/$SCRIPTS_DIR" "$TEMP_DIR/$ENV_FILE" || { echo "Error running $script"; exit 1; }
  echo "Script $script completed successfully."
done

# Clean up - remove the temporary directory
sudo rm -rf "$TEMP_DIR"
