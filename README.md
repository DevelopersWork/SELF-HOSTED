# The Developers@Work Homelab

# Docker Environment Setup Scripts

This repository contains a set of Bash scripts that automate the installation, configuration, and deployment of Docker, along with two popular Docker management tools: Portainer and Dockge.

## Overview

These scripts aim to streamline the process of setting up a powerful and easy-to-use Docker environment on your system. They are designed to work together, with each script handling a specific step in the setup process.

## Scripts

1. **01-dependencies.sh:**
    - Checks if Docker is installed.
    - If not, prompts the user to install Docker.
    - If the user confirms, it installs Docker using `apt-get` (Debian/Ubuntu).
    - Checks and creates the "docker" group if it doesn't exist.
    - Checks and creates the "docker" user if it doesn't exist.
    - Adds the current user to the 'docker' group if the docker user was created for the first time with the script.

2. **02-user-setup.sh:**
    - Creates the necessary directories for Docker (e.g., `/home/docker/containers`).
    - Sets the ownership of these directories to the `docker` user and group.

3. **03-storage-setup.sh:**
    - Sets up Portainer, a web-based Docker management UI.
    - Stops and removes any existing Portainer containers.
    - Creates a dedicated volume for Portainer data persistence.
    - Runs a new Portainer container with resource constraints and necessary volume mounts.

4. **04-setup-dockge.sh:**
    - Sets up Dockge, a user-friendly Docker Compose UI.
    - Stops and removes any existing Dockge containers.
    - Creates a dedicated volume for Dockge data.
    - Runs a new Dockge container with resource constraints and necessary volume mounts.

5. **setup.sh (Master Script):**
    - Orchestrates the entire setup process by calling the other scripts in sequence.
    - Ensures that each script is executed with the appropriate privileges.
    - Includes error handling for robustness.

## Prerequisites

* **Linux System:** The scripts are designed for Debian-based Linux distributions (e.g., Ubuntu, Debian).
* **Sudo Privileges:** You need `sudo` access to run the `setup.sh` script.
* **Sufficient Disk Space:** Ensure that you have enough disk space available for Docker images and volumes.

## Installation

1. Clone or download this repository.
2. Make all scripts executable: `chmod +x bash-scripts/*.sh`
3. Run the master script from the root of the repository: `sudo ./setup.sh`

## Configuration

* You can customize the following settings:
    - Docker-related environment variables (e.g., `DOCKER_PATH`, `DOCKER_CONTAINER_PATH`, etc.) in the `setup.sh` script.
    - Resource limits for Portainer and Dockge containers (modify the `--cpus` and `--memory` flags in the `docker run` commands within the respective scripts).

## Additional Notes

* This setup is designed to isolate the Docker environment within the `docker` user's context. If you want other users to have Docker access, add them to the `docker` group manually. 
* You might consider configuring Docker networks for better isolation and communication between your containers.

## License

[MIT License](LICENSE) 
