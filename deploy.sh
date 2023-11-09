#!/bin/bash

# Check the dependencies to run this script.
function checkDependencies() {
  TERRAFORM_CMD=$(which terraform)

  if [ -z "$TERRAFORM_CMD" ]; then
    echo "Terraform is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepare the environment to execute this script.
function prepareToExecute() {
  cd iac || exit 1
}

# Provision the environment and deploy the stack.
function deploy() {
  $TERRAFORM_CMD init \
                 -upgrade \
                 -migrate-state

  $TERRAFORM_CMD apply \
                 -auto-approve
}

# Main function.
function main() {
  checkDependencies
  prepareToExecute
  deploy
}

main