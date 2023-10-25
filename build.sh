#!/bin/bash

function checkDependencies() {
  DOCKER_CMD=$(which docker)

  if [ -z "$DOCKER_CMD" ]; then
    echo "Docker is not installed! Please install it first to continue!"

    exit 1
  fi
}

function prepareToExecute() {
  cd iac || exit 1

  source .env
}

function build() {
  $DOCKER_CMD compose build
}

function main() {
  checkDependencies
  prepareToExecute
  build
}

main