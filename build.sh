#!/bin/bash

export PYINSTALLER_TAG=${1:-v3.4}
export ALPINE_VERSION=${2:-3.6}
export REPO=${3:-six8/pyinstaller-alpine}

REPO="${REPO}:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"

cat Dockerfile | envsubst | docker build -f - \
    --build-arg PYINSTALLER_TAG=${PYINSTALLER_TAG} \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    -t $REPO .

docker push $REPO
