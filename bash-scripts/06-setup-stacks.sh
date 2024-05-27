#!/bin/bash
# 06-setup-stacks.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Get the docker user's UID and GID
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(id -g "$DOCKER_USER")

# Ensure script is running as docker user
check_user $DOCKER_PUID
# Ensure script is running as docker group
check_group $DOCKER_GUID

STACK_NAME="$3"          
STACK_SOURCE_PATH="$1/../stacks/$STACK_NAME"
if [[ -z "$STACK_NAME" ]]; then
    echo "Error: Stack name not provided."
    exit 1
elif [[ ! -d "$STACK_SOURCE_PATH" ]]; then
    echo "Error: Stack directory '$STACK_NAME' not found in $STACK_SOURCE_PATH."
    exit 1
fi

# Create the destination directory for the stack in the Docker path
STACK_DEST_PATH="$DOCKER_STACKS_PATH/$STACK_NAME"
create_dir_if_not_exists "$STACK_DEST_PATH"

# Copy docker-compose.yml file to the destination directory
cp "$STACK_SOURCE_PATH/docker-compose.yml" "$STACK_DEST_PATH/" || {
    echo "Error: Failed to copy docker-compose.yml for $STACK_NAME."
    exit 1
}

# Execute the deploy.sh (if exists) in the stack directory
SCRIPT_FILE="$STACK_SOURCE_PATH/deploy.sh"  
if [[ -f "$SCRIPT_FILE" ]]; then
    echo "Executing script: $SCRIPT_FILE"
    chmod +x "$SCRIPT_FILE" && /bin/bash "$SCRIPT_FILE" "$2" || {
        echo "Error: Failed to execute deploy.sh for $STACK_NAME."
        exit 1
    }
fi
