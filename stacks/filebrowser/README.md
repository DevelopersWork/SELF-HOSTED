# File Browser Stack

This stack deploys File Browser, a user-friendly web-based file manager for your homelab. It allows you to easily access and manage files on your server through a web interface.

## Stack Files

- `docker-compose.yml`: Defines the File Browser service and its configuration.
- `deploy.sh`: Script to automatically create the required `.env` file for the stack and set up the database.

## Services

- **filebrowser:**  The main File Browser application.

## Environment Variables

- **`PUID`**: The user ID (UID) for running the container (automatically set in the `deploy.sh` script).
- **`PGID`**: The group ID (GID) for running the container (automatically set in the `deploy.sh` script).
- **`FILEBROWSER_VOLUME_PATH`**: The path where File Browser data is stored (defaults to `/home/docker/containers/filebrowser`).
- **`FILEBROWSER_HTTP_WEBPORT`**: The port on which File Browser is accessible (defaults to `8082`).
- **`FILEBROWSER_RESOURCES_CPUS`**: The number of CPU cores allocated to File Browser (defaults to `0.5`).
- **`FILEBROWSER_RESOURCES_MEMORY`**: The amount of memory allocated to File Browser (defaults to `512M`).

## Usage

1. **Deployment:**
   - Run the `update.sh` script from the root of the repository to deploy the File Browser stack. The `deploy.sh` script will create the necessary files.
2. **Accessing File Browser:**
   - After deployment, you can access File Browser at `http://<your-host-ip>:8082` (or the port you specified in the `.env` file).

## Authors

* Developers@Work
