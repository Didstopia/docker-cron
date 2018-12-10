#!/bin/bash

./docker_build.sh

docker run -v $(pwd)/data:/data --name docker-cron -it --rm didstopia/docker-cron:latest
