#!/usr/bin/env bash
source ${1:-.env}
export POSTGRES_HOST POSTGRES_USER POSTGRES_DB
docker run -it --rm postgres psql -h $POSTGRES_HOST -U $POSTGRES_USER $POSTGRES_DB
