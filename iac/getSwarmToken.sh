#!/bin/bash

# Check the dependencies to run this script.
function checkDependencies() {
  PRIVATE_KEY_FILENAME=$2

  if [ ! -f "$PRIVATE_KEY_FILENAME" ]; then
    echo "Private key filename not found! Please provide a valid private key!"

    exit 1
  fi

  MANAGER_NODE=$1

  if [ -z "$MANAGER_NODE" ]; then
    echo "Manager node not specified! Please provide a valid manager node (IP/Hostname)!"

    exit 1
  fi
}

# Get the swarm token.
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
    checkDependencies "$1" "$2"
    getSwarmToken
}

main "$1" "$2"