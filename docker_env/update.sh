#!/usr/bin/env bash
export ENV_FILE=${1:-.env}
docker-compose down
docker rmi makerdao/vulcan0x
docker-compose up -d
