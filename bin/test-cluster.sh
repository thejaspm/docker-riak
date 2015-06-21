#! /bin/bash

set -e

if env | grep -q "DOCKER_RIAK_DEBUG"; then
  set -x
fi

if [[ "${DOCKER_HOST}" == unix://* ]]; then
  CLEAN_DOCKER_HOST="localhost"
else
  CLEAN_DOCKER_HOST=$(echo "${DOCKER_HOST}" | cut -d'/' -f3 | cut -d':' -f1)
  CLEAN_DOCKER_HOST="localhost"
fi
RANDOM_CONTAINER_ID=$(docker ps | egrep "hectcastro/riak" | cut -d" " -f1 | perl -MList::Util=shuffle -e'print shuffle<>' | head -n1)
CONTAINER_HTTP_PORT=$(docker port "${RANDOM_CONTAINER_ID}" 8098 | cut -d ":" -f2)

curl -s "http://${CLEAN_DOCKER_HOST}:${CONTAINER_HTTP_PORT}/stats" | python -mjson.tool
