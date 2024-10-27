# DNS(Domain Name Server) Stack 
> Pi-hole + Unbound

This stack combines Pi-hole, a network-wide ad blocker, with Unbound, a validating, recursive, and caching DNS resolver. This setup provides a comprehensive solution for ad-free browsing and enhanced privacy and security for your home network.

## Stack Files

- `docker-compose.yml`: Defines the Pi-hole and Unbound services, their configuration, and the network they share.
- `deploy.sh`: Script simplifies the deployment process by automatically:
    -  Creating or updating the necessary `.env` file with configuration options.
    -  Downloading the latest configuration files from the GitHub repository (if they don't already exist).

## Services

- **pihole:**  The Pi-hole ad-blocking service, providing a web interface for management and statistics.
- **unbound:** The Unbound DNS resolver, responsible for handling DNS queries securely and efficiently.

## Environment Variables

- **`PUID`:** User ID (UID) for running the containers.
- **`PGID`:** Group ID (GID) for running the containers.
- **`PIHOLE_WEBPASSWORD`:** Password for the Pi-hole web interface (default: `password`). 
- **`PIHOLE_VOLUME_PATH`:** Path to the Pi-hole data volume (defaults to `/home/docker/containers/pihole`).
- **`PIHOLE_RESOURCES_CPUS`:** CPU cores allocated to Pi-hole (default: `0.5`).
- **`PIHOLE_RESOURCES_MEMORY`:** Memory allocated to Pi-hole (default: `512M`).
- **`UNBOUND_VOLUME_PATH`:** Path to the Unbound data volume (defaults to `/home/docker/containers/unbound`).
- **`UNBOUND_RESOURCES_CPUS`:** CPU cores allocated to Unbound (default: `0.5`).
- **`UNBOUND_RESOURCES_MEMORY`:** Memory allocated to Unbound (default: `512M`).

## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   Review and modify any of the environment variable defaults in the `deploy.sh` if you need to customize them.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

2.  **Accessing Pi-hole:**
    -   Open your browser and navigate to `http://<your-host-ip>:1010` (or the port you specified).
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
