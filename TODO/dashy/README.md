# Dashy Stack

This Docker Compose stack sets up Dashy, a customizable personal dashboard to organize and access your self-hosted services and tools.

## Stack Files

- `docker-compose.yml`: Defines the Dashy service, its configuration, and how it interacts with Docker.
- `deploy.sh`: Script simplifies the deployment process by automatically:
    - Creating or updating the necessary `.env` file with configuration options.
    - Setting appropriate user and group IDs for file ownership.

## Services

- **dashy:** The Dashy dashboard service, providing a customizable and interactive web interface.

## Environment Variables

- **`PUID`:** User ID (UID) for running the container (automatically set by `deploy.sh`).
- **`PGID`:** Group ID (GID) for running the container (automatically set by `deploy.sh`).
- **`DASHY_HTTP_WEBPORT`:** Port for accessing the Dashy web interface (default: `4000`).
- **`DASHY_VOLUME_PATH`:** Path to the Dashy data volume (defaults to `/home/docker/containers/dashy`).
- **`DASHY_RESOURCES_CPUS`:** CPU cores allocated to Dashy (default: `0.5`).
- **`DASHY_RESOURCES_MEMORY`:** Memory allocated to Dashy (default: `512M`).

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   Review and modify any of the environment variable defaults in the `deploy.sh` if you need to customize them.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing Dashy:**
    -   Open your web browser and navigate to `http://<your-host-ip>:4000` (or the port you specified).

3.  **Customization:**
    - Edit the `conf.yml` file in the Dashy volume (`$DASHY_VOLUME_PATH/conf.yml`) to customize the dashboard layout, widgets, themes, and more.
    - Refer to the official [Dashy documentation](https://dashy.to/docs/) for detailed configuration instructions.

## Notes

*   The `user-data` directory in the Dashy volume stores your configuration and customization data.
*   After making changes to the `conf.yml` file, restart the Dashy container for the changes to take effectose restart dashy.

## Authors

*   Developers@Work
