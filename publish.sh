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

function publish() {
  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login "$DOCKER_REGISTRY_URL" "$DOCKER_REGISTRY_ID" --password-stdin

  $DOCKER_CMD compose push
}

function main() {
  checkDependencies
  prepareToExecute
  publish
}

main