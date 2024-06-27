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
update_env_file $ENV_FILE "NPM_HTTP_PORT" "80"
update_env_file $ENV_FILE "NPM_HTTPS_PORT" "443"
update_env_file $ENV_FILE "NPM_HTTP_WEBPORT" "8081"
update_env_file $ENV_FILE "NPM_VOLUME_PATH" "$VOLUME_PATH"
update_env_file $ENV_FILE "NPM_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "NPM_RESOURCES_MEMORY" "512M"
update_env_file $ENV_FILE "MYSQL_ROOT_PASSWORD" "MYSQL_ROOT_PASSWORD"
update_env_file $ENV_FILE "MYSQL_PASSWORD" "MYSQL_PASSWORD"
update_env_file $ENV_FILE "MARIADB_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "MARIADB_RESOURCES_MEMORY" "256M"

create_dir_if_not_exists "$VOLUME_PATH/data" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$VOLUME_PATH/letsencrypt/log" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$VOLUME_PATH/mysql" "$DOCKER_USER" "$DOCKER_GROUP"
