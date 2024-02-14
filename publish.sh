#!/bin/bash

# Checks the dependencies of this script.
function checkDependencies() {
  if [ -z "$DOCKER_CMD" ]; then
    echo "Docker is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  source functions.sh

  showBanner

  cd iac || exit 1
}

# Publishes the container image.
function publish() {
  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin

  $DOCKER_CMD compose push
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  publish
}

main