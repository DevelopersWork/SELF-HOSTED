# homelab

# Docker Environment Setup Scripts

This repository contains a set of Bash scripts that automate the installation, configuration, and deployment of Docker, along with two popular Docker management tools: Portainer and Dockge.

## Overview

These scripts aim to streamline the process of setting up a powerful and easy-to-use Docker environment on your system. They are designed to work together, with each script handling a specific step in the setup process.

## Scripts

1. **01-setup-docker.sh:**
   - Checks if Docker is installed.
   - If not, prompts the user to install Docker.
   - If the user confirms, it installs Docker using `apt-get` (Debian/Ubuntu).
   - Checks and creates the "docker" group if it doesn't exist.
   - Checks and creates the "docker" user if it doesn't exist.
   - Adds the current user to the 'docker' group if the docker user was created for the first time with the script

2. **02-configure-docker.sh:**
   - Creates necessary directories for Docker volumes and stacks (e.g., `/home/docker/volumes`, `/home/docker/stacks`).
   - Sets the ownership of these directories to the `docker` user and group to avoid permission issues.

3. **03-setup-portainer.sh:**
   - Sets up Portainer, a web-based Docker management UI.
   - Stops any existing Portainer containers.
   - Creates a dedicated volume for Portainer data persistence.
   - Runs a new Portainer container with resource constraints and necessary volume mounts.

4. **04-setup-dockge.sh:**
   - Sets up Dockge, a user-friendly Docker Compose UI.
   - Stops any existing Dockge containers.
   - Creates a dedicated volume for Dockge data.
   - Runs a new Dockge container with resource constraints and necessary volume mounts.

5. **setup.sh (Master Script):**
   - Orchestrates the entire setup process by calling the other scripts in sequence.
   - Ensures that each script is executed with the appropriate privileges (sudo for installation/configuration, docker user for container setup).
   - Includes error handling to report and stop execution if any step fails.


## Prerequisites

* **Linux System:** The scripts are designed for Debian-based Linux distributions (e.g., Ubuntu, Debian).
* **Sudo Privileges:** You need `sudo` access to run the `setup.sh` script, as it performs tasks requiring administrative privileges.

## Installation

1. Clone or download this repository.
2. Make all scripts executable: `chmod +x bash-scripts/*.sh`
3. Run the master script: `sudo ./setup.sh`

## Configuration

* You can customize the following settings by editing the individual scripts:
    - `DATA_DIR`: The base directory for Docker data (default: `/home/docker`).
    - Resource limits for Portainer and Dockge containers.

## Additional Notes

* This setup is designed to isolate the Docker environment within the `docker` user's context. If you want other users to have Docker access, you'll need to add them to the `docker` group manually.
* Consider reviewing and adjusting the resource limits in the scripts to fit your system resources and usage patterns.

## License

<!-- [Choose a license - e.g., MIT License] -->

