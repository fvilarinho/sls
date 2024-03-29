#!/bin/bash

# Checks the dependencies of this script.
function checkDependencies() {
  SLS_CMD=$(which sls)

  if [ ! -f "$SLS_CMD" ]; then
    echo "SLS binary was not found! Please check your installation!"

    exit 1
  fi
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  cp -f "$ETC_DIR"/sls.conf.template "$ETC_DIR"/sls.conf

  # Replaces placeholders with environment variables.
  sed -i -e 's|${THREADS}|'"$THREADS"'|g' "$ETC_DIR"/sls.conf
  sed -i -e 's|${CONNECTIONS}|'"$CONNECTIONS"'|g' "$ETC_DIR"/sls.conf
  sed -i -e 's|${LISTEN_PORT}|'"$LISTEN_PORT"'|g' "$ETC_DIR"/sls.conf
  sed -i -e 's|${LATENCY}|'"$LATENCY"'|g' "$ETC_DIR"/sls.conf
  sed -i -e 's|${BACKLOG}|'"$BACKLOG"'|g' "$ETC_DIR"/sls.conf
  sed -i -e 's|${IDLE_TIMEOUT}|'"$IDLE_TIMEOUT"'|g' "$ETC_DIR"/sls.conf
  sed -i -e 's|${LOGS_DIR}|'"$LOGS_DIR"'|g' "$ETC_DIR"/sls.conf
}

# Starts the server.
function start() {
  $SLS_CMD -c "$ETC_DIR"/sls.conf
}

# Main function.
function main() {
  checkDependencies
  prepareToExecute
  start
}

main