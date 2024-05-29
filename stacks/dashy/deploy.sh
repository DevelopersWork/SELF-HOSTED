#!/bin/bash
# stacks/dashy/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Define and Create the dashy stack directory
STACK_PATH="$DOCKER_STACKS_PATH/dashy"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the dashy volume directory
VOLUME_PATH="$DOCKER_CONTAINER_PATH/dashy"
create_dir_if_not_exists "$VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "DASHY_VOLUME_PATH" "$VOLUME_PATH"
update_env_file $ENV_FILE "DASHY_HTTP_WEBPORT" "4000"
update_env_file $ENV_FILE "DASHY_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "DASHY_RESOURCES_MEMORY" "512M"
