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
    local container_ids=$(docker container ls -a | grep "$image_base" | awk '{ print $1 }') 

    if [ -n "$container_ids" ]; then
        echo "Removing existing containers with image base: $image_base"
        docker container rm -f $container_ids # Force removal
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install a package (generic)
install_package() {
    local package_manager="$1"
    local package_name="$2"
    local install_options=${3:-"-y"}  # Default to -y (yes to all prompts)

    echo "Installing $package_name using $package_manager..."

    # Update package lists (some package managers don't need this)
    if $package_manager update &> /dev/null; then 
        echo "Package lists updated."
    else
        echo "Warning: Failed to update package lists. Continuing with installation..."
    fi

    # Install the package
    $package_manager install $install_options "$package_name" || {
        echo "Error: Failed to install $package_name." >&2  # Redirect error message to stderr
        exit 1
    }

    echo "$package_name installation complete."
}

# Function to create a directory if it doesn't exist
create_dir_if_not_exists() {
    local dir_path="$1"
    local owner_user="$2" 
    local owner_group="$3" 

    if [[ ! -d "$dir_path" ]]; then
        echo "Creating directory: $dir_path"
        mkdir -p "$dir_path" || { echo "Failed to create directory: $dir_path"; exit 1; }
        set_ownership $dir_path $owner_user $owner_group
        set_permissions $dir_path
    fi
}

# Function to set ownership of a directory (if not already owned by the specified user/group)
set_ownership() {
    local dir_path="$1"
    local owner_user="$2" 
    local owner_group="$3" 

    if ! [[ "$(stat -c %u "$dir_path")" = "$owner_uid" ]] || ! [[ "$(stat -c %g "$dir_path")" = "$owner_gid" ]]; then
        echo "Setting ownership of $dir_path to $owner_user:$owner_group"
        chown "$owner_user:$owner_group" "$dir_path" || { 
            echo "Failed to set ownership for $dir_path" >&2
            exit 1 
        }
    fi
}

# Function to set permissions on a directory (optional)
set_permissions() {
    local dir_path="$1"
    local permissions="${2:-754}" 

    echo "Setting permissions for $dir_path to $permissions"
    chmod "$permissions" "$dir_path" || { 
        echo "Failed to set permissions for $dir_path" >&2
        exit 1 
    }
}