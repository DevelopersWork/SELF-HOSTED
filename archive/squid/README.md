# Squid Proxy Stack

This stack deploys a Squid proxy server using Docker. Squid is a powerful caching proxy that can improve network performance, enhance security, and provide content filtering capabilities.

## Stack Files

- `docker-compose.yml`: Defines the Squid services, their configuration, and the network they share.
- `deploy.sh`: Script simplifies the deployment process by automatically:
    -  Creating or updating the necessary `.env` file with configuration options.
    -  Downloading the latest configuration files from the GitHub repository (if they don't already exist).

## Services

- **squid:** <fill it>

## Environment Variables

- **`PUID`:** User ID (UID) for running the containers.
- **`PGID`:** Group ID (GID) for running the containers.
- **`SQUID_DOCKER_TAG`:** Specific version tag for the `ubuntu/squid` Docker image (e.g., `6.6-24.04_beta`).
- **`SQUID_PROXY_PORT`:** Port on which Squid will listen for proxy requests (default: `3128`).
- **`SQUID_VOLUME_PATH`:** Path to the directory where Squid configuration and data will be stored (e.g., `/home/docker/containers/squid`).
- **`SQUID_RESOURCES_CPUS`:** CPU cores allocated to container (default: `0.5`).
- **`SQUID_RESOURCES_MEMORY`:** Memory allocated to container (default: `512M`).
- **`SQUID_TZ`:** Timezone for the Squid container (default: `IST`).

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   Review and modify any of the environment variable defaults in the `deploy.sh` if you need to customize them.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing Pi-hole:**
    -   Open your browser and navigate to `http://<your-host-ip>:3128` (or the port you specified).
    -   You'll be prompted to enter the password you set (or the default "password").

3.  **Configuring Your Network:**
    -   In your router or DHCP server settings, set the DNS server for your devices to the IP address of your Docker host (where Pi-hole is running). This will direct all DNS traffic through Pi-hole and Unbound.

## Notes

*   Change the default `PIHOLE_WEBPASSWORD` in the `deploy.sh` script before running it for security.
*   The `dnsmasq.d` directory in the Pi-hole volume allows you to add custom DNS configurations.
*   Consult the Pi-hole and Unbound documentation for more advanced configuration options.
*   **Port 53:** If you encounter issues with port 53 being used by another service (e.g., `systemd-resolved` on Ubuntu), you may need to disable or reconfigure that service. [Click here](https://www.linuxuprising.com/2020/07/ubuntu-how-to-free-up-port-53-used-by.html) for solution.
*   **File Permissions:** If you modify Unbound configuration files directly, ensure they have the correct ownership and permissions for the Docker container to access them.
*   **Due to current limitations, the Pi-hole and Unbound runs as root within the Docker container.**

## Authors

*   Developers@Work
