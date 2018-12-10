#!/bin/bash

docker tag didstopia/docker-cron:latest docker.didstopia.com/didstopia/docker-cron:latest
docker push docker.didstopia.com/didstopia/docker-cron:latest
