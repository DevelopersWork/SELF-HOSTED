# homelab

# Docker Management Tools Installation Script

This Bash script automates the installation and configuration of Docker, Portainer, and Dockge on your system. It streamlines the setup process, ensuring you have the necessary tools for efficient Docker container management.

## Features

* **Docker Installation:**
   - Checks if Docker is installed.
   - If not, prompts the user for installation and installs Docker.
* **User/Group Management:**
   - Checks and creates the "docker" group if it doesn't exist.
   - Checks and creates the "docker" user if it doesn't exist.
   - Ensures the current user is part of the "docker" group for easier Docker command execution.
* **Docker Daemon Configuration:**
   - Configures the Docker daemon to use a custom storage directory (`/home/docker/lib`) for images, containers, and volumes.
* **Portainer Setup:**
   - Stops any existing Portainer containers.
   - Creates a dedicated volume for Portainer data.
   - Runs a new Portainer container with resource constraints and necessary volume mounts.
* **Dockge Setup:**
   - Stops any existing Dockge containers.
   - Creates a dedicated volume for Dockge data.
   - Runs a new Dockge container with resource constraints and necessary volume mounts.

## Prerequisites:

* **Linux System:** This script is designed for Debian-based Linux distributions (e.g., Ubuntu, Debian).
* **Sudo Privileges:** The script requires `sudo` permissions to install Docker and manage users/groups.

## Usage:

1. Save this script as `init.sh`.
2. Make it executable: `chmod +x init.sh`
3. Run the script: `sudo ./init.sh`

## Configuration:

* **Data Directory:** The default directory for storing Docker data is `/home/docker`. You can change this in the script if needed.
* **Resource Limits:** The script sets some default resource limits for Portainer and Dockge. You can adjust these in the script if needed.

## Additional Notes:

* The script does not remove existing volumes when recreating containers. If you want to reset data, you'll need to manually remove the volumes before running the script again.
* This script is a basic starting point. You might need to adapt it to your specific requirements or environment.

