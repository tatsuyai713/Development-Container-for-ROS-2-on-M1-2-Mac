#!/bin/bash

NAME_IMAGE="development-container-for-ros-2-on-m1-2-mac"
echo "Build Base Container"

docker build -f common.dockerfile -t ghcr.io/tatsuyai713/${NAME_IMAGE}:v0.02 .
docker push ghcr.io/tatsuyai713/${NAME_IMAGE}:v0.02
