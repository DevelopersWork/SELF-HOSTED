#!/bin/bash
# stacks/github-actions-runner/deploy.sh

# Source the utility script
source "$1/utils.sh"

# Load configuration and validate user/group
load_config "$2"

# Define and Create the stack directory
STACK_PATH="$DOCKER_STACKS_PATH/github-actions-runner"
create_dir_if_not_exists "$STACK_PATH" "$DOCKER_USER" "$DOCKER_GROUP"

# Download the Dockerfile
DOCKERFILE_SHA="e1fa1fcbc3de1c0b57f6fe2a82f77a8ed3a138b1"
DOCKERFILE_URL="https://raw.githubusercontent.com/actions/runner/${DOCKERFILE_SHA}/images/Dockerfile"
DOCKERFILE_OUTPUT_PATH="$STACK_PATH/Dockerfile"
wget -q -O "$DOCKERFILE_OUTPUT_PATH" "$DOCKERFILE_URL" || {
    echo "Failed to download: $DOCKERFILE_URL" >&2
    exit 1
}
echo "$DOCKERFILE_SHA $DOCKERFILE_OUTPUT_PATH" | shasum -a 256 -c
set_ownership "$DOCKERFILE_OUTPUT_PATH" "$DOCKER_USER" "$DOCKER_GROUP"
set_permissions "$DOCKERFILE_OUTPUT_PATH" "644"

# .env file
ENV_FILE="$STACK_PATH/.env"
create_file_if_not_exists "$ENV_FILE" "$DOCKER_USER" "$DOCKER_GROUP"
update_env_file "$ENV_FILE" "PUID" "$(id -u $DOCKER_USER)"
update_env_file "$ENV_FILE" "PGID" "$(getent group $DOCKER_GROUP | cut -d: -f3)"
update_env_file "$ENV_FILE" "ACTIONS_REPO" ""
update_env_file "$ENV_FILE" "ACTIONS_TOKEN" ""
