#!/bin/bash
# stacks/coolify/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Define and Create the Nginx Proxy Manager stack directory
STACK_PATH="$DOCKER_STACKS_PATH/coolify"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the Nginx Proxy Manager volume directory
VOLUME_PATH="$DOCKER_CONTAINER_PATH/coolify"
create_dir_if_not_exists "$VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "COOLIFY_HTTP_WEBPORT" "80"
update_env_file $ENV_FILE "COOLIFY_VOLUME_PATH" "$VOLUME_PATH"
update_env_file $ENV_FILE "COOLIFY_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "COOLIFY_RESOURCES_MEMORY" "512M"
update_env_file $ENV_FILE "POSTGRES_USER" "POSTGRES_USER"
update_env_file $ENV_FILE "POSTGRES_PASSWORD" "POSTGRES_PASSWORD"
update_env_file $ENV_FILE "POSTGRES_DB" "POSTGRES_DB"
update_env_file $ENV_FILE "POSTGRES_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "POSTGRES_RESOURCES_MEMORY" "256M"
update_env_file $ENV_FILE "REDIS_PASSWORD" "REDIS_PASSWORD"
update_env_file $ENV_FILE "REDIS_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "REDIS_RESOURCES_MEMORY" "256M"
update_env_file $ENV_FILE "PUSHER_APP_ID" "256M"
update_env_file $ENV_FILE "PUSHER_APP_KEY" "256M"
update_env_file $ENV_FILE "PUSHER_APP_SECRET" "256M"
update_env_file $ENV_FILE "SOKETI_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "SOKETI_RESOURCES_MEMORY" "256M"

create_dir_if_not_exists "$VOLUME_PATH/app" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$VOLUME_PATH/postgresql" "$DOCKER_USER" "$DOCKER_GROUP"
