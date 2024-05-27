#!/bin/bash
# stacks/pihole-unbound/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

STACK_PATH="$DOCKER_STACKS_PATH/pihole-unbound"

PIHOLE_VOLUME_PATH="$DOCKER_CONTAINER_PATH/pihole"
UNBOUND_VOLUME_PATH="$DOCKER_CONTAINER_PATH/unbound"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "PIHOLE_DNS_PORT" "53"
update_env_file $ENV_FILE "PIHOLE_HTTP_WEBPORT" "1010"
update_env_file $ENV_FILE "PIHOLE_HTTPS_WEBPORT" "4443"
update_env_file $ENV_FILE "PIHOLE_WEBPASSWORD" "password"
update_env_file $ENV_FILE "PIHOLE_VOLUME_PATH" "$PIHOLE_VOLUME_PATH"
update_env_file $ENV_FILE "PIHOLE_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "PIHOLE_RESOURCES_MEMORY" "512M"
update_env_file $ENV_FILE "UNBOUND_VOLUME_PATH" "$UNBOUND_VOLUME_PATH"
update_env_file $ENV_FILE "UNBOUND_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "UNBOUND_RESOURCES_MEMORY" "512M"

# https://raw.githubusercontent.com/MatthewVance/unbound-docker/master/1.19.3/data/opt/unbound/etc/unbound/forward-records.conf 
# https://raw.githubusercontent.com/MatthewVance/unbound-docker/master/1.19.3/data/opt/unbound/etc/unbound/a-records.conf 
# https://raw.githubusercontent.com/MatthewVance/unbound-docker/master/1.19.3/data/opt/unbound/etc/unbound/srv-records.conf 
# TODO copy these config into the volume path of the unbound
