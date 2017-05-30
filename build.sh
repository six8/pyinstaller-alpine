#!/bin/bash

export PYINSTALLER_TAG=${1:-v3.3}
export ALPINE_VERSION=${2:-v3.4}

REPO="six8/pyinstaller-alpine:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"

docker build \
    --build-arg PYINSTALLER_TAG=${PYINSTALLER_TAG} \
    -t $REPO .

docker push $REPO