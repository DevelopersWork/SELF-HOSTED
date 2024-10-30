# Container Management Stack

This stack provides a comprehensive solution for managing your Docker environment using Portainer and Dockge.

## Features

* **Portainer:** A powerful and user-friendly web-based interface for managing Docker containers, images, networks, and volumes.
* **Centralized Management:** Manage all your Docker resources from a single, unified interface.
* **Simplified Deployment:** Easily deploy and update Docker Compose stacks using Dockge.
* **Health Checks:**  Automatic health checks ensure the availability of Portainer and Dockge.
* **Resource Management:**  Resource limits prevent containers from consuming excessive resources.

## Stack Components

* **Portainer CE:** The community edition of Portainer, providing a web-based management interface.
* **Dockge:** A tool for managing Docker Compose stacks.

## Important Notes

* **Security:** Mounting the Docker socket (/var/run/docker.sock) grants Portainer and Dockge extensive control over your Docker environment. Ensure that only authorized users have access to these tools.
* **Port Conflicts:** If another service is using port 9000 or 5001, adjust the port mappings in the docker-compose.yml file.
* **Volumes:** The stack uses named volumes (portainer and dockge) for data persistence. You can manage these volumes using Docker commands.

## Authors

*   Developers@Work
