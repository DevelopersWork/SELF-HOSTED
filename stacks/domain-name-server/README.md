# DNS(Domain Name Server) Stack 
> Pi-hole + Unbound

This stack sets up a robust and private DNS solution using Pi-hole for ad-blocking and Unbound as a secure and validating DNS resolver.

## Features

* **Ad Blocking:** Pi-hole blocks ads and trackers at the network level, improving browsing speed and privacy.
* **DNS Security:** Unbound validates DNS responses using DNSSEC, protecting against DNS spoofing and tampering.
* **Privacy:** Unbound encrypts DNS queries using DNS over TLS (DoT), preventing eavesdropping on your DNS traffic.
* **Caching:** Unbound caches DNS records, speeding up lookups and reducing reliance on external servers.
* **Customization:** The stack is highly customizable, allowing you to configure forwarding zones, access control lists, and other advanced features.

## Components

- **pihole:**  The Pi-hole ad-blocking service, providing a web interface for management and statistics.
- **unbound:** The Unbound DNS resolver, responsible for handling DNS queries securely and efficiently.

## Files

- `docker-compose.yml`: Defines the Pi-hole and Unbound services, their configuration, and the network they share.
- `deploy.sh`: Script simplifies the deployment process by automatically:
    -  Creating or updating the necessary `.env` file with configuration options.
    -  Downloading the latest configuration files from the GitHub repository (if they don't already exist).

## Environment Variables

- **`PUID`:** User ID (UID) for running the containers.
- **`PGID`:** Group ID (GID) for running the containers.
- **`PIHOLE_WEBPASSWORD`:** Password for the Pi-hole web interface (default: `password`). 
- **`UNBOUND_VOLUME_PATH`:** Path to the Unbound data volume (defaults to `/home/docker/containers/unbound`).

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

## Important Notes

* **Security:** Change the default `PIHOLE_WEBPASSWORD` for security.
* **Port Conflicts:** If another service is using port 53, disable or reconfigure it.
* **Configuration:** Customize Unbound's `unbound.conf` file (found in the `UNBOUND_VOLUME_PATH`) for advanced settings.
* **Volumes:**  The stack uses named volumes (`pihole`, `pihole-dnsmasq_d`, `unbound`) for data persistence. You can manage these volumes using Docker commands.
* **Updates:**  Consider using the `latest` tags for Pi-hole and Unbound images to get automatic updates. If stability is critical, use specific version tags.
* **Due to current limitations, the Pi-hole and Unbound runs as root within the Docker container.**

## Authors

*   Developers@Work
