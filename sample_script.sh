#!/usr/bin/env sh

# Enable error handling
# set -eo pipefail

# Enable script debugging
# set -x

# Get the script's full path
SCRIPT_FULL_PATH=$(realpath "$0")

echo "Hello from ${SCRIPT_FULL_PATH}" > /dev/stdout
exit 0
