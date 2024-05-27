# Nginx Proxy Manager with Cloudflared Stack

This stack deploys Nginx Proxy Manager (NPM) in conjunction with Cloudflared, providing a powerful reverse proxy solution with automatic HTTPS and easy Cloudflare Tunnel integration.

## Stack Files

- `docker-compose.yml`: Defines the Nginx Proxy Manager, Cloudflared, and MariaDB (database) services and their configuration.
- `deploy.sh`: Script to automatically create or update the required `.env` file for the stack.

## Services

- **nginx-proxy-manager:** The core reverse proxy service that manages your web applications.
- **cloudflared:**  Cloudflare Tunnel daemon for secure access to your applications.
- **mariadb-aria-npm:**  MariaDB database for storing Nginx Proxy Manager configuration.

## Environment Variables

- **`PUID`**: User ID (UID) for running the container (automatically set in the `deploy.sh` script).
- **`PGID`**: Group ID (GID) for running the container (automatically set in the `deploy.sh` script).

**Cloudflared:**

- **`CLOUDFLARED_TUNNEL_TOKEN`**: Your Cloudflare Tunnel token (**required**, obtain it from your Cloudflare account).
- **`CLOUDFLARED_VOLUME_PATH`**: Path to the Cloudflared data volume (defaults to `/home/docker/containers/cloudflared`).
- **`CLOUDFLARED_RESOURCES_CPUS`**: CPU cores allocated to Cloudflared (default: `0.5`).
- **`CLOUDFLARED_RESOURCES_MEMORY`**: Memory allocated to Cloudflared (default: `512M`).

**Nginx Proxy Manager:**

- **`NPM_HTTP_PORT`:** Port for HTTP traffic (default: `80`).
- **`NPM_HTTPS_PORT`:** Port for HTTPS traffic (default: `443`).
- **`NPM_HTTP_WEBPORT`:** Port for the Nginx Proxy Manager web interface (default: `8081`).
- **`NPM_VOLUME_PATH`:** Path to the Nginx Proxy Manager data volume (defaults to `/home/docker/containers/nginx-proxy-manager`).
- **`NPM_RESOURCES_CPUS`:** CPU cores allocated to Nginx Proxy Manager (default: `0.5`).
- **`NPM_RESOURCES_MEMORY`:** Memory allocated to Nginx Proxy Manager (default: `512M`).

**MariaDB:**

- **`MYSQL_ROOT_PASSWORD`:** Root password for the MariaDB database (**required**, set a strong password).
- **`MYSQL_PASSWORD`:** User password for the MariaDB database (**required**, set a strong password).
- **`MARIADB_RESOURCES_CPUS`:** CPU cores allocated to MariaDB (default: `0.5`).
- **`MARIADB_RESOURCES_MEMORY`:** Memory allocated to MariaDB (default: `512M`).

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   **Replace the placeholders** in `deploy.sh` with your actual Cloudflare Tunnel token and strong passwords for the MariaDB database.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing Nginx Proxy Manager:**
    -   Open your browser and navigate to `http://<your-host-ip>:8081`.
    -   You'll be prompted to set up an initial user account.

3.  **Configuring Cloudflare Tunnel:**
    -   Follow the instructions in the Nginx Proxy Manager documentation to add your domains and configure Cloudflare Tunnel.

## Authors

*   Developers@Work
