#!/bin/bash
# stacks/squid/deploy.sh

SQUID_CONFIG_URL="https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/squid/plain/examples/config"

# Source the utility script
source "$1/utils.sh"

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Define and Create the Squid stack directory
STACK_PATH="$DOCKER_STACKS_PATH/squid"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Define and Create the Squid volume directory
SQUID_VOLUME_PATH="$DOCKER_CONTAINER_PATH/squid"
create_dir_if_not_exists "$SQUID_VOLUME_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP" 
update_env_file $ENV_FILE "PUID" "$(id -u $DOCKER_USER)"
update_env_file $ENV_FILE "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file $ENV_FILE "SQUID_PROXY_PORT" "3128"
update_env_file $ENV_FILE "SQUID_VOLUME_PATH" "$SQUID_VOLUME_PATH"
update_env_file $ENV_FILE "SQUID_RESOURCES_CPUS" "0.5"
update_env_file $ENV_FILE "SQUID_RESOURCES_MEMORY" "256M"

# Download Squid Configuration Files
for file in "squid.conf"; do
    config_file="$SQUID_VOLUME_PATH/$file"
    if [[ ! -f "$config_file" ]]; then
        echo "Downloading Squid configuration file: $file"
        wget -q -O "$config_file" "$SQUID_CONFIG_URL/$file?h=6.6-24.04_beta" || {
            echo "Failed to download Squid configuration: $file" >&2
            exit 1
        }
        set_ownership "$config_file" "$DOCKER_USER" "$DOCKER_GROUP"
        set_permissions "$config_file" "644"
    fi
done
