# File Browser Stack

This stack deploys File Browser, a user-friendly web-based file manager for your homelab. It allows you to easily access and manage files on your server through a web interface.

## Stack Files

- `docker-compose.yml`: Defines the File Browser service and its configuration.
- `deploy.sh`: Script to automatically create or update the required `.env` file for the stack and set up the database.

## Services

- **filebrowser:** The main File Browser application.

## Environment Variables

- **`PUID`**: The user ID (UID) for running the container (automatically set in the `deploy.sh` script).
- **`PGID`**: The group ID (GID) for running the container (automatically set in the `deploy.sh` script).
- **`FILEBROWSER_VOLUME_PATH`**: The path where File Browser data is stored (defaults to `/home/docker/containers/filebrowser`).
- **`FILEBROWSER_HTTP_WEBPORT`**: The port on which File Browser is accessible (defaults to `8082`).
- **`FILEBROWSER_RESOURCES_CPUS`**: The number of CPU cores allocated to File Browser (defaults to `0.5`).
- **`FILEBROWSER_RESOURCES_MEMORY`**: The amount of memory allocated to File Browser (defaults to `512M`).
- **`MOUNT_PATH`**: The path on your host system that you want to share with File Browser (no default, must be specified in the `deploy.sh` script).

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   Set the `MOUNT_PATH` variable to the directory on your host system that you want to share with File Browser.  
    -   (Optional) Adjust any other environment variables if needed.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing File Browser:**
    -   Open your browser and navigate to `http://<your-host-ip>:8082` (or the port you specified).

## Authors

*   Developers@Work
