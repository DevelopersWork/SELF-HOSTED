#!/bin/bash
# stacks/filebrowser/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

VOLUME_PATH="$DOCKER_CONTAINER_PATH/filebrowser"
STACK_PATH="$DOCKER_STACKS_PATH/filebrowser"

# .env file
ENV_FILE="$STACK_PATH/.env"
if [[ ! -f "$ENV_FILE" ]]; then  # Check if .env file exists
    echo "Creating .env file at $ENV_FILE..."
    {
        echo "PUID=$(id -u $DOCKER_USER)"
        echo "PGID=$(getent group "$DOCKER_GROUP" | cut -d: -f3)"
        echo "FILEBROWSER_VOLUME_PATH=$VOLUME_PATH"
        echo "FILEBROWSER_HTTP_WEBPORT=8082"
        echo "FILEBROWSER_RESOURCES_CPUS=0.5"
        echo "FILEBROWSER_RESOURCES_MEMORY=512M"
    } > "$ENV_FILE"
fi

# Database File and Directory
DATABASE_PATH="$VOLUME_PATH/database" 
DATABASE_FILE="$DATABASE_PATH/filebrowser.db"
create_dir_if_not_exists "$DATABASE_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
create_file_if_not_exists "$DATABASE_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
