#!/bin/bash

# Ensure script is running as the 'docker' user
if [ "$(id -u)" -ne "$DOCKER_USER" ] || [ "$(id -g)" -ne "$DOCKER_GROUP" ]; then
  echo "This script must be run as the 'docker' user."
  exit 1
fi

if [ ! -d "$DOCKER_CONTAINER_DIR" ]; then
  mkdir -p "$DOCKER_CONTAINER_DIR"
fi
if ! [ "$(stat -c %u "$DOCKER_CONTAINER_DIR")" = "$DOCKER_USER" ] || ! [ "$(stat -c %g "$DOCKER_CONTAINER_DIR")" = "$DOCKER_GROUP" ]; then
  chown -R "$DOCKER_USER:$DOCKER_GROUP" "$DOCKER_CONTAINER_DIR"
fi

if [ ! -d "$DOCKER_STACKS_DIR" ]; then
  mkdir -p "$DOCKER_STACKS_DIR"
fi
if ! [ "$(stat -c %u "$DOCKER_STACKS_DIR")" = "$DOCKER_USER" ] || ! [ "$(stat -c %g "$DOCKER_STACKS_DIR")" = "$DOCKER_GROUP" ]; then
  chown -R "$DOCKER_USER:$DOCKER_GROUP" "$DOCKER_STACKS_DIR"
fi

if [ ! -d "$DOCKER_STORAGE_DIR" ]; then
  mkdir -p "$DOCKER_STORAGE_DIR"
fi
if ! [ "$(stat -c %u "$DOCKER_STORAGE_DIR")" = "$DOCKER_USER" ] || ! [ "$(stat -c %g "$DOCKER_STORAGE_DIR")" = "$DOCKER_GROUP" ]; then
  chown -R "$DOCKER_USER:$DOCKER_GROUP" "$DOCKER_STORAGE_DIR"
fi
