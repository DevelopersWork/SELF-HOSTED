#!/bin/bash
# 06-setup-stacks.sh

# Source the utility script
source "$1/utils.sh" 

# Get the environment file path and exit if not provided or not a regular file
# Source the environment file to load variables
load_config "$2"

# Get the docker user's UID and GID
DOCKER_PUID=$(id -u "$DOCKER_USER")
DOCKER_GUID=$(id -g "$DOCKER_USER")

# Ensure script is running as docker user
check_user $DOCKER_PUID
# Ensure script is running as docker group
check_group $DOCKER_GUID

# TODO
STACK_NAME=$3


