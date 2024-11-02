#!/bin/bash
# stacks/nginx-proxy-manager/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Define and Create the Nginx Proxy Manager stack directory
STACK_PATH="$DOCKER_STACKS_PATH/nginx-proxy-manager"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the Nginx Proxy Manager volume directory
VOLUME_PATH="$DOCKER_CONTAINER_PATH/nginx-proxy-manager"
create_dir_if_not_exists "$VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "NPM_VOLUME_PATH" "$VOLUME_PATH"
update_env_file $ENV_FILE "DB_NAME" "npm_db"
update_env_file $ENV_FILE "DB_USER" "npm_user"
update_env_file $ENV_FILE "DB_PASSWORD" "password"
update_env_file $ENV_FILE "DB_ROOT_PASSWORD" "password"

create_dir_if_not_exists "$VOLUME_PATH/data" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$VOLUME_PATH/letsencrypt/log" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$VOLUME_PATH/mysql" "$DOCKER_USER" "$DOCKER_GROUP"
