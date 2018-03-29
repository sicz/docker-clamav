#!/bin/bash -e

################################################################################

# Lighttpd user, group and file owner
export CLAMAV_USER=clamav
export CLAMAV_GROUP=${CLAMAV_USER}
CLAMAV_FILE_OWNER="${CLAMAV_USER}:${CLAMAV_GROUP}"

################################################################################
