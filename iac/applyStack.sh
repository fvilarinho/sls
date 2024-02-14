#!/bin/bash

# Checks the dependencies to run this script.
function checkDependencies() {
  if [ -z "$MANAGER_NODE" ]; then
    echo "Manager node not specified! Please provide a valid manager node (IP/Hostname)!"

    exit 1
  fi
}

# Prepare the environment to execute this script.
function prepareToExecute() {
  cd .. || exit 1

  source functions.sh

  cd iac || exit 1
}

# Uploads the stack file to the swarm
function uploadTheStack() {
  scp -q \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      -i "$PRIVATE_KEY_FILENAME" \
      .env \
      ./stack.yml \
      root@"$MANAGER_NODE":/root
}

# Applies the stack in the swarm.
function applyTheStack() {
  ssh -q \
      -o "UserKnownHostsFile=/dev/null" \
      -o "StrictHostKeyChecking=no" \
      -i "$PRIVATE_KEY_FILENAME" \
      root@"$MANAGER_NODE" "source .env; docker stack deploy --compose-file stack.yml --prune sls"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  uploadTheStack
  applyTheStack
}

main