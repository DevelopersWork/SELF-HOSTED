# Docker Socket Proxy Stack

This Docker Compose stack sets up a secure socket proxy for the Docker daemon. It allows remote access to the Docker API while restricting what actions can be performed.

## Why Use a Socket Proxy?

A socket proxy provides a layer of security by:

*   Limiting access to specific Docker API endpoints.
*   Enforcing read-only access to the Docker socket.
*   Preventing unauthorized modifications to your Docker environment.

## Features

*   **Controlled Access:** Restrict API actions like starting, stopping, or restarting containers.
*   **Read-Only Socket:** Prevent writes to the Docker socket, enhancing security.
*   **Easy Configuration:** Use environment variables to fine-tune permissions.

## Prerequisites

*   **Docker and Docker Compose:** Ensure Docker and Docker Compose are installed.
*   **Environment Variables:** Set `PUID` and `PGID` to your user and group ID in the `.env` file. 

## Deployment

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/](https://github.com/)<your-username>/<your-repository>.git
    cd <your-repository>/stacks/socket-proxy
    ```
2.  **Customize Configuration (Optional):** Edit the `.env` file to adjust permissions for specific Docker API endpoints.
3.  **Start the Stack:**
    ```bash
    docker-compose up -d
    ```

## Configuration

By default, most actions are disabled.  Edit the `.env` file to modify the following environment variables:

*   `ALLOW_START`, `ALLOW_STOP`, `ALLOW_RESTARTS`, etc. (0 for deny, 1 for allow)
*   Refer to the [linuxserver/socket-proxy documentation](https://github.com/linuxserver/docker-socket-proxy) for the full list of options.

## Accessing the Docker API

You can now access the Docker API through the proxy:

```bash
docker -H tcp://<your-server-ip>:2375 ps
```

**Key Changes and Explanations:**

*   **Renamed Service:** The service in `docker-compose.yml` is renamed to `socket-proxy` for clarity.
*   **Port Mapping:** The Docker API port (2375) is mapped to the host for remote access.
*   **Default Security:** Most actions are disabled by default to maximize security. You can enable specific actions by setting the corresponding environment variables to `1`.
*   **Read-Only Access:** The Docker socket is mounted in read-only mode (`ro`) for additional security.
*   **tmpfs:** A `tmpfs` mount is used for `/run` to improve performance by keeping temporary files in memory.
