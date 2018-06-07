#!/usr/bin/env bash
docker-compose down
docker rmi makerdao/vulcan0x
docker-compose up -d
