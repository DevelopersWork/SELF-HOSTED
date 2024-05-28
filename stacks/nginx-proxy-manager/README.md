# Nginx Proxy Manager Stack

This stack deploys Nginx Proxy Manager (NPM), a powerful and user-friendly web interface for managing reverse proxies, SSL certificates, and more. It simplifies the process of setting up secure access to your web applications within your homelab.

## Stack Files

- `docker-compose.yml`: Defines the Nginx Proxy Manager and MariaDB (database) services, their configuration, and the network they share.
- `deploy.sh`: Script to create or update the required `.env` file for the stack.

## Services

- **nginx-proxy-manager:** The core reverse proxy service that manages your web applications.
- **mariadb-aria-npm:**  MariaDB database for storing Nginx Proxy Manager configuration.

## Environment Variables

**Nginx Proxy Manager:**

- **`PUID`**: User ID (UID) for running the container (automatically set in the `deploy.sh` script).
- **`PGID`**: Group ID (GID) for running the container (automatically set in the `deploy.sh` script).
- **`NPM_HTTP_PORT`:** Port for HTTP traffic (default: `80`).
- **`NPM_HTTPS_PORT`:** Port for HTTPS traffic (default: `443`).
- **`NPM_HTTP_WEBPORT`:** Port for the Nginx Proxy Manager web interface (default: `8081`).
- **`NPM_VOLUME_PATH`:** Path to the Nginx Proxy Manager data volume (defaults to `/home/docker/containers/nginx-proxy-manager`).
- **`NPM_RESOURCES_CPUS`:** CPU cores allocated to Nginx Proxy Manager (default: `0.5`).
- **`NPM_RESOURCES_MEMORY`:** Memory allocated to Nginx Proxy Manager (default: `512M`).

**MariaDB:**

- **`MYSQL_ROOT_PASSWORD`:** Root password for the MariaDB database (**required**, set a strong password).
- **`MYSQL_PASSWORD`:** Password for the Nginx Proxy Manager database user (**required**, set a strong password).
- **`MARIADB_RESOURCES_CPUS`:** CPU cores allocated to MariaDB (default: `0.5`).
- **`MARIADB_RESOURCES_MEMORY`:** Memory allocated to MariaDB (default: `512M`).

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   **Replace the placeholders** `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` in the `deploy.sh` script with your actual, strong passwords.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing Nginx Proxy Manager:**
    -   Open your browser and navigate to `http://<your-host-ip>:8081`.
    -   You'll be prompted to set up an initial user account.

3.  **Using Nginx Proxy Manager:**
    -   Once logged in, you can use the web interface to add your domains, configure SSL certificates (manually or with Let's Encrypt), set up reverse proxies, and manage other aspects of your web services.
    
## Additional Notes

- **Custom Configuration:** Nginx Proxy Manager offers extensive options for customization. Refer to the official documentation for advanced configuration.
- **Security:** Remember to set strong passwords for your MariaDB database.

## Authors

*   Developers@Work
