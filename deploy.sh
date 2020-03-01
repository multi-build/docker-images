#!/bin/bash
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD https://hub.docker.com/
tag="multibuild/xenial_$PLATFORM"
docker tag ${tag}:${TRAVIS_COMMIT} ${tag}:latest
docker push ${tag}:latest
