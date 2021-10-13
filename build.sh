#!/bin/bash

# Stop at any error, show all commands
set -ex

docker build --rm -t multibuild/${DIST}_${PLATFORM}:${TRAVIS_COMMIT} -f docker/Dockerfile-$DIST-$PLATFORM docker/
