# Bash Scripts for Homelab Docker Setup

This directory contains Bash scripts that automate various aspects of setting up and managing your Docker-based homelab environment.

## Script Overview

### Core Setup Scripts

1.  **`01-dependencies.sh`:**
    -   Checks if Docker is installed and prompts the user to install it if it's missing.
    -   Uses the `apt-get` package manager for installation by default, but you can customize it in the `.env` file.
2.  **`02-user-setup.sh`:**
    -   Creates a dedicated user (and group if it doesn't exist) for running Docker containers in a non-root environment for enhanced security.
3.  **`03-storage-setup.sh`:**
    -   Sets up the necessary directories (`containers`, `stacks`, `storage`) for Docker data and configuration.
    -   Assigns ownership of these directories to the Docker user for proper permissions.
4.  **`04-setup-portainer.sh`:**
    -   Installs and configures Portainer, a web-based Docker management UI.
    -   Removes any existing Portainer containers to ensure a clean installation.
5.  **`05-setup-dockge.sh`:**
    -   Installs and configures Dockge, a user-friendly Docker Compose UI for easy stack management.
    -   Removes any existing Dockge containers for a fresh setup.
6.  **`06-setup-stacks.sh`:**
    -   Deploys Docker Compose stacks defined in the `stacks` directory.
    -   Copies the stack's `docker-compose.yml`, `.env` (if available), and optional `deploy.sh` script to the Docker user's home directory.

### Master Scripts

- **`setup.sh`:** The main script to run for the initial setup of your homelab.
    - Calls scripts 1-3 as root to install Docker and set up the user/storage.
    - Copies the repo into a temporary directory and calls the rest of the scripts 4-6 as the `docker` user.

- **`update.sh`:** Use this script to update or add new stacks to your environment after the initial setup.
    - Calls script 6 for each of the stacks defined in the `.env` file.

### Utility Functions (`utils.sh`)

*   **`load_config <file>`:** Loads and exports environment variables from the specified configuration file.
*   **`check_user <uid>`:** Verifies that the script is running as the user with the specified User ID (UID).
*   **`check_group <gid>`:** Verifies that the script is running as a member of the group with the specified Group ID (GID).
*   **`remove_containers_with_image_base <image_base>`:** Removes Docker containers based on the provided image base (ignores tags).
*   **`command_exists <command>`:**  Checks if the specified command is available on the system.
*   **`install_package <package_manager> <package_name> [options]`:** Installs the specified package using the given package manager (e.g., `apt-get`, `yum`).
*   **`create_dir_if_not_exists <path> [owner] [group] [permissions]`:** Creates a directory at the given path if it doesn't exist, optionally setting the owner, group, and permissions.
*   **`create_file_if_not_exists <path> [owner] [group] [permissions]`:** Creates an empty file at the given path if it doesn't exist, optionally setting the owner, group, and permissions.
*   **`set_ownership <path> <owner> <group>`:** Sets the ownership of the specified file or directory.
*   **`set_permissions <path> [permissions]`:** Sets the permissions of the specified file or directory (defaults to `654`).
