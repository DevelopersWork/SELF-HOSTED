# Cloudflared Tunnel Stack

This stack deploys Cloudflared, enabling secure access to your applications or services running within your homelab via Cloudflare Tunnel. It allows you to expose your local services to the internet without needing to open ports on your router.

## Stack Files

- `docker-compose.yml`: Defines the Cloudflared service and its configuration.
- `deploy.sh`: Script to automatically create or update the required `.env` file for the stack.

## Services

- **cloudflared:**  The Cloudflare Tunnel daemon.


## Environment Variables

- **`PUID`**: User ID (UID) for running the container (automatically set in the `deploy.sh` script).
- **`PGID`**: Group ID (GID) for running the container (automatically set in the `deploy.sh` script).
- **`CLOUDFLARED_TUNNEL_TOKEN`**: **(Required)** Your Cloudflare Tunnel token (obtain it from your Cloudflare account).
- **`CLOUDFLARED_VOLUME_PATH`**: Path to the Cloudflared data volume (defaults to `/home/docker/containers/cloudflared`).
- **`CLOUDFLARED_RESOURCES_CPUS`**: CPU cores allocated to Cloudflared (default: `0.5`).
- **`CLOUDFLARED_RESOURCES_MEMORY`**: Memory allocated to Cloudflared (default: `512M`).



## Usage

1.  **Preparation:**
    -   Open the `deploy.sh` script in this directory.
    -   **Replace the placeholder** for `CLOUDFLARED_TUNNEL_TOKEN` with your actual Cloudflare Tunnel token.
    -   Run the `update.sh` script from the root of the repository to execute the `deploy.sh` script.

## Authors

*   Developers@Work

