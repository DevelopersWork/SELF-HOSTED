#!/bin/bash
# stacks/domain-name-server/deploy.sh

UNBOUND_CONFIG_URL="https://raw.githubusercontent.com/MatthewVance/unbound-docker/master/1.19.3/data/opt/unbound/etc/unbound"

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Define and Create the Pihole Unbound stack directory
STACK_PATH="$DOCKER_STACKS_PATH/domain-name-server"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the Pihole and Unbound volume directory
VOLUME_PATH="$DOCKER_VOLUME_PATH/domain-name-server"
PIHOLE_VOLUME_PATH="$DOCKER_CONTAINER_PATH/pihole"
UNBOUND_VOLUME_PATH="$DOCKER_CONTAINER_PATH/unbound"
create_dir_if_not_exists "$VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$PIHOLE_VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
create_dir_if_not_exists "$UNBOUND_VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "PIHOLE_WEBPASSWORD" "password"
update_env_file $ENV_FILE "VOLUME_PATH" "$VOLUME_PATH"
update_env_file $ENV_FILE "PIHOLE_VOLUME_PATH" "$PIHOLE_VOLUME_PATH"
update_env_file $ENV_FILE "UNBOUND_VOLUME_PATH" "$UNBOUND_VOLUME_PATH"

# Download Unbound Configuration Files
for file in "forward-records.conf" "a-records.conf" "srv-records.conf"; do
    config_file="$UNBOUND_VOLUME_PATH/$file"
    if [[ ! -f "$config_file" ]]; then
        echo "Downloading Unbound configuration file: $file"
        wget -q -O "$config_file" "$UNBOUND_CONFIG_URL/$file" || {
            echo "Failed to download Unbound configuration: $file" >&2
            exit 1
        }
        set_ownership "$config_file" "$DOCKER_USER" "$DOCKER_GROUP"
        set_permissions "$config_file" "644"
    fi
done
