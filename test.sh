#/bin/bash

# execute integration tests
docker pull postgres
cd test/docker && docker-compose up --abort-on-container-exit graphql_tester
TEST_RESULT=$?
docker-compose down
cd ../../
exit $TEST_RESULT
