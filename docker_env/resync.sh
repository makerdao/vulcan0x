#!/usr/bin/env bash
export ENV_FILE=${1:-.env}
docker-compose down
sudo rm -rf pgdata
docker-compose up -d
