#!/bin/bash
# stacks/nginx_proxy_manager-cloudflare/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

STACK_PATH="$DOCKER_STACKS_PATH/nginx_proxy_manager-cloudflare"

CLOUDFLARED_VOLUME_PATH="$DOCKER_CONTAINER_PATH/cloudflared"
NPM_VOLUME_PATH="$DOCKER_CONTAINER_PATH/nginx-proxy-manager"

# .env file
ENV_FILE="$STACK_PATH/.env"
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "CLOUDFLARED_TUNNEL_TOKEN" ""
update_env_file $ENV_FILE "CLOUDFLARED_VOLUME_PATH" "$CLOUDFLARED_VOLUME_PATH"
update_env_file $ENV_FILE "CLOUDFLARED_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "CLOUDFLARED_RESOURCES_MEMORY" "512M"
update_env_file $ENV_FILE "NPM_HTTP_PORT" "80"
update_env_file $ENV_FILE "NPM_HTTPS_PORT" "443"
update_env_file $ENV_FILE "NPM_HTTP_WEBPORT" "8081"
update_env_file $ENV_FILE "NPM_VOLUME_PATH" "$NPM_VOLUME_PATH"
update_env_file $ENV_FILE "NPM_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "NPM_RESOURCES_MEMORY" "512M"
update_env_file $ENV_FILE "MYSQL_ROOT_PASSWORD" "MYSQL_ROOT_PASSWORD"
update_env_file $ENV_FILE "MYSQL_PASSWORD" "MYSQL_PASSWORD"
update_env_file $ENV_FILE "MARIADB_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "MARIADB_RESOURCES_MEMORY" "512M"

create_dir_if_not_exists "$NPM_VOLUME_PATH/data" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$NPM_VOLUME_PATH/letsencrypt/log" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$NPM_VOLUME_PATH/mysql" "$DOCKER_USER" "$DOCKER_GROUP"
