# The Developers@Work Homelab

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository streamlines the creation of a secure and manageable Docker-based homelab environment. It simplifies the setup of essential tools like **Portainer** (for comprehensive container management) and **Dockge** (for user-friendly Docker Compose stack deployment).

## Why This Setup?

*   **Rootless Docker:**  Enhances security by running containers with limited privileges, preventing full root access to your system.
*   **Portainer for Management:** Provides a powerful web-based UI for monitoring, managing, and troubleshooting your containers.
*   **Dockge for Stacks:** Offers an intuitive interface to deploy, configure, and update Docker Compose stacks effortlessly.
*   **Customizable Stacks:** Easily deploy pre-configured stacks or create your own to tailor the environment to your needs.
*   **Easy Updates:** Add or update stacks effortlessly with the `update.sh` script.

## Getting Started

1.  **Prerequisites:**
    -   **Debian-based Linux:** Ubuntu, Debian, etc.
    -   **Sudo Privileges:** Required to run the initial setup script.
    -   **Disk Space:** Ensure enough space for Docker images and volumes.

2.  **Clone:**
    ```bash
    git clone [https://github.com/DevelopersWork/Homelab.git](https://github.com/DevelopersWork/Homelab.git)
    ```

3.  **Setup:**
    ```bash
    cd Homelab
    sudo bash setup.sh
    ```

## Key Directories and Files

*   **`.env`:** The central configuration file for your setup. Customize this file to match your preferences and system details.
*   **`bash-scripts/`:** Contains the core setup scripts. Refer to `bash-scripts/README.md` for details about each script's role.
*   **`stacks/`:** Contains individual stack directories (e.g., `filebrowser/`). Each stack has:
    *   **`docker-compose.yml`:** Defines the Docker services for the stack.
    *   **`deploy.sh`:** Script to create the necessary `.env` file and handle any additional stack-specific setup tasks.
    *   **(Optional) Other configuration files:** Depending on the stack's requirements.

## Usage

After running the setup script:

*   Access **Portainer:** Open your browser and navigate to `http://<your-host-ip>:9000`.
*   Access **Dockge:** Open your browser and navigate to `http://<your-host-ip>:5001`.

## Updates

To add new stacks or update existing ones, use the `update.sh` script. You can create your own stacks by following the instructions in `stacks/README.md`. Each stack includes a `deploy.sh` script to handle setup and configuration automatically.

## Contributing

1.  **Fork this repository.**
2.  Create a new branch for your stack: `git checkout -b feature/my-new-stack`
3.  **Create the stack directory:**  Add a new subdirectory within `stacks/` (e.g., `my-new-stack/`).
4.  **Add your files:** Place your `docker-compose.yml` and `deploy.sh` files in this directory. Add any additional configuration files if required.
5.  **Test thoroughly:**  Make sure your stack works as expected in your own environment.
6.  **Create a pull request:** Submit your changes to the `develop` branch, providing clear descriptions and instructions.

We appreciate your contributions! By sharing your stacks, you help others build their homelabs more easily.

## License

This project is licensed under the [MIT License](LICENSE). 
