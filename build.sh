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
}

# Build container image.
function build() {
  $DOCKER_CMD compose build
}

# Main function.
function main() {
  checkDependencies
  prepareToExecute
  build
}

main