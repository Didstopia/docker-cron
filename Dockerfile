# Base image
FROM didstopia/base:alpine-3.5

# Maintainer information
LABEL maintainer="Didstopia <support@didstopia.com>"

# Install dependencies
RUN apk add --no-cache \
    python3 \
    sudo \
    && \
    python3 -m ensurepip \
    && \
    rm -r /usr/lib/python*/ensurepip \
    && \
    pip3 install --upgrade pip setuptools \
    && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi \
    && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi \
    && \
    rm -r /root/.cache

# Run as the "docker" user by default
ENV PGID=1000
ENV PUID=1000

## NOTE: Slashes need to be escaped (see entrypoint.sh for details)
# Allow build and runtime customization
ENV SCRIPT_SCHEDULE="daily"
ENV SCRIPT_WORKING_DIRECTORY="\/data"
ENV SCRIPT_STARTUP_COMMAND=".\/script.sh"
ENV CRON_LOG_LEVEL="8"

# Copy files over
ADD entrypoint.sh /
ADD crontab /var/spool/cron/crontabs/root

# Setup cron
RUN mkdir -p /etc/periodic/everyminute

# Setup our scheduled script wrapper
RUN echo "#!/usr/bin/env sh" > /cron_script && \
    echo "set -e" >> /cron_script && \
    echo "set -o pipefail" >> /cron_script && \
    echo "set -x" >> /cron_script && \
    echo "cd SCRIPT_WORKING_DIRECTORY" >> /cron_script && \
    echo "SCRIPT_STARTUP_COMMAND" >> /cron_script && \
    chmod +x /cron_script

# Setup volumes
VOLUME [ "/data" ]

# Set the default entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set the default command (only "shell" and "cron" are supported)
CMD ["cron"]
