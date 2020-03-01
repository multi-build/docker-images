#!/bin/bash
set -ex

docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
tag="multibuild/xenial_$PLATFORM"
docker tag ${tag}:${TRAVIS_COMMIT} ${tag}:latest
docker push ${tag}:latest
