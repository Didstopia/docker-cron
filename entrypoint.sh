#!/usr/bin/env sh

# Enable error handling
set -e
set -o pipefail

# Enable script debugging
#set -x

# Handle different startup commands
case ${1} in
  shell)
    # Start a shell
    /bin/sh
    ;;
  cron)
    # Apply the selected schedule (remember to escape slashes in the environment variables)
    cp /cron_script /etc/periodic/${SCRIPT_SCHEDULE}/cron_script
    sed -i -r "s/SCRIPT_WORKING_DIRECTORY/$SCRIPT_WORKING_DIRECTORY/g" /etc/periodic/${SCRIPT_SCHEDULE}/cron_script
    sed -i -r "s/SCRIPT_STARTUP_COMMAND/$SCRIPT_STARTUP_COMMAND/g" /etc/periodic/${SCRIPT_SCHEDULE}/cron_script
    chmod +x /etc/periodic/${SCRIPT_SCHEDULE}/cron_script

    # Start cron, logging to stdout and running in foreground
    crond \
      -l $CRON_LOG_LEVEL \
      -L /dev/stdout \
      -c /var/spool/cron/crontabs \
      -f
    ;;
esac
