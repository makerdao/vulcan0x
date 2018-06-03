#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USER" --password-stdin
docker push makerdao/vulcan0x
