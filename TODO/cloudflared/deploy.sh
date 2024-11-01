#!/bin/bash
# stacks/cloudflared/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Load configuration and validate user/group
load_config "$2"

# Define and Create the Cloudflared stack directory
STACK_PATH="$DOCKER_STACKS_PATH/cloudflared"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the Cloudflared volume directory
VOLUME_PATH="$DOCKER_CONTAINER_PATH/cloudflared"
create_dir_if_not_exists "$VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP"

# Overwrite PUID and PGID to ensure they are always up-to-date
update_env_file "$ENV_FILE" "PUID" "$(id -u $DOCKER_USER)"
update_env_file "$ENV_FILE" "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file "$ENV_FILE" "CLOUDFLARED_TUNNEL_TOKEN" ""
update_env_file "$ENV_FILE" "CLOUDFLARED_TUNNEL_METRICS" "localhost:60123"
update_env_file "$ENV_FILE" "CLOUDFLARED_VOLUME_PATH" "$VOLUME_PATH"
