#!/bin/bash -e

################################################################################

# Initial update of antivirus databases
if [ -n "${DOCKER_CONTAINER_START}" ]; then
  if [ "$(basename ${DOCKER_COMMAND})" = "clamd" ]; then
    freshclam --verbose
  fi
fi

################################################################################
