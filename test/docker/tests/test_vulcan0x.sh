#!/bin/sh
while ! curl -s http://graphql:4000 > /dev/null
do
  echo "trying to connect to graphql"
  sleep 5
done

py.test test_vulcan0x.tavern.yaml -v
