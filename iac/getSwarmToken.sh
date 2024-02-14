#!/bin/bash

# Checks the dependencies to run this script.
function checkDependencies() {
  MANAGER_NODE=$1

  if [ -z "$MANAGER_NODE" ]; then
    echo "Manager node not specified! Please provide a valid manager node (IP/Hostname)!"

    exit 1
  fi
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  cd .. || exit 1

  source functions.sh

  cd iac || exit 1
}

# Gets the swarm token.
function getSwarmToken() {
  TOKEN=$(ssh -q \
              -o "UserKnownHostsFile=/dev/null" \
              -o "StrictHostKeyChecking=no" \
              -i "$PRIVATE_KEY_FILENAME" \
              root@"$MANAGER_NODE" "docker swarm join-token worker -q")

  echo "{\"token\": \"$TOKEN\"}"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies "$1"
  getSwarmToken
}

main "$1"