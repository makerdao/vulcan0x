#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

cd ../docker_env

exec ENV_FILE=.env.dev docker-compose -f ./docker-compose-dev.yml up