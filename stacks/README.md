# Docker Stacks for Your Homelab

This directory contains raw templates for Docker Compose stacks, along with scripts to help you prepare these stacks for deployment in your homelab environment.

## How Stacks Work

Each stack is organized in a separate subdirectory and consists of the following files:

*   **`docker-compose.yml`:** The main configuration file defining the Docker services, networks, volumes, and other settings for the stack. (This is a template file)
*   **`deploy.sh`:** A script that:
    -   Creates the necessary `.env` file for the stack (if it doesn't exist).
    -   Handles any stack-specific setup tasks (e.g., database initialization, directory creation).
    -   Copies the `docker-compose.yml` and `.env` files to the appropriate location in your Docker environment (managed by the `docker` user).
    
**Note:** The actual deployment of the stacks is done through the Dockge interface, not directly from these scripts.

## Available Stacks

*   **`filebrowser/`:**  Web-based file manager for easy access and management of your server's files. Refer to `filebrowser/README.md` for configuration and usage instructions.
   
## Using Stacks

1.  **Customize Configuration:** 
    -   Go to the stack's directory (e.g., `stacks/filebrowser`).
    -   Open the `deploy.sh` script and customize the default values for environment variables (if needed).

2.  **Prepare the Stack:**
    -   Run the `update.sh` script from the root of the repository to run the `deploy.sh` script for the stack:
    ```bash
    sudo bash update.sh
    ```

3.  **Deploy with Dockge:**
    -   Access the Dockge interface in your browser (`http://<your-host-ip>:5001`).
    -   Since the `DOCKER_STACKS_PATH` is already mapped to Dockge, you should see all available stacks listed.
    -   Click on the stack you want to deploy.
    -   Review and adjust the settings as needed.
    -   Click **DEPLOY** to start the containers.
