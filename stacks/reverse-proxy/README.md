# Reverse Proxy Stack

This stack deploys Nginx Proxy Manager (NPM), a powerful and user-friendly web interface for managing reverse proxies, SSL certificates, and more. It simplifies the process of setting up secure access to your web applications within your homelab.

## Stack Files

- `docker-compose.yml`: Defines the Nginx Proxy Manager and MariaDB (database) services, their configuration, and the network they share.
- `deploy.sh`: Script to create or update the required `.env` file for the stack.

## Services

- **nginx-proxy-manager:** The primary reverse proxy service that manages and routes your web applications.
- **traefik:** A dynamic reverse proxy that simplifies the deployment of microservices.

## Environment Variables

- **`PUID`**: User ID (UID) for running the container.
- **`PGID`**: Group ID (GID) for running the container.
- **`DB_NAME`**: The name of the database.
- **`DB_USER`**: The username for the database.
- **`DB_PASSWORD`**: The password for the database.

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   **Replace the placeholders** `DB_PASSWORD` in the `deploy.sh` script with your actual, strong passwords.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing Nginx Proxy Manager:**
    -   Open your browser and navigate to `http://<your-host-ip>:81`.
    -   You'll be prompted to set up an initial user account.
    
3.  **Accessing Traefik:**
    -   Open your browser and navigate to `http://<your-host-ip>:8081`.

4.  **Using Nginx Proxy Manager:**
    -   Once logged in, you can use the web interface to add your domains, configure SSL certificates (manually or with Let's Encrypt), set up reverse proxies, and manage other aspects of your web services.
    
## Additional Notes

- **Custom Configuration:** Nginx Proxy Manager offers extensive options for customization. Refer to the official documentation for advanced configuration.
- **Security:** Remember to set strong passwords for your Postgresql database.
- **Due to current limitations, the Nginx Proxy Manager container runs as root within the Docker container.**

## Authors

*   Developers@Work
