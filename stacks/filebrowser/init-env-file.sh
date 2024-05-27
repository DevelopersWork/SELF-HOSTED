#!/bin/bash
# init-env-file.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

STACK_PATH="$DOCKER_STACKS_PATH/filebrowser"

# .env file
STACK_ENV_FILE="$STACK_PATH/.env"
echo "PUID=$DOCKER_PUID" > $STACK_ENV_FILE
echo "PGID=$DOCKER_GUID" >> $STACK_ENV_FILE
echo "FILEBROWSER_VOLUME_PATH=$DOCKER_CONTAINER_PATH/filebrowser" >> $STACK_ENV_FILE
echo "FILEBROWSER_HTTP_WEBPORT=8082" >> $STACK_ENV_FILE
echo "FILEBROWSER_RESOURCES_CPUS=0.5" >> $STACK_ENV_FILE
echo "FILEBROWSER_RESOURCES_MEMORY=512M" >> $STACK_ENV_FILE
