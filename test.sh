#/bin/bash

# execute integration tests
cd test/docker && docker-compose up --exit-code-from graphql_tester
TEST_RESULT=$?
docker-compose down
cd ../../
exit $TEST_RESULT
