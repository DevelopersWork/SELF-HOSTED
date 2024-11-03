#!/bin/bash
# stacks/databases/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Load configuration and validate user/group
load_config "$2"

# Define and Create the Databases stack directory
STACK_PATH="$DOCKER_STACKS_PATH/databases"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the redis volume directory
REDIS_VOLUME_PATH="$DOCKER_VOLUME_PATH/databases/redis"
create_dir_if_not_exists "$REDIS_VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP"
update_env_file "$ENV_FILE" "PUID" "$(id -u $DOCKER_USER)"
update_env_file "$ENV_FILE" "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file "$ENV_FILE" "REDIS_VOLUME_PATH" "$REDIS_VOLUME_PATH"
update_env_file "$ENV_FILE" "DB_ROOT_PASSWORD" "<ROOT PASSWORD>"
update_env_file "$ENV_FILE" "DB_USER" "user"
update_env_file "$ENV_FILE" "DB_PASSWORD" "<PASSWORD>"
