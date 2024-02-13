#!/bin/bash

# Check the dependencies of this script.
function checkDependencies() {
  DOCKER_CMD=$(which docker)

  if [ -z "$DOCKER_CMD" ]; then
    echo "Docker is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepare the environment to execute this script.
function prepareToExecute() {
  cd iac || exit 1

  source .env

  echo $DOCKER_REGISTRY_URL
  echo $DOCKER_REGISTRY_ID
}

# Publish the container image.
function publish() {
  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin

  $DOCKER_CMD compose push
}

# Main function.
function main() {
  checkDependencies
  prepareToExecute
  publish
}

main