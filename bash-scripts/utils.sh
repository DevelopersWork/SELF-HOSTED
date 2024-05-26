#!/bin/bash

# Function to load and export environment variables
load_config() {
    local config_file="$1"

    if [[ ! -f "$config_file" ]]; then
        echo "Error: Config file '$config_file' not found."
        exit 1
    fi

    # Use set -o allexport to export all variables in the file
    set -o allexport
    source "$config_file"
    set +o allexport

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to source config file '$config_file'."
        exit 1
    fi
}

# Function to validate the current user against the expected UID
check_user() {
    local expected_uid="$1"

    # Ensure script is running as the correct user
    if [[ -z "$expected_uid" ]]; then
        echo "ERROR: User UID is not set. Please check your environment variables."
        exit 1
    elif [[ "$(id -u)" -ne "$expected_uid" ]]; then
        echo "This script must be run as the user with UID '$expected_uid'."
        exit 1
    fi
}

# Function to validate the current user against the expected GID
check_group() {
    local expected_gid="$1"

    # Ensure script is running as the correct group
    if [[ -z "$expected_gid" ]]; then
        echo "ERROR: User GID is not set. Please check your environment variables."
        exit 1
    elif [[ "$(id -g)" -ne "$expected_gid" ]]; then
        echo "This script must be run as the user with GID '$expected_gid'."
        exit 1
    fi
}


# Function to remove containers with a specific image base (ignoring tag)
remove_containers_with_image_base() {
    local image_base="$1"

    # Filter containers by image base and remove (force if necessary)
    docker container ls -aqf "ancestor=$image_base" | xargs docker container rm -f
}
