#!/bin/bash
SCRIPTS_DIR="$(dirname "$(realpath "$0")")/bash-scripts"  # Get the absolute path of the script's directory

# Check if the scripts exist
for script in "01-setup-docker.sh" "02-configure-docker.sh" "03-setup-portainer.sh" "04-setup-dockge.sh" "utils.sh"; do
  if [ ! -f "$SCRIPTS_DIR/$script" ]; then
    echo "Error: Script $script not found in $SCRIPTS_DIR"
    exit 1
  else 
    chmod +x "$SCRIPTS_DIR/$script"
  fi
done

# Run scripts 01 and 02 as sudo (or root)
sudo /bin/bash -c "$SCRIPTS_DIR/01-setup-docker.sh" || { echo "Error running 01-setup-docker.sh"; exit 1; }
sudo /bin/bash -c "$SCRIPTS_DIR/02-configure-docker.sh" || { echo "Error running 02-configure-docker.sh"; exit 1; }

# Switch to the docker user for subsequent scripts 
exec sudo -u docker -g docker bash << EOF
# Run scripts 03 and 04 as the docker user 
echo "Running as user: $(whoami)"
/bin/bash -c "$SCRIPTS_DIR/03-setup-portainer.sh" || { echo "Error running 03-setup-portainer.sh"; exit 1; }
/bin/bash -c "$SCRIPTS_DIR/04-setup-dockge.sh" || { echo "Error running 04-setup-dockge.sh"; exit 1; }
EOF
