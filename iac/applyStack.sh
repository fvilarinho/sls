#!/bin/bash

# Check the dependencies to run this script.
function checkDependencies() {
  if [ ! -f "$PRIVATE_KEY_FILENAME" ]; then
    echo "Private key filename not found! Please provide a valid private key!"

    exit 1
  fi

  if [ -z "$MANAGER_NODE" ]; then
    echo "Manager node not specified! Please provide a valid manager node (IP/Hostname)!"

    exit 1
  fi
}

# Upload the stack file to the swarm
function uploadTheStack() {
  scp -q \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      -i "$PRIVATE_KEY_FILENAME" \
      .env \
      ./docker-compose.yml \
      root@"$MANAGER_NODE":/root
}

# Apply the stack in the swarm.
function applyTheStack() {
  ssh -q \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      -i "$PRIVATE_KEY_FILENAME" \
      root@"$MANAGER_NODE" "source .env; docker stack deploy --compose-file stack.yml --prune sls"
}

# Main function.
function main() {
  checkDependencies
  uploadTheStack
  applyTheStack
}

main