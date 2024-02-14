#!/bin/bash

# Check the dependencies of this script.
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

# Builds the container image.
function build() {
  $DOCKER_CMD compose build
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  build
}

main