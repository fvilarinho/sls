#!/bin/bash

# Shows the labels.
function showLabel() {
  if [[ "$0" == *"build.sh"* ]]; then
    echo "** Build/Package **"
  elif [[ "$0" == *"publish.sh"* ]]; then
    echo "** Publish **"
  elif [[ "$0" == *"undeploy.sh"* ]]; then
    echo "** Undeploy **"
  elif [[ "$0" == *"deploy.sh"* ]]; then
    echo "** Deploy **"
  fi

  echo
}

# Shows the banner.
function showBanner() {
  if [ -f "banner.txt" ]; then
    cat banner.txt
  fi

  showLabel
}

# Gets a credential value.
function getCredential() {
  if [ -f "$CREDENTIALS_FILENAME" ]; then
    value=$(awk -F'=' '/'$1'/,/^\s*$/{ if($1~/'$2'/) { print substr($0, length($1) + 2) } }' "$CREDENTIALS_FILENAME" | tr -d '"' | tr -d ' ')
  else
    value=
  fi

  echo "$value"
}

# Prepares the environment to execute the commands of this script.
function prepareToExecute() {
  # Required files/paths.
  export WORK_DIR="$PWD/iac"
  export BUILD_ENV_FILENAME="$WORK_DIR/.env"
  export CREDENTIALS_FILENAME="$WORK_DIR"/.credentials
  export SETTINGS_FILENAME="$WORK_DIR"/settings.json
  export PRIVATE_KEY_FILENAME="$WORK_DIR"/.id_rsa

  # Required binaries.
  export TERRAFORM_CMD=$(which terraform)
  export DOCKER_CMD=$(which docker)

  # Environment variables.
  source "$BUILD_ENV_FILENAME"

  export TF_VAR_credentialsFilename="$CREDENTIALS_FILENAME"
  export TF_VAR_settingsFilename="$SETTINGS_FILENAME"
  export TF_VAR_privateKeyFilename="$PRIVATE_KEY_FILENAME"
}

prepareToExecute