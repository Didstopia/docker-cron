#!/usr/bin/env sh

# Enable error handling
# set -eo pipefail

# Enable script debugging
# set -x

# Setup the signal trap for handling graceful shutdowns
trap shutdown SIGTERM SIGINT SIGQUIT SIGHUP

function shutdown() {
  echo "Exit signal received, shutting down ..." > /dev/stdout

  CROND_PID=$(pidof crond)
  if [ -n "$CROND_PID" ]; then
    echo "Shutting down cron ..." > /dev/stdout
    kill -SIGINT ${CROND_PID}
    wait ${CROND_PID}
  fi

  echo "Shutdown complete, terminating ..." > /dev/stdout
  exit 0
}

# FIXME: This should be handled in the base image and with a base entrypoint script/S6 overlay logic!
# Set the default time zone
cp -f "/usr/share/zoneinfo/${TZ}" /etc/localtime

# Handle different startup commands
case ${1} in
  shell)
    # Start a shell
    /bin/sh
    ;;
  cron)
    # Apply the selected schedule (remember to escape slashes in the environment variables)
    echo "Setting up scheduler ..." > /dev/stdout
    cp /cron_script /etc/periodic/${SCRIPT_SCHEDULE}/cron_script
    sed -i -r "s/SCRIPT_WORKING_DIRECTORY/$SCRIPT_WORKING_DIRECTORY/g" /etc/periodic/${SCRIPT_SCHEDULE}/cron_script
    sed -i -r "s/SCRIPT_STARTUP_COMMAND/$SCRIPT_STARTUP_COMMAND/g" /etc/periodic/${SCRIPT_SCHEDULE}/cron_script
    chmod +x /etc/periodic/${SCRIPT_SCHEDULE}/cron_script

    # Start cron, logging to stdout and running in foreground
    echo "Starting scheduler ..." > /dev/stdout
    crond \
      -l $CRON_LOG_LEVEL \
      -L /dev/stdout \
      -c /var/spool/cron/crontabs \
      -f
    ;;
esac
